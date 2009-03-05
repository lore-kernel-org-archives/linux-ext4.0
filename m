From: Theodore Ts'o <tytso@mit.edu>
Subject: [STABLE, 2.6.28.y] ext4: Add fallback for find_group_flex
Date: Thu,  5 Mar 2009 02:35:14 -0500
Message-ID: <1236238515-8479-1-git-send-email-tytso@mit.edu>
References: <1235495688-8044-8-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59134 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841AbZCEHfU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Mar 2009 02:35:20 -0500
In-Reply-To: <1235495688-8044-8-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a workaround for find_group_flex() which badly needs to be
replaced.  One of its problems (besides ignoring the Orlov algorithm)
is that it is a bit hyperactive about returning failure under
suspicious circumstances.  This can lead to spurious ENOSPC failures
even when there are inodes still available.

Work around this for now by retrying the search using
find_group_other() if find_group_flex() returns -1.  If
find_group_other() succeeds when find_group_flex() has failed, log a
warning message.

A better block/inode allocator that will fix this problem for real has
been queued up for the next merge window.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
(cherry picked from commit 05bf9e839d9de4e8a094274a0a2fd07beb47eaf1)
---
 fs/ext4/ialloc.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index b363c49..03c0819 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -703,6 +703,13 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode *dir, int mode)
 
 	if (sbi->s_log_groups_per_flex) {
 		ret2 = find_group_flex(sb, dir, &group);
+		if (ret2 == -1) {
+			ret2 = find_group_other(sb, dir, &group);
+			if (ret2 == 0 && printk_ratelimit())
+				printk(KERN_NOTICE "ext4: find_group_flex "
+				       "failed, fallback succeeded dir %lu\n",
+				       dir->i_ino);
+		}
 		goto got_group;
 	}
 
-- 
1.5.6.3

