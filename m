From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 14/19] tests: add tests for handling of corrupt extents
Date: Fri, 01 Aug 2014 11:13:14 -0700
Message-ID: <20140801181314.12496.3254.stgit@birch.djwong.org>
References: <20140801181139.12496.14390.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33704 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827AbaHASNU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Aug 2014 14:13:20 -0400
In-Reply-To: <20140801181139.12496.14390.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Add some regression tests to examine how e2fsck deals with (a) extent
blocks with only a bad checksum; (b) extent blocks with a bad magic
number; and (c) extent entries with corruption.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/f_extent_bad_node/name            |    2 +-
 tests/f_extent_int_bad_csum/expect.1    |   11 +++++++++++
 tests/f_extent_int_bad_csum/expect.2    |    7 +++++++
 tests/f_extent_int_bad_csum/image.gz    |  Bin
 tests/f_extent_int_bad_csum/name        |    1 +
 tests/f_extent_int_bad_extent/expect.1  |   24 ++++++++++++++++++++++++
 tests/f_extent_int_bad_extent/expect.2  |    7 +++++++
 tests/f_extent_int_bad_extent/image.gz  |  Bin
 tests/f_extent_int_bad_extent/name      |    1 +
 tests/f_extent_int_bad_magic/expect.1   |   23 +++++++++++++++++++++++
 tests/f_extent_int_bad_magic/expect.2   |    7 +++++++
 tests/f_extent_int_bad_magic/image.gz   |  Bin
 tests/f_extent_int_bad_magic/name       |    1 +
 tests/f_extent_leaf_bad_csum/expect.1   |   11 +++++++++++
 tests/f_extent_leaf_bad_csum/expect.2   |    7 +++++++
 tests/f_extent_leaf_bad_csum/image.gz   |  Bin
 tests/f_extent_leaf_bad_csum/name       |    1 +
 tests/f_extent_leaf_bad_extent/expect.1 |   24 ++++++++++++++++++++++++
 tests/f_extent_leaf_bad_extent/expect.2 |    7 +++++++
 tests/f_extent_leaf_bad_extent/image.gz |  Bin
 tests/f_extent_leaf_bad_extent/name     |    1 +
 tests/f_extent_leaf_bad_magic/expect.1  |   23 +++++++++++++++++++++++
 tests/f_extent_leaf_bad_magic/expect.2  |    7 +++++++
 tests/f_extent_leaf_bad_magic/image.gz  |  Bin
 tests/f_extent_leaf_bad_magic/name      |    1 +
 25 files changed, 165 insertions(+), 1 deletion(-)
 create mode 100644 tests/f_extent_int_bad_csum/expect.1
 create mode 100644 tests/f_extent_int_bad_csum/expect.2
 create mode 100644 tests/f_extent_int_bad_csum/image.gz
 create mode 100644 tests/f_extent_int_bad_csum/name
 create mode 100644 tests/f_extent_int_bad_extent/expect.1
 create mode 100644 tests/f_extent_int_bad_extent/expect.2
 create mode 100644 tests/f_extent_int_bad_extent/image.gz
 create mode 100644 tests/f_extent_int_bad_extent/name
 create mode 100644 tests/f_extent_int_bad_magic/expect.1
 create mode 100644 tests/f_extent_int_bad_magic/expect.2
 create mode 100644 tests/f_extent_int_bad_magic/image.gz
 create mode 100644 tests/f_extent_int_bad_magic/name
 create mode 100644 tests/f_extent_leaf_bad_csum/expect.1
 create mode 100644 tests/f_extent_leaf_bad_csum/expect.2
 create mode 100644 tests/f_extent_leaf_bad_csum/image.gz
 create mode 100644 tests/f_extent_leaf_bad_csum/name
 create mode 100644 tests/f_extent_leaf_bad_extent/expect.1
 create mode 100644 tests/f_extent_leaf_bad_extent/expect.2
 create mode 100644 tests/f_extent_leaf_bad_extent/image.gz
 create mode 100644 tests/f_extent_leaf_bad_extent/name
 create mode 100644 tests/f_extent_leaf_bad_magic/expect.1
 create mode 100644 tests/f_extent_leaf_bad_magic/expect.2
 create mode 100644 tests/f_extent_leaf_bad_magic/image.gz
 create mode 100644 tests/f_extent_leaf_bad_magic/name

