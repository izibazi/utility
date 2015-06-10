html=$(cat << EOS
<!DOCTYPE html>
<html>
<head>
<title>PROJECTS.</title>
<meta name="viewport" content="width=device-width; initial-scale=1.0">
<link href='http://fonts.googleapis.com/css?family=Open+Sans:300italic,400,300&subset=cyrillic-ext,latin' rel='stylesheet' type='text/css'>
<link href='http://fonts.googleapis.com/css?family=Lato:100,300,400,100italic,300italic' rel='stylesheet' type='text/css'>
<style>
	\* {
		font-style: italic;
		margin: 0;
		padding: 0;
	}
	::-moz-selection { color: #fff;  background: #00c5a7; }
	::selection      { color: #fff;  background: #00c5a7; } 
	body {
		font-family: "ヒラギノ明朝 Pro","Hiragino Mincho Pro"; 
		/*font-family: 'Open Sans', sans-serif;*/
		font-family: 'Lato', sans-serif;
		font-weight: 300;
		overflow-x: hidden;
		width: 100%;
	}
	section {
		width: 100%;
		margin-left: 80px;
	}
	h1 {
		font-size: 35px;
		margin: 80px 0 70px;
	}
	ul {
		list-style: decimal;
		list-style-position: outer;
		margin-left: 40px;
	}
	li {
		padding: 0 0 6px;
		margin-bottom: 18px;
		font-size: 34px;
		border-bottom: 1px dotted #666;
	}
	li a {
		color: #00c5a7;
		font-size: 27px;
		text-decoration: none;
	}
	li a:hover {
		color: #fff;
		background: #00c5a7;
	}
	@media screen and (max-width: 660px) {
	body {
		font-weight: normal;
	}
	section {
		margin-left: 10%;
	}
	h1 {
		font-size: 25px;
		margin: 13% 0;
	}
	ul {
		margin-left: 35px;
	}
	li {
		font-size: 30px;
		padding-bottom: 1%;
		margin-bottom: 4%;
	}
	li a {
		font-size: 25px;
	}
	}

	.line {
	}
</style>
</head>
<body>
<div class="line"></div>
<section>
<h1>PROJECTS.</h1>
<ul>
EOS
)
projects="/etc/httpd/sites-enabled/*"
for path in $projects; do
	basename=${path##*/}
	url="//${basename}.izibazi.com/"
	li="<li><a href=\"${url}\" target=\"_blank\">${basename}</a></li>"
	html=${html}$li
done
html="${html}</ul></section>"
echo $html | cat > /var/www/html/projects.html
