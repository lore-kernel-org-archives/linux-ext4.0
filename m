From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: [PATCH] ext4: fix message in ext4_remount for rw-remount case
Date: Mon, 1 Aug 2011 13:56:28 +0900
Message-ID: <20110801135628.3257a561.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33614 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab1HAGmm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Aug 2011 02:42:42 -0400
Received: from m3.gw.fujitsu.co.jp (unknown [10.0.50.73])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 706153EE0AE
	for <linux-ext4@vger.kernel.org>; Mon,  1 Aug 2011 15:42:40 +0900 (JST)
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 5806F45DEA6
	for <linux-ext4@vger.kernel.org>; Mon,  1 Aug 2011 15:42:40 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 4277A45DE9E
	for <linux-ext4@vger.kernel.org>; Mon,  1 Aug 2011 15:42:40 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 36B2D1DB8037
	for <linux-ext4@vger.kernel.org>; Mon,  1 Aug 2011 15:42:40 +0900 (JST)
Received: from ml13.s.css.fujitsu.com (ml13.s.css.fujitsu.com [10.240.81.133])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 029AC1DB803B
	for <linux-ext4@vger.kernel.org>; Mon,  1 Aug 2011 15:42:40 +0900 (JST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If there are some inodes in orphan list while a filesystem is being 
read-only mounted, we should recommend that pepole umount and then
mount it when they try to remount with read-write. But the current
message/comment recommends that they umount and then remount it.

ext4_remount:
	/*
	 * If we have an unprocessed orphan list hanging
	 * around from a previously readonly bdev mount,
	 * require a full umount/remount for now.
                          ^^^^^^^^^^^^^^
	 */
	if (es->s_last_orphan) {
		ext4_msg(sb, KERN_WARNING, "Couldn't "
				"remount RDWR because of unprocessed "
				"orphan inode list.  Please "
				"umount/remount instead");
                                 ^^^^^^^^^^^^^^

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
---
 fs/ext4/super.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9ea71aa..c518522 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4390,13 +4390,13 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 			/*
 			 * If we have an unprocessed orphan list hanging
 			 * around from a previously readonly bdev mount,
-			 * require a full umount/remount for now.
+			 * require a full umount/mount for now.
 			 */
 			if (es->s_last_orphan) {
 				ext4_msg(sb, KERN_WARNING, "Couldn't "
 				       "remount RDWR because of unprocessed "
 				       "orphan inode list.  Please "
-				       "umount/remount instead");
+				       "umount/mount instead");
 				err = -EINVAL;
 				goto restore_opts;
 			}
-- 
1.5.5.6
