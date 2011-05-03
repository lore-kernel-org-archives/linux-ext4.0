From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 16/19] ext4: enable mounting bigalloc as read/write
Date: Tue,  3 May 2011 18:24:46 -0400
Message-ID: <1304461490-11056-17-git-send-email-tytso@mit.edu>
References: <1304461490-11056-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58139 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823Ab1ECWY5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 May 2011 18:24:57 -0400
In-Reply-To: <1304461490-11056-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Now that we have implemented all of the changes needed for bigalloc,
we can finally enable it!

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ext4.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 57e7255..c7d3eea 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1401,7 +1401,8 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK | \
 					 EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE | \
 					 EXT4_FEATURE_RO_COMPAT_BTREE_DIR |\
-					 EXT4_FEATURE_RO_COMPAT_HUGE_FILE)
+					 EXT4_FEATURE_RO_COMPAT_HUGE_FILE |\
+					 EXT4_FEATURE_RO_COMPAT_BIGALLOC)
 
 /*
  * Default values for user and/or group using reserved blocks
-- 
1.7.3.1

