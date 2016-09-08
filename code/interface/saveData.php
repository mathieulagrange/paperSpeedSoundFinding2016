<?php
// $dataSave = &$_POST['value'] ; 
// $timestamp = time();

$posted = &$_POST ;
$timestamp = time();
$fname=$posted["file"];
$name= $posted["name"];
$typeXP = $posted["typeXP"];
$audioDevice = $posted["audioDevice"];

$fname = $fname.'saveXP_'.$typeXP .'_'.$name.'_'.$audioDevice.'_'.$timestamp.'.json';

$value = $posted["content"];

$nfile = fopen($fname, "w");

if($nfile != false)
{
	fwrite($nfile, $value);
	fclose($nfile);
}	
	
?>
