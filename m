From: Tao Ma <tm@tao.ma>
Subject: [PATCH] ext4: Add EXT4_ZERO_XATTR_VALUE to init inline data directly.
Date: Tue, 11 Dec 2012 14:39:49 +0800
Message-ID: <1355207989-4823-1-git-send-email-tm@tao.ma>
Cc: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy11-pub.bluehost.com ([173.254.64.10]:37311 "HELO
	oproxy11-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752853Ab2LKGkC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Dec 2012 01:40:02 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

Build rebot found this error:

config: make ARCH=sparc allyesconfig

All error/warnings:

fs/ext4/inline.c: In function 'ext4_create_inline_data':
fs/ext4/inline.c:268:19: error: 'empty_zero_page' undeclared (first use in this function)
fs/ext4/inline.c:268:19: note: each undeclared identifier is reported only once for each function it appears in
fs/ext4/inline.c: At top level:
fs/ext4/inline.c:164:12: warning: 'ext4_read_inline_data' defined but not used [-Wunused-function]

In sparc, it seems that we don't have empty_zero_page, so add a new specific
value EXT4_ZERO_XATTR_VALUE so that when ext4_xattr_set_entry see this flag
memset the space directly instead of copying from value. This idea is
inspired by Theodore Ts'o.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/inline.c |    2 +-
 fs/ext4/xattr.c  |   22 ++++++++++++++++------
 fs/ext4/xattr.h  |    1 +
 3 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 6b600b4..e435343 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -263,7 +263,7 @@ static int ext4_create_inline_data(handle_t *handle,
 		goto out;
 
 	if (len > EXT4_MIN_INLINE_DATA_SIZE) {
-		value = (void *)empty_zero_page;
+		value = EXT4_ZERO_XATTR_VALUE;
 		len -= EXT4_MIN_INLINE_DATA_SIZE;
 	} else {
 		value = "";
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 2251769..3a91ebc 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -628,9 +628,14 @@ ext4_xattr_set_entry(struct ext4_xattr_info *i, struct ext4_xattr_search *s)
 				   size. Just replace. */
 				s->here->e_value_size =
 					cpu_to_le32(i->value_len);
-				memset(val + size - EXT4_XATTR_PAD, 0,
-				       EXT4_XATTR_PAD); /* Clear pad bytes. */
-				memcpy(val, i->value, i->value_len);
+				if (i->value == EXT4_ZERO_XATTR_VALUE) {
+					memset(val, 0, size);
+				} else {
+					/* Clear pad bytes first. */
+					memset(val + size - EXT4_XATTR_PAD, 0,
+					       EXT4_XATTR_PAD);
+					memcpy(val, i->value, i->value_len);
+				}
 				return 0;
 			}
 
@@ -669,9 +674,14 @@ ext4_xattr_set_entry(struct ext4_xattr_info *i, struct ext4_xattr_search *s)
 			size_t size = EXT4_XATTR_SIZE(i->value_len);
 			void *val = s->base + min_offs - size;
 			s->here->e_value_offs = cpu_to_le16(min_offs - size);
-			memset(val + size - EXT4_XATTR_PAD, 0,
-			       EXT4_XATTR_PAD); /* Clear the pad bytes. */
-			memcpy(val, i->value, i->value_len);
+			if (i->value == EXT4_ZERO_XATTR_VALUE) {
+				memset(val, 0, size);
+			} else {
+				/* Clear the pad bytes first. */
+				memset(val + size - EXT4_XATTR_PAD, 0,
+				       EXT4_XATTR_PAD);
+				memcpy(val, i->value, i->value_len);
+			}
 		}
 	}
 	return 0;
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index c33fa41..17a6e44 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -71,6 +71,7 @@ struct ext4_xattr_entry {
 #define BFIRST(bh) ENTRY(BHDR(bh)+1)
 #define IS_LAST_ENTRY(entry) (*(__u32 *)(entry) == 0)
 
+#define EXT4_ZERO_XATTR_VALUE ((void *)-1)
 
 struct ext4_xattr_info {
 	int name_index;
-- 
1.7.0.4

