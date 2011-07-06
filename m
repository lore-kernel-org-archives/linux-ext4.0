From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 17/23] ext4: enable mounting bigalloc as read/write
Date: Wed,  6 Jul 2011 12:36:00 -0400
Message-ID: <1309970166-11770-18-git-send-email-tytso@mit.edu>
References: <1309970166-11770-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33456 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754742Ab1GFQgJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Jul 2011 12:36:09 -0400
In-Reply-To: <1309970166-11770-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Now that we have implemented all of the changes needed for bigalloc,
we can finally enable it!

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ext4.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 78ac8ed..d79e773 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1424,7 +1424,8 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK | \
 					 EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE | \
 					 EXT4_FEATURE_RO_COMPAT_BTREE_DIR |\
-					 EXT4_FEATURE_RO_COMPAT_HUGE_FILE)
+					 EXT4_FEATURE_RO_COMPAT_HUGE_FILE |\
+					 EXT4_FEATURE_RO_COMPAT_BIGALLOC)
 
 /*
  * Default values for user and/or group using reserved blocks
-- 
1.7.4.1.22.gec8e1.dirty

