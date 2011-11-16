From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 1/2] dumpe2fs: dump blocks count used by super and GDT
Date: Wed, 16 Nov 2011 09:02:07 +0800
Message-ID: <1321405328-5298-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47395 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756818Ab1KPD3L (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Nov 2011 22:29:11 -0500
Received: by iage36 with SMTP id e36so7620iag.19
        for <linux-ext4@vger.kernel.org>; Tue, 15 Nov 2011 19:29:10 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Blocks count used by super and GDT is dumped so that users
can know how many blocks are taken up by super and GDT.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 misc/dumpe2fs.c |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index 5b114e9..2f9e87b 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -489,6 +489,32 @@ static void parse_extended_opts(const char *opts, blk64_t *superblock,
 	free(buf);
 }
 
+void print_super_gdt_blocks_count (ext2_filsys fs) {
+	blk64_t gdt_blks = 0, super_blks = 0;
+	blk64_t	super_blk, old_desc_blk, new_desc_blk;
+	blk64_t old_desc_blocks;
+	unsigned int grp;
+
+	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
+		old_desc_blocks = fs->super->s_first_meta_bg;
+	else
+		old_desc_blocks = fs->desc_blocks;
+
+	for (grp = 0; grp < fs->group_desc_count; grp++) {
+		ext2fs_super_and_bgd_loc2(fs, grp, &super_blk,
+					  &old_desc_blk, &new_desc_blk, 0);
+		if (old_desc_blk)
+			gdt_blks += old_desc_blocks + 
+				    fs->super->s_reserved_gdt_blocks;
+		else if (new_desc_blk)
+			gdt_blks++;
+		super_blks += ((grp == 0) || super_blk);
+	}
+	printf("\nSuper blocks:             %llu\n", super_blks);
+	printf("GDT   blocks:             %llu\n", gdt_blks);
+}
+
+
 int main (int argc, char ** argv)
 {
 	errcode_t	retval;
@@ -588,6 +614,12 @@ int main (int argc, char ** argv)
 		     EXT3_FEATURE_COMPAT_HAS_JOURNAL) &&
 		    (fs->super->s_journal_inum != 0))
 			print_inline_journal_information(fs);
+
+		/*
+		 * Print block used by super and group descriptors.
+		 */
+		print_super_gdt_blocks_count(fs);
+
 		list_bad_blocks(fs, 0);
 		if (header_only) {
 			ext2fs_close (fs);
-- 
1.7.5.1

