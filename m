From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>
Subject: Journal file fragmentation
Date: Wed, 27 Aug 2008 19:36:07 +0200
Message-ID: <1219858567.3591.64.camel@frecb007923.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:50628 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391AbYH0PeK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Aug 2008 11:34:10 -0400
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 9908F19D99A
	for <linux-ext4@vger.kernel.org>; Wed, 27 Aug 2008 17:34:02 +0200 (CEST)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 31420-04 for <linux-ext4@vger.kernel.org>;
 Wed, 27 Aug 2008 17:33:59 +0200 (CEST)
Received: from cyclope.frec.bull.fr (cyclope.frec.bull.fr [129.183.4.9])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 871C019D971
	for <linux-ext4@vger.kernel.org>; Wed, 27 Aug 2008 17:33:59 +0200 (CEST)
Received: from [129.183.101.220] (dhcp129183101220.frec.bull.fr [129.183.101.220])
	by cyclope.frec.bull.fr (Postfix) with ESMTP id 625B427291
	for <linux-ext4@vger.kernel.org>; Wed, 27 Aug 2008 17:33:57 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

While playing with filesystems using flex bg, I noticed that the journal
file may be fragmented when there are a lots of meta-data in  the first
flex-group.
For example, with this command : mkfs.ext4 -t ext4dev -G512 /dev/sdb1
The journal file is reported by "stat <8>" in debugfs to be like this :

Inode: 8   Type: regular    Mode:  0600   Flags: 0x0
Generation: 0    Version: 0x00000000
User:     0   Group:     0   Size: 134217728
File ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 262416
Fragment:  Address: 0    Number: 0    Size: 0
ctime: 0x48b4a426 -- Wed Aug 27 02:47:34 2008
atime: 0x00000000 -- Thu Jan  1 01:00:00 1970
mtime: 0x48b4a426 -- Wed Aug 27 02:47:34 2008
Size of extra inode fields: 0
BLOCKS:
(0-11):28679-28690, (IND):28691, (12-1035):28692-29715, (DIND):29716,
(IND):29717, (1036-2059):29718-30741, (IND):30742,
(2060-3083):30743-31766, (IND):31767, (3084-4083):31768-32767,
(4084-4107):94209-94232, (IND):94233, (4108-5131):94234-95257,
(IND):95258, (5132-6155):95259-96282, (IND):96283,
(6156-7179):96284-97307, (IND):97308, (7180-8174):97309-98303,
(8175-8203):159745-159773, (IND):159774, (8204-9227):159775-160798,
(IND):160799, (9228-10251):160800-161823, (IND):161824,
(10252-11275):161825-162848, (IND):162849, (11276-12265):162850-163839,
(12266-12299):225281-225314, (IND):225315, (12300-13323):225316-226339,
(IND):226340, (13324-14347):226341-227364, (IND):227365,
(14348-15371):227366-228389, (IND):228390, (15372-16356):228391-229375,
(16357-16395):284673-284711, (IND):284712, (16396-17419):284713-285736,
(IND):285737, (17420-18443):285738-286761, (IND):286762,
(18444-19467):286763-287786, (IND):287787, (19468-20491):287788-288811,
(IND):288812, (20492-21515):288813-289836, (IND):289837,
(21516-22539):289838-290861, (IND):290862, (22540-23563):290863-291886,
(IND):291887, (23564-24587):291888-292911, (IND):292912,
(24588-25611):292913-293936, (IND):293937, (25612-26585):293938-294911,
(26586-26635):295937-295986, (IND):295987, (26636-27659):295988-297011,
(IND):297012, (27660-28683):297013-298036, (IND):298037,
(28684-29707):298038-299061, (IND):299062, (29708-30731):299063-300086,
(IND):300087, (30732-31755):300088-301111, (IND):301112,
(31756-32768):301113-302125
TOTAL: 32802

This journal file is splited in 5 parts : some blocks at 28679-32767,
then 94209-98303, then 159745-163839, then 225281-229375 and finally
284673-302125

Of course "-G512" in the mkfs commad line is an extreme case but it
shows clearly the fragmentation.

I've tried to find if this fragmentation has any performance impact. So
I've quickly wrote the following patch for the mkfs program :

Index: e2fsprogs/lib/ext2fs/mkjournal.c
===================================================================
--- e2fsprogs.orig/lib/ext2fs/mkjournal.c       2008-08-27 02:37:59.000000000 +0200
+++ e2fsprogs/lib/ext2fs/mkjournal.c    2008-08-27 14:51:02.000000000 +0200
@@ -220,7 +220,11 @@ static int mkjournal_proc(ext2_filsys      fs
                last_blk = *blocknr;
                return 0;
        }
-       retval = ext2fs_new_block(fs, last_blk, 0, &new_blk);
+       retval = ext2fs_get_free_blocks(fs, ref_block,
+                                       fs->super->s_blocks_count,
+                                       es->num_blocks, fs->block_map,
+                                       &new_blk);
+
        if (retval) {
                es->err = retval;
                return BLOCK_ABORT;

This makes the mkfs time a bit longer but ends up with an unfragmented
journal file : debugfs stat<8> reports that the journal file uses
contiguous blocks from 295937 to 328738.

Then I've launched bonnie++ for testing performance impact.This is my
test script :

mkfs.ext4 -t ext4dev -G512 /dev/sdb1
mount -t ext4dev -o data=journal /dev/sdb1 /mnt/test
bonnie++ -u root -s 0 -n 4000 -d /mnt/test/

And the results:

Without patch :

Version 1.03d       ------Sequential Create------ --------Random Create--------
                    -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
               4000  3978   7   602   0   518   1  3962   8   520   0   326   1

With patch :

Version 1.03d       ------Sequential Create------ --------Random Create--------
                    -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
               4000  4180   8   736   1   543   1  4029   8   556   0   335   1

Difference :
                     
                     +5.0      +22%     +4.8%      +1.6%     +6.9%     +2.7%

Conclusion :

First, the higher performance enhancement are on read operation, which,
if i am not wrong, has nothing to do with the journal file. This is
surprising and may indicate that those results are wrong, but I can't
see why right now.
Second, there is a slight enhancement on write operations so the journal
file defragmentation seems to have a positive impact in this test.

I'm still bothered by the performance increase in read. So I will launch
some more tests and see if it is consistant.

Please, feel free to give me any comments you may have on this subject.

Thanks.

Frederic







