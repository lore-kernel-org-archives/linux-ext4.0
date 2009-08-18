From: Frank Mayhar <fmayhar@google.com>
Subject: Re: fsck infinite loop on corrupt ext4 file system
Date: Mon, 17 Aug 2009 18:10:22 -0700
Message-ID: <1250557822.23227.9.camel@bobble.smo.corp.google.com>
References: <1250294105.6221.24.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-pGV9J0rc8p583CHH/Zpz"
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:26732 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbZHRBK0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Aug 2009 21:10:26 -0400
In-Reply-To: <1250294105.6221.24.camel@bobble.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-pGV9J0rc8p583CHH/Zpz
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, 2009-08-14 at 16:55 -0700, Frank Mayhar wrote:
> Hello, folks.  We recently ran into a pretty severe ext4 crash (being
> worked on by someone else) that caused some seriously corrupted file
> systems, one of which in turn exposed an fsck problem.  We noticed this
> when fsck started looping endlessly trying to correct that file system.
> Basically, the group descriptors were mangled; fsck complains about
> invalid checksums, forces a full check and during pass 1 tries to
> allocate some inode bitmap blocks (apparently).  That allocation fails,
> pass 1 errors out and starts the check over.  Endlessly.

I've made a little more progress since Friday.  I had grabbed a dumpe2fs
dump of the corrupted file system and one of the newly-created file
system on the same device.  Adjusting for normal variation (numbers of
free blocks, flags, etc.), there are no differences _except_ in the very
block groups that fsck complained about having bad checksums.  For those
(and only those), the locations of the block bitmap and inode table
differ.  I've attached the diff output.

In particular, block group 276 claims to have its inode table at blocks
0-204, which is clearly wrong.  This is the block group for which the
allocation failed, causing the original loop.

It's clear that fsck is neither correcting the block groups nor is it
detecting the bad entries properly (a sanity check might be in order
here).  It's not even noticing that it's looping, it just keeps failing
the allocation and retrying.  While it may be that fsck can't recover
the file system in this case, it should at least notice and abort.

My thinking is that the location of the inode tables should be invariant
over the life of the file system.  Certainly there's no place in ext4
itself that changes those fields (that I can see, anyway).  Why couldn't
fsck compute the proper values and compare those against what's there?
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

--=-pGV9J0rc8p583CHH/Zpz
Content-Disposition: attachment; filename=dump-diff
Content-Type: text/x-patch; name=dump-diff; charset=utf-8
Content-Transfer-Encoding: 7bit

--- dump	2009-08-17 14:03:54.700557000 -0700
+++ dump-new	2009-08-17 14:04:03.476788000 -0700
@@ -818,390 +818,390 @@
   Block bitmap at 7864335, Inode bitmap at 7864351
   Inode table at 7867427-7867631
 Group 256: (Blocks 8388608-8421375)
-  Block bitmap at 8388608 (+0), Inode bitmap at 8388609 (+1)
-  Inode table at 8388610-8388814 (+2)
+  Block bitmap at 8388608 (+0), Inode bitmap at 8388624 (+16)
+  Inode table at 8388640-8388844 (+32)
 Group 257: (Blocks 8421376-8454143)
-  Block bitmap at 8421376 (+0), Inode bitmap at 8421377 (+1)
-  Inode table at 8421378-8421582 (+2)
+  Block bitmap at 8388609, Inode bitmap at 8388625
+  Inode table at 8388845-8389049
 Group 258: (Blocks 8454144-8486911)
-  Block bitmap at 8454147 (+3), Inode bitmap at 8454148 (+4)
-  Inode table at 8454149-8454353 (+5)
+  Block bitmap at 8388610, Inode bitmap at 8388626
+  Inode table at 8389050-8389254
 Group 259: (Blocks 8486912-8519679)
-  Block bitmap at 8486912 (+0), Inode bitmap at 8486913 (+1)
-  Inode table at 8486916-8487120 (+4)
+  Block bitmap at 8388611, Inode bitmap at 8388627
+  Inode table at 8389255-8389459
 Group 260: (Blocks 8519680-8552447)
-  Block bitmap at 8525824 (+6144), Inode bitmap at 8525825 (+6145)
-  Inode table at 8526848-8527052 (+7168)
+  Block bitmap at 8388612, Inode bitmap at 8388628
+  Inode table at 8389460-8389664
 Group 261: (Blocks 8552448-8585215)
-  Block bitmap at 8552450 (+2), Inode bitmap at 8552452 (+4)
-  Inode table at 8552453-8552657 (+5)
+  Block bitmap at 8388613, Inode bitmap at 8388629
+  Inode table at 8389665-8389869
 Group 262: (Blocks 8585216-8617983)
-  Block bitmap at 8585216 (+0), Inode bitmap at 8585217 (+1)
-  Inode table at 8586240-8586444 (+1024)
+  Block bitmap at 8388614, Inode bitmap at 8388630
+  Inode table at 8389870-8390074
 Group 263: (Blocks 8617984-8650751)
-  Block bitmap at 8617984 (+0), Inode bitmap at 8617985 (+1)
-  Inode table at 8620033-8620237 (+2049)
+  Block bitmap at 8388615, Inode bitmap at 8388631
+  Inode table at 8390075-8390279
 Group 264: (Blocks 8650752-8683519)
