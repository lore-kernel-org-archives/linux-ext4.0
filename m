From: Tao Ma <tm@tao.ma>
Subject: [PATCH] ext4: Use kzalloc instead of empty_zero_page because of SPARC build error.
Date: Tue, 11 Dec 2012 10:55:45 +0800
Message-ID: <1355194545-4002-1-git-send-email-tm@tao.ma>
Cc: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:52660 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751291Ab2LKC4I (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Dec 2012 21:56:08 -0500
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

In sparc, it seems that we don't have empty_zero_page, so replace it
with kzalloc and kfree to make sparc happy and make any future architecture
build successfully by not using empty_zero_page at all.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/inline.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 6b600b4..997c1aa 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -263,8 +263,10 @@ static int ext4_create_inline_data(handle_t *handle,
 		goto out;
 
 	if (len > EXT4_MIN_INLINE_DATA_SIZE) {
-		value = (void *)empty_zero_page;
 		len -= EXT4_MIN_INLINE_DATA_SIZE;
+		value = kzalloc(len, GFP_NOFS);
+		if (!value)
+			goto out;
 	} else {
 		value = "";
 		len = 0;
@@ -275,6 +277,8 @@ static int ext4_create_inline_data(handle_t *handle,
 	i.value_len = len;
 
 	error = ext4_xattr_ibody_find(inode, &i, &is);
+	if (len)
+		kfree(value);
 	if (error)
 		goto out;
 
-- 
1.7.0.4

