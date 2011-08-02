From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: [PATCH v2] ext3: fix message in ext3_remount for rw-remount case
Date: Tue, 2 Aug 2011 18:16:57 +0900
Message-ID: <20110802181657.d758bd44.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: jack@suse.cz, akpm@linux-foundation.org, adilger.kernel@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47757 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab1HBJSG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Aug 2011 05:18:06 -0400
Received: from m2.gw.fujitsu.co.jp (unknown [10.0.50.72])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 3EC993EE081
	for <linux-ext4@vger.kernel.org>; Tue,  2 Aug 2011 18:18:06 +0900 (JST)
Received: from smail (m2 [127.0.0.1])
	by outgoing.m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 140DB45DE82
	for <linux-ext4@vger.kernel.org>; Tue,  2 Aug 2011 18:18:06 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by m2.gw.fujitsu.co.jp (Postfix) with ESMTP id E446F45DE7F
	for <linux-ext4@vger.kernel.org>; Tue,  2 Aug 2011 18:18:05 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id D70941DB8042
	for <linux-ext4@vger.kernel.org>; Tue,  2 Aug 2011 18:18:05 +0900 (JST)
Received: from m107.s.css.fujitsu.com (m107.s.css.fujitsu.com [10.240.81.147])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id A1E9C1DB803A
	for <linux-ext4@vger.kernel.org>; Tue,  2 Aug 2011 18:18:05 +0900 (JST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If there are some inodes in orphan list while a filesystem is being 
read-only mounted, we should recommend that pepole umount and then
mount it when they try to remount with read-write. But the current
message and comment recommend that they umount and then remount it.

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
index 7beb69a..2043bcc 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -2669,13 +2669,13 @@ static int ext3_remount (struct super_block * sb, int * flags, char * data)
 			/*
 			 * If we have an unprocessed orphan list hanging
 			 * around from a previously readonly bdev mount,
-			 * require a full umount/remount for now.
+			 * require a full umount & mount for now.
 			 */
 			if (es->s_last_orphan) {
 				ext3_msg(sb, KERN_WARNING, "warning: couldn't "
 				       "remount RDWR because of unprocessed "
 				       "orphan inode list.  Please "
-				       "umount/remount instead.");
+				       "umount & mount instead.");
 				err = -EINVAL;
 				goto restore_opts;
 			}
-- 
1.5.5.6
