From: Bron Gondwana <brong@fastmail.fm>
Subject: fallocate creating fragmented files
Date: Wed, 30 Jan 2013 16:46:49 +1100
Message-ID: <1359524809.5789.140661184325217.261ED7C8@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Rob Mueller <robm@fastmail.fm>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:47449 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750732Ab3A3Fqu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Jan 2013 00:46:50 -0500
Received: from compute3.internal (compute3.nyi.mail.srv.osa [10.202.2.43])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id 1AF2B209DA
	for <linux-ext4@vger.kernel.org>; Wed, 30 Jan 2013 00:46:50 -0500 (EST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi All,

I'm trying to understand why my ext4 filesystem is creating highly fragmented files even though it's only just over 50% full.

The hardware is 2 x 64Gb Intel x25e drives in software RAID1 as /dev/md0:

[brong@imap14 conf]$ cat /proc/mdstat 
Personalities : [raid1] 
md0 : active raid1 sdf[0] sdg[1]
      62522624 blocks [2/2] [UU]
      
unused devices: <none>


[brong@imap14 conf]$ df | grep md0
/dev/md0              58594701  30996530  24472040  56% /mnt/ssd14

It's mounted data=ordered:

[brong@imap14 conf]$ mount | grep md0
/dev/md0 on /mnt/ssd14 type ext4 (rw,noatime,data=ordered,barrier=0,commit=120)


The filesystem was created with 1k blocks, nearly 2 years ago.  It's seen a lot of usage since then, but never been super-full.


[brong@imap14 conf]$ dumpe2fs -h /dev/md0
dumpe2fs 1.42.4 (12-Jun-2012)
Filesystem volume name:   <none>
Last mounted on:          /mnt/ssd14
Filesystem UUID:          f10d5f08-a4b5-476f-9568-586ca0b793b5
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype needs_recovery extent flex_bg sparse_super huge_file uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash 
Default mount options:    (none)
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              15632384
Block count:              62522624
Reserved block count:     3126131
Free blocks:              26483551
Free inodes:              13674200
First block:              1
Block size:               1024
Fragment size:            1024
Reserved GDT blocks:      256
Blocks per group:         8192
Fragments per group:      8192
Inodes per group:         2048
Inode blocks per group:   512
Flex block group size:    16
Filesystem created:       Tue Mar  8 08:30:35 2011
Last mount time:          Thu Jan 24 20:05:50 2013
Last write time:          Thu Jan 24 20:05:50 2013
Mount count:              10
Maximum mount count:      24
Last checked:             Fri May 13 09:10:27 2011
Check interval:           15552000 (6 months)
Next check after:         Wed Nov  9 08:10:27 2011
Lifetime writes:          33 TB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:	          256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
First orphan inode:       14256056
Default directory hash:   half_md4
Directory Hash Seed:      2f49b7f2-f4f7-464a-b804-8598867da2ba
Journal backup:           inode blocks
Journal features:         journal_incompat_revoke
Journal size:             32M
Journal length:           32768
Journal sequence:         0xcfc0f41e
Journal start:            16226


----------------------------

Now we've got some background, let's create two files using the fallocate command line tool, and see where the blocks wound up.  This mirrors exactly the behaviour we have seen with both using posix_fallocate to pre-allocate space, or just using seek and writev to write individual records out to the file.  Except with the slower writes of a real application, we get closer to 9000 extents for a file this size.

[brong@imap14 conf]$ fallocate -l 20m testfile 
[brong@imap14 conf]$ fallocate -l 20m testfile2
[brong@imap14 conf]$ filefrag testfile
testfile: 421 extents found
[brong@imap14 conf]$ filefrag testfile2
testfile2: 306 extents found

Now looking at the verbose output, we can see that there are many extents of just 3 or 4 blocks:

[brong@imap14 conf]$ filefrag -v testfile | awk '{print $5}' | sort -n | uniq -c | head
      2 
      1 is
      1 length
      1 unwritten
      6 3
     10 4
      6 5
      5 6
      3 7
      1 8

Yet looking at the next file,

[brong@imap14 conf]$ filefrag -v testfile2 | awk '{print $5}' | sort -n | uniq -c | tail
      1 173
      1 175
      1 178
      1 184
      1 187
      1 189
      1 194
      1 289
      1 321
      1 330


There are multiple extents of hundreds of blocks in length.  Why weren't they used in allocating the first file?

This filesystem is quite busy all the time.  There are hundreds of imapd processes all locking and writing to it, including a lot of fdatasync and fsync calls.  During the time it took to run this command, there would have been multiple fsyncs.  I can't see why that would affect the allocator in this way for a single fallocate call though.

Regards,

Bron.

(full filefrag dump for testfile follows:)

[brong@imap14 conf]$ filefrag -v testfile
Filesystem type is: ef53
File size of testfile is 20971520 (20480 blocks, blocksize 1024)
 ext logical physical expected length flags
   0       0 13545000              48 unwritten
   1      48 13545134 13545048     48 unwritten
   2      96 13545357 13545182     48 unwritten
   3     144 13545431 13545405     48 unwritten
   4     192 13546319 13545479     48 unwritten
   5     240 13546936 13546367     48 unwritten
   6     288 13542294 13546984     47 unwritten
   7     335 13542391 13542341     47 unwritten
   8     382 13542478 13542438     47 unwritten
   9     429 13542719 13542525     47 unwritten
  10     476 13542927 13542766     47 unwritten
  11     523 13543448 13542974     47 unwritten
  12     570 13543595 13543495     47 unwritten
  13     617 13543745 13543642     47 unwritten
  14     664 13543994 13543792     47 unwritten
  15     711 13544115 13544041     47 unwritten
  16     758 13544396 13544162     47 unwritten
  17     805 13544471 13544443     47 unwritten
  18     852 13544608 13544518     47 unwritten
  19     899 13547571 13544655     48 unwritten
  20     947 13545648 13547619     47 unwritten
  21     994 13545706 13545695     47 unwritten
  22    1041 13544043 13545753     46 unwritten
  23    1087 13547656 13544089     88 unwritten
  24    1175 13544923 13547744     46 unwritten
  25    1221 13547756 13544969     47 unwritten
  26    1268 13545598 13547803     46 unwritten
  27    1314 13546485 13545644     46 unwritten
  28    1360 13546677 13546531     46 unwritten
  29    1406 13547836 13546723     83 unwritten
  30    1489 13547921 13547919     51 unwritten
  31    1540 13547973 13547972     55 unwritten
  32    1595 13546828 13548028     46 unwritten
  33    1641 13548107 13546874     68 unwritten
  34    1709 13548176 13548175     59 unwritten
  35    1768 13546883 13548235     46 unwritten
  36    1814 13542536 13546929     45 unwritten
  37    1859 13546182 13542581     44 unwritten
  38    1903 13548255 13546226     52 unwritten
  39    1955 13541526 13548307     43 unwritten
  40    1998 13545077 13541569     43 unwritten
  41    2041 13545183 13545120     43 unwritten
  42    2084 13541687 13545226     42 unwritten
  43    2126 13543819 13541729     42 unwritten
  44    2168 13548400 13543861    132 unwritten
  45    2300 13548605 13548532     73 unwritten
  46    2373 13548679 13548678     43 unwritten
  47    2416 13545815 13548722     42 unwritten
  48    2458 13548728 13545857    104 unwritten
  49    2562 13548833 13548832     62 unwritten
  50    2624 13548896 13548895     45 unwritten
  51    2669 13548942 13548941     66 unwritten
  52    2735 13546442 13549008     40 unwritten
  53    2775 13542342 13546482     38 unwritten
  54    2813 13544286 13542380     38 unwritten
  55    2851 13549069 13544324    152 unwritten
  56    3003 13541775 13549221     37 unwritten
  57    3040 13545858 13541812     37 unwritten
  58    3077 13549016 13545895     37 unwritten
  59    3114 13544780 13549053     36 unwritten
  60    3150 13547004 13544816     36 unwritten
  61    3186 13546147 13547040     34 unwritten
  62    3220 13549304 13546181     60 unwritten
  63    3280 13549365 13549364     76 unwritten
  64    3356 13548308 13549441     34 unwritten
  65    3390 13542234 13548342     32 unwritten
  66    3422 13548343 13542266     32 unwritten
  67    3454 13542009 13548375     31 unwritten
  68    3485 13542445 13542040     31 unwritten
  69    3516 13542662 13542476     31 unwritten
  70    3547 13545965 13542693     31 unwritten
  71    3578 13549222 13545996     31 unwritten
  72    3609 13543892 13549253     30 unwritten
  73    3639 13544749 13543922     30 unwritten
  74    3669 13545323 13544779     30 unwritten
  75    3699 13546759 13545353     30 unwritten
  76    3729 13546645 13546789     29 unwritten
  77    3758 13547328 13546674     29 unwritten
  78    3787 13544257 13547357     28 unwritten
  79    3815 13549893 13544285     33 unwritten
  80    3848 13550421 13549926     60 unwritten
  81    3908 13554246 13550481     59 unwritten
  82    3967 13550131 13554305     56 unwritten
  83    4023 13551262 13550187     56 unwritten
  84    4079 13551565 13551318     56 unwritten
  85    4135 13551661 13551621     56 unwritten
  86    4191 13553303 13551717     56 unwritten
  87    4247 13555017 13553359     56 unwritten
  88    4303 13550960 13555073     55 unwritten
  89    4358 13554082 13551015     55 unwritten
  90    4413 13554384 13554137     55 unwritten
  91    4468 13554916 13554439     55 unwritten
  92    4523 13551128 13554971     54 unwritten
  93    4577 13552389 13551182     52 unwritten
  94    4629 13555468 13552441     51 unwritten
  95    4680 13554742 13555519     50 unwritten
  96    4730 13555208 13554792     50 unwritten
  97    4780 13554673 13555258     49 unwritten
  98    4829 13555132 13554722     48 unwritten
  99    4877 13551757 13555180     47 unwritten
 100    4924 13552116 13551804     47 unwritten
 101    4971 13552595 13552163     47 unwritten
 102    5018 13554562 13552642     47 unwritten
 103    5065 13550644 13554609     46 unwritten
 104    5111 13550702 13550690     46 unwritten
 105    5157 13552001 13550748     46 unwritten
 106    5203 13552535 13552047     46 unwritten
 107    5249 13552971 13552581     46 unwritten
 108    5295 13553841 13553017     46 unwritten
 109    5341 13557058 13553887    123 unwritten
 110    5464 13550578 13557181     45 unwritten
 111    5509 13551044 13550623     43 unwritten
 112    5552 13557376 13551087    111 unwritten
 113    5663 13557488 13557487     71 unwritten
 114    5734 13551325 13557559     43 unwritten
 115    5777 13552774 13551368     43 unwritten
 116    5820 13553935 13552817     43 unwritten
 117    5863 13557599 13553978    162 unwritten
 118    6025 13552493 13557761     41 unwritten
 119    6066 13550194 13552534     39 unwritten
 120    6105 13550520 13550233     39 unwritten
 121    6144 13553029 13550559     39 unwritten
 122    6183 13552643 13553068     38 unwritten
 123    6221 13555841 13552681     38 unwritten
 124    6259 13555681 13555879     37 unwritten
 125    6296 13551425 13555718     36 unwritten
 126    6332 13550385 13551461     35 unwritten
 127    6367 13552288 13550420     35 unwritten
 128    6402 13552457 13552323     35 unwritten
 129    6437 13555329 13552492     35 unwritten
 130    6472 13550340 13555364     33 unwritten
 131    6505 13550901 13550373     33 unwritten
 132    6538 13552164 13550934     33 unwritten
 133    6571 13551528 13552197     32 unwritten
 134    6603 13551622 13551560     31 unwritten
 135    6634 13557026 13551653     31 unwritten
 136    6665 13552696 13557057     29 unwritten
 137    6694 13549661 13552725     26 unwritten
 138    6720 13552070 13549687     26 unwritten
 139    6746 13557336 13552096     26 unwritten
 140    6772 13549741 13557362     24 unwritten
 141    6796 13551016 13549765     24 unwritten
 142    6820 13551805 13551040     24 unwritten
 143    6844 13551878 13551829     24 unwritten
 144    6868 13553981 13551902     24 unwritten
 145    6892 13554972 13554005     24 unwritten
 146    6916 13556993 13554996     23 unwritten
 147    6939 13554631 13557016     22 unwritten
 148    6961 13551201 13554653     21 unwritten
 149    6982 13553888 13551222     21 unwritten
 150    7003 13554508 13553909     21 unwritten
 151    7024 13557560 13554529     21 unwritten
 152    7045 13554610 13557581     20 unwritten
 153    7065 13555188 13554630     19 unwritten
 154    7084 13553910 13555207     18 unwritten
 155    7102 13549803 13553928     17 unwritten
 156    7119 13550307 13549820     17 unwritten
 157    7136 13550938 13550324     17 unwritten
 158    7153 13551381 13550955     17 unwritten
 159    7170 13553806 13551398     17 unwritten
 160    7187 13556111 13553823     17 unwritten
 161    7204 13556460 13556128     17 unwritten
 162    7221 13549602 13556477     16 unwritten
 163    7237 13549786 13549618     16 unwritten
 164    7253 13550482 13549802     16 unwritten
 165    7269 13552097 13550498     16 unwritten
 166    7285 13556478 13552113     15 unwritten
 167    7300 13556776 13556493     15 unwritten
 168    7315 13549622 13556791     13 unwritten
 169    7328 13549993 13549635     13 unwritten
 170    7341 13550234 13550006     13 unwritten
 171    7354 13550499 13550247     13 unwritten
 172    7367 13551950 13550512     13 unwritten
 173    7380 13554362 13551963     13 unwritten
 174    7393 13557585 13554375     13 unwritten
 175    7406 13550091 13557598     12 unwritten
 176    7418 13550248 13550103     12 unwritten
 177    7430 13551484 13550260     12 unwritten
 178    7442 13551981 13551496     12 unwritten
 179    7454 13552582 13551993     12 unwritten
 180    7466 13554799 13552594     12 unwritten
 181    7478 13554997 13554811     12 unwritten
 182    7490 13555452 13555009     12 unwritten
 183    7502 13556098 13555464     12 unwritten
 184    7514 13557363 13556110     12 unwritten
 185    7526 13550750 13557375     11 unwritten
 186    7537 13550762 13550761     11 unwritten
 187    7548 13551903 13550773     11 unwritten
 188    7559 13554730 13551914     11 unwritten
 189    7570 13550691 13554741     10 unwritten
 190    7580 13551517 13550701     10 unwritten
 191    7590 13552324 13551527     10 unwritten
 192    7600 13554013 13552334     10 unwritten
 193    7610 13554812 13554023     10 unwritten
 194    7620 13549843 13554822      9 unwritten
 195    7629 13551118 13549852      9 unwritten
 196    7638 13551250 13551127      9 unwritten
 197    7647 13551500 13551259      9 unwritten
 198    7656 13552335 13551509      9 unwritten
 199    7665 13553684 13552344      9 unwritten
 200    7674 13554661 13553693      9 unwritten
 201    7683 13556886 13554670      9 unwritten
 202    7692 13559300 13556895      9 unwritten
 203    7701 13561293 13559309      9 unwritten
 204    7710 13561303 13561302      8 unwritten
 205    7718 13560950 13561311      7 unwritten
 206    7725 13561199 13560957      7 unwritten
 207    7732 13561317 13561206      7 unwritten
 208    7739 13559285 13561324      6 unwritten
 209    7745 13561183 13559291      6 unwritten
 210    7751 13561192 13561189      6 unwritten
 211    7757 13561548 13561198      6 unwritten
 212    7763 13558768 13561554      5 unwritten
 213    7768 13558889 13558773      5 unwritten
 214    7773 13559294 13558894      5 unwritten
 215    7778 13559310 13559299      5 unwritten
 216    7783 13560214 13559315      5 unwritten
 217    7788 13561118 13560219      5 unwritten
 218    7793 13558047 13561123      4 unwritten
 219    7797 13558332 13558051      4 unwritten
 220    7801 13558365 13558336      4 unwritten
 221    7805 13558622 13558369      4 unwritten
 222    7809 13558679 13558626      4 unwritten
 223    7813 13558749 13558683      4 unwritten
 224    7817 13559165 13558753      4 unwritten
 225    7821 13564189 13559169     36 unwritten
 226    7857 13564289 13564225     70 unwritten
 227    7927 13559354 13564359      4 unwritten
 228    7931 13564891 13559358     38 unwritten
 229    7969 13565148 13564929     84 unwritten
 230    8053 13565233 13565232     63 unwritten
 231    8116 13565297 13565296     19 unwritten
 232    8135 13565317 13565316     10 unwritten
 233    8145 13565328 13565327     41 unwritten
 234    8186 13559471 13565369      4 unwritten
 235    8190 13565375 13559475     45 unwritten
 236    8235 13565421 13565420     38 unwritten
 237    8273 13565460 13565459     48 unwritten
 238    8321 13565509 13565508     17 unwritten
 239    8338 13565370 13565526      4 unwritten
 240    8342 13557962 13565374      3 unwritten
 241    8345 13565533 13557965     94 unwritten
 242    8439 13558370 13565627      3 unwritten
 243    8442 13565631 13558373      6 unwritten
 244    8448 13565638 13565637     86 unwritten
 245    8534 13558540 13565724      3 unwritten
 246    8537 13565729 13558543     13 unwritten
 247    8550 13565743 13565742    105 unwritten
 248    8655 13565849 13565848     28 unwritten
 249    8683 13565878 13565877     75 unwritten
 250    8758 13558664 13565953      3 unwritten
 251    8761 13558762 13558667      3 unwritten
 252    8764 13558858 13558765      3 unwritten
 253    8767 13565981 13558861     11 unwritten
 254    8778 13570409 13565992     54 unwritten
 255    8832 13571201 13570463     47 unwritten
 256    8879 13575188 13571248     35 unwritten
 257    8914 13579393 13575223    119 unwritten
 258    9033 13582040 13579512    106 unwritten
 259    9139 13582147 13582146     82 unwritten
 260    9221 13582231 13582229    106 unwritten
 261    9327 13575840 13582337     53 unwritten
 262    9380 13582005 13575893     34 unwritten
 263    9414 13579728 13582039     33 unwritten
 264    9447 13579915 13579761     24 unwritten
 265    9471 13574339 13579939     23 unwritten
 266    9494 13577088 13574362     20 unwritten
 267    9514 13577627 13577108     19 unwritten
 268    9533 13579950 13577646     18 unwritten
 269    9551 13574295 13579968     17 unwritten
 270    9568 13582508 13574312     30 unwritten
 271    9598 13588652 13582538    146 unwritten
 272    9744 13585801 13588798    121 unwritten
 273    9865 13585434 13585922    120 unwritten
 274    9985 13588448 13585554    119 unwritten
 275   10104 13588180 13588567    113 unwritten
 276   10217 13588951 13588293    107 unwritten
 277   10324 13586207 13589058    106 unwritten
 278   10430 13589131 13586313    164 unwritten
 279   10594 13586622 13589295    102 unwritten
 280   10696 13589328 13586724    106 unwritten
 281   10802 13586927 13589434     82 unwritten
 282   10884 13585993 13587009     79 unwritten
 283   10963 13587311 13586072     78 unwritten
 284   11041 13589514 13587389     78 unwritten
 285   11119 13587602 13589592     77 unwritten
 286   11196 13589929 13587679    161 unwritten
 287   11357 13589436 13590090     77 unwritten
 288   11434 13590120 13589513    120 unwritten
 289   11554 13590241 13590240    126 unwritten
 290   11680 13586543 13590367     76 unwritten
 291   11756 13590409 13586619    120 unwritten
 292   11876 13589593 13590529     70 unwritten
 293   11946 13586857 13589663     69 unwritten
 294   12015 13586359 13586926     67 unwritten
 295   12082 13588883 13586426     67 unwritten
 296   12149 13589063 13588950     67 unwritten
 297   12216 13586727 13589130     64 unwritten
 298   12280 13586468 13586791     61 unwritten
 299   12341 13585929 13586529     60 unwritten
 300   12401 13586073 13585989     59 unwritten
 301   12460 13585613 13586132     58 unwritten
 302   12518 13585690 13585671     58 unwritten
 303   12576 13584829 13585748     57 unwritten
 304   12633 13589704 13584886     57 unwritten
 305   12690 13588800 13589761     52 unwritten
 306   12742 13588312 13588852     51 unwritten
 307   12793 13586148 13588363     47 unwritten
 308   12840 44779909 13586195     61 unwritten
 309   12901 44780846 44779970     79 unwritten
 310   12980 44780458 44780925     61 unwritten
 311   13041 44779653 44780519     58 unwritten
 312   13099 44777775 44779711     52 unwritten
 313   13151 44778482 44777827     51 unwritten
 314   13202 44779251 44778533     51 unwritten
 315   13253 44781016 44779302     91 unwritten
 316   13344 44778808 44781107     48 unwritten
 317   13392 44779120 44778856     46 unwritten
 318   13438 44781140 44779166     63 unwritten
 319   13501 44778244 44781203     45 unwritten
 320   13546 44778762 44778289     45 unwritten
 321   13591 44781225 44778807     95 unwritten
 322   13686 44778858 44781320     44 unwritten
 323   13730 44778187 44778902     43 unwritten
 324   13773 44779053 44778230     41 unwritten
 325   13814 44781399 44779094     43 unwritten
 326   13857 44778962 44781442     40 unwritten
 327   13897 44779487 44779002     40 unwritten
 328   13937 44778414 44779527     39 unwritten
 329   13976 44778922 44778453     39 unwritten
 330   14015 44781321 44778961     39 unwritten
 331   14054 44781517 44781360     85 unwritten
 332   14139 44780786 44781602     38 unwritten
 333   14177 44777555 44780824     37 unwritten
 334   14214 44780587 44777592     36 unwritten
 335   14250 44778642 44780623     35 unwritten
 336   14285 44781647 44778677    100 unwritten
 337   14385 44781748 44781747     45 unwritten
 338   14430 44780382 44781793     35 unwritten
 339   14465 44778340 44780417     34 unwritten
 340   14499 44779385 44778374     34 unwritten
 341   14533 44781848 44779419     72 unwritten
 342   14605 44779870 44781920     34 unwritten
 343   14639 44780015 44779904     34 unwritten
 344   14673 44777889 44780049     33 unwritten
 345   14706 44781972 44777922    138 unwritten
 346   14844 44782111 44782110    160 unwritten
 347   15004 44780926 44782271     32 unwritten
 348   15036 44778375 44780958     31 unwritten
 349   15067 44778575 44778406     31 unwritten
 350   15098 44780187 44778606     30 unwritten
 351   15128 44782299 44780217     37 unwritten
 352   15165 44778688 44782336     29 unwritten
 353   15194 44782353 44778717     75 unwritten
 354   15269 44782429 44782428    122 unwritten
 355   15391 44782553 44782551    322 unwritten
 356   15713 44782876 44782875     40 unwritten
 357   15753 44782917 44782916     30 unwritten
 358   15783 44782948 44782947     70 unwritten
 359   15853 44783019 44783018     86 unwritten
 360   15939 44783107 44783105    215 unwritten
 361   16154 44783323 44783322     35 unwritten
 362   16189 44778724 44783358     29 unwritten
 363   16218 44783389 44778753     52 unwritten
 364   16270 44783442 44783441     67 unwritten
 365   16337 44783510 44783509     76 unwritten
 366   16413 44783587 44783586     91 unwritten
 367   16504 44783679 44783678    188 unwritten
 368   16692 44783868 44783867     55 unwritten
 369   16747 44783924 44783923     45 unwritten
 370   16792 44783970 44783969     39 unwritten
 371   16831 44780072 44784009     29 unwritten
 372   16860 44784022 44780101     73 unwritten
 373   16933 44784096 44784095     76 unwritten
 374   17009 44780115 44784172     29 unwritten
 375   17038 44780145 44780144     29 unwritten
 376   17067 44784181 44780174    233 unwritten
 377   17300 44784415 44784414    255 unwritten
 378   17555 44783359 44784670     29 unwritten
 379   17584 44779712 44783388     28 unwritten
 380   17612 44779777 44779740     28 unwritten
 381   17640 44784707 44779805     52 unwritten
 382   17692 44781369 44784759     28 unwritten
 383   17720 44777970 44781397     27 unwritten
 384   17747 44778085 44777997     27 unwritten
 385   17774 44778141 44778112     27 unwritten
 386   17801 44778293 44778168     27 unwritten
 387   17828 44784809 44778320    179 unwritten
 388   18007 44784989 44784988     40 unwritten
 389   18047 44785030 44785029    231 unwritten
 390   18278 44785262 44785261     45 unwritten
 391   18323 44785308 44785307    357 unwritten
 392   18680 44778547 44785665     27 unwritten
 393   18707 44779357 44778574     27 unwritten
 394   18734 44779537 44779384     27 unwritten
 395   18761 44780278 44779564     27 unwritten
 396   18788 44781921 44780305     27 unwritten
 397   18815 44779017 44781948     26 unwritten
 398   18841 44779580 44779043     26 unwritten
 399   18867 44780335 44779606     26 unwritten
 400   18893 44780658 44780361     26 unwritten
 401   18919 44780728 44780684     26 unwritten
 402   18945 44785892 44780754     30 unwritten
 403   18975 44789606 44785922    136 unwritten
 404   19111 44788602 44789742    104 unwritten
 405   19215 44789075 44788706     95 unwritten
 406   19310 44789895 44789170     92 unwritten
 407   19402 44787855 44789987     78 unwritten
 408   19480 44787670 44787933     77 unwritten
 409   19557 44791413 44787747     80 unwritten
 410   19637 44788513 44791493     75 unwritten
 411   19712 44790631 44788588     75 unwritten
 412   19787 44787177 44790706     71 unwritten
 413   19858 44791556 44787248    122 unwritten
 414   19980 44790092 44791678     69 unwritten
 415   20049 44786455 44790161     68 unwritten
 416   20117 44790242 44786523     66 unwritten
 417   20183 44791726 44790308    118 unwritten
 418   20301 44791100 44791844     63 unwritten
 419   20364 44788380 44791163     62 unwritten
 420   20426 44786252 44788442     54 unwritten,eof
testfile: 421 extents found


-- 
  Bron Gondwana
  brong@fastmail.fm

