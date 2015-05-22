From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] misc: fix alignment warnings on ARM
Date: Fri, 22 May 2015 16:40:51 -0600
Message-ID: <1432334451-15863-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-05.shaw.ca ([64.59.134.13]:38583 "EHLO
	smtp-out-05.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756946AbbEVWtB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 May 2015 18:49:01 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Some temporary char buffers allocated on the stack are not properly
aligned when typecast to a structure containing __u32 or __u64 types,
and this can cause alignment warnings on ARM and other alignment
sensitive architectures, and potential slowdowns to do fixups.

Fix the buffer alignment to avoid such issues.

Addresses: https://bugzilla.redhat.com/show_bug.cgi?id=680090

Reported-by: Gordan Bobic <gordan.bobic@gmail.com>
Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 misc/filefrag.c |    2 +-
 misc/tune2fs.c  |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/misc/filefrag.c b/misc/filefrag.c
index 3b104c6..46f1218 100644
--- a/misc/filefrag.c
+++ b/misc/filefrag.c
@@ -198,7 +198,7 @@ static void print_extent_info(struct fiemap_extent *fm_extent, int cur_ex,
 static int filefrag_fiemap(int fd, int blk_shift, int *num_extents,
 			   ext2fs_struct_stat *st)
 {
-	char buf[16384];
+	__u64 buf[2048];	/* __u64 for proper field alignment */
 	struct fiemap *fiemap = (struct fiemap *)buf;
 	struct fiemap_extent *fm_ext = &fiemap->fm_extents[0];
 	int count = (sizeof(buf) - sizeof(*fiemap)) /
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index d2e8b20..36c2ff7 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -240,7 +240,7 @@ static int remove_journal_device(ext2_filsys fs)
 {
 	char		*journal_path;
 	ext2_filsys	jfs;
-	char		buf[SUPERBLOCK_SIZE];
+	char		buf[SUPERBLOCK_SIZE] __attribute__ ((aligned(8)));
 	journal_superblock_t	*jsb;
 	int		i, nr_users;
 	errcode_t	retval;
@@ -2609,7 +2609,7 @@ fs_update_journal_user(struct ext2_super_block *sb, __u8 old_uuid[UUID_SIZE])
 	__u8 *j_uuid;
 	char *journal_path;
 	char uuid[UUID_STR_SIZE];
-	char buf[SUPERBLOCK_SIZE];
+	char buf[SUPERBLOCK_SIZE] __attribute__ ((aligned(8)));
 
 	if (!(sb->s_feature_compat & EXT3_FEATURE_COMPAT_HAS_JOURNAL) ||
 		uuid_is_null(sb->s_journal_uuid))
@@ -2964,7 +2964,7 @@ retry_open:
 	if (U_flag) {
 		int set_csum = 0;
 		dgrp_t i;
-		char buf[SUPERBLOCK_SIZE];
+		char buf[SUPERBLOCK_SIZE] __attribute__ ((aligned(8)));
 		__u8 old_uuid[UUID_SIZE];
 
 		if (ext2fs_has_group_desc_csum(fs)) {
-- 
1.7.3.4

