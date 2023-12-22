
var failedinfo;
var errornumber=-4;
var lang = (navigator.userLanguage||navigator.language).toLowerCase(); 
if(lang == "zh-cn")
{
	failedinfo="登录失败！";
	if(errornumber==-1)
	{
		failedinfo="登录失败，用户名不存在！";
	}
	else if(errornumber==-2)
	{
		failedinfo="登录失败，密码错误！";
	}
	else
	{
		failedinfo="登录失败，权限错误！";
	}

}
else
{
	failedinfo="Log in failed!";
	if(errornumber==-1)
	{
		failedinfo="Log in failed, username does not exist!";
	}
	else if(errornumber==-2)
	{
		failedinfo="Log in failed, password error!";
	}
        else
	{
		failedinfo="Log in failed，nopower!";
	}
}
alert(failedinfo);
location="Login.htm"
