import Nat "mo:base/Nat";
import Text "mo:base/Text";

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
};
