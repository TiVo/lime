package lime.project;


class Keystore {
	
	public var alias:String;
	public var aliasPassword:String;
	public var identity:String;
	public var password:String;
	public var path:String;
	public var type:String;
    public var developmentTeam:String;
    public var provisioningProfile:String;
    public var provisioningProfileSpecifier:String;

	public function new (path:String = null, password:String = null, alias:String = null, aliasPassword:String = null, identity:String = null) {
		
		this.path = path;
		this.password = password;
		this.alias = alias;
		this.aliasPassword = aliasPassword;
		this.identity = identity;
        this.developmentTeam = developmentTeam;
        this.provisioningProfile = provisioningProfile;
        this.provisioningProfileSpecifier = provisioningProfileSpecifier;
		
	}
	
	public function clone ():Keystore {
		
		return new Keystore (path, password, alias, aliasPassword, identity,
                             developmentTeam, provisioningProfile,
                             provisioningProfileSpecifier);
		
	}
	
	public function merge (keystore:Keystore):Void {
		
		if (keystore != null) {
			
			if (keystore.path != null && keystore.path != "") path = keystore.path;
			if (keystore.password != null) path = keystore.password;
			if (keystore.alias != null) path = keystore.alias;
			if (keystore.aliasPassword != null) path = keystore.aliasPassword;
			if (keystore.identity != null) identity = keystore.identity;
			if (keystore.developmentTeam != null) developmentTeam = keystore.developmentTeam;
			if (keystore.provisioningProfile != null) provisioningProfile = keystore.provisioningProfile;
			if (keystore.provisioningProfileSpecifier != null) provisioningProfileSpecifier = keystore.provisioningProfileSpecifier;
			
		}
		
	}
	
}
