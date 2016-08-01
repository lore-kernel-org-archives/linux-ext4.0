From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Open bugs found by fuzzing as of 2016-07-30
Date: Mon, 1 Aug 2016 00:55:21 -0400
Message-ID: <20160801045521.GF12853@thunk.org>
References: <579CA5EB.1070707@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Vegard Nossum <vegard.nossum@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33310 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbcHAFi3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Aug 2016 01:38:29 -0400
Content-Disposition: inline
In-Reply-To: <579CA5EB.1070707@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jul 30, 2016 at 03:04:43PM +0200, Vegard Nossum wrote:
> Hi,
> 
> It's been two weeks since I posted the first list of bugs found using
> AFL: https://www.spinics.net/lists/linux-ext4/msg53022.html
> 
> With a bunch of ext4 patches going into 4.8 we're down from 15 to 6
> with current linus/master...

Does this patch bring things down further?  I expect it should at the
very list address

> 6. WARNING: CPU: 0 PID: 58 at fs/ext4/ext4.h:2748
> ext4_block_bitmap_csum_set+0x358/0x600
> http://139.162.151.198/f/ext4/9628c19aff0bbaaae4149a03486305c7f6cd7523

... and possibly others.

If there are any remaining of these bugs where the superblock is
sufficiently corrupt that dumpe2fs refuses to print anything, could
you print a hex dump of the superblock (located at offset 1024) so we
could see what is going on?

					- Ted

commit 0a8bffdacb178a43a1be61270f22517de76ee8f8
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Mon Aug 1 00:51:02 2016 -0400

    ext4: validate that metadata blocks do not overlap superblock
    
    A number of fuzzing failures seem to be caused by allocation bitmaps
    or other metadata blocks being pointed at the superblock.
    
    This can cause kernel BUG or WARNings once the superblock is
    overwritten, so validate the group descriptor blocks to make sure this
    doesn't happen.
    
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e2622ba..2942fda 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2211,6 +2211,7 @@ void ext4_group_desc_csum_set(struct super_block *sb, __u32 block_group,
 
 /* Called at mount-time, super-block is locked */
 static int ext4_check_descriptors(struct super_block *sb,
+				  ext4_fsblk_t sb_block,
 				  ext4_group_t *first_not_zeroed)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
@@ -2241,6 +2242,11 @@ static int ext4_check_descriptors(struct super_block *sb,
 			grp = i;
 
 		block_bitmap = ext4_block_bitmap(sb, gdp);
+		if (block_bitmap == sb_block) {
+			ext4_msg(sb, KERN_ERR, "ext4_check_descriptors: "
+				 "Block bitmap for group %u overlaps "
+				 "superblock", i);
+		}
 		if (block_bitmap < first_block || block_bitmap > last_block) {
 			ext4_msg(sb, KERN_ERR, "ext4_check_descriptors: "
 			       "Block bitmap for group %u not in group "
@@ -2248,6 +2254,11 @@ static int ext4_check_descriptors(struct super_block *sb,
 			return 0;
 		}
 		inode_bitmap = ext4_inode_bitmap(sb, gdp);
+		if (inode_bitmap == sb_block) {
+			ext4_msg(sb, KERN_ERR, "ext4_check_descriptors: "
+				 "Inode bitmap for group %u overlaps "
+				 "superblock", i);
+		}
 		if (inode_bitmap < first_block || inode_bitmap > last_block) {
 			ext4_msg(sb, KERN_ERR, "ext4_check_descriptors: "
 			       "Inode bitmap for group %u not in group "
@@ -2255,6 +2266,11 @@ static int ext4_check_descriptors(struct super_block *sb,
 			return 0;
 		}
 		inode_table = ext4_inode_table(sb, gdp);
+		if (inode_table == sb_block) {
+			ext4_msg(sb, KERN_ERR, "ext4_check_descriptors: "
+				 "Inode table for group %u overlaps "
+				 "superblock", i);
+		}
 		if (inode_table < first_block ||
 		    inode_table + sbi->s_itb_per_group - 1 > last_block) {
 			ext4_msg(sb, KERN_ERR, "ext4_check_descriptors: "
@@ -3757,7 +3773,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 			goto failed_mount2;
 		}
 	}
-	if (!ext4_check_descriptors(sb, &first_not_zeroed)) {
+	if (!ext4_check_descriptors(sb, logical_sb_block, &first_not_zeroed)) {
 		ext4_msg(sb, KERN_ERR, "group descriptors corrupted!");
 		ret = -EFSCORRUPTED;
 		goto failed_mount2;
