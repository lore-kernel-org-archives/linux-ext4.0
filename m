From: Theodore Ts'o <tytso@mit.edu>
Subject: Problem with online resizing with metadata checksum patch...
Date: Mon, 17 Sep 2012 13:06:31 -0400
Message-ID: <nsxpq5kefzc.fsf@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51140 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932130Ab2IQRGp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Sep 2012 13:06:45 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi Darrick,

I don't know if you have any time to look at this, but if you do, that
would be great.

I was testing online resizing with the metadata_csum feature, and found
that we're seeing a certain small amount of corrupted group descriptor
checksums.  This doesn't occur with the standard original
uninit_bg/csum_gdt feature.

This test below was done with the latest e2fsprogs next branch, as well
as the ext4 dev branch.  I've also done a test with the ext4 origin
branch, which is ext4 with all of the patches that have gone upstream to
Linus's branch.  The result was slightly different, but I saw the same
pattern of block group descriptor checksum failures and inode bitmap
corruption.

If you could take a look at it, I'd really appreciate it!!!

                                           - Ted

# mke2fs -t ext4 -O metadata_csum /dev/vdc 8M
# mount /dev/vdc /vdc
# resize2fs /dev/vdc 1024M
# umount /dev/vdc
# e2fsck -fy /dev/vdc

e2fsck 1.43-WIP (31-Aug-2012)
One or more block group descriptor checksums are invalid.  Fix? yes

Group descriptor 31 checksum is 0xadcb, should be 0x9352.  FIXED.
Group descriptor 63 checksum is 0xefc4, should be 0xf0db.  FIXED.
Group descriptor 95 checksum is 0xa02c, should be 0x1d6b.  FIXED.
Group descriptor 127 checksum is 0x4e35, should be 0xdf4a.  FIXED.
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences:  -262144
Fix? yes

Inode bitmap differences:  -(63510--63512) -63525 -(63542--63544) -63558 -(63574--63576) -(63590--63597) -63599 -63614 -63633 -(63681--63682) -63684 -(63686--63690) -63695 -63726 -(63731--63733) -63738 -63740 -63743 -63937 -(63941--63943) -63945 -63948 -63952 -64001 -(64022--64024) -64033 -64037 -(64054--64056) -64070 -64074 -(64086--64088) -64112 -64126 -(64145--64146) -64238 -(64241--64242) -64244 -(64246--64252) -64254 -64256 -64514 -(64534--64536) -64546 -64549 -(64566--64568) -64582 -64587 -(64598--64600) -64624 -64638 -(64657--64658) -64750 -(64753--64755) -(64758--64759) -(64761--64762) -(64764--64768) -(65025--65026) -(65046--65048) -(65057--65058) -65061 -(65078--65080) -65094 -(65098--65099) -(65110--65112) -65136 -65150 -(65169--65170) -65262 -(65267--65268) -65271 -65273 -65275
  -(65278--65280) -(129046--129048) -129061 -(129078--129080) -129094 -(129110--129112) -(129126--129133) -129135 -129150 -129169 -(129217--129218) -129220 -(129222--129226) -129231 -129262 -(129267--129269) -129274 -129276 -129279 -129473 -(129477--129479) -129481 -129484 -129488 -129537 -(129558--129560) -129569 -129573 -(129590--129592) -129606 -129610 -(129622--129624) -129648 -129662 -(129681--129682) -129774 -(129777--129778) -129780 -(129782--129788) -129790 -129792 -130050 -(130070--130072) -130082 -130085 -(130102--130104) -130118 -130123 -(130134--130136) -130160 -130174 -(130193--130194) -130286 -(130289--130291) -(130294--130295) -(130297--130298) -(130300--130304) -(130561--130562) -(130582--130584) -(130593--130594) -130597 -(130614--130616) -130630 -(130634--130635) -(13064
 6--130648) -130672 -130686 -(130705--130706) -130798 -(130803--130804) -130807 -130809 -130811 -(130814--130816) -(194582--194584) -194597 -(194614--194616) -194630 -(194646--194648) -(194662--194669) -194671 -194686 -194705 -(194753--194754) -194756 -(194758--194762) -194767 -194798 -(194803--194805) -194810 -194812 -194815 -195009 -(195013--195015) -195017 -195020 -195024 -195073 -(195094--195096) -195105 -195109 -(195126--195128) -195142 -195146 -(195158--195160) -195184 -195198 -(195217--195218) -195310 -(195313--195314) -195316 -(195318--195324) -195326 -195328 -195586 -(195606--195608) -195618 -195621 -(195638--195640) -195654 -195659 -(195670--195672) -195696 -195710 -(195729--195730) -195822 -(195825--195827) -(195830--195831) -(195833--195834) -(195836--195840) -(196097--196098)
  -(196118--196120) -(196129--196130) -196133 -(196150--196152) -196166 -(196170--196171) -(196182--196184) -196208 -196222 -(196241--196242) -196334 -(196339--196340) -196343 -196345 -196347 -(196350--196352) -(260118--260120) -260133 -(260150--260152) -260166 -(260182--260184) -(260198--260205) -260207 -260222 -260241 -(260289--260290) -260292 -(260294--260298) -260303 -260334 -(260339--260341) -260346 -260348 -260351 -260545 -(260549--260551) -260553 -260556 -260560 -260609 -(260630--260632) -260641 -260645 -(260662--260664) -260678 -260682 -(260694--260696) -260720 -260734 -(260753--260754) -260846 -(260849--260850) -260852 -(260854--260860) -260862 -260864 -261122 -(261142--261144) -261154 -261157 -(261174--261176) -261190 -261195 -(261206--261208) -261232 -261246 -(261265--261266) -
 261358 -(261361--261363) -(261366--261367) -(261369--261370) -(261372--261376) -(261633--261634) -(261654--261656) -(261665--261666) -261669 -(261686--261688) -261702 -(261706--261707) -(261718--261720) -261744 -261758 -(261777--261778) -261870 -(261875--261876) -261879 -261881 -261883 -(261886--261888)
Fix? yes


/dev/vdc: ***** FILE SYSTEM WAS MODIFIED *****
/dev/vdc: 11/262144 files (9.1% non-contiguous), 34426/1048576 blocks
candygram:~# 
