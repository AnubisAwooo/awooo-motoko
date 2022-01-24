import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Principal "mo:base/Principal";
import Time "mo:base/Time";
import List "mo:base/List";
import Iter "mo:base/Iter";

actor {
    stable var counter = 0;

    // Get the value of the counter.
    public query func get() : async Nat {
        return counter;
    };

    // Set the value of the counter.
    public func set(n : Nat) : async () {
        counter := n;
    };

    // Increment the value of the counter.
    public func inc() : async () {
        counter += 1;
    };

    
    public type HeaderField = (Text, Text);
    public type HttpRequest = {
        url : Text;
        method : Text;
        headers : [HeaderField];
        body : [Nat8];
    };
    public type HttpResponse = {
        status_code : Nat16;
        headers : [HeaderField];
        streaming_strategy : ?StreamingStrategy;
        body : Blob;
    };
    public type StreamingStrategy = {
        #Callback : {
            token : StreamingCallbackToken;
            callback : shared query StreamingCallbackToken -> async StreamingCallbackHttpResponse;
        };
    };
    public type StreamingCallbackToken = {
        key : Text;
        sha256 : ?[Nat8];
        index : Nat;
        content_encoding : Text;
    };
    public type StreamingCallbackHttpResponse = {
        token : ?StreamingCallbackToken;
        body : [Nat8];
    };

    public shared query func http_request(request: HttpRequest): async HttpResponse {
        {
            status_code = 200;
            headers = [];
            streaming_strategy = null;
            body = Text.encodeUtf8("<html><body><h1>" # Nat.toText(counter) # "</h1></body></html>");
        }
    };

    public type Message = {
        text: Text;
        time: Time.Time;
        author: Text;
    };

    public type Microblog = actor {
        follow: shared(Principal) -> async ();
        follows: shared query () -> async [Principal];
        post: shared (Text) -> async ();
        posts: shared query () -> async [Message];
        timeline: shared () -> async [Message];
        set_name: shared (Text) -> async ();
        get_name: shared query () -> async Text;
    };

    stable var followed: List.List<Principal> = List.nil();
    stable var messages: List.List<Message> = List.nil();
    stable var username: Text = "";

    public shared func follow(id: Principal): async () {
        followed := List.push(id, followed);
    };

    public shared query func follows(): async [Principal] {
        List.toArray(followed)
    };

    public shared (msg) func post(text: Text): async () {
        // assert(Principal.toText(msg.caller) == "xxxxxx");
        let message: Message = {
            text = text;
            time = Time.now();
            author = username;
        };
        messages := List.push(message, messages);
    };

    public shared query func posts(): async [Message] {
        List.toArray(messages);
    };

    public shared func timeline(): async [Message] {
        var all: List.List<Message> = List.nil();
        for (id in Iter.fromList(followed)) {
            let canister: Microblog = actor(Principal.toText(id));
            let messages = await canister.posts();
            for (message in Iter.fromArray(messages)) {
                all := List.push(message, all);
            };
        };
        List.toArray(all);
    };

    public shared func set_name(name: Text): async () {
        username := name;
    };

    public shared query func get_name(): async Text {
        username
    };

};