-  Block bitmap at 8660992 (+10240), Inode bitmap at 8660993 (+10241)
-  Inode table at 8660996-8661200 (+10244)
+  Block bitmap at 8388616, Inode bitmap at 8388632
+  Inode table at 8390280-8390484
 Group 265: (Blocks 8683520-8716287)
-  Block bitmap at 8683520 (+0), Inode bitmap at 8683521 (+1)
-  Inode table at 8685571-8685775 (+2051)
+  Block bitmap at 8388617, Inode bitmap at 8388633
+  Inode table at 8390485-8390689
 Group 266: (Blocks 8716288-8749055)
-  Block bitmap at 8716288 (+0), Inode bitmap at 8716289 (+1)
-  Inode table at 8716316-8716520 (+28)
+  Block bitmap at 8388618, Inode bitmap at 8388634
+  Inode table at 8390690-8390894
 Group 267: (Blocks 8749056-8781823)
-  Block bitmap at 8749056 (+0), Inode bitmap at 8749057 (+1)
-  Inode table at 8749312-8749516 (+256)
+  Block bitmap at 8388619, Inode bitmap at 8388635
+  Inode table at 8390895-8391099
 Group 268: (Blocks 8781824-8814591)
-  Block bitmap at 8783872 (+2048), Inode bitmap at 8783873 (+2049)
-  Inode table at 8784384-8784588 (+2560)
+  Block bitmap at 8388620, Inode bitmap at 8388636
+  Inode table at 8391100-8391304
 Group 269: (Blocks 8814592-8847359)
-  Block bitmap at 8814592 (+0), Inode bitmap at 8814593 (+1)
-  Inode table at 8814603-8814807 (+11)
+  Block bitmap at 8388621, Inode bitmap at 8388637
+  Inode table at 8391305-8391509
 Group 270: (Blocks 8847360-8880127)
-  Block bitmap at 8847360 (+0), Inode bitmap at 8847361 (+1)
-  Inode table at 8850176-8850380 (+2816)
+  Block bitmap at 8388622, Inode bitmap at 8388638
+  Inode table at 8391510-8391714
 Group 271: (Blocks 8880128-8912895)
-  Block bitmap at 8880128 (+0), Inode bitmap at 8880129 (+1)
-  Inode table at 8881152-8881356 (+1024)
+  Block bitmap at 8388623, Inode bitmap at 8388639
+  Inode table at 8391715-8391919
 Group 272: (Blocks 8912896-8945663)
-  Block bitmap at 8912896 (+0), Inode bitmap at 8912897 (+1)
-  Inode table at 8912898-8913102 (+2)
+  Block bitmap at 8912896 (+0), Inode bitmap at 8912912 (+16)
+  Inode table at 8912928-8913132 (+32)
 Group 273: (Blocks 8945664-8978431)
-  Block bitmap at 8947712 (+2048), Inode bitmap at 8947713 (+2049)
-  Inode table at 8947715-8947919 (+2051)
+  Block bitmap at 8912897, Inode bitmap at 8912913
+  Inode table at 8913133-8913337
 Group 274: (Blocks 8978432-9011199)
-  Block bitmap at 8978432 (+0), Inode bitmap at 8978433 (+1)
-  Inode table at 8979456-8979660 (+1024)
+  Block bitmap at 8912898, Inode bitmap at 8912914
+  Inode table at 8913338-8913542
 Group 275: (Blocks 9011200-9043967)
-  Block bitmap at 9011200 (+0), Inode bitmap at 9011201 (+1)
-  Inode table at 9011712-9011916 (+512)
+  Block bitmap at 8912899, Inode bitmap at 8912915
+  Inode table at 8913543-8913747
 Group 276: (Blocks 9043968-9076735)
-  Block bitmap at 9043968 (+0), Inode bitmap at 9043969 (+1)
-  Inode table at 0-204
+  Block bitmap at 8912900, Inode bitmap at 8912916
+  Inode table at 8913748-8913952
 Group 277: (Blocks 9076736-9109503)
-  Block bitmap at 9078787 (+2051), Inode bitmap at 9078788 (+2052)
-  Inode table at 9079040-9079244 (+2304)
+  Block bitmap at 8912901, Inode bitmap at 8912917
+  Inode table at 8913953-8914157
 Group 278: (Blocks 9109504-9142271)
-  Block bitmap at 9111553 (+2049), Inode bitmap at 9111556 (+2052)
-  Inode table at 9115670-9115874 (+6166)
+  Block bitmap at 8912902, Inode bitmap at 8912918
+  Inode table at 8914158-8914362
 Group 279: (Blocks 9142272-9175039)
-  Block bitmap at 9142273 (+1), Inode bitmap at 9144322 (+2050)
-  Inode table at 9144326-9144530 (+2054)
+  Block bitmap at 8912903, Inode bitmap at 8912919
+  Inode table at 8914363-8914567
 Group 280: (Blocks 9175040-9207807)
-  Block bitmap at 9175043 (+3), Inode bitmap at 9175044 (+4)
-  Inode table at 9175045-9175249 (+5)
+  Block bitmap at 8912904, Inode bitmap at 8912920
+  Inode table at 8914568-8914772
 Group 281: (Blocks 9207808-9240575)
