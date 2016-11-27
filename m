From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH 3/3] ext4: correctly detect when an xattr value has an invalid size
Date: Sat, 26 Nov 2016 22:39:46 -0800
Message-ID: <1480228786-106775-3-git-send-email-ebiggers@google.com>
References: <1480228786-106775-1-git-send-email-ebiggers@google.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Eric Biggers <ebiggers@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f46.google.com ([74.125.83.46]:34620 "EHLO
        mail-pg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751546AbcK0GlG (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Nov 2016 01:41:06 -0500
Received: by mail-pg0-f46.google.com with SMTP id x23so44556902pgx.1
        for <linux-ext4@vger.kernel.org>; Sat, 26 Nov 2016 22:41:06 -0800 (PST)
In-Reply-To: <1480228786-106775-1-git-send-email-ebiggers@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It was possible for an xattr value to have a very large size, which
would then pass validation on 32-bit architectures due to a pointer
wraparound.  Fix this by validating the size in a way which avoids
pointer wraparound.

It was also possible that a value's size would fit in the available
space but its padded size would not.  This would cause an out-of-bounds
memory write in ext4_xattr_set_entry when replacing the xattr value.
For example, if an xattr value of unpadded size 253 bytes went until the
very end of the inode or block, then using setxattr(2) to replace this
xattr's value with 256 bytes would cause a write to the 3 bytes past the
end of the inode or buffer, and the new xattr value would be incorrectly
truncated.  Fix this by requiring that the padded size fit in the
available space rather than the unpadded size.

This patch shouldn't have any noticeable effect on
non-corrupted/non-malicious filesystems.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/xattr.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 59c9ec7..5a94fa52 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -185,6 +185,7 @@ ext4_xattr_check_names(struct ext4_xattr_entry *entry, void *end,
 {
 	struct ext4_xattr_entry *e = entry;
 
+	/* Find the end of the names list */
 	while (!IS_LAST_ENTRY(e)) {
 		struct ext4_xattr_entry *next = EXT4_XATTR_NEXT(e);
 		if ((void *)next >= end)
@@ -192,15 +193,29 @@ ext4_xattr_check_names(struct ext4_xattr_entry *entry, void *end,
 		e = next;
 	}
 
+	/* Check the values */
 	while (!IS_LAST_ENTRY(entry)) {
 		if (entry->e_value_block != 0)
 			return -EFSCORRUPTED;
-		if (entry->e_value_size != 0 &&
-		    (value_start + le16_to_cpu(entry->e_value_offs) <
-		     (void *)e + sizeof(__u32) ||
-		     value_start + le16_to_cpu(entry->e_value_offs) +
-		    le32_to_cpu(entry->e_value_size) > end))
-			return -EFSCORRUPTED;
+		if (entry->e_value_size != 0) {
+			u16 offs = le16_to_cpu(entry->e_value_offs);
+			u32 size = le32_to_cpu(entry->e_value_size);
+			void *value;
+
+			/*
+			 * The value cannot overlap the names, and the value
+			 * with padding cannot extend beyond 'end'.  Check both
+			 * the padded and unpadded sizes, since the size may
+			 * overflow to 0 when adding padding.
+			 */
+			if (offs > end - value_start)
+				return -EFSCORRUPTED;
+			value = value_start + offs;
+			if (value < (void *)e + sizeof(u32) ||
+			    size > end - value ||
+			    EXT4_XATTR_SIZE(size) > end - value)
+				return -EFSCORRUPTED;
+		}
 		entry = EXT4_XATTR_NEXT(entry);
 	}
 
-- 
2.8.0.rc3.226.g39d4020

