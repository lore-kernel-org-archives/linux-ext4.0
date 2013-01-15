From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/5] mke2fs: the -g option will now specify the clusters per block group
Date: Mon, 14 Jan 2013 19:37:09 -0500
Message-ID: <1358210232-30578-2-git-send-email-tytso@mit.edu>
References: <20130114211014.GA22642@thunk.org>
 <1358210232-30578-1-git-send-email-tytso@mit.edu>
Cc: gnehzuil.liu@gmail.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43387 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756501Ab3AOAhT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Jan 2013 19:37:19 -0500
In-Reply-To: <1358210232-30578-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If bigalloc is enabled, then -g will specify the clusters per block
group.  (If bigalloc is not enabled, then a cluster == a block, so the
meaning of -g is not changed.)

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/mke2fs.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 75d0e48..5cb49b3 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1962,6 +1962,15 @@ profile_error:
 		}
 	}
 
+	/*
+	 * If the bigalloc feature is enabled, then the -g option will
+	 * specify the number of clusters per group.
+	 */
+	if (fs_param.s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_BIGALLOC) {
+		fs_param.s_clusters_per_group = fs_param.s_blocks_per_group;
+		fs_param.s_blocks_per_group = 0;
+	}
+
 	if (inode_size == 0)
 		inode_size = get_int_from_profile(fs_types, "inode_size", 0);
 	if (!flex_bg_size && (fs_param.s_feature_incompat &
-- 
1.7.12.rc0.22.gcdd159b

