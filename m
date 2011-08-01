From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: [PATCH] ext3: fix message in ext3_remount for rw-remount case
Date: Mon, 1 Aug 2011 13:54:51 +0900
Message-ID: <20110801135451.cb73c981.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: jack@suse.cz, akpm@linux-foundation.org, adilger.kernel@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47809 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab1HAGlF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Aug 2011 02:41:05 -0400
Received: from m1.gw.fujitsu.co.jp (unknown [10.0.50.71])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 57FA93EE0B5
	for <linux-ext4@vger.kernel.org>; Mon,  1 Aug 2011 15:41:03 +0900 (JST)
Received: from smail (m1 [127.0.0.1])
	by outgoing.m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 3B0D345DE58
	for <linux-ext4@vger.kernel.org>; Mon,  1 Aug 2011 15:41:03 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 224DA45DE55
	for <linux-ext4@vger.kernel.org>; Mon,  1 Aug 2011 15:41:03 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 13E7B1DB8051
	for <linux-ext4@vger.kernel.org>; Mon,  1 Aug 2011 15:41:03 +0900 (JST)
Received: from ml14.s.css.fujitsu.com (ml14.s.css.fujitsu.com [10.240.81.134])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id D23C51DB8050
	for <linux-ext4@vger.kernel.org>; Mon,  1 Aug 2011 15:41:02 +0900 (JST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If there are some inodes in orphan list while a filesystem is being 
read-only mounted, we should recommend that pepole umount and then
mount it when they try to remount with read-write. But the current
message/comment recommends that they umount and then remount it.

ext3_remount:
	/*
	 * If we have an unprocessed orphan list hanging
	 * around from a previously readonly bdev mount,
	 * require a full umount/remount for now.
                          ^^^^^^^^^^^^^^
	 */
	if (es->s_last_orphan) {
		printk(KERN_WARNING "EXT3-fs: %s: couldn't "
			"remount RDWR because of unprocessed "
			"orphan inode list.  Please "
			"umount/remount instead.\n",
                         ^^^^^^^^^^^^^^
			sb->s_id);

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
---
 fs/ext3/super.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 7beb69a..d3df0d4 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -2669,13 +2669,13 @@ static int ext3_remount (struct super_block * sb, int * flags, char * data)
 			/*
 			 * If we have an unprocessed orphan list hanging
 			 * around from a previously readonly bdev mount,
-			 * require a full umount/remount for now.
+			 * require a full umount/mount for now.
 			 */
 			if (es->s_last_orphan) {
 				ext3_msg(sb, KERN_WARNING, "warning: couldn't "
 				       "remount RDWR because of unprocessed "
 				       "orphan inode list.  Please "
-				       "umount/remount instead.");
+				       "umount/mount instead.");
 				err = -EINVAL;
 				goto restore_opts;
 			}
-- 
1.5.5.6