-  Block bitmap at 9209856 (+2048), Inode bitmap at 9209857 (+2049)
-  Inode table at 9210880-9211084 (+3072)
+  Block bitmap at 8912905, Inode bitmap at 8912921
+  Inode table at 8914773-8914977
 Group 282: (Blocks 9240576-9273343)
-  Block bitmap at 9242624 (+2048), Inode bitmap at 9242625 (+2049)
-  Inode table at 9244682-9244886 (+4106)
+  Block bitmap at 8912906, Inode bitmap at 8912922
+  Inode table at 8914978-8915182
 Group 283: (Blocks 9273344-9306111)
-  Block bitmap at 9275392 (+2048), Inode bitmap at 9275393 (+2049)
-  Inode table at 9275904-9276108 (+2560)
+  Block bitmap at 8912907, Inode bitmap at 8912923
+  Inode table at 8915183-8915387
 Group 284: (Blocks 9306112-9338879)
-  Block bitmap at 9306126 (+14), Inode bitmap at 9306128 (+16)
-  Inode table at 9306368-9306572 (+256)
+  Block bitmap at 8912908, Inode bitmap at 8912924
+  Inode table at 8915388-8915592
 Group 285: (Blocks 9338880-9371647)
-  Block bitmap at 9340928 (+2048), Inode bitmap at 9340929 (+2049)
-  Inode table at 9355264-9355468 (+16384)
+  Block bitmap at 8912909, Inode bitmap at 8912925
+  Inode table at 8915593-8915797
 Group 286: (Blocks 9371648-9404415)
-  Block bitmap at 9371648 (+0), Inode bitmap at 9371649 (+1)
-  Inode table at 9371650-9371854 (+2)
+  Block bitmap at 8912910, Inode bitmap at 8912926
+  Inode table at 8915798-8916002
 Group 287: (Blocks 9404416-9437183)
-  Block bitmap at 9404416 (+0), Inode bitmap at 9404419 (+3)
-  Inode table at 9404420-9404624 (+4)
+  Block bitmap at 8912911, Inode bitmap at 8912927
+  Inode table at 8916003-8916207
 Group 288: (Blocks 9437184-9469951)
-  Block bitmap at 9437184 (+0), Inode bitmap at 9437185 (+1)
-  Inode table at 9437186-9437390 (+2)
+  Block bitmap at 9437184 (+0), Inode bitmap at 9437200 (+16)
+  Inode table at 9437216-9437420 (+32)
 Group 289: (Blocks 9469952-9502719)
-  Block bitmap at 9469954 (+2), Inode bitmap at 9469956 (+4)
-  Inode table at 9472016-9472220 (+2064)
+  Block bitmap at 9437185, Inode bitmap at 9437201
+  Inode table at 9437421-9437625
 Group 290: (Blocks 9502720-9535487)
-  Block bitmap at 9502728 (+8), Inode bitmap at 9502729 (+9)
-  Inode table at 9503744-9503948 (+1024)
+  Block bitmap at 9437186, Inode bitmap at 9437202
+  Inode table at 9437626-9437830
 Group 291: (Blocks 9535488-9568255)
-  Block bitmap at 9536384 (+896), Inode bitmap at 9536385 (+897)
-  Inode table at 9538556-9538760 (+3068)
+  Block bitmap at 9437187, Inode bitmap at 9437203
+  Inode table at 9437831-9438035
 Group 292: (Blocks 9568256-9601023)
-  Block bitmap at 9568256 (+0), Inode bitmap at 9568257 (+1)
-  Inode table at 9598208-9598412 (+29952)
+  Block bitmap at 9437188, Inode bitmap at 9437204
+  Inode table at 9438036-9438240
 Group 293: (Blocks 9601024-9633791)
-  Block bitmap at 9603072 (+2048), Inode bitmap at 9603073 (+2049)
-  Inode table at 9608192-9608396 (+7168)
+  Block bitmap at 9437189, Inode bitmap at 9437205
+  Inode table at 9438241-9438445
 Group 294: (Blocks 9633792-9666559)
-  Block bitmap at 9633792 (+0), Inode bitmap at 9633793 (+1)
-  Inode table at 9635864-9636068 (+2072)
+  Block bitmap at 9437190, Inode bitmap at 9437206
+  Inode table at 9438446-9438650
 Group 295: (Blocks 9666560-9699327)
-  Block bitmap at 9666563 (+3), Inode bitmap at 9666564 (+4)
-  Inode table at 9666565-9666769 (+5)
+  Block bitmap at 9437191, Inode bitmap at 9437207
+  Inode table at 9438651-9438855
 Group 296: (Blocks 9699328-9732095)
-  Block bitmap at 9699328 (+0), Inode bitmap at 9699329 (+1)
-  Inode table at 9699332-9699536 (+4)
+  Block bitmap at 9437192, Inode bitmap at 9437208
+  Inode table at 9438856-9439060
 Group 297: (Blocks 9732096-9764863)
-  Block bitmap at 9732096 (+0), Inode bitmap at 9732097 (+1)
-  Inode table at 9737262-9737466 (+5166)
+  Block bitmap at 9437193, Inode bitmap at 9437209
+  Inode table at 9439061-9439265
 Group 298: (Blocks 9764864-9797631)
-  Block bitmap at 9768962 (+4098), Inode bitmap at 9768963 (+4099)
-  Inode table at 9771520-9771724 (+6656)
+  Block bitmap at 9437194, Inode bitmap at 9437210
+  Inode table at 9439266-9439470
 Group 299: (Blocks 9797632-9830399)
