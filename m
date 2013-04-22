From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: fix online resizing for ext3-compat file systems
Date: Sun, 21 Apr 2013 20:06:02 -0400
Message-ID: <1366589162-28527-1-git-send-email-tytso@mit.edu>
References: <20130421233057.GA5625@thunk.org>
Cc: sandeen@redhat.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43309 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817Ab3DVAGI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Apr 2013 20:06:08 -0400
In-Reply-To: <20130421233057.GA5625@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit fb0a387dcdc restricts block allocations for indirect-mapped
files to block groups less than s_blockfile_groups.  However, the
online resizing code wasn't setting s_blockfile_groups, so the newly
added block groups were not available for non-extent mapped files.

Reported-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/resize.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index e349853..08d2312 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1341,6 +1341,8 @@ static void ext4_update_super(struct super_block *sb,
 
 	/* Update the global fs size fields */
 	sbi->s_groups_count += flex_gd->count;
+	sbi->s_blockfile_groups = min_t(ext4_group_t, sbi->s_groups_count,
+			(EXT4_MAX_BLOCK_FILE_PHYS / EXT4_BLOCKS_PER_GROUP(sb)));
 
 	/* Update the reserved block counts only once the new group is
 	 * active. */
-- 
1.7.12.rc0.22.gcdd159b

