From: Andreas Dilger <adilger@dilger.ca>
Subject: Fwd: e2fsck -fD corruption of large htree/extent directory
Date: Fri, 6 Nov 2015 01:23:20 -0700
Message-ID: <549505B6-A176-4061-93C2-78C6EE094A2B@dilger.ca>
References: <D261A180.118DB8%andreas.dilger@intel.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: multipart/signed; boundary="Apple-Mail=_D2FC45A4-20DA-4B19-90A7-7E9759764228"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:32871 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757237AbbKFIX3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Nov 2015 03:23:29 -0500
Received: by pabfh17 with SMTP id fh17so115847876pab.0
        for <linux-ext4@vger.kernel.org>; Fri, 06 Nov 2015 00:23:28 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_D2FC45A4-20DA-4B19-90A7-7E9759764228
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

Ted, per our discussion this morning, here are the details of the
e2fsck -fD corruption problem we saw.

Running e2fsck -fD on a large extent+htree directory (> 300k entries,
1600+ filesystem blocks) showed corruption on a large number of dirs.
This is definitely caused by a bug in the code rather than hardware, as
this corrupted multiple large directories on 11 different systems.
Sometimes, similar directories on the same systems did not have errors.

As yet the reason and mechanism has not been determined, but it may
relate to the filesystem history (the directories may have originally
been block mapped, an in any case the blocks are mostly discontiguous
on disk).  These dirs undergo continuous insertion and deletion of
entries with ~10-character filenames, so the leaf blocks may have become
quite fragmented over time.

Running e2fsck on the filesystem showed:

   e2fsck 1.42.12.wc1 (15-Sep-2014)
   MMP interval is 5 seconds and total wait time is 22 seconds. Please wait.
   Pass 1: Checking inodes, blocks, and sizes
   Interior extent node level 1 of inode 39321606:
   Logical start 1430 does not match logical start 1875 at next level.
Fix? yes

   Inode 39321606, end of extent exceeds allowed value
   (logical block 1875, physical block 1258402260, len 1)
   Clear? yes

   Failed to iterate extents in inode 39321606
   (op EXT2_EXTENT_UP, blk 1258402260, lblk 1875): No 'up' extent
   Clear inode? yes

   Inode 39321606 is a zero-length directory.  Clear? yes

   Update quota info for quota type 0? yes
   Update quota info for quota type 1? yes

   Restarting e2fsck from the beginning...
   Pass 1: Checking inodes, blocks, and sizes
   Pass 2: Checking directory structure
   Entry 'd2' in /O/0 (39321602) has deleted/unused inode 39321606.
   Clear? yes

   Pass 3: Checking directory connectivity
   Pass 4: Checking reference counts
   Unattached inode 147
   Connect to /lost+found? yes
   Inode 147 ref count is 2, should be 1.  Fix? yes

   Unattached inode 173
   Connect to /lost+found? yes
   Inode 173 ref count is 2, should be 1.  Fix? yes
   :
   :
   Unattached inode 92016391
   Connect to /lost+found? yes

   Inode 92016391 ref count is 2, should be 1.  Fix? yes
   Pass 5: Checking group summary information
   Block bitmap differences:  -1258308100

   Update quota info for quota type 0? yesm
   Update quota info for quota type 1? yes

   scratch-OST0049: ***** FILE SYSTEM WAS MODIFIED *****

Stat data for the corrupted directory inode:

   debugfs -c -R "stat <39321606>"
   Inode: 39321606 Type: directory Mode: 0700 Flags: 0x81000
   Generation: 2310511783 Version: 0x00000000:00000000
   User: 0 Group: 0 Size: 6750208
   File ACL: 0 Directory ACL: 0
   Links: 2 Blockcount: 13232
   Fragment: Address: 0 Number: 0 Size: 0
   ctime: 0x563111cf:15fb2694 -- Wed Oct 28 14:19:59 2015
   atime: 0x52f30c97:9fe5c3ac -- Wed Feb 5 23:16:23 2014
   mtime: 0x563111cf:15fb2694 -- Wed Oct 28 14:19:59 2015
   crtime: 0x52f30c97:9fe5c3ac -- Wed Feb 5 23:16:23 2014
   Size of extra inode fields: 28
   Extended attributes stored in inode body:
   invalid EA entry in inode
   EXTENTS:
   [shown below]

The debugfs dump_extents command shows that the extent tree is mostly OK.
In all observed cases, the extent tree was 5 blocks long (possibly a
result of 4 extent blocks being moved out of the in-inode i_block[]
array and into an external second-level index block), or because the
number of entries in each directory is roughly the same, not sure.