-  Block bitmap at 9799680 (+2048), Inode bitmap at 9799681 (+2049)
-  Inode table at 9806848-9807052 (+9216)
+  Block bitmap at 9437195, Inode bitmap at 9437211
+  Inode table at 9439471-9439675
 Group 300: (Blocks 9830400-9863167)
-  Block bitmap at 9830403 (+3), Inode bitmap at 9830404 (+4)
-  Inode table at 9831424-9831628 (+1024)
+  Block bitmap at 9437196, Inode bitmap at 9437212
+  Inode table at 9439676-9439880
 Group 301: (Blocks 9863168-9895935)
-  Block bitmap at 9863168 (+0), Inode bitmap at 9863169 (+1)
-  Inode table at 9864147-9864351 (+979)
+  Block bitmap at 9437197, Inode bitmap at 9437213
+  Inode table at 9439881-9440085
 Group 302: (Blocks 9895936-9928703)
-  Block bitmap at 9897984 (+2048), Inode bitmap at 9897985 (+2049)
-  Inode table at 9900036-9900240 (+4100)
+  Block bitmap at 9437198, Inode bitmap at 9437214
+  Inode table at 9440086-9440290
 Group 303: (Blocks 9928704-9961471)
-  Block bitmap at 9930752 (+2048), Inode bitmap at 9930753 (+2049)
-  Inode table at 9930762-9930966 (+2058)
+  Block bitmap at 9437199, Inode bitmap at 9437215
+  Inode table at 9440291-9440495
 Group 304: (Blocks 9961472-9994239)
-  Block bitmap at 9961472 (+0), Inode bitmap at 9961473 (+1)
-  Inode table at 9961474-9961678 (+2)
+  Block bitmap at 9961472 (+0), Inode bitmap at 9961488 (+16)
+  Inode table at 9961504-9961708 (+32)
 Group 305: (Blocks 9994240-10027007)
-  Block bitmap at 9994240 (+0), Inode bitmap at 9994241 (+1)
-  Inode table at 9994356-9994560 (+116)
+  Block bitmap at 9961473, Inode bitmap at 9961489
+  Inode table at 9961709-9961913
 Group 306: (Blocks 10027008-10059775)
-  Block bitmap at 10027008 (+0), Inode bitmap at 10027009 (+1)
-  Inode table at 10027019-10027223 (+11)
+  Block bitmap at 9961474, Inode bitmap at 9961490
+  Inode table at 9961914-9962118
 Group 307: (Blocks 10059776-10092543)
-  Block bitmap at 10060544 (+768), Inode bitmap at 10060545 (+769)
-  Inode table at 10061312-10061516 (+1536)
+  Block bitmap at 9961475, Inode bitmap at 9961491
+  Inode table at 9962119-9962323
 Group 308: (Blocks 10092544-10125311)
-  Block bitmap at 10092547 (+3), Inode bitmap at 10092548 (+4)
-  Inode table at 10092800-10093004 (+256)
+  Block bitmap at 9961476, Inode bitmap at 9961492
+  Inode table at 9962324-9962528
 Group 309: (Blocks 10125312-10158079)
-  Block bitmap at 10127360 (+2048), Inode bitmap at 10127361 (+2049)
-  Inode table at 10127362-10127566 (+2050)
+  Block bitmap at 9961477, Inode bitmap at 9961493
+  Inode table at 9962529-9962733
 Group 310: (Blocks 10158080-10190847)
-  Block bitmap at 10158083 (+3), Inode bitmap at 10158084 (+4)
-  Inode table at 10166272-10166476 (+8192)
+  Block bitmap at 9961478, Inode bitmap at 9961494
+  Inode table at 9962734-9962938
 Group 311: (Blocks 10190848-10223615)
-  Block bitmap at 10190848 (+0), Inode bitmap at 10190850 (+2)
-  Inode table at 10197504-10197708 (+6656)
+  Block bitmap at 9961479, Inode bitmap at 9961495
+  Inode table at 9962939-9963143
 Group 312: (Blocks 10223616-10256383)
-  Block bitmap at 10223619 (+3), Inode bitmap at 10223620 (+4)
-  Inode table at 10223621-10223825 (+5)
+  Block bitmap at 9961480, Inode bitmap at 9961496
+  Inode table at 9963144-9963348
 Group 313: (Blocks 10256384-10289151)
-  Block bitmap at 10260480 (+4096), Inode bitmap at 10260481 (+4097)
-  Inode table at 10260736-10260940 (+4352)
+  Block bitmap at 9961481, Inode bitmap at 9961497
+  Inode table at 9963349-9963553
 Group 314: (Blocks 10289152-10321919)
-  Block bitmap at 10291200 (+2048), Inode bitmap at 10291201 (+2049)
-  Inode table at 10291202-10291406 (+2050)
+  Block bitmap at 9961482, Inode bitmap at 9961498
+  Inode table at 9963554-9963758
 Group 315: (Blocks 10321920-10354687)
-  Block bitmap at 10321923 (+3), Inode bitmap at 10321924 (+4)
-  Inode table at 10321925-10322129 (+5)
+  Block bitmap at 9961483, Inode bitmap at 9961499
+  Inode table at 9963759-9963963
 Group 316: (Blocks 10354688-10387455)
