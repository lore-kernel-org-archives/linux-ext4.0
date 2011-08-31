From: Tao Ma <tm@tao.ma>
Subject: [PATCH ] ext3: Fix a possible corruption in dx_probe.
Date: Wed, 31 Aug 2011 23:57:24 +0800
Message-ID: <1314806244-8434-1-git-send-email-tm@tao.ma>
Cc: Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:43402 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755985Ab1HaP7i (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 31 Aug 2011 11:59:38 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

For all the callers of dx_probe, frame_in is passed in uninitialized.
So we should set frame->bh to NULL in the beginning of while, not
the end. Otherwise, the first "goto fail2" will try to brelse(frame->bh)
while frame->bh is still invalid.

Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext3/namei.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 34b6d9b..45468b9 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -404,6 +404,7 @@ dx_probe(struct qstr *entry, struct inode *dir,
 	dxtrace (printk("Look up %x", hash));
 	while (1)
 	{
+		frame->bh = NULL;
 		count = dx_get_count(entries);
 		if (!count || count > dx_get_limit(entries)) {
 			ext3_warning(dir->i_sb, __func__,
@@ -458,7 +459,6 @@ dx_probe(struct qstr *entry, struct inode *dir,
 			goto fail2;
 		}
 		frame++;
-		frame->bh = NULL;
 	}
 fail2:
 	while (frame >= frame_in) {
-- 
1.7.0.4

