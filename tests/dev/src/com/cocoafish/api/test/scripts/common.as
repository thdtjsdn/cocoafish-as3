import com.cocoafish.api.Cocoafish;
import com.cocoafish.api.test.scripts.SDKHelper;

public var sdk:Cocoafish = null;

protected function getSDK():Cocoafish {
	if(sdk == null) {
		if(appKey.selected) {
			sdk = SDKHelper.getInstance().getSDK(appKeyTextField.text);
		}
		if(oauth.selected) {
			sdk = SDKHelper.getInstance().getSDK(oauthKeyTextField.text, oauthSecretTextField.text);
		}
	}
	return sdk;
}