-  Block bitmap at 10354688 (+0), Inode bitmap at 10354689 (+1)
-  Inode table at 10354690-10354894 (+2)
+  Block bitmap at 9961484, Inode bitmap at 9961500
+  Inode table at 9963964-9964168
 Group 317: (Blocks 10387456-10420223)
-  Block bitmap at 10387458 (+2), Inode bitmap at 10387459 (+3)
-  Inode table at 10389514-10389718 (+2058)
+  Block bitmap at 9961485, Inode bitmap at 9961501
+  Inode table at 9964169-9964373
 Group 318: (Blocks 10420224-10452991)
-  Block bitmap at 10422275 (+2051), Inode bitmap at 10422276 (+2052)
-  Inode table at 10422277-10422481 (+2053)
+  Block bitmap at 9961486, Inode bitmap at 9961502
+  Inode table at 9964374-9964578
 Group 319: (Blocks 10452992-10485759)
-  Block bitmap at 10455040 (+2048), Inode bitmap at 10455041 (+2049)
-  Inode table at 10457088-10457292 (+4096)
+  Block bitmap at 9961487, Inode bitmap at 9961503
+  Inode table at 9964579-9964783
 Group 320: (Blocks 10485760-10518527)
-  Block bitmap at 10485760 (+0), Inode bitmap at 10485761 (+1)
-  Inode table at 10485762-10485966 (+2)
+  Block bitmap at 10485760 (+0), Inode bitmap at 10485776 (+16)
+  Inode table at 10485792-10485996 (+32)
 Group 321: (Blocks 10518528-10551295)
-  Block bitmap at 10518528 (+0), Inode bitmap at 10518529 (+1)
-  Inode table at 10519587-10519791 (+1059)
+  Block bitmap at 10485761, Inode bitmap at 10485777
+  Inode table at 10485997-10486201
 Group 322: (Blocks 10551296-10584063)
-  Block bitmap at 10551554 (+258), Inode bitmap at 10551555 (+259)
-  Inode table at 10551556-10551760 (+260)
+  Block bitmap at 10485762, Inode bitmap at 10485778
+  Inode table at 10486202-10486406
 Group 323: (Blocks 10584064-10616831)
-  Block bitmap at 10584064 (+0), Inode bitmap at 10584065 (+1)
-  Inode table at 10584066-10584270 (+2)
+  Block bitmap at 10485763, Inode bitmap at 10485779
+  Inode table at 10486407-10486611
 Group 324: (Blocks 10616832-10649599)
-  Block bitmap at 10616832 (+0), Inode bitmap at 10616833 (+1)
-  Inode table at 10621345-10621549 (+4513)
+  Block bitmap at 10485764, Inode bitmap at 10485780
+  Inode table at 10486612-10486816
 Group 325: (Blocks 10649600-10682367)
-  Block bitmap at 10649600 (+0), Inode bitmap at 10649601 (+1)
-  Inode table at 10649602-10649806 (+2)
+  Block bitmap at 10485765, Inode bitmap at 10485781
+  Inode table at 10486817-10487021
 Group 326: (Blocks 10682368-10715135)
-  Block bitmap at 10686464 (+4096), Inode bitmap at 10686465 (+4097)
-  Inode table at 10687515-10687719 (+5147)
+  Block bitmap at 10485766, Inode bitmap at 10485782
+  Inode table at 10487022-10487226
 Group 327: (Blocks 10715136-10747903)
-  Block bitmap at 10715136 (+0), Inode bitmap at 10715137 (+1)
-  Inode table at 10721280-10721484 (+6144)
+  Block bitmap at 10485767, Inode bitmap at 10485783
+  Inode table at 10487227-10487431
 Group 328: (Blocks 10747904-10780671)
-  Block bitmap at 10754048 (+6144), Inode bitmap at 10754049 (+6145)
-  Inode table at 10754050-10754254 (+6146)
+  Block bitmap at 10485768, Inode bitmap at 10485784
+  Inode table at 10487432-10487636
 Group 329: (Blocks 10780672-10813439)
-  Block bitmap at 10780672 (+0), Inode bitmap at 10780673 (+1)
-  Inode table at 10781696-10781900 (+1024)
+  Block bitmap at 10485769, Inode bitmap at 10485785
+  Inode table at 10487637-10487841
 Group 330: (Blocks 10813440-10846207)
-  Block bitmap at 10817536 (+4096), Inode bitmap at 10817537 (+4097)
-  Inode table at 10817540-10817744 (+4100)
+  Block bitmap at 10485770, Inode bitmap at 10485786
+  Inode table at 10487842-10488046
 Group 331: (Blocks 10846208-10878975)
-  Block bitmap at 10846208 (+0), Inode bitmap at 10846209 (+1)
-  Inode table at 10846220-10846424 (+12)
+  Block bitmap at 10485771, Inode bitmap at 10485787
+  Inode table at 10488047-10488251
 Group 332: (Blocks 10878976-10911743)
-  Block bitmap at 10878976 (+0), Inode bitmap at 10878977 (+1)
-  Inode table at 10878978-10879182 (+2)
+  Block bitmap at 10485772, Inode bitmap at 10485788
+  Inode table at 10488252-10488456
 Group 333: (Blocks 10911744-10944511)
