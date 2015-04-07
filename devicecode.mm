#import <MobileGestalt/MobileGestalt.h>

int main(int argc, char **argv, char **envp) {
	//get device name (e.g. iPhone5,2)
	NSString *device = (NSString *)MGCopyAnswer(CFSTR("ProductType"));

	NSString *ecid;
	//non-Verizon iPhone 4's (and below) use IMEI, otherwise they use ECID
	if ([device isEqualToString:@"iPhone3,1"] || [device isEqualToString:@"iPhone3,2"]){
		ecid = (NSString *)MGCopyAnswer(CFSTR("InternationalMobileEquipmentIdentity"));
	} else {
		ecid = (NSString *)MGCopyAnswer(CFSTR("UniqueChipID"));
	}
	//serial number
	NSString *serialNumber = (NSString *)MGCopyAnswer(CFSTR("SerialNumber"));
	//wifi MAC address
	NSString *wifiMac = (NSString *)MGCopyAnswer(CFSTR("WifiAddress"));
	//bluetooth MAC address
	NSString *btMac = (NSString *)MGCopyAnswer(CFSTR("BluetoothAddress"));
	//the string of all of these items, in the correct order
	NSString *hashStr = [NSString stringWithFormat:@"%@%@%@%@", serialNumber, ecid, wifiMac, btMac];

	//pass the string of stuff to the server, along with the package ID and the version 
	//(you can cut out package ID and version and hardcode it to the PHP script if you aren't using this for more than one package)
	NSString *urlString = [NSString stringWithFormat:@"http://yourdomain.com/packagecheck.php?hashstr=%@&package=%@&version=%@", hashStr, @"org.thebigboss.snooscreens", @"1.1-1"];
	NSError *sendError = nil;
	NSData *response = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] returningResponse:nil error:&sendError];
	//get a dictionary of the response (which returns the calculated UDID and if they paid)
	NSError *jsonError = nil;
	NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:response options:0 error:&jsonError];

	//check if their paid.
	BOOL paid = [responseDict[@"paid"] boolValue];
	//now you can give them a stearn talking-to if they pirated it
	if (!paid) {
		NSLog(@"Piracy is bad, mkay?");
	}
}