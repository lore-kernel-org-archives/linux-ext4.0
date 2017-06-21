From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH 06/32] ext4: ea_inode owner should be the same as the inode owner
Date: Wed, 21 Jun 2017 14:21:16 -0700
Message-ID: <20170621212142.16581-6-tahsin@google.com>
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

Quota charging is based on the ownership of the inode. Currently, the
xattr inode owner is set to the caller which may be different from the
parent inode owner. This is inconsistent with how quota is charged for
xattr block and regular data block writes.

Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
 fs/ext4/xattr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 8e123533315f..32ad2f2870e9 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -826,6 +826,7 @@ static struct inode *ext4_xattr_inode_create(handle_t *handle,
 					     struct inode *inode)
 {
 	struct inode *ea_inode = NULL;
+	uid_t owner[2] = { i_uid_read(inode), i_gid_read(inode) };
 	int err;
 
 	/*
@@ -833,7 +834,7 @@ static struct inode *ext4_xattr_inode_create(handle_t *handle,
 	 * in the same group, or nearby one.
 	 */
 	ea_inode = ext4_new_inode(handle, inode->i_sb->s_root->d_inode,
-				  S_IFREG | 0600, NULL, inode->i_ino + 1, NULL,
+				  S_IFREG | 0600, NULL, inode->i_ino + 1, owner,
 				  EXT4_EA_INODE_FL);
 	if (!IS_ERR(ea_inode)) {
 		ea_inode->i_op = &ext4_file_inode_operations;
-- 
2.13.1.611.g7e3b11ae1-goog