-  Block bitmap at 10911744 (+0), Inode bitmap at 10911745 (+1)
-  Inode table at 10911746-10911950 (+2)
+  Block bitmap at 10485773, Inode bitmap at 10485789
+  Inode table at 10488457-10488661
 Group 334: (Blocks 10944512-10977279)
-  Block bitmap at 10946576 (+2064), Inode bitmap at 10948608 (+4096)
-  Inode table at 10948609-10948813 (+4097)
+  Block bitmap at 10485774, Inode bitmap at 10485790
+  Inode table at 10488662-10488866
 Group 335: (Blocks 10977280-11010047)
-  Block bitmap at 10977280 (+0), Inode bitmap at 10977281 (+1)
-  Inode table at 10977536-10977740 (+256)
+  Block bitmap at 10485775, Inode bitmap at 10485791
+  Inode table at 10488867-10489071
 Group 336: (Blocks 11010048-11042815)
-  Block bitmap at 11010048 (+0), Inode bitmap at 11010049 (+1)
-  Inode table at 11010050-11010254 (+2)
+  Block bitmap at 11010048 (+0), Inode bitmap at 11010064 (+16)
+  Inode table at 11010080-11010284 (+32)
 Group 337: (Blocks 11042816-11075583)
-  Block bitmap at 11042816 (+0), Inode bitmap at 11042818 (+2)
-  Inode table at 11042819-11043023 (+3)
+  Block bitmap at 11010049, Inode bitmap at 11010065
+  Inode table at 11010285-11010489
 Group 338: (Blocks 11075584-11108351)
-  Block bitmap at 11075585 (+1), Inode bitmap at 11075586 (+2)
-  Inode table at 11075598-11075802 (+14)
+  Block bitmap at 11010050, Inode bitmap at 11010066
+  Inode table at 11010490-11010694
 Group 339: (Blocks 11108352-11141119)
-  Block bitmap at 11110404 (+2052), Inode bitmap at 11110405 (+2053)
-  Inode table at 11111424-11111628 (+3072)
+  Block bitmap at 11010051, Inode bitmap at 11010067
+  Inode table at 11010695-11010899
 Group 340: (Blocks 11141120-11173887)
-  Block bitmap at 11141120 (+0), Inode bitmap at 11141121 (+1)
-  Inode table at 11141285-11141489 (+165)
+  Block bitmap at 11010052, Inode bitmap at 11010068
+  Inode table at 11010900-11011104
 Group 341: (Blocks 11173888-11206655)
-  Block bitmap at 11175939 (+2051), Inode bitmap at 11175940 (+2052)
-  Inode table at 11175941-11176145 (+2053)
+  Block bitmap at 11010053, Inode bitmap at 11010069
+  Inode table at 11011105-11011309
 Group 342: (Blocks 11206656-11239423)
-  Block bitmap at 11206656 (+0), Inode bitmap at 11206657 (+1)
-  Inode table at 11215478-11215682 (+8822)
+  Block bitmap at 11010054, Inode bitmap at 11010070
+  Inode table at 11011310-11011514
 Group 343: (Blocks 11239424-11272191)
   Backup superblock at 11239424, Group descriptors at 11239425-11239483
-  Block bitmap at 11239484 (+60), Inode bitmap at 11239488 (+64)
-  Inode table at 11241472-11241676 (+2048)
+  Block bitmap at 11010055, Inode bitmap at 11010071
+  Inode table at 11011515-11011719
 Group 344: (Blocks 11272192-11304959)
-  Block bitmap at 11272197 (+5), Inode bitmap at 11272201 (+9)
-  Inode table at 11280896-11281100 (+8704)
+  Block bitmap at 11010056, Inode bitmap at 11010072
+  Inode table at 11011720-11011924
 Group 345: (Blocks 11304960-11337727)
-  Block bitmap at 11304960 (+0), Inode bitmap at 11304961 (+1)
-  Inode table at 11308032-11308236 (+3072)
+  Block bitmap at 11010057, Inode bitmap at 11010073
+  Inode table at 11011925-11012129
 Group 346: (Blocks 11337728-11370495)
-  Block bitmap at 11337729 (+1), Inode bitmap at 11337732 (+4)
-  Inode table at 11337740-11337944 (+12)
+  Block bitmap at 11010058, Inode bitmap at 11010074
+  Inode table at 11012130-11012334
 Group 347: (Blocks 11370496-11403263)
-  Block bitmap at 11370497 (+1), Inode bitmap at 11370498 (+2)
-  Inode table at 11370752-11370956 (+256)
+  Block bitmap at 11010059, Inode bitmap at 11010075
+  Inode table at 11012335-11012539
 Group 348: (Blocks 11403264-11436031)
-  Block bitmap at 11403264 (+0), Inode bitmap at 11403265 (+1)
-  Inode table at 11403520-11403724 (+256)
+  Block bitmap at 11010060, Inode bitmap at 11010076
+  Inode table at 11012540-11012744
 Group 349: (Blocks 11436032-11468799)
-  Block bitmap at 11436032 (+0), Inode bitmap at 11436033 (+1)
-  Inode table at 11438720-11438924 (+2688)
+  Block bitmap at 11010061, Inode bitmap at 11010077
+  Inode table at 11012745-11012949
 Group 350: (Blocks 11468800-11501567)
