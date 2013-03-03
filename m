From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 1/2] e4defrag: defrag a file when orig_physical_cnt == donor_physical_cnt
Date: Mon,  4 Mar 2013 00:26:17 +0800
Message-ID: <1362327978-30423-2-git-send-email-wenqing.lz@taobao.com>
References: <1362327978-30423-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f45.google.com ([209.85.210.45]:40174 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589Ab3CCQLU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 3 Mar 2013 11:11:20 -0500
Received: by mail-da0-f45.google.com with SMTP id v40so2139209dad.18
        for <linux-ext4@vger.kernel.org>; Sun, 03 Mar 2013 08:11:20 -0800 (PST)
In-Reply-To: <1362327978-30423-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

When orig_physical_cnt == donor_physical_cnt, we need to defrag a file
because a file could be written backwards.  So that will make it look
like a contiguous extent but actually the physical blocks are reversed.

This case can be created artificially just like xfstests #218 does.  The
following script can create it.

	for I in `seq 9 -1 0`; do
		dd if=/dev/zero of=$testfile bs=4k count=1 conv=notrunc \
			seek=$I oflag=sync &>/dev/null
	done
	sudo filefrag -v $testfile
	sudo e4defrag -v $testfile
	sudo filefrag -v $testfile

Before applied this patch, the result of running script is like:

Filesystem type is: ef53
File size of /mnt/sda3/testfile is 40960 (10 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..       0:      34825..     34825:      1:
   1:        1..       1:      34824..     34824:      1:      34826:
   2:        2..       2:      34823..     34823:      1:      34825:
   3:        3..       3:      34822..     34822:      1:      34824:
   4:        4..       4:      34821..     34821:      1:      34823:
   5:        5..       5:      34820..     34820:      1:      34822:
   6:        6..       6:      34819..     34819:      1:      34821:
   7:        7..       7:      34818..     34818:      1:      34820:
   8:        8..       8:      34817..     34817:      1:      34819:
   9:        9..       9:      34816..     34816:      1:      34818: eof
/mnt/sda3/testfile: 10 extents found
ext4 defragmentation for /mnt/sda3/testfile
[1/1]/mnt/sda3/testfile:	100%  extents: 10 -> 10	[ OK ]
 Success:			[1/1]
Filesystem type is: ef53
File size of /mnt/sda3/testfile is 40960 (10 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..       0:      34825..     34825:      1:
   1:        1..       1:      34824..     34824:      1:      34826:
   2:        2..       2:      34823..     34823:      1:      34825:
   3:        3..       3:      34822..     34822:      1:      34824:
   4:        4..       4:      34821..     34821:      1:      34823:
   5:        5..       5:      34820..     34820:      1:      34822:
   6:        6..       6:      34819..     34819:      1:      34821:
   7:        7..       7:      34818..     34818:      1:      34820:
   8:        8..       8:      34817..     34817:      1:      34819:
   9:        9..       9:      34816..     34816:      1:      34818: eof
/mnt/sda3/testfile: 10 extents found

After applied it, the result of running script looks like:
Filesystem type is: ef53
File size of /mnt/sda3/testfile is 40960 (10 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..       0:      34313..     34313:      1:
   1:        1..       1:      34312..     34312:      1:      34314:
   2:        2..       2:      34311..     34311:      1:      34313:
   3:        3..       3:      34310..     34310:      1:      34312:
   4:        4..       4:      34309..     34309:      1:      34311:
   5:        5..       5:      34308..     34308:      1:      34310:
   6:        6..       6:      34307..     34307:      1:      34309:
   7:        7..       7:      34306..     34306:      1:      34308:
   8:        8..       8:      34305..     34305:      1:      34307:
   9:        9..       9:      34304..     34304:      1:      34306: eof
/mnt/sda3/testfile: 10 extents found
ext4 defragmentation for /mnt/sda3/testfile
[1/1]/mnt/sda3/testfile:	100%  extents: 10 -> 1	[ OK ]
 Success:			[1/1]
Filesystem type is: ef53
File size of /mnt/sda3/testfile is 40960 (10 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..       9:      33794..     33803:     10:             eof
/mnt/sda3/testfile: 1 extent found

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 misc/e4defrag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index 4b31d03..ae4e8d8 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -1649,7 +1649,7 @@ check_improvement:
 	}
 
 	if (file_frags_start <= best ||
-			orig_physical_cnt <= donor_physical_cnt) {
+			orig_physical_cnt < donor_physical_cnt) {
 		printf("\033[79;0H\033[K[%u/%u]%s:\t%3d%%",
 			defraged_file_count, total_count, file, 100);
 		if (mode_flag & DETAIL)
-- 
1.7.12.rc2.18.g61b472e

