# mkcpp
A cute little script for creating dummy cpp classes <br>
Creates cpp + hpp files with Coplien form classes <br>
and adds the 42 header to the top. <br>

If one of args is "main", it will also create a main.cpp and<br>
include all the other arguments as headers. <br><br>

```bash
usage:	mkcpp <filename1> ... <filenameN>
		mkcpp	-h --help
			-u --uninstall
```

# installation
```bash
sh -c "$(curl -fSsL https://raw.githubusercontent.com/Shimata/cpp_maker/master/install.sh)"
```
The default installation dir is $HOME/goinfre/bin/<br>
You can specify another installation directory: <br>
```bash
install_path="Custom/path/here" sh -c "$(curl -fSsL https://raw.githubusercontent.com/Shimata/cpp_maker/master/install.sh)"
```
