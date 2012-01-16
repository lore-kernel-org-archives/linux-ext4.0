From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH RESEND] ext4: remove 'error' variable in ext4_xattr_check_block() function
Date: Mon, 16 Jan 2012 17:16:13 +0800
Message-ID: <1326705373-4659-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43155 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab2APJMc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Jan 2012 04:12:32 -0500
Received: by iagf6 with SMTP id f6so2275173iag.19
        for <linux-ext4@vger.kernel.org>; Mon, 16 Jan 2012 01:12:32 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We can return from ext4_xattr_check_block() directly. Thus, we don't
need to define a 'error' variable.

CC: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/xattr.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 93a00d8..1bff752 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -158,13 +158,10 @@ ext4_xattr_check_names(struct ext4_xattr_entry *entry, void *end)
 static inline int
 ext4_xattr_check_block(struct buffer_head *bh)
 {
-	int error;
