From: Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH] ext4: fix printk format warnings
Date: Sun, 22 Oct 2006 20:23:35 -0700
Message-ID: <20061022202335.ab86073b.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: akpm <akpm@osdl.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:19856 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S1751324AbWJWDV6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 Oct 2006 23:21:58 -0400
Received: from midway.site ([71.117.236.95]) by xenotime.net for <linux-ext4@vger.kernel.org>; Sun, 22 Oct 2006 20:21:55 -0700
To: linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix ext4 printk format warnings:
fs/ext4/resize.c:72: warning: long long unsigned int format, __u64 arg (arg 4)
fs/ext4/resize.c:76: warning: long long unsigned int format, __u64 arg (arg 4)
fs/ext4/resize.c:81: warning: long long unsigned int format, __u64 arg (arg 4)
fs/ext4/resize.c:85: warning: long long unsigned int format, __u64 arg (arg 4)
fs/ext4/resize.c:89: warning: long long unsigned int format, __u64 arg (arg 4)
fs/ext4/resize.c:89: warning: long long unsigned int format, __u64 arg (arg 5)
fs/ext4/resize.c:93: warning: long long unsigned int format, __u64 arg (arg 4)
fs/ext4/resize.c:93: warning: long long unsigned int format, __u64 arg (arg 5)
fs/ext4/resize.c:98: warning: long long unsigned int format, __u64 arg (arg 4)
fs/ext4/resize.c:103: warning: long long unsigned int format, __u64 arg (arg 4)
fs/ext4/resize.c:109: warning: long long unsigned int format, __u64 arg (arg 4)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---

 fs/ext4/resize.c |   23 ++++++++++++++---------
 1 files changed, 14 insertions(+), 9 deletions(-)

diff -Naurp linux-2619-rc2g4/fs/ext4/resize.c~ext4_printk linux-2619-rc2g4/fs/ext4/resize.c
--- linux-2619-rc2g4/fs/ext4/resize.c~ext4_printk	2006-10-20 17:38:30.834843000 -0700
+++ linux-2619-rc2g4/fs/ext4/resize.c	2006-10-22 20:17:37.490397000 -0700
@@ -69,44 +69,49 @@ static int verify_group_input(struct sup
 	else if (outside(input->block_bitmap, start, end))
 		ext4_warning(sb, __FUNCTION__,
 			     "Block bitmap not in group (block %llu)",
-			     input->block_bitmap);
+			     (unsigned long long)input->block_bitmap);
 	else if (outside(input->inode_bitmap, start, end))
 		ext4_warning(sb, __FUNCTION__,
 			     "Inode bitmap not in group (block %llu)",
-			     input->inode_bitmap);
+			     (unsigned long long)input->inode_bitmap);
 	else if (outside(input->inode_table, start, end) ||
 	         outside(itend - 1, start, end))
 		ext4_warning(sb, __FUNCTION__,
 			     "Inode table not in group (blocks %llu-%llu)",
-			     input->inode_table, itend - 1);
+			     (unsigned long long)input->inode_table, itend - 1);
 	else if (input->inode_bitmap == input->block_bitmap)
 		ext4_warning(sb, __FUNCTION__,
 			     "Block bitmap same as inode bitmap (%llu)",
-			     input->block_bitmap);
+			     (unsigned long long)input->block_bitmap);
 	else if (inside(input->block_bitmap, input->inode_table, itend))
 		ext4_warning(sb, __FUNCTION__,
 			     "Block bitmap (%llu) in inode table (%llu-%llu)",
-			     input->block_bitmap, input->inode_table, itend-1);
+			     (unsigned long long)input->block_bitmap,
+			     (unsigned long long)input->inode_table, itend - 1);
 	else if (inside(input->inode_bitmap, input->inode_table, itend))
 		ext4_warning(sb, __FUNCTION__,
 			     "Inode bitmap (%llu) in inode table (%llu-%llu)",
-			     input->inode_bitmap, input->inode_table, itend-1);
+			     (unsigned long long)input->inode_bitmap,
+			     (unsigned long long)input->inode_table, itend - 1);
 	else if (inside(input->block_bitmap, start, metaend))
 		ext4_warning(sb, __FUNCTION__,
 			     "Block bitmap (%llu) in GDT table"
 			     " (%llu-%llu)",
-			     input->block_bitmap, start, metaend - 1);
+			     (unsigned long long)input->block_bitmap,
+			     start, metaend - 1);
 	else if (inside(input->inode_bitmap, start, metaend))
 		ext4_warning(sb, __FUNCTION__,
 			     "Inode bitmap (%llu) in GDT table"
 			     " (%llu-%llu)",
-			     input->inode_bitmap, start, metaend - 1);
+			     (unsigned long long)input->inode_bitmap,
+			     start, metaend - 1);
 	else if (inside(input->inode_table, start, metaend) ||
 	         inside(itend - 1, start, metaend))
 		ext4_warning(sb, __FUNCTION__,
 			     "Inode table (%llu-%llu) overlaps"
 			     "GDT table (%llu-%llu)",
-			     input->inode_table, itend - 1, start, metaend - 1);
+			     (unsigned long long)input->inode_table,
+			     itend - 1, start, metaend - 1);
 	else
 		err = 0;
 	brelse(bh);


---
