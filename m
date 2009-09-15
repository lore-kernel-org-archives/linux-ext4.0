From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: [PATCH 1/3][RFC] ext2: add a message in mount/remount/umount for
 ext2
Date: Tue, 15 Sep 2009 15:22:34 +0900
Message-ID: <20090915152234.4bfe44f6.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sct@redhat.com, adilger@sun.com, linux-ext4@vger.kernel.org
To: tytso@mit.edu, akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57600 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757630AbZIOG0q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Sep 2009 02:26:46 -0400
Received: from m4.gw.fujitsu.co.jp ([10.0.50.74])
	by fgwmail6.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id n8F6QmB8003877
	for <linux-ext4@vger.kernel.org> (envelope-from toshi.okajima@jp.fujitsu.com);
	Tue, 15 Sep 2009 15:26:48 +0900
Received: from smail (m4 [127.0.0.1])
	by outgoing.m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 50D5E45DE6F
	for <linux-ext4@vger.kernel.org>; Tue, 15 Sep 2009 15:26:48 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 33DB045DE86
	for <linux-ext4@vger.kernel.org>; Tue, 15 Sep 2009 15:26:46 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 8F118E18005
	for <linux-ext4@vger.kernel.org>; Tue, 15 Sep 2009 15:26:45 +0900 (JST)
Received: from m106.s.css.fujitsu.com (m106.s.css.fujitsu.com [10.249.87.106])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 848AB1DB803F
	for <linux-ext4@vger.kernel.org>; Tue, 15 Sep 2009 15:26:44 +0900 (JST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>

ext2 doesn't log a record of having mounted, remounted and unmounted the 
filesystem. Therefore in the system log, we cannot judge whether or not at 
the certain time this filesystem user touches it.
For enterprise users, they often want to know when a certain filesystem is 
mounted/remounted/unmounted.

So, we output the message to the system log when the filesystem is 
mounted/remounted/unmounted.

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
---
 fs/ext2/super.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -Nurp linux-2.6.31.orig/fs/ext2/super.c linux-2.6.31/fs/ext2/super.c
--- linux-2.6.31.orig/fs/ext2/super.c	2009-09-10 07:13:59.000000000 +0900
+++ linux-2.6.31/fs/ext2/super.c	2009-09-11 17:08:53.907463826 +0900
@@ -109,6 +109,19 @@ void ext2_update_dynamic_rev(struct supe
 	 */
 }
 
+static void ext2_print_mount_message(struct super_block *sb, 
+					int is_remount)
+{
+	printk(KERN_INFO "EXT2 FS %s on %s\n", 
+			is_remount? "remounted": "mounted", sb->s_id);
+}
+
+static void ext2_print_umount_message(struct super_block *sb)
+{
+	printk(KERN_INFO "EXT2 FS unmounted from %s\n", sb->s_id);
+}
+
+
 static void ext2_put_super (struct super_block * sb)
 {
 	int db_count;
@@ -140,6 +153,7 @@ static void ext2_put_super (struct super
 	sb->s_fs_info = NULL;
 	kfree(sbi->s_blockgroup_lock);
 	kfree(sbi);
+	ext2_print_umount_message(sb);
 
 	unlock_kernel();
 }
@@ -1063,6 +1077,7 @@ static int ext2_fill_super(struct super_
 		ext2_warning(sb, __func__,
 			"mounting ext3 filesystem as ext2");
 	ext2_setup_super (sb, es, sb->s_flags & MS_RDONLY);
+	ext2_print_mount_message(sb, 0);
 	return 0;
 
 cantfind_ext2:
@@ -1232,6 +1247,7 @@ static int ext2_remount (struct super_bl
 			sb->s_flags &= ~MS_RDONLY;
 	}
 	ext2_sync_super(sb, es);
+	ext2_print_mount_message(sb, 1);
 	unlock_kernel();
 	return 0;
 restore_opts:
