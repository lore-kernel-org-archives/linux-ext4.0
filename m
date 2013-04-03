From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/2] ext4: fix usless declarations
Date: Wed,  3 Apr 2013 14:58:30 +0400
Message-ID: <1364986711-3630-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, wenqing.lz@taobao.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:45323 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759004Ab3DCK66 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Apr 2013 06:58:58 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch should fix sparse complains about shadow declatations.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/ialloc.c      |    1 -
 fs/ext4/ioctl.c       |    1 -
 fs/ext4/mballoc.c     |    1 -
 fs/ext4/move_extent.c |    1 -
 4 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 6c5bb8d..4c358f7 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -899,7 +899,6 @@ got:
 	if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
 			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
 		__u32 csum;
-		struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 		__le32 inum = cpu_to_le32(inode->i_ino);
 		__le32 gen = cpu_to_le32(inode->i_generation);
 		csum = ext4_chksum(sbi, sbi->s_csum_seed, (__u8 *)&inum,
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index a07b7bc..fb4e77f 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -355,7 +355,6 @@ group_add_out:
 
 	case EXT4_IOC_RESIZE_FS: {
 		ext4_fsblk_t n_blocks_count;
-		struct super_block *sb = inode->i_sb;
 		int err = 0, err2 = 0;
 		ext4_group_t o_group = EXT4_SB(sb)->s_groups_count;
 
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 580aada..5bf8056 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -860,7 +860,6 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 
 	first_block = page->index * blocks_per_page;
 	for (i = 0; i < blocks_per_page; i++) {
-		int group;
 
 		group = (first_block + i) >> 1;
 		if (group >= ngroups)
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 33e1c08..7f3ed63 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -856,7 +856,6 @@ mext_page_mkuptodate(struct page *page, unsigned from, unsigned to)
 		if (buffer_uptodate(bh))
 			continue;
 		if (!buffer_mapped(bh)) {
-			int err = 0;
 			err = ext4_get_block(inode, block, bh, 0);
 			if (err) {
 				SetPageError(page);
-- 
1.7.1

