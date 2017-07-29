
	function doYcLogin() {
		var username = document.getElementById('uid');
		var pwd = document.getElementsByName('password')[0];
		username.value = "";
		pwd.value = "";
		doLogin();
	}
	
	
	function testYc() {
		var mis = document.getElementsByClassName('mis');
		var str = ""
		for (m in mis) {
			str = "Hello, UIC!"
		}

		return str;
	}
