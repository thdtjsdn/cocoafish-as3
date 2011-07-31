# Cocoafish ActionScript 3 Library

This is a Flex wrapper for the Cocoafish REST API that can be used in your Flash and Air apps. For full documentation about the API methods that can be used through this library, see the [Cocoafish REST API documentation](http://cocoafish.com/docs/rest).

## Setup

The Cocoafish ActionScript 3 library is contained within the file `bin/cocoafish-1.0.swc`. To use it in an ActionScript/Flex project, configure it into project's build path as a referenced library. Before your app can access the Cocoafish API servers, you must:

1. Request a Beta invitation code at http://cocoafish.com/beta/signup
2. Use the Beta invitation code to create an account at http://cocoafish.com/signup
3. Register your app at http://cocoafish.com/apps to generate an app key, OAuth consumer key, and OAuth secret

## Usage

Import Cocoafish along with the standard JSON parsing class:

    import com.adobe.serialization.json.JSON;
    import com.cocoafish.api.Cocoafish;

Create an instance of Cocoafish using an app key:

    var sdk:Cocoafish = new Cocoafish("<app key>");

or OAuth consumer key & secret:
    
    var sdk:Cocoafish = new Cocoafish("<OAuth consumer key>", "<OAuth secret>");

Then send an API request with the `sendRequest` method:

     public function sendRequest(url:String, method:String, data:Object, useSecure:Boolean, callback:Function):void

which takes the following parameters:  

* url: the API url without the standard REST API http://api.cocoafish.com/v1/ prefix  
* method: the http method (accepted values are GET, POST, PUT, DELETE)  
* data: the parameters to be passed to the API  
* useSecure: a boolean that indicates whether to use https  
* callback: the callback function

The specified callback function will be invoked with a single parameter of type `Object`. This contains the results of JSON response from the Cocoafish API server, accessible by using dot "." notation to access individual fields.

## Example

The following is an example of creating user by using the Cocoafish AS3 library. This example will create a user with a profile photo. To send photo data, the library accepts an instance of `FileReference` as the `photo` field. The `FileReference` instance should be loaded with the local file information before being passed to `sendRequest`.

### Example Source Code

    private var photo:FileReference;	// FileReference instance for "photo" field of input data
    
    var sdk:Cocoafish = new Cocoafish("tplS0cAZtDjO1QYOdiOhroMcLIJ98WJZ"); // app key
    //var sdk:Cocoafish = new Cocoafish("2ywmQMDvPvDvySPjfTykUIMkPxa0zKDE", "63Y2eW7QmmUTpGmNUxrGoHzf9060od9u"); // OAuth key & secret
	
    //the user's parameters
    var data:Object = new Object();
    data.email = "test@cocoafish.com";
    data.first_name = "test_firstname";
    data.last_name = "test_lastname";
    data.password = "test_password";
    data.password_confirmation = "test_password";
    data.photo = photo;
				
    sdk.sendRequest("users/create.json", URLRequestMethod.POST, data, false, function(data:Object):void {
		if(data) {
			if(data.hasOwnProperty("meta")) {
				var meta:Object = data.meta;
				if(meta.status == "ok" && meta.code == 200 && meta.method_name == "createUser") {
					var message:String = "";
					var user:Object = data.response.users[0];
					message += "Create user successful!\n";
					message += "id:" + user.id + "\n";
					message += "first name:" + user.first_name + "\n";
					message += "last name:" + user.last_name + "\n";
					message += "email:" + user.email + "\n";
					Alert.show(message);
				}
			}
		}
    });
	
    // Browse and load photo file
    protected function selectPhoto(event:MouseEvent):void {
      photo= new FileReference();
      photo.addEventListener(Event.SELECT, photoSelected);
      photo.browse();
    }
			
    protected function photoSelected(event:Event):void {
      photoTextField.text = photo.name;
      photo.removeEventListener(Event.SELECT, photoSelected);
      photo.addEventListener(Event.COMPLETE, photoLoaded);
      photo.load();
    }
			
    protected function photoLoaded(event:Event):void {
      photo.removeEventListener(Event.COMPLETE, photoLoaded);
    }
    
## Sample Flash App

The `tests/dev` folder contains a [sample Flash app](https://github.com/cocoafish/cocoafish-as3/tree/master/tests/dev) that demonstrates how to use the Cocoafish AS3 library. To build and run it yourself, import it into Flash Builder. You must then edit the Properties of the cocoafish-as3-test project to change the Flex Source Build path to reflect the absolute path on your system to the `cocoafish-as3/src` folder.
