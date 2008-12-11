From: "Duane Griffin" <duaneg@dghda.com>
Subject: [PATCH] ext2: ensure link targets are NULL-terminated
Date: Thu, 11 Dec 2008 19:16:28 +0000
Message-ID: <1229022995-9898-5-git-send-email-duaneg@dghda.com>
References: <1229022995-9898-1-git-send-email-duaneg@dghda.com>
 <1229022995-9898-2-git-send-email-duaneg@dghda.com>
 <1229022995-9898-3-git-send-email-duaneg@dghda.com>
 <1229022995-9898-4-git-send-email-duaneg@dghda.com>
Cc: linux-fsdevel@vger.kernel.org, Boaz Harrosh <bharrosh@panasas.com>,
	Duane Griffin <duaneg@dghda.com>, linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kumera.dghda.com ([80.68.90.171]:39574 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756945AbYLKTQu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Dec 2008 14:16:50 -0500
In-Reply-To: <1229022995-9898-4-git-send-email-duaneg@dghda.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ensure link targets are NULL-terminated, even if corrupted on-disk.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
---
 fs/ext2/symlink.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/ext2/symlink.c b/fs/ext2/symlink.c
index 4e2426e..9b164ba 100644
--- a/fs/ext2/symlink.c
+++ b/fs/ext2/symlink.c
@@ -24,7 +24,9 @@
 static void *ext2_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
 	struct ext2_inode_info *ei = EXT2_I(dentry->d_inode);
-	nd_set_link(nd, (char *)ei->i_data);
+	char *link = (char *) ei->i_data;
+	link[sizeof(ei->i_data) - 1] = '\0';
+	nd_set_link(nd, link);
 	return NULL;
 }
 
-- 
1.6.0.4

