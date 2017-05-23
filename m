From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH] ext4: fix quota charging for shared xattr blocks
Date: Mon, 22 May 2017 20:01:48 -0700
Message-ID: <20170523030148.24361-1-tahsin@google.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tahsin Erdogan <tahsin@google.com>
To: Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

ext4_xattr_block_set() calls dquot_alloc_block() to charge for an xattr
block when new references are made. However if dquot_initialize() hasn't
been called on an inode, request for charging is effectively ignored
because ext4_inode_info->i_dquot is not initialized yet.

Add dquot_initialize() call to ext4_xattr_set_handle().

Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
 fs/ext4/xattr.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 8fb7ce14e6eb..e94575448550 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1166,6 +1166,11 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 		return -EINVAL;
 	if (strlen(name) > 255)
 		return -ERANGE;
+
+	error = dquot_initialize(inode);
+	if (error)
+		return error;
+
 	ext4_write_lock_xattr(inode, &no_expand);
 
 	error = ext4_reserve_inode_write(handle, inode, &is.iloc);
-- 
2.13.0.219.gdb65acc882-goog
