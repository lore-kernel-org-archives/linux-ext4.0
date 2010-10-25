From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/4] ext4: Add batched discard support for ext4
Date: Mon, 25 Oct 2010 15:08:41 -0400
Message-ID: <20101025190840.GI16981@thunk.org>
References: <1285596600-28358-1-git-send-email-lczerner@redhat.com>
 <1285596600-28358-4-git-send-email-lczerner@redhat.com>
 <20101025185010.GH16981@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, rwheeler@redhat.com,
	sandeen@redhat.com, adilger@dilger.ca,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:37441 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932889Ab0JYTIn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Oct 2010 15:08:43 -0400
Content-Disposition: inline
In-Reply-To: <20101025185010.GH16981@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The following diff (against this patch) allows the ext4 tree to build
on 32-bit x86.  I'm still not entirely convinced the right thing
happens when start+len goes beyond the end of the file system....

	     	       	    	   - Ted

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 8cbef43..e3bcc06 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4761,7 +4761,6 @@ ext4_grpblk_t ext4_trim_all_free(struct super_block *sb, struct ext4_buddy *e4b,
 	ext4_lock_group(sb, group);
 
 	while (start < max) {
-
 		start = mb_find_next_zero_bit(bitmap, max, start);
 		if (start >= max)
 			break;
@@ -4816,10 +4815,9 @@ ext4_grpblk_t ext4_trim_all_free(struct super_block *sb, struct ext4_buddy *e4b,
 int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 {
 	struct ext4_buddy e4b;
-	ext4_fsblk_t first_group, last_group;
+	ext4_group_t first_group, last_group;
 	ext4_group_t group, ngroups = ext4_get_groups_count(sb);
 	ext4_grpblk_t cnt = 0, first_block, last_block;
-	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
 	uint64_t start, len, minlen, trimmed;
 	int ret = 0;
 
@@ -4832,21 +4830,17 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 		return -EINVAL;
 
 	/* Determine first and last group to examine based on start and len */
-	first_group = (start - le32_to_cpu(es->s_first_data_block)) /
-		      EXT4_BLOCKS_PER_GROUP(sb);
-	last_group = (start + len - le32_to_cpu(es->s_first_data_block)) /
-		     EXT4_BLOCKS_PER_GROUP(sb);
+	ext4_get_group_no_and_offset(sb, (ext4_fsblk_t) start,
+				     &first_group, &first_block);
+	ext4_get_group_no_and_offset(sb, (ext4_fsblk_t) (start + len),
+				     &last_group, &last_block);
 	last_group = (last_group > ngroups - 1) ? ngroups - 1 : last_group;
+	last_block = EXT4_BLOCKS_PER_GROUP(sb);
 
 	if (first_group > last_group)
 		return -EINVAL;
 
-	first_block = (start - le32_to_cpu(es->s_first_data_block)) %
-			EXT4_BLOCKS_PER_GROUP(sb);
-	last_block = EXT4_BLOCKS_PER_GROUP(sb);
-
 	for (group = first_group; group <= last_group; group++) {