Level Entries       Logical                Physical Length Flags
 0/ 2   1/  1     0 -  1647 1258392344                1648
 1/ 2   1/  5     0 -   353 1258308301                 354
 2/ 2   1/340     0 -     0 1258308100 - 1258308100      1
 2/ 2   2/340     1 -     2 1258308174 - 1258308175      2
 2/ 2   3/340     3 -     3 1258308213 - 1258308213      1
 2/ 2   4/340     4 -     4 1258308241 - 1258308241      1
 :
 :
 2/ 2 339/340   352 -   352 1258319291 - 1258319291      1
 2/ 2 340/340   353 -   353 1258319375 - 1258319375      1
 1/ 2   2/  5   354 -   704 1258319416                 351
 2/ 2   1/340   354 -   354 1258319415 - 1258319415      1
 2/ 2   2/340   355 -   355 1258319470 - 1258319470      1
 :
 :
 2/ 2 339/340   703 -   703 1258350886 - 1258350886      1
 2/ 2 340/340   704 -   704 1258350895 - 1258350895      1
 1/ 2   3/  5   705 -  1055 1258350929                 351
 2/ 2   1/339   705 -   705 1258350928 - 1258350928      1
 2/ 2   2/339   706 -   706 1258343948 - 1258343948      1
 :
 :
 2/ 2 336/339  1052 -  1052 1258365348 - 1258365348      1
 2/ 2 337/339  1053 -  1053 1258365355 - 1258365355      1
 2/ 2 338/339  1054 -  1054 1258365417 - 1258365417      1
 2/ 2 339/339  1055 -  1055 1258365432 - 1258365432      1
 1/ 2   4/  5  1056 -  1874 1258324458                 819
 2/ 2   1/340  1056 -  1056 1258365435 - 1258365435      1
 2/ 2   2/340  1057 -  1057 1258366983 - 1258366983      1
 2/ 2   3/340  1058 -  1059 1258366993 - 1258366994      2
 :
 :
 2/ 2 338/340  1427 -  1427 1258379312 - 1258379312      1
 2/ 2 339/340  1428 -  1428 1258379117 - 1258379117      1
 2/ 2 340/340  1429 -  1429 1258379133 - 1258379133      1
 1/ 2   5/  5  1875 - 4294968943 1258406330              4294967069
 2/ 2   1/  1  1875 -  1875 1258402260 - 1258402260      1

The 4/5 extent index block shows an extent length of 1874 - 1056 = 819
blocks, but the extent block only has 1429 - 1056 = 373 blocks in the
extent.  The extent root block reports 1648 blocks, which matches both
i_size and i_blocks.  There appears to be one block missing from the
extent tree, or it was clobbered by 5/5 during an update, and/or the
starting offset of block 5/5 is just wrong.

There doesn't appear to be any other data corruption in the filesystem
besides the directory extent blocks, but this resulted in several
hundred leaf blocks being lost per directory, resulting in millions of
files in lost+found (see my other recent email on that topic).

In some cases, it appears that 100% of files were readable from the
corrupted directory using debugfs _before_ the e2fsck was run:

   debugfs -c -R "ls -l $DIR" $DEV

even though e2fsck was unhappy with the extent structure and cleared
part of the extent tree and dumped the files into lost+found.  This
implies that the directory entries were all moved into the first blocks
of the directory (i.e. leaf blocks under extent indices 1/5..4/5, and
the blocks in the corrupt part of the directory were somehow "extra" and
the bug lies in the extent handling when shrinking the directory.

Cheers, Andreas






--Apple-Mail=_D2FC45A4-20DA-4B19-90A7-7E9759764228
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVjxjenKl2rkXzB/gAQilYA/8CPGnBviUEfd3nfQT+oGKC1Ag6nna7UuX
B7nVUOCbb9f9wArwrF2iCOFQQfonPbfq9CZUAGAn6I9Jlma94faaqb5nuitmwBrs
+t6a06QSbqbbWvkeAimbAwJ6GWA7wrNrz4twSJlPPWwQ+uQpq3RnpBAn3L49C4YA
CVwreQAlK8i5AfvTGA51UeqJkEci4ib4kwXLfklzfHka20hJv0gmEv0QvLTyXc7o
PrHEroZOWKWQx1wg0cu1LSKEgvyzK/huUxEepdMA9SmQbTYRq2aYRmtpkzLTg8hp
SahaiKB8+3enDQwmqNGcmYcv8MxLWHgRbXO0vJheffzcIJdSqB+wJGeyP4YyPgOQ
mvmdjwWqkg49TdCzC0TUk9NGqHmdNsAxkC4WNvVsFDU4IuWKyWuySEmQ/vQFL364
CZXPeX+S316HnUXq+GStZ+1A3PvzzkRLfkO5hZhmVc8orQmOrNMa61RTb14A/UYl
EZJAonNUPQkw8xOUxdHSABfG2/fmfhqCwc8tMgd6Id2TA13Avi1eUMeOGKdTVolX
ULeSBi2qK3r3VYgGIIkK4d59AsKl14ca9zvH3h8nEpZt7w9p/hjLgFucKvAEAu9n
B1h17M1C4vWYusnW6R7UPUhaNzle9gnwsV2RmJXLJpa/ehpaZvEoDJgnavXPCwrT
tYs+LAzglx8=
=8NGg
-----END PGP SIGNATURE-----

--Apple-Mail=_D2FC45A4-20DA-4B19-90A7-7E9759764228--
