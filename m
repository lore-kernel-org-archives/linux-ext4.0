From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 1/3] ext4: remove 'error' variable in ext4_xattr_check_block()
Date: Mon,  7 Nov 2011 21:32:02 +0800
Message-ID: <1320672724-4432-2-git-send-email-wenqing.lz@taobao.com>
References: <1320672724-4432-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61119 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab1KGNaj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Nov 2011 08:30:39 -0500
Received: by iage36 with SMTP id e36so5838947iag.19
        for <linux-ext4@vger.kernel.org>; Mon, 07 Nov 2011 05:30:38 -0800 (PST)
In-Reply-To: <1320672724-4432-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

We could return directly from ext4_xattr_check_block(). Thus, we shouldn't
need to define a 'error' variable.

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