-  Block bitmap at 11468800 (+0), Inode bitmap at 11468801 (+1)
-  Inode table at 11469568-11469772 (+768)
+  Block bitmap at 11010062, Inode bitmap at 11010078
+  Inode table at 11012950-11013154
 Group 351: (Blocks 11501568-11534335)
-  Block bitmap at 11505920 (+4352), Inode bitmap at 11505921 (+4353)
-  Inode table at 11505922-11506126 (+4354)
+  Block bitmap at 11010063, Inode bitmap at 11010079
+  Inode table at 11013155-11013359
 Group 352: (Blocks 11534336-11567103)
-  Block bitmap at 11534336 (+0), Inode bitmap at 11534337 (+1)
-  Inode table at 11534338-11534542 (+2)
+  Block bitmap at 11534336 (+0), Inode bitmap at 11534352 (+16)
+  Inode table at 11534368-11534572 (+32)
 Group 353: (Blocks 11567104-11599871)
-  Block bitmap at 11567104 (+0), Inode bitmap at 11567105 (+1)
-  Inode table at 11570176-11570380 (+3072)
+  Block bitmap at 11534337, Inode bitmap at 11534353
+  Inode table at 11534573-11534777
 Group 354: (Blocks 11599872-11632639)
-  Block bitmap at 11599872 (+0), Inode bitmap at 11599873 (+1)
-  Inode table at 11599876-11600080 (+4)
+  Block bitmap at 11534338, Inode bitmap at 11534354
+  Inode table at 11534778-11534982
 Group 355: (Blocks 11632640-11665407)
-  Block bitmap at 11632640 (+0), Inode bitmap at 11632641 (+1)
-  Inode table at 11633664-11633868 (+1024)
+  Block bitmap at 11534339, Inode bitmap at 11534355
+  Inode table at 11534983-11535187
 Group 356: (Blocks 11665408-11698175)
-  Block bitmap at 11665412 (+4), Inode bitmap at 11665413 (+5)
-  Inode table at 11666944-11667148 (+1536)
+  Block bitmap at 11534340, Inode bitmap at 11534356
+  Inode table at 11535188-11535392
 Group 357: (Blocks 11698176-11730943)
-  Block bitmap at 11698176 (+0), Inode bitmap at 11698177 (+1)
-  Inode table at 11698379-11698583 (+203)
+  Block bitmap at 11534341, Inode bitmap at 11534357
+  Inode table at 11535393-11535597
 Group 358: (Blocks 11730944-11763711)
-  Block bitmap at 11730944 (+0), Inode bitmap at 11730945 (+1)
-  Inode table at 11734016-11734220 (+3072)
+  Block bitmap at 11534342, Inode bitmap at 11534358
+  Inode table at 11535598-11535802
 Group 359: (Blocks 11763712-11796479)
-  Block bitmap at 11763713 (+1), Inode bitmap at 11763716 (+4)
-  Inode table at 11764736-11764940 (+1024)
+  Block bitmap at 11534343, Inode bitmap at 11534359
+  Inode table at 11535803-11536007
 Group 360: (Blocks 11796480-11829247)
-  Block bitmap at 11796480 (+0), Inode bitmap at 11798532 (+2052)
-  Inode table at 11798533-11798737 (+2053)
+  Block bitmap at 11534344, Inode bitmap at 11534360
+  Inode table at 11536008-11536212
 Group 361: (Blocks 11829248-11862015)
-  Block bitmap at 11829248 (+0), Inode bitmap at 11829251 (+3)
-  Inode table at 11830272-11830476 (+1024)
+  Block bitmap at 11534345, Inode bitmap at 11534361
+  Inode table at 11536213-11536417
 Group 362: (Blocks 11862016-11894783)
-  Block bitmap at 11862016 (+0), Inode bitmap at 11862018 (+2)
-  Inode table at 11862019-11862223 (+3)
+  Block bitmap at 11534346, Inode bitmap at 11534362
+  Inode table at 11536418-11536622
 Group 363: (Blocks 11894784-11927551)
-  Block bitmap at 11894788 (+4), Inode bitmap at 11894789 (+5)
-  Inode table at 11894797-11895001 (+13)
+  Block bitmap at 11534347, Inode bitmap at 11534363
+  Inode table at 11536623-11536827
 Group 364: (Blocks 11927552-11960319)
-  Block bitmap at 11927552 (+0), Inode bitmap at 11927553 (+1)
-  Inode table at 11929608-11929812 (+2056)
+  Block bitmap at 11534348, Inode bitmap at 11534364
+  Inode table at 11536828-11537032
 Group 365: (Blocks 11960320-11993087)
-  Block bitmap at 11960320 (+0), Inode bitmap at 11960321 (+1)
-  Inode table at 11962368-11962572 (+2048)
+  Block bitmap at 11534349, Inode bitmap at 11534365
+  Inode table at 11537033-11537237
 Group 366: (Blocks 11993088-12025855)
-  Block bitmap at 11993088 (+0), Inode bitmap at 11993089 (+1)
-  Inode table at 11993600-11993804 (+512)
+  Block bitmap at 11534350, Inode bitmap at 11534366
+  Inode table at 11537238-11537442
 Group 367: (Blocks 12025856-12058623)
