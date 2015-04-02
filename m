From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 05/22] ext4 crypto: add encryption xattr support
Date: Thu,  2 Apr 2015 18:10:42 -0400
Message-ID: <1428012659-12709-6-git-send-email-tytso@mit.edu>
References: <1428012659-12709-1-git-send-email-tytso@mit.edu>
Cc: jaegeuk@kernel.org, mhalcrow@google.com,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47979 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340AbbDBWMe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Apr 2015 18:12:34 -0400
In-Reply-To: <1428012659-12709-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Michael Halcrow <mhalcrow@google.com>

Change-Id: Icec301ab73c83e647c184f3b33aa0be76228dfcc
Signed-off-by: Michael Halcrow <mhalcrow@google.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/xattr.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index 29bedf5..ddc0957 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -23,6 +23,7 @@
 #define EXT4_XATTR_INDEX_SECURITY	        6
 #define EXT4_XATTR_INDEX_SYSTEM			7
 #define EXT4_XATTR_INDEX_RICHACL		8
+#define EXT4_XATTR_INDEX_ENCRYPTION		9
 
 struct ext4_xattr_header {
 	__le32	h_magic;	/* magic number for identification */
@@ -98,6 +99,8 @@ extern const struct xattr_handler ext4_xattr_user_handler;
 extern const struct xattr_handler ext4_xattr_trusted_handler;
 extern const struct xattr_handler ext4_xattr_security_handler;
 
+#define EXT4_XATTR_NAME_ENCRYPTION_CONTEXT "c"
+
 extern ssize_t ext4_listxattr(struct dentry *, char *, size_t);
 
 extern int ext4_xattr_get(struct inode *, int, const char *, void *, size_t);
-- 
2.3.0

