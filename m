From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH] ext4: Fix 32bit overflow in ext4_ext_find_goal()
Date: Mon, 13 Dec 2010 14:37:54 +0900
Message-ID: <4D05B132.3060402@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:39575 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab0LMFjk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Dec 2010 00:39:40 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

ext4_ext_find_goal() returns an ideal physical block number that the block
allocator tries to allocate first. However, if a required file offset is
smaller than the existing extent's one, ext4_ext_find_goal() returns
a wrong block number because it may overflow at
"block - le32_to_cpu(ex->ee_block)". This patch fixes the problem.

ext4_ext_find_goal() will also return a wrong block number in case
a file offset of the existing extent is too big. In this case,
the ideal physical block number is fixed in ext4_mb_initialize_context(),
so it's no problem.

reproduce:
# dd if=/dev/zero of=/mnt/mp1/tmp bs=127M count=1 oflag=sync
# dd if=/dev/zero of=/mnt/mp1/file bs=512K count=1 seek=1 oflag=sync
# filefrag -v /mnt/mp1/file
Filesystem type is: ef53
File size of /mnt/mp1/file is 1048576 (256 blocks, blocksize 4096)
 ext logical physical expected length flags
   0     128    67456             128 eof
/mnt/mp1/file: 2 extents found
# rm -rf /mnt/mp1/tmp
# echo $((512*4096)) > /sys/fs/ext4/loop0/mb_stream_req
# dd if=/dev/zero of=/mnt/mp1/file bs=512K count=1 oflag=sync conv=notrunc

result (linux-2.6.37-rc2 + ext4 patch queue):
# filefrag -v /mnt/mp1/file
Filesystem type is: ef53
File size of /mnt/mp1/file is 1048576 (256 blocks, blocksize 4096)
 ext logical physical expected length flags
   0       0    33280             128 
   1     128    67456    33407    128 eof
/mnt/mp1/file: 2 extents found

result(apply this patch):
# filefrag -v /mnt/mp1/file
Filesystem type is: ef53
File size of /mnt/mp1/file is 1048576 (256 blocks, blocksize 4096)
 ext logical physical expected length flags
   0       0    66560             128 
   1     128    67456    66687    128 eof
/mnt/mp1/file: 2 extents found

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 fs/ext4/extents.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 0554c48..ef76b70 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -119,9 +119,15 @@ static ext4_fsblk_t ext4_ext_find_goal(struct inode *inode,
 
 		/* try to predict block placement */
 		ex = path[depth].p_ext;
-		if (ex)
-			return (ext4_ext_pblock(ex) +
-				(block - le32_to_cpu(ex->ee_block)));
+		if (ex) {
+			ext4_fsblk_t ext_pblk = ext4_ext_pblock(ex);
+			ext4_lblk_t ext_block = le32_to_cpu(ex->ee_block);
+
+			if (block > ext_block)
+				return (ext_pblk + (block - ext_block));
+			else
+				return (ext_pblk - (ext_block - block));
+		}
 
 		/* it looks like index is empty;
 		 * try to find starting block from index itself */
