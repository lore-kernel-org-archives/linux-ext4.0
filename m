From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [BUG] e2fsprogs: e2fsck -b outputs checksum warnings
Date: Wed, 07 Sep 2011 17:10:12 +0900
Message-ID: <4E6726E4.8070203@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([202.32.8.215]:38980 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab1IGRKR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Sep 2011 13:10:17 -0400
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id p878Axch028559
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 7 Sep 2011 17:10:59 +0900 (JST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

With e2fsck -b option, we can use an alternative
superblock instead of the normal superblock.
However it shows some warnings, especially checksum warnings
appear when we do e2fsck -b every time.

Test environment:
- kernel 3.1.0-rc3
- e2fsprogs (commit:d4c0d8e5b858cdf3d3000f2b3fca532787f34a02)

# mkfs -t ext4 /dev/sda8
# e2fsck -b 32768 /dev/sda8
e2fsck 1.42-WIP (02-Jul-2011)
One or more block group descriptor checksums are invalid.  Fix<y>? yes

Group descriptor 0 checksum is invalid.  FIXED.
Group descriptor 1 checksum is invalid.  FIXED.
Group descriptor 2 checksum is invalid.  FIXED.
Group descriptor 3 checksum is invalid.  FIXED.
Group descriptor 4 checksum is invalid.  FIXED.
Group descriptor 5 checksum is invalid.  FIXED.
Group descriptor 6 checksum is invalid.  FIXED.
Group descriptor 7 checksum is invalid.  FIXED.
Group descriptor 8 checksum is invalid.  FIXED.
Group descriptor 9 checksum is invalid.  FIXED.
Group descriptor 10 checksum is invalid.  FIXED.
Group descriptor 11 checksum is invalid.  FIXED.
Group descriptor 12 checksum is invalid.  FIXED.
Group descriptor 13 checksum is invalid.  FIXED.
Group descriptor 14 checksum is invalid.  FIXED.
Group descriptor 15 checksum is invalid.  FIXED.
Group descriptor 16 checksum is invalid.  FIXED.
Group descriptor 17 checksum is invalid.  FIXED.
Group descriptor 18 checksum is invalid.  FIXED.
Group descriptor 19 checksum is invalid.  FIXED.
Group descriptor 20 checksum is invalid.  FIXED.
Group descriptor 21 checksum is invalid.  FIXED.
Group descriptor 22 checksum is invalid.  FIXED.
Group descriptor 23 checksum is invalid.  FIXED.
Group descriptor 24 checksum is invalid.  FIXED.
Group descriptor 25 checksum is invalid.  FIXED.
Group descriptor 26 checksum is invalid.  FIXED.
Group descriptor 27 checksum is invalid.  FIXED.
Group descriptor 28 checksum is invalid.  FIXED.
Group descriptor 29 checksum is invalid.  FIXED.
Group descriptor 30 checksum is invalid.  FIXED.
Group descriptor 31 checksum is invalid.  FIXED.
/dev/sda8 contains a file system with errors, check forced.
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences:  -(65600--65602) -(65611--65612) -(65621--65622) -(65625--65627) -65630 -(65632--65634) -(65643--65644) -(65653--65654) -(65657--65659) -65662 -(65664--65666) -(65675--65676)
-(65685--65686) -(65689--65691) -65694 -67584 -(67586--67587) -(67589--67592) -67598 -67628 -(67648--67650) -(67659--67660) -(67669--67670) -(67673--67675) -67678 -(67680--67682) -(67691--67692)
-(67701--67702) -(67705--67707) -67710 -(67712--67714) -(67723--67724) -(67733--67734) -(67737--67739) -67742 -(67792--67793) -67811 -(67904--67905) -(67912--67913) -(68610--68612) -(68736--68738)
-(68747--68748) -(68757--68758) -(68761--68763) -68766 -(77831--77832) -77839 -(77870--77871) -77878 -(77888--77890) -(77899--77900) -(77909--77910) -(77913--77915) -77918 -(77920--77922)
-(77931--77932) -(77941--77942) -(77945--77947) -77950 -(77952--77954) -(77963--77964) -(77973--77974) -(77977--77979) -77982 -78032 -78051 -(78054--78061) -78563 -(78568--78569) -78688
-(78850--78852) -(78976--78978) -(78987--78988) -(78997--78998) -(79001--79003) -79006 -(79879--79880) -79887 -79931 -(79936--79938) -(79947--79948) -(79957--79958) -(79961--79963) -79966
-(79968--79970) -(79979--79980) -(79989--79990) -(79993--79995) -79998 -(80000--80002) -(80011--80012) -(80021--80022) -(80025--80027) -80030 -80080 -80099 -80104 -80114 -80193 -80201 -(80207--80210)
-(80224--80225) -80233 -(80239--80242) -80258 -80265 -(80271--80274) -80288 -80290 -80297 -(80303--80306) -(80321--80322) -80329 -(80335--80338) -(80352--80354) -80361 -(80367--80370) -80387 -80393
-(80399--80402) -80416 -80419 -80425 -(80431--80434) -80449 -80451 -80457 -(80463--80466) -(80480--80481) -80483 -80489 -(80495--80498) -(80514--80515) -80521 -(80527--80530) -80544 -(80546--80547)
-80553 -(80559--80562) -(80577--80579) -80585 -(80591--80594) -(80608--80611) -(80617--80618) -(80623--80626) -(80898--80900) -(81024--81026) -(81035--81036) -(81045--81046) -(81049--81051) -81054
-(86022--86024) -86030 -86062 -(86080--86082) -(86091--86092) -(86101--86102) -(86105--86107) -86110 -(86112--86114) -(86123--86124) -(86133--86134) -(86137--86139) -86142 -(86144--86146)
-(86155--86156) -(86165--86166) -(86169--86171) -86174 -86225 -86245 -86338 -(86344--86345) -86368 -86370 -(86376--86377) -(86401--86402) -(86408--86409) -(86432--86434) -(86440--86441)
-(87042--87044) -(87168--87170) -(87179--87180) -(87189--87190) -(87193--87195) -87198 -(565248--589823)
Fix<y>? yes


/dev/sda8: ***** FILE SYSTEM WAS MODIFIED *****
/dev/sda8: 11/262144 files (0.0% non-contiguous), 51278/1048576 blocks


Regards,
Akira Fujita
