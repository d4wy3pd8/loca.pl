#!/usr/bin/perl -s

$fileNum = 0;

$head = <<__DATA__;
<?xml version='1.0' encoding='UTF-8'?>
<kml xmlns='http://www.opengis.net/kml/2.2' xmlns:gx='http://www.google.com/kml/ext/2.2'>
 <Document>
  <Placemark>
   <open>1</open>
   <gx:Track>
    <altitudeMode>clampToGround</altitudeMode>
__DATA__

$tail = <<__DATA__;
   </gx:Track>
  </Placemark>
 </Document>
</kml>
__DATA__

while(<>) {
  if(m/altitudeMode/) { last; }
}

$date = 'invalid';

while(<>) { s/\r//g; s/\n//g;
  if(m/<when>(....\-..\-..T)/) {
    $tmp = $1;
    if($tmp ne $date) {
      print OUT $tail; close(OUT);
      $date = $tmp;
      $fileNum++;
      $fileName = $date.".kml"; # sprintf("%05d.kml", $fileNum);
      printf STDERR "$date : $fileName\n";
      open(OUT, ">$fileName"); print OUT $head;
    }
  }
  if(m,gx:Track,) { close(OUT); last; }
  print OUT "$_\n";
}
