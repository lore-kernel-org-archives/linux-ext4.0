From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH 2/3] ext4: don't read out of bounds when checking for in-inode xattrs
Date: Sat, 26 Nov 2016 22:39:45 -0800
Message-ID: <1480228786-106775-2-git-send-email-ebiggers@google.com>
References: <1480228786-106775-1-git-send-email-ebiggers@google.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Eric Biggers <ebiggers@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f50.google.com ([74.125.83.50]:35307 "EHLO
        mail-pg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751542AbcK0GlE (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Nov 2016 01:41:04 -0500
Received: by mail-pg0-f50.google.com with SMTP id p66so44541041pga.2
        for <linux-ext4@vger.kernel.org>; Sat, 26 Nov 2016 22:41:03 -0800 (PST)
In-Reply-To: <1480228786-106775-1-git-send-email-ebiggers@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

With i_extra_isize equal to or close to the available space, it was
possible for us to read past the end of the inode when trying to detect
or validate in-inode xattrs.  Fix this by checking for the needed extra
space first.

This patch shouldn't have any noticeable effect on
non-corrupted/non-malicious filesystems.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/inode.c | 4 +++-
 fs/ext4/xattr.c | 5 ++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index bc99ebe..e52f41a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4519,7 +4519,9 @@ static inline void ext4_iget_extra_inode(struct inode *inode,
 {
 	__le32 *magic = (void *)raw_inode +
 			EXT4_GOOD_OLD_INODE_SIZE + ei->i_extra_isize;
-	if (*magic == cpu_to_le32(EXT4_XATTR_MAGIC)) {
+	if (EXT4_GOOD_OLD_INODE_SIZE + ei->i_extra_isize + sizeof(__le32)
+			<= EXT4_INODE_SIZE(inode->i_sb) &&
+	    *magic == cpu_to_le32(EXT4_XATTR_MAGIC)) {
 		ext4_set_inode_state(inode, EXT4_STATE_XATTR);
 		ext4_find_inline_data_nolock(inode);
 	} else
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 1846e91..59c9ec7 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -231,13 +231,12 @@ static int
 __xattr_check_inode(struct inode *inode, struct ext4_xattr_ibody_header *header,
 			 void *end, const char *function, unsigned int line)
 {
-	struct ext4_xattr_entry *entry = IFIRST(header);
 	int error = -EFSCORRUPTED;
 
-	if (((void *) header >= end) ||
+	if (end - (void *)header < sizeof(*header) + sizeof(u32) ||
 	    (header->h_magic != cpu_to_le32(EXT4_XATTR_MAGIC)))
 		goto errout;
-	error = ext4_xattr_check_names(entry, end, entry);
+	error = ext4_xattr_check_names(IFIRST(header), end, IFIRST(header));
 errout:
 	if (error)
 		__ext4_error_inode(inode, function, line, 0,
-- 
2.8.0.rc3.226.g39d4020

