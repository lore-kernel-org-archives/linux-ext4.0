From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 7/7] mke2fs: only print the low-level file system stats in verbose mode
Date: Sat, 26 Apr 2014 20:00:34 -0400
Message-ID: <1398556834-31913-7-git-send-email-tytso@mit.edu>
References: <1398556834-31913-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34699 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbaD0AAm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Apr 2014 20:00:42 -0400
In-Reply-To: <1398556834-31913-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/mke2fs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 3694ce5..b274165 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -618,6 +618,9 @@ static void show_stats(ext2_filsys fs)
 	dgrp_t			i;
 	int			need, col_left;
 
+	if (!verbose)
+		goto skip_details;
+
 	if (ext2fs_blocks_count(&fs_param) != ext2fs_blocks_count(s))
 		fprintf(stderr, _("warning: %llu blocks unused.\n\n"),
 		       ext2fs_blocks_count(&fs_param) - ext2fs_blocks_count(s));
@@ -666,6 +669,7 @@ static void show_stats(ext2_filsys fs)
 		       s->s_blocks_per_group, s->s_clusters_per_group);
 	printf(_("%u inodes per group\n"), s->s_inodes_per_group);
 
+skip_details:
 	if (fs->group_desc_count == 1) {
 		printf("\n");
 		return;
-- 
1.9.0