-  Block bitmap at 12025856 (+0), Inode bitmap at 12025860 (+4)
-  Inode table at 12025861-12026065 (+5)
+  Block bitmap at 11534351, Inode bitmap at 11534367
+  Inode table at 11537443-11537647
 Group 368: (Blocks 12058624-12091391)
-  Block bitmap at 12058624 (+0), Inode bitmap at 12058625 (+1)
-  Inode table at 12058626-12058830 (+2)
+  Block bitmap at 12058624 (+0), Inode bitmap at 12058640 (+16)
+  Inode table at 12058656-12058860 (+32)
 Group 369: (Blocks 12091392-12124159)
-  Block bitmap at 12091392 (+0), Inode bitmap at 12091393 (+1)
-  Inode table at 12092416-12092620 (+1024)
+  Block bitmap at 12058625, Inode bitmap at 12058641
+  Inode table at 12058861-12059065
 Group 370: (Blocks 12124160-12156927)
-  Block bitmap at 12124163 (+3), Inode bitmap at 12124165 (+5)
-  Inode table at 12124672-12124876 (+512)
+  Block bitmap at 12058626, Inode bitmap at 12058642
+  Inode table at 12059066-12059270
 Group 371: (Blocks 12156928-12189695)
-  Block bitmap at 12157440 (+512), Inode bitmap at 12157441 (+513)
-  Inode table at 12157471-12157675 (+543)
+  Block bitmap at 12058627, Inode bitmap at 12058643
+  Inode table at 12059271-12059475
 Group 372: (Blocks 12189696-12222463)
-  Block bitmap at 12189696 (+0), Inode bitmap at 12189698 (+2)
-  Inode table at 12189711-12189915 (+15)
+  Block bitmap at 12058628, Inode bitmap at 12058644
+  Inode table at 12059476-12059680
 Group 373: (Blocks 12222464-12255231)
-  Block bitmap at 12222465 (+1), Inode bitmap at 12222467 (+3)
-  Inode table at 12222720-12222924 (+256)
+  Block bitmap at 12058629, Inode bitmap at 12058645
+  Inode table at 12059681-12059885
 Group 374: (Blocks 12255232-12287999)
-  Block bitmap at 12255232 (+0), Inode bitmap at 12255233 (+1)
-  Inode table at 12256256-12256460 (+1024)
+  Block bitmap at 12058630, Inode bitmap at 12058646
+  Inode table at 12059886-12060090
 Group 375: (Blocks 12288000-12320767)
-  Block bitmap at 12290050 (+2050), Inode bitmap at 12290055 (+2055)
-  Inode table at 12290056-12290260 (+2056)
+  Block bitmap at 12058631, Inode bitmap at 12058647
+  Inode table at 12060091-12060295
 Group 376: (Blocks 12320768-12353535)
-  Block bitmap at 12320768 (+0), Inode bitmap at 12320769 (+1)
-  Inode table at 12320776-12320980 (+8)
+  Block bitmap at 12058632, Inode bitmap at 12058648
+  Inode table at 12060296-12060500
 Group 377: (Blocks 12353536-12386303)
-  Block bitmap at 12353536 (+0), Inode bitmap at 12353537 (+1)
-  Inode table at 12353538-12353742 (+2)
+  Block bitmap at 12058633, Inode bitmap at 12058649
+  Inode table at 12060501-12060705
 Group 378: (Blocks 12386304-12419071)
-  Block bitmap at 12386304 (+0), Inode bitmap at 12386305 (+1)
-  Inode table at 12386308-12386512 (+4)
+  Block bitmap at 12058634, Inode bitmap at 12058650
+  Inode table at 12060706-12060910
 Group 379: (Blocks 12419072-12451839)
-  Block bitmap at 12419072 (+0), Inode bitmap at 12419073 (+1)
-  Inode table at 12419074-12419278 (+2)
+  Block bitmap at 12058635, Inode bitmap at 12058651
+  Inode table at 12060911-12061115
 Group 380: (Blocks 12451840-12484607)
-  Block bitmap at 12451840 (+0), Inode bitmap at 12451844 (+4)
-  Inode table at 12451855-12452059 (+15)
+  Block bitmap at 12058636, Inode bitmap at 12058652
+  Inode table at 12061116-12061320
 Group 381: (Blocks 12484608-12517375)
-  Block bitmap at 12484609 (+1), Inode bitmap at 12484610 (+2)
-  Inode table at 12485120-12485324 (+512)
+  Block bitmap at 12058637, Inode bitmap at 12058653
+  Inode table at 12061321-12061525
 Group 382: (Blocks 12517376-12550143)
-  Block bitmap at 12517376 (+0), Inode bitmap at 12517377 (+1)
-  Inode table at 12517378-12517582 (+2)
+  Block bitmap at 12058638, Inode bitmap at 12058654
+  Inode table at 12061526-12061730
 Group 383: (Blocks 12550144-12582911)
-  Block bitmap at 12550144 (+0), Inode bitmap at 12550145 (+1)
-  Inode table at 12550151-12550355 (+7)
+  Block bitmap at 12058639, Inode bitmap at 12058655
+  Inode table at 12061731-12061935
 Group 384: (Blocks 12582912-12615679)
   Block bitmap at 12582912 (+0), Inode bitmap at 12582928 (+16)
   Inode table at 12582944-12583148 (+32)

--=-pGV9J0rc8p583CHH/Zpz--

