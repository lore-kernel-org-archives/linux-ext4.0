From: Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: [PATCH] ext4: Fix memleak in ext4_readdir()
Date: Tue, 19 Jan 2016 17:42:08 +0300
Message-ID: <569E4B40.3060506@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <dmonakhov@virtuozzo.com>, <tytso@mit.edu>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:38301 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073AbcASOmT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Jan 2016 09:42:19 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When ext4_bread() fails, fname_crypto_str remains
allocated after return. Fix that.

Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
CC: Theodore Ts'o <tytso@mit.edu>
CC: Dmitry Monakhov <dmonakhov@virtuozzo.com>
---
 fs/ext4/dir.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 1d1bca7..def3215 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -157,8 +157,11 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 					index, 1);
 			file->f_ra.prev_pos = (loff_t)index << PAGE_CACHE_SHIFT;
 			bh = ext4_bread(NULL, inode, map.m_lblk, 0);
-			if (IS_ERR(bh))
-				return PTR_ERR(bh);
+			if (IS_ERR(bh)) {
+				err = PTR_ERR(bh);
+				bh = NULL;
+				goto errout;
+			}
 		}
 
 		if (!bh) {

