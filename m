From: Tao Ma <tm@tao.ma>
Subject: [PATCH] ext4: Fix a possible corruption in dx_probe.
Date: Thu,  1 Sep 2011 00:00:52 +0800
Message-ID: <1314806452-8763-1-git-send-email-tm@tao.ma>
Cc: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy9.bluehost.com ([69.89.24.6]:49425 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932075Ab1HaQDF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 31 Aug 2011 12:03:05 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

For all the callers of dx_probe, frame_in is passed in uninitialized.
So we should set frame->bh to NULL in the beginning of while, not
the end. Otherwise, the first "goto fail2" will try to brelse(frame->bh)
while frame->bh is still invalid.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/namei.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index b754b77..86c5c69 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -404,6 +404,7 @@ dx_probe(const struct qstr *d_name, struct inode *dir,
 	dxtrace(printk("Look up %x", hash));
 	while (1)
 	{
+		frame->bh = NULL;
 		count = dx_get_count(entries);
 		if (!count || count > dx_get_limit(entries)) {
 			ext4_warning(dir->i_sb,
@@ -458,7 +459,6 @@ dx_probe(const struct qstr *d_name, struct inode *dir,
 			goto fail2;
 		}
 		frame++;
-		frame->bh = NULL;
 	}
 fail2:
 	while (frame >= frame_in) {
-- 
1.7.0.4

