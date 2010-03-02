From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 08/28] ext4: Reserve INCOMPAT_EA_INODE and INCOMPAT_DIRDATA feature codepoints
Date: Tue,  2 Mar 2010 13:18:25 -0500
Message-ID: <1267553925-6308-9-git-send-email-tytso@mit.edu>
References: <1267553925-6308-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:43018 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250Ab0CBSSu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Mar 2010 13:18:50 -0500
In-Reply-To: <1267553925-6308-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ext4.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index ffe1334..61cf3b3 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -284,6 +284,7 @@ struct flex_groups {
 #define EXT4_TOPDIR_FL			0x00020000 /* Top of directory hierarchies*/
 #define EXT4_HUGE_FILE_FL               0x00040000 /* Set to each huge file */
 #define EXT4_EXTENTS_FL			0x00080000 /* Inode uses extents */
+#define EXT4_EA_INODE_FL	        0x00200000 /* Inode used for large EA */
 #define EXT4_RESERVED_FL		0x80000000 /* reserved for ext4 lib */
 
 #define EXT4_FL_USER_VISIBLE		0x000BDFFF /* User visible flags */
@@ -1144,6 +1145,8 @@ static inline void ext4_clear_inode_state(struct inode *inode, int bit)
 #define EXT4_FEATURE_INCOMPAT_64BIT		0x0080
 #define EXT4_FEATURE_INCOMPAT_MMP               0x0100
 #define EXT4_FEATURE_INCOMPAT_FLEX_BG		0x0200
+#define EXT4_FEATURE_INCOMPAT_EA_INODE		0x0400 /* EA in inode */
+#define EXT4_FEATURE_INCOMPAT_DIRDATA		0x1000 /* data in dirent */
 
 #define EXT4_FEATURE_COMPAT_SUPP	EXT2_FEATURE_COMPAT_EXT_ATTR
 #define EXT4_FEATURE_INCOMPAT_SUPP	(EXT4_FEATURE_INCOMPAT_FILETYPE| \
-- 
1.6.6.1.1.g974db.dirty

