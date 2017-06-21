From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH 22/32] ext4: move struct ext4_xattr_inode_array to xattr.h
Date: Wed, 21 Jun 2017 14:21:32 -0700
Message-ID: <20170621212142.16581-22-tahsin@google.com>
References: <20170621212142.16581-1-tahsin@google.com>
Cc: linux-kernel@vger.kernel.org, Tahsin Erdogan <tahsin@google.com>
To: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
        linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170621212142.16581-1-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Since this is a xattr specific data structure it is cleaner to keep it in
xattr header file.

Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
 fs/ext4/ext4.h  | 4 ----
 fs/ext4/xattr.h | 5 +++++
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 603edb5ff304..580fdb753f29 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2232,10 +2232,6 @@ struct mmpd_data {
 # define ATTRIB_NORET	__attribute__((noreturn))
 # define NORET_AND	noreturn,
 
-struct ext4_xattr_inode_array {
-	unsigned int count;		/* # of used items in the array */
-	struct inode *inodes[0];
-};
 /* bitmap.c */
 extern unsigned int ext4_count_free(char *bitmap, unsigned numchars);
 void ext4_inode_bitmap_csum_set(struct super_block *sb, ext4_group_t group,
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index 323eba54f72f..adf761518a73 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -117,6 +117,11 @@ struct ext4_xattr_ibody_find {
 	struct ext4_iloc iloc;
 };
 
+struct ext4_xattr_inode_array {
+	unsigned int count;		/* # of used items in the array */
+	struct inode *inodes[0];
+};
+
 extern const struct xattr_handler ext4_xattr_user_handler;
 extern const struct xattr_handler ext4_xattr_trusted_handler;
 extern const struct xattr_handler ext4_xattr_security_handler;
-- 
2.13.1.611.g7e3b11ae1-goog