diff --git a/tests/f_extent_bad_node/name b/tests/f_extent_bad_node/name
index 9c9d79f..0b4ab8c 100644
--- a/tests/f_extent_bad_node/name
+++ b/tests/f_extent_bad_node/name
@@ -1 +1 @@
-bad interior node in extent tree
+bad interior node in extent tree (metadata_csum)
diff --git a/tests/f_extent_int_bad_csum/expect.1 b/tests/f_extent_int_bad_csum/expect.1
new file mode 100644
index 0000000..57a2a61
--- /dev/null
+++ b/tests/f_extent_int_bad_csum/expect.1
@@ -0,0 +1,11 @@
+Pass 1: Checking inodes, blocks, and sizes
+Inode 12 extent block passes checks, but checksum does not match extent
+	(logical block 698, invalid physical block 1788, len 1)
+Fix? yes
+
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/128 files (16.7% non-contiguous), 1446/2048 blocks
+Exit status is 0
diff --git a/tests/f_extent_int_bad_csum/expect.2 b/tests/f_extent_int_bad_csum/expect.2
new file mode 100644
index 0000000..6f73d98
--- /dev/null
+++ b/tests/f_extent_int_bad_csum/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/128 files (16.7% non-contiguous), 1446/2048 blocks
+Exit status is 0
diff --git a/tests/f_extent_int_bad_csum/image.gz b/tests/f_extent_int_bad_csum/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..f3878981239804cbd7244abf21b7130a1129df41
GIT binary patch
literal 7202
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
PwD4$4;Zsk&_SAm>O7k`<

literal 0
HcmV?d00001

diff --git a/tests/f_extent_int_bad_csum/name b/tests/f_extent_int_bad_csum/name
new file mode 100644
index 0000000..87317e3
--- /dev/null
+++ b/tests/f_extent_int_bad_csum/name
@@ -0,0 +1 @@
+bad csum in internal extent (metadata_csum)
diff --git a/tests/f_extent_int_bad_extent/expect.1 b/tests/f_extent_int_bad_extent/expect.1
new file mode 100644
index 0000000..3d2fb58
--- /dev/null
+++ b/tests/f_extent_int_bad_extent/expect.1
@@ -0,0 +1,24 @@
+Pass 1: Checking inodes, blocks, and sizes
+Inode 12 has an invalid extent
+	(logical block 0, invalid physical block 4294967295, len 168)
+Clear? yes
+
+Inode 12, i_blocks is 712, should be 542.  Fix? yes
+
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Block bitmap differences:  -(1090--1091) -1093 -1095 -1097 -1099 -1101 -1103 -1105 -1107 -1109 -1111 -1113 -1115 -1117 -1119 -1121 -1123 -1125 -1127 -1129 -1131 -1133 -1135 -1137 -1139 -1141 -1143 -1145 -1147 -1149 -1151 -1153 -1155 -1157 -1159 -1161 -1163 -1165 -1167 -1169 -1171 -1173 -1175 -1177 -1179 -1181 -1183 -1185 -1187 -1189 -1191 -1193 -1195 -1197 -1199 -1201 -1203 -1205 -1207 -1209 -1211 -1213 -1215 -1217 -1219 -1221 -1223 -1225 -1227 -1229 -1231 -1233 -1235 -1237 -1239 -1241 -1243 -1245 -1247 -1249 -1251 -1253 -1255 -1257
+Fix? yes
+
+Free blocks count wrong for group #0 (602, counted=687).
+Fix? yes
+
+Free blocks count wrong (602, counted=687).
+Fix? yes
+
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 12/128 files (16.7% non-contiguous), 1361/2048 blocks
+Exit status is 1
diff --git a/tests/f_extent_int_bad_extent/expect.2 b/tests/f_extent_int_bad_extent/expect.2
new file mode 100644
index 0000000..4e72e41
--- /dev/null
+++ b/tests/f_extent_int_bad_extent/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/128 files (16.7% non-contiguous), 1361/2048 blocks
+Exit status is 0
diff --git a/tests/f_extent_int_bad_extent/image.gz b/tests/f_extent_int_bad_extent/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..e8745bff45f2a1f226ba59278bcaf7868e4533c8
GIT binary patch
literal 7205
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
N<Z{k)&%N>7KLJX2H(US!

literal 0
HcmV?d00001

diff --git a/tests/f_extent_int_bad_extent/name b/tests/f_extent_int_bad_extent/name
new file mode 100644
index 0000000..e22f6b4
--- /dev/null
+++ b/tests/f_extent_int_bad_extent/name
@@ -0,0 +1 @@
+bad extent in internal extent (metadata_csum)
diff --git a/tests/f_extent_int_bad_magic/expect.1 b/tests/f_extent_int_bad_magic/expect.1
new file mode 100644
index 0000000..0e82e2b
--- /dev/null
+++ b/tests/f_extent_int_bad_magic/expect.1
@@ -0,0 +1,23 @@
+Pass 1: Checking inodes, blocks, and sizes
+Inode 12 has an invalid extent node (blk 1295, lblk 0)
+Clear? yes
+
+Inode 12, i_blocks is 712, should be 0.  Fix? yes
+
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Block bitmap differences:  -(1090--1093) -1095 -1097 -1099 -1101 -1103 -1105 -1107 -1109 -1111 -1113 -1115 -1117 -1119 -1121 -1123 -1125 -1127 -1129 -1131 -1133 -1135 -1137 -1139 -1141 -1143 -1145 -1147 -1149 -1151 -1153 -1155 -1157 -1159 -1161 -1163 -1165 -1167 -1169 -1171 -1173 -1175 -1177 -1179 -1181 -1183 -1185 -1187 -1189 -1191 -1193 -1195 -1197 -1199 -1201 -1203 -1205 -1207 -1209 -1211 -1213 -1215 -1217 -1219 -1221 -1223 -1225 -1227 -1229 -1231 -1233 -1235 -1237 -1239 -1241 -1243 -1245 -1247 -1249 -1251 -1253 -1255 -1257 -1259 -1261 -1263 -1265 -1267 -1269 -1271 -1273 -1275 -1277 -1279 -1281 -1283 -1285 -1287 -(1289--1298) -1300 -1302 -1304 -1306 -1308 -1310 -1312 -1314 -1316 -1318 -1320 -1322 -1324 -1326 -1328 -1330 -1332 -1334 -1336 -1338 -1340 -1342 -1344 -1346 -1348 -1350 -1352 
 -1354 -1356 -1358 -1360 -1362 -1364 -1366 -1368 -1370 -1372 -1374 -1376 -1378 -1380 -1382 -1384 -1386 -1388 -1390 -1392 -1394 -1396 -1398 -1400 -1402 -1404 -1406 -1408 -1410 -1412 -1414 -14!
 16 -1418 -1420 -1422 -1424 -1426 -1428 -1430 -1432 -1434 -1436 -1438 -1440 -1442 -1444 -1446 -1448 -1450 -1452 -1454 -1456 -1458 -1460 -1462 -1464 -1466 -1468 -1470 -1472 -1474 -1476 -1478 -1480 -1482 -1484 -1486 -1488 -1490 -1492 -1494 -1496 -1498 -1500 -1502 -1504 -1506 -1508 -1510 -1512 -1514 -1516 -1518 -1520 -1522 -1524 -1526 -1528 -1530 -1532 -1534 -1536 -1538 -1540 -1542 -1544 -1546 -1548 -1550 -1552 -1554 -1556 -1558 -1560 -1562 -1564 -1566 -1568 -1570 -1572 -1574 -1576 -1578 -1580 -1582 -1584 -1586 -1588 -1590 -1592 -1594 -1596 -1598 -1600 -1602 -1604 -1606 -1608 -1610 -1612 -1614 -1616 -1618 -1620 -1622 -1624 -1626 -1628 -1630 -1632 -1634 -1636 -1638 -1640 -1642 -1644 -1646 -1648 -1650 -1652 -1654 -1656 -1658 -1660 -1662 -1664 -1666 -1668 -1670 -1672 -1674 -1676 -1678 -1680 -168
 2 -1684 -1686 -1688 -1690 -1692 -1694 -1696 -1698 -1700 -1702 -1704 -1706 -1708 -1710 -1712 -1714 -1716 -1718 -1720 -1722 -1724 -1726 -1728 -1730 -1732 -1734 -1736 -1738 -1740 -1742 -1744 -!
 1746 -1748 -1750 -1752 -1754 -1756 -1758 -1760 -1762 -1764 -17!
 66 -1768 -1770 -1772 -1774 -1776 -1778 -1780 -1782 -1784 -1786 -1788
+Fix? yes
+
+Free blocks count wrong for group #0 (602, counted=958).
+Fix? yes
+
+Free blocks count wrong (602, counted=958).
+Fix? yes
+
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 12/128 files (8.3% non-contiguous), 1090/2048 blocks
+Exit status is 1
diff --git a/tests/f_extent_int_bad_magic/expect.2 b/tests/f_extent_int_bad_magic/expect.2
new file mode 100644
index 0000000..283cc1f
--- /dev/null
+++ b/tests/f_extent_int_bad_magic/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/128 files (8.3% non-contiguous), 1090/2048 blocks
+Exit status is 0
diff --git a/tests/f_extent_int_bad_magic/image.gz b/tests/f_extent_int_bad_magic/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..e00f887cca9e8d6b139083ac51c54b46f0e30fd8
GIT binary patch
literal 7205
zcmeHLeN+=?zOHMxbhoS7*3+fcC8^t5PS@3F6;Wc6x~_uq5mAx|NTQ`0HHN5wk-<so
z+Df~ApcO$u5*0!)Ll}`S`AA~53$_Z;#32fXv?AgRA5obhWa4D*?EUNZ+&}L9=bm%V
zp3YzM&UxQ+e)F8?_xzsc<s5nam4aFB4ZoT?>R}b7d<pu0da!lHrZ<1{(>mFW=g;1f
zP49HCT)K9t?dI$+e!ued3$NbU82^lOA@28<6+11)S1ogT-l^zFi~rri;<r{FUD)x~
z&SMLEvZjfZmW3S`8++awu>UqWQ{3+zIUt=fTW^~<mYB!3@(hFBx6AVtKI<aQHqFdw
zo7IgM14ea4-T9>BD)r*xo*jM174P)SEFB6y<!KiLGou=!o74s>C*2=7jQIJA(UynW
zz_!1ZKTLDy?TxM2<1@M)`+d(jG2@3<`E^b14iV+ZP<OT^rC!0i99>i3V2O=~OP{FI
zLUSujn%eT+L(L!BgX4$#dOwUJ8x>2Gf|%xsojD`BLld{P`L%)asCLU?Q-0LUdJT`7
z!ULllLdw3bmYCkOTd(%7)hu70_3T<qgzUxz&oJ#IQ`OYw>8NmPpR<GIznV10+x;x~
zmld!4{F!vrQTDF}j`toKm0O=AK0R>gfxIqa;?pj>$_3x;5wzYVdC}C&(b0<7=Fnls
z`PGWxqYc6qT*qBX9Gx>>HZb#8txTngyua%@w=u0G+D`MlXRdhX57Wgm3&EN6SwnE%
z9@h`s)WcizuJt#C)S(c)aT^sjEZj_m)zF_4oXer9J-TZoYa=~nSorK#bI7~*JG!Oa
z)@4f8;Gd0WLK@GXb9Cz`vIL!NUCuA$NvU+-6)lTircn7FyjE1l!!PjgKF!mn2;fJh
zXJMdm%<7wN^-j0a)4^-gsV35i$_~+g>|@;@%-`(WLKRqht}TD67JMaa0(bE5WJUb;
z9jESxCgU;Ae2;73Fc>ynYlszHqoLD_{9^$_-W}b+0in;r&765`i*NGV5&eas-HsDu
zE}KWrYi=U`_`%pR?ZbEQ4^7mUmSY`vIuy3619s~YN`4d)iskyJyN<#r`{ae8XJTo-
zGSnw4rzfOb%_qJdG$LxmAh2{_RReM5xpq9d;I_=#wu3X#^5msIJx14Yupp{{5Tg4v
z<NFqiba#beu$`vq;nt@XI-q-DwUjI`9p?*HDih#`eY}1e-f`>O?&wUVVmxHe-ZUN>
zYjH4#Xti;UW7N|}XA58Scwf`etO)^MN2^z{AI+;iRmQMMv3OtJ3f)HKc0H`1@Aurd
zffFv3XQ*$F4#{qzUUYpC(_&rn=Sa=S1UQwK=l&?Z*cNDs`7xJvY6?O>yiB~M+lu4e
zjWfnx_B__;w7b*$Dp%Vl+-y20YqZfNu<`4?dZkt|tt<RJL+xNgupIxq+%_wX9v$m?
zGeTwA`YW|@aMVQI_tJ;0(xIMZ$CkA%he3I)(%>HPYa06Byg$N9!Pn?6S2U_s69qA8
z>K}GY6!6j<GfF84p<Env`)EWNzpa8ee101Txf^r*-bkT@l|-izCvaHGITP9#n{DsK
z2F$FrhC6qArP0C4<2}lmU7`KNSGYQ*Fd^D+uW%Zw1xvxT#B6i}6l>DeR|FTNYIIjB
z2w+XU<LP$myXFUWF@HYQhZLA}Cg1?6;iVNGDW&p}87_laUnDRAdr3cJs-(}8H*phW
zs-iCgY2+fr<uX|GCqtWv+xQ%$-f4jKr$QB2g-f>yOdv((!bIH#Ad5VLj63CKfq)vs
zX1H`|d?BTXuymg73aurs<5DQxXqQ-*QUo>!Ri_w=L)!=xRg1ZabRKa9Z-yKR^eQ41
zwbuxER5><?`t~)j2bKi$k-09N7|bGJ$PrH`5@y^FIYhLI_%+&Q<|fb?#46Md+m=!+
zq@+r>4ooEr5Wf0$FqwE8)z!$#wbkSgxKIqQp|c4ws=H*1p<qPm5@z-5w{Y~H`j9_k
z{FC(Y$*tKB39B+trLLBh+UkH*U?p)DJ%%WZYO{a`W)m;)dB|L6vjk4?N|<UUuyJPw
z0y#A)219=exPt7)-f(H8@*<mwe1uz>T6~c0FQASXM8nK*oN%Kx#@fPEasyF13sdB$
zwGAYOXEKGPo83kZZ2OS<8$se55O<Z~l5IY<iy%-H5?yJ4YzwKs5{L04$SfCE>@Ct7
z$tOA4H^BH-E7_A1OQ=u*(rgM!G)5lei}OSMMPqVM0enJu(1VD-GED3(V{ZcGKpa7#
zQz1?q%c5NXt|Ok{m$3rZ4T!U*uv)vAe}$~WtFd|LA&4X5tf&44<PaOsg@~h)*}jC|
z1f&C-h-~x*B#$eEwF~(dNF)9oCUu@78}xBY^7rQE18Z|*$(xt}y@Y@+mzn2sK|!M;
z#V>Nyuutg4`~`dyu#S9+eT!z6jt5=YOLDWy5k^<rKFjYrag^885phPJ&R@)j$@BPg
z<c2d+!V)=P_DR_~{>RqKKnjpde2e}QDX1(-DNHg*_#c7*aRD_VnXX&rPNSnnupE>S
zllTK<hVvE_StU&ot%Ym!=LF5bTCyE`-vyaXRSsBRY&#DC<aO*_^oUte#jVw!wlx4r
z<Q0a>B~s2Q+eOj1^&N{WgC7lUCED>)Y``TI8_w8T0WF{+{*Jd|U!qELxX~@;Cdt#S
zAAlLe4s;k2iM;Eqi@{8W$A_^+u33;{tv3bSM?MjB4V`<yNrB_MY1WUybfN|AV_2*a
z!)v|CpcdG`keCN?6TBH<GO5Roxcm}%sSPHt;1p6~;#AxIL~SN8{0TPK#gf8ngzG^u
zc^89Rg<?2SeMwfLZ6{0d8OX3pB$k(HtH@To9&wwR#oiOzTCxLw1DWOIO4JGVdkTk0
zYvAW48@es^>BIB@x7l;D^EGOxz3wBAo$SUx$J$&|A>SI7*%r;eO4{%fSkM(F5uRYD
zQJcy0SQoklVVMe~!f)8g)OO%AA`?wU(w$*ap<Yl)evLoHOwLTRVGSpZ+6C+)n((XG
zkh4H)Kf#t$p8|g+;?b`WxH6K+TIFA2YvuEen&C6@f4z!;ow;7T0qe$bOpCtDDB&U~
ztWqInB{(jziv+E}Zt@H^8_k564;FT*UJ9-wC$TN)45+{~BrS~NR<qB_HuC>$ttNlO
zA7Lw<@#a{Q2x6ZSSjjuM6RShFA_Go^grgTgjNXl4zd;8Xv72j-G)g6+BttrX4k#l|
zqGDu&Ye*`Jm#^dV!7ap5d=;|D6)ttGm8bC|!BpZddJ8ICBToi*0lCCO{4}F<N^_w|
zE(Sj(F)V;KB5yc{&EZw>C0UV7Ze0qhh;Q&*M6UHKW6gegB40o9u(z#;b{}6a>fVFq
zc4d0#gZ`zvCVQ3Y<NK>0$4zE9nmM^C^=;jG)fU1`CJoHu54gKj#|)(2o#o9iDqflk
z8#{E*_&m-Ioz0ybJ59-N2XlK9VKyzS&28DzVq<6SI~%&Uf~zt30$=kobbh?dUYYao
zqe$+uK+%jpL{F$P?tb1*8<*JvK<D3Q{DCVVDrXdH4{Y?`;&iQP2Tg(W#+D!%t_Ab^
zlA7&`15ebw>?ii&?|TM?4P^n&H(7#k#@I}h%l5wW&G3#c`ljCathQsmixUM$QR$Im
zTLMB)n!sCjH8|+4GY!%QN88dva9OA|!R}*Md5P|xNl;U+?NEO|C{66WF=)Tn8ez~k
z1pB<%ZEaNz-R`KmTrl>thqI`cN7HE1Ku4H_*!MjzhI^Y@R3g83OIJWQc-oLnk1nU`
z&V~eC)ZkaAx|f3cGYzY|n}_lIzqCJ&g_CrnZ;F05`jBjr7Sfhm+L6dyh3u5}3ILKQ
zrgYH~FauCB`f89cePUz!#9@xEq^&?EIf#`x`yh2vGqP{6I0wekT~<gP@7n+}`j*i&
z*YluH$$Pdsi?{2xW;|%;g|d9JN~uGdKi;Jy3u~KRo$_NznV-(5X>O^X_Ibv2oskn`
z0nQ71KiPNrVj!r_jERxiDfO^mn}6GF;L!68rX|ffVeolv@Pd5uW%O%{_eIl|=tBR?
z&_Efeo*d3-s#``M5`lAvXv<^2&P(?F=-18C(&0Zhz&~HzuaHG87WOp;_87sP_f2=n
zdu~wqv}TKa_3*gN4`0w#5P6+bXIdP**M5HRm(?!_{DQ#0Ap-j$#%;OI)Zg%{qT1n#
zyW2%}d+Ynu!G8!)mc*Z^t8QIH{ltu4xn;}{iX%S9N3ervg*nV9Oye)5l*me_T?TF@
zGm(|9PBEuQZ~@pzR$@P)h0Fk^R}(k!?~(r&J%9xA6jD&-sAiXiEZ82@TPs*j@sI(R
zJ)J-M|1fYcb69>!b|$owxQM&W;U>Gx`T=zeb2+^=0zPHIjHnQn6^HgQ=H6Z{m`jx)
z3X^?<bvfn1-bQ_5IDr;3F3nym;8M|yz4yWbA=Qk8SNhDh1(XH}H_|r7-wRXZrJ)tX
zR+J-=>qGy$sG)k}^?w6yJ@cmjXS~hr)pSi&nHr;J61oAh|5yi#&N7!&scU4#{p-MO
zKqeFA%FK==?<VVVFrN4aZeem<v)E8(vy$yOQYOYlAVa2TvHXOsp1h8G7-W5yY)e5k
zVMK#wZoF3x=8*@nxlWb@PEyy}KBjgPrTF`Z)X1?g5pE;Vix*?LXeY$j;$*9UN+B9i
zg&B?)rh_1mPE13G%#86}XPr%bN_61yNVHLY$+pb%bc27z|BvLfIQ#$<DQz~HQZ$u?
zHDjmrX`X1lrF9YC+A0TD=hFCXYzmr+Om$^5jaXRAJ}0PJW*71mr{=vk(iNmrJwZCR
zWS4r@H>w+TjjE*!_|3p}Kt`-U2cQC@sD`cA%lUt@o(Dbywh-0$MeLC42*g^$y~HjT
zSeWL-v6ZfPsI#g>To`Xi1^1IR*mJZVimWV=iW1;zeUU7czYNSGits!nwn{1%B^u=X
zdEg2H$G=1tIm5+{1o<ZZTyO_*4&REznz*pwLvR&QhayO}ODb{1!<PgCP)vM{LeP-O
zE#bz&knD`D3P=V(;t}46#5>($L$S?9;`lTq-W4t3#;dCZi>!5I4W7s}rMgz8w;6#|
zWDj;4?K3+Py)sbN3ISsBI5zGoGjrp-so)lJ3_IfVr^wIQnn@=PA|*y2Y+Fu!!i4`Y
zNNS3f%Fk-A0*T~F400Aq<mK8LKn27Tt@r@qt~6B33|ceUi!ValMuWvBuv*B&cs3GU
zC9m#3p{-*ap;3@8^ZzS3ane7z&zQUV^dQ|S&uXhUIkcZ>-?O1rN0g&e5REBJ;yuMq
z0oA~60z_vceiN%k`yRi6{1#t<l(}x0IY}&7`vLzVc^AKlbvi4|&6TWL?Q$@Vn1S9!
zM8?h(;VD4_`2fF<sn9)$!^mu(&9{;N#J|8woHHQ#8WHCC$Jo$*WEA}fi9p|nf|Vvl
zyhYGhf(RZf(I<O^{CeOMKtf!@&tWUj3MkA}c!~XupozSOKg2Gec?iQJm|ZNW1NH-2
z=GN%%*h%zDM!AoeSxMYl!3Wk#Act(g7NRbQmB_WQ%VZM%d~h4_6IyTXG&ySZCuB1I
zLhD6fJ+PH{jJF^goI_&HS(%t01!{=~{MXDiQMkkrCr{xo0{0L#xDm;AmWVm!ws!Ii
z{x;HCC6zi7<*9tGwThg?#YkioT&p+8(yi}VYk@6fDYgnFkRvXJENkRaYEaYM6Pyw?
zLXY~F?|9?&e0a1k-yO1#BECpXLy{YL*3@sw63o9Z^c*<0*_$)I|646OO|E2ncI8$7
zZu{VW$y51%vhHJhpT29)%2K|(=WlNUTOs_YoT%%WWQ{Gb1z%W?$L!oV{A>bpWnnGz
zz(Qq4*2Y@6^GrsSF!#<a&rrVhQIgxsr@*<#d4rGVL>l&9f7D^K%-wmMQ*_Jce#q5d
z-v9hkWcg)$;Kt10*7a)dj*vt(W($2O_x3lrMt$!Z0%c7F0UvNBH^3U*7AmM5iZUqJ
zbyihpP!m^cilX1oFTUP3vn@e)ue}FXmtQRyq;r&k1L{X(CAv<1F&)<A%L>@D$l;GE
zTmBiXo0mS|_vDiA+UJzWqjs=L==H<<4gk(Ewazg*R_ctAyT9upB2Mm6<Kv5VQp38C
z=3J;cGW`~;?0eG0_vi|uhUn8$Z8z0Cj(2V&gNr%b!lmd@S3&f|j>iYulI)$=<Fz=3
zyV=jbTlX*S8)&;F7|=Nc_Le=9YgD%x-A!e5H;2((9b}ttZ6rxt1gYbMaxjxrFgFjh
z%({@;OC+MBNVKUB+w;$Ps0?YY%9nbJ`%UBoUevlv+FIWne7paqs^D0l*7$EQ9e??S
YUl8~o5qNneXy0G`M#?L%y!Xm~02`7oGynhq

literal 0
HcmV?d00001

diff --git a/tests/f_extent_int_bad_magic/name b/tests/f_extent_int_bad_magic/name
new file mode 100644
index 0000000..a451e9a
--- /dev/null
+++ b/tests/f_extent_int_bad_magic/name
@@ -0,0 +1 @@
+bad magic number in internal extent (metadata_csum)
diff --git a/tests/f_extent_leaf_bad_csum/expect.1 b/tests/f_extent_leaf_bad_csum/expect.1
new file mode 100644
index 0000000..0dc78ad
--- /dev/null
+++ b/tests/f_extent_leaf_bad_csum/expect.1
@@ -0,0 +1,11 @@
+Pass 1: Checking inodes, blocks, and sizes
+Inode 12 extent block passes checks, but checksum does not match extent
+	(logical block 7, invalid physical block 1090, len 1)
+Fix? yes
+
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/128 files (16.7% non-contiguous), 1099/2048 blocks
+Exit status is 0
diff --git a/tests/f_extent_leaf_bad_csum/expect.2 b/tests/f_extent_leaf_bad_csum/expect.2
new file mode 100644
index 0000000..a564763
--- /dev/null
+++ b/tests/f_extent_leaf_bad_csum/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/128 files (16.7% non-contiguous), 1099/2048 blocks
+Exit status is 0
diff --git a/tests/f_extent_leaf_bad_csum/image.gz b/tests/f_extent_leaf_bad_csum/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..6c778f699725e9db8d94c9c464f3a687a714d757
GIT binary patch
literal 5005
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

literal 0
HcmV?d00001

diff --git a/tests/f_extent_leaf_bad_csum/name b/tests/f_extent_leaf_bad_csum/name
new file mode 100644
index 0000000..62a2285
--- /dev/null
+++ b/tests/f_extent_leaf_bad_csum/name
@@ -0,0 +1 @@
+bad csum in leaf extent (metadata_csum)
diff --git a/tests/f_extent_leaf_bad_extent/expect.1 b/tests/f_extent_leaf_bad_extent/expect.1
new file mode 100644
index 0000000..f96a8a9
--- /dev/null
+++ b/tests/f_extent_leaf_bad_extent/expect.1
@@ -0,0 +1,24 @@
+Pass 1: Checking inodes, blocks, and sizes
+Inode 12 has an invalid extent
+	(logical block 2, invalid physical block 4294967295, len 1)
+Clear? yes
+
+Inode 12, i_blocks is 18, should be 16.  Fix? yes
+
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Block bitmap differences:  -1096
+Fix? yes
+
+Free blocks count wrong for group #0 (949, counted=950).
+Fix? yes
+
+Free blocks count wrong (949, counted=950).
+Fix? yes
+
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 12/128 files (16.7% non-contiguous), 1098/2048 blocks
+Exit status is 1
diff --git a/tests/f_extent_leaf_bad_extent/expect.2 b/tests/f_extent_leaf_bad_extent/expect.2
new file mode 100644
index 0000000..de1727c
--- /dev/null
+++ b/tests/f_extent_leaf_bad_extent/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/128 files (16.7% non-contiguous), 1098/2048 blocks
+Exit status is 0
diff --git a/tests/f_extent_leaf_bad_extent/image.gz b/tests/f_extent_leaf_bad_extent/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..d34d4d4d51d24e4de54f6b38beedc831d8c2d266
GIT binary patch
literal 5008
zcmeH}`BRhU7ROOLwJx|^DhMKhv5F|G77<yZPz6PA1O#MF0VyJzED}NpZynh*ELK@$
zFM_g(QGzH0NI^nus7X;E$dZ)AutQAJkc1@fbJN~?XRdSa{R2AVb7r2I^V@ko=lh)R
zK@h&s(9mLeu3fh@sTmbGjMw;}U?=GFQb#rS*KSJ>JG0H{#_>bipJ{DLzwK?9QEHf-
z{{9hlM_8?I_(k`xT<?9eFMa4jy{_I;uZ!`CyQhaQJ9%up<@ZhX*F#3%2bbN?vG9uY
z^{~Bn?tZegGr_=~mgE}piX={>%*rMbIPC&<0xyBx4y4MMqBW8$=VXHgVUyUl2L)jc
z*r58yziNBdv);a8wI4xIqpm(lKvxF{Ue4hw3L6WT9@h5m#jX%SiY6y+hjBQ`UW$=i
zLaD(-C#fcOX)9}Ys{YJmM@#r(bA)c&!-gx^;ZD+XPCVm|*;Y>1{VvR$CTU|vUepyU
zNA0n}2{c`=abCw$OqeTSzIv-8YPCS3D)uZ>uDM1e!9+`^=1eDh<MVFeD(cUI*RRAY
z_JQY@frDI-qNFO9$Bh$LF6{!AV{I%Bc%REK)cE+M9{HR`=p7v!OiV0m)=fXA-97%@
z74Q9(WmG|XN$C#4Oyw@h%bD6o?J^c;b-Xg6gK}-0PRydUEXqBqpY%T2pykIdmQKi-
zoQpR6A7McDSOh-_Cjmm4@2Q>1U$=K=-F!2kh&hzW```w=bryX8U)R}An8M={3|<lD
zVumyesUKL$#=Bcj%m4mv&jgM9TU2jf!74QS($n#Q1(TSwrd`)-z$i9pUoclU%C>&<
zP_A|LTbnRnOr=90y`}Po@tSC>j1&hme1*{tvHSi1(U$;6yBF=jeG8dJ4Dz)w=BNv)
zC^)i_qI2p0w4s!mp7gb}_<)WR0u?ppVNfa0vBw*s6e97EEf@CBD)?>&oGLwU{Uz7-
zy5GFw3ICnnGI%2xlFA`LZ`@Ut4!kxsMjsq#IJEk@QSU^VVv}=!f5V>7vh#*~in6Rk
zb<UqJ&9m-?PPs(#3@N5ipnru2fB2EnGs^iGD9%;!vSUEJ<L+BgSk_MF^Vp7HPBzio
ztXhRQOI|^w$(>xs4gBH6qj|RxBsn;0)qaEmcLPF)_FC)`w!;vGw2)jXbdOn@*E)u4
zfuJj`d15lai%uQhf7F}{sPr(!)a+uUFTRJ;E$$$#r=0{AwQe2qtonHe<Z&fRNi^p|
zxz1eZ!FC>$8-X1(3b|fG1uM;)mmuXJ3-Rvv5Lbylh};ftl=g$l##<n8<#IN_i)#jt
zF{r3)&=dD1C`<WDNWq4yU{1Ni(HJiDwhw3sk?Np0UBT{!S(YKnSP#E$?zX2t4RRsW
zwTu<y#0zP-RIs_Bk_Xihz=?A_2-$QCIN0s!1MuQcmv_&sNB<4n;O&QPma@4J8dOCy
z4D=D1Xn=>eEF#vkew$jgsS-_;pfP4{CXOCwdKh#GI(SsVxfwcv0r;uaSeD&XibZYZ
z%1kVBghhGQibLV0?S$oe!3vn<OD18c#9I-1QHzUC*rk`54>Cj;L=M#l$rt8=9sQKu
zn4v?kPYg6tnmYvV)Ogf~q^(YFdue8G)e1U${Msl*eSp>@sgi+uA<%s}4OOL<4cwPa
z{bof43O#3q0MBhaY!|elL0brY{3Some*5(dcB3>&Q+h~KYN;tT*Tmo*j8Lz!rFW=`
zuFP>S6qBpU^Cu-!LcisX#R*Sty(ILeR!1_C-wa>1dmrLwp4Kw)V!x)AM%I#Ak{AVt
zd{sXOY!V|9NQ-}ts|&i^@IvuJ5px=L!scDvK7GSDH;#k$tqdcPs@g6P6_)_5KYwHz
zIo1;8>xQ10FW~OUh~MR`*o1ga`5;Up=!H6(bR`E3Zku5QW8Iz0owN7@BK}fY%&5(q
zZn97MN>u`mCSC~I7%?6?P_>1&T@*SD_r!7EShdy6%^vYT{KYlXv-9KP#1oZmg()I;
zWS(fNseLucSi!3=mQ5DhV{3FbpN)F0y4w=jL=R@fW1Vx>XY#3<SvE9mw6_aZ!49)n
z4odbZ(yWc=>4Z8S<|lZ-cMH4tDb4xHhvm{r1M%|jGG|IkO#mDDs}G|%&2HGvHrfVR
z#4^p6M@EnrGXmp4Lnj29_@ZAtL$JdxLitE+o<zG&@{as;qJo~lN$CpcHZHWO?Ti#L
zM61mW$^behKx;vu@=S%Vx2EBb!R#g;wj|+702EBusZ(|oVCp&-grkpf9_^Bn;sJge
zV-%LyP<hdIW<_W>3HzM<I2{+8o6jt-U_f*nK`7U$iywc03sHE=R|=4ch6W(>!g9yH
znCJ61?lA)m#wVYd6xp%!<;NSVmhwRUVU(K!C1)e*RCS^^*ryW`k4MPT{5K2UBO^+o
zAo9t#p0wNXCwcBGgto~*Ux`***P!)#xlc1eanLMT{HSN1SAm=>oaYgTh(k>Um~zCz
zjw_>5FjsKR=79{Y7U>qZaP+`D7RLs=YK+fDc?rR`tnFZZ-UcCvvxEsCUk_AOjsYwc
zP%ufC0f}6Rzb1)wZk&;Uz|g2H88XKV2A8~)fY`0e1>rHftsUb@GUVCB*Q(q-{lG0k
zPOnL}IIcvi19~;hI|M_5E(qCt0OrKM7|)Oar6&-$okHCkZRCO}R7xMX9_plo)Z*oW
znttH#sX!8CpeDLnRR`kE0ajAR1*Q=6ShYDT5&hbL<F^BFJ`@|lAlIzsTKQ|rmmurr
z<90}tEd(KcL5KRKYx@9I9kg&I6sef=@umX*tr&8=5^`>1&Ti21_fjI2%|sdU>e+0N
ze?zFQa!3YphG6DF806<?tYFL)*tykW=f(vY*lCg82ZE!7z)a0a(7l@r)Sl}{YlqW>
z(7oAGMcJtwpz}sljC?6wyH*HZ1gRfQ84&^ndsTA1Q3isc3dk0w;NC?2i}h6#OE7Ek
zV9gfw06Dr-U1p><5JYZXqDXHxF&2~e*825<rfG0E?-C4Vd{7G1o}KzOVxUEm9r<34
z94eU-Q<$9VD&DtS45le^{Ut^!`<dwjnX3u@r>7~f^d|j#TWyszL(X}O=}rCj6cls(
z#=7dd6%!{hIb|%s{XuzbMhu>rp>eTg?ppiWtc82c7Z{}QGrmdwNx$Om{9&}=?}@oa
zJ6d{r82F6%u6b4yJ;~E!>W)3m9N`<oKp&-0gpDiByL7A_USPvrIAe&%cCw@Y^j-hM
z%7ec&T72jI+772Mn=ySS`Y?HL3|GvyY&t*t>Y+BW1gLE{v$J2l{2WB*C7sgdd^K5I
zRrdqBHVfV`yr|^33Is>~blqc^AHz<YNiAUHmT8C!_zRS<myf~5suUGQ9-KF&HY^By
zcNvuTxcPC?%xhC%C8*Uq2c@pnuLAkkL0yw0fW{wwkOLZVS2HhF5LNYuS`NUN-tB#$
zr~+vjt+vLG2lJ=w6M;_zJ`wmt;IBi#GVW`sO&H6&a1*wp(`ecVZ;Lj6$nOa-F+-OS
zV_gRb;*8S~@>{9xR%RCTV&gjgfF4)Ol!v(3f}iQ^$xQ-!%ZN*wCj*Dd$6`{H)#xsF
za{*%Z;EWrkV!oohtqd^`sokf1)*86d`#2tJSSS@h&jKp3XH1E!`yDx}ub;BHt&TXG
zBC;oT*`HWEAgvW;7GTb?eS;|0g;j3yyvPt$7j%n>ygfoh(Kt8>fuG7~h*M>lpvy%I
z9_$LyV_GPA`80ndJjlFw{8*@h#rZP-`BLk}G_zrx4S$`9pv&6PF(Jv6c^VsQ<p{VJ
zV#tZ8DChvEQk1o&kH@)94`lT%dE>W<+Xq6)<RjF0n!*a<Dj`j(_qyqb2w=id@LIuz
zpko$A<e*y;7xCb?1<$M@r9#hibjYeUU@*Brbw3*8<E=`Mj!o3W!d?qp_{=7@edLqX
z<QY`TgH_o<$wA2h{_YuCN`~Hw>W>{~%^t(Qj!HgN`X2<UGQj$Jzy0nS8ipGG076{(
AwEzGB

literal 0
HcmV?d00001

diff --git a/tests/f_extent_leaf_bad_extent/name b/tests/f_extent_leaf_bad_extent/name
new file mode 100644
index 0000000..1bd8bd1
--- /dev/null
+++ b/tests/f_extent_leaf_bad_extent/name
@@ -0,0 +1 @@
+bad extent in leaf extent (metadata_csum)
diff --git a/tests/f_extent_leaf_bad_magic/expect.1 b/tests/f_extent_leaf_bad_magic/expect.1
new file mode 100644
index 0000000..7b6dbf1
--- /dev/null
+++ b/tests/f_extent_leaf_bad_magic/expect.1
@@ -0,0 +1,23 @@
+Pass 1: Checking inodes, blocks, and sizes
+Inode 12 has an invalid extent node (blk 1604, lblk 0)
+Clear? yes
+
+Inode 12, i_blocks is 18, should be 0.  Fix? yes
+
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Block bitmap differences:  -(1090--1097) -1604
+Fix? yes
+
+Free blocks count wrong for group #0 (949, counted=958).
+Fix? yes
+
+Free blocks count wrong (949, counted=958).
+Fix? yes
+
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 12/128 files (8.3% non-contiguous), 1090/2048 blocks
+Exit status is 1
diff --git a/tests/f_extent_leaf_bad_magic/expect.2 b/tests/f_extent_leaf_bad_magic/expect.2
new file mode 100644
index 0000000..283cc1f
--- /dev/null
+++ b/tests/f_extent_leaf_bad_magic/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/128 files (8.3% non-contiguous), 1090/2048 blocks
+Exit status is 0
diff --git a/tests/f_extent_leaf_bad_magic/image.gz b/tests/f_extent_leaf_bad_magic/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..7dd044ffc430e1e7f3750fa628984e750ede9006
GIT binary patch
literal 5008
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

literal 0
HcmV?d00001

diff --git a/tests/f_extent_leaf_bad_magic/name b/tests/f_extent_leaf_bad_magic/name
new file mode 100644
index 0000000..e9f756e
--- /dev/null
+++ b/tests/f_extent_leaf_bad_magic/name
@@ -0,0 +1 @@
+bad magic number in leaf extent (metadata_csum)

