From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: [PATCH 1/3][RFC](Repost) ext2: add a message in
 mount/remount/umount for ext2
Date: Wed, 30 Sep 2009 15:46:11 +0900
Message-ID: <20090930154611.4a61e539.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sandeen@redhat.com, linux-ext4@vger.kernel.org
To: tytso@mit.edu, akpm@linux-foundation.org, adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41499 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbZI3Gwc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Sep 2009 02:52:32 -0400
Received: from m1.gw.fujitsu.co.jp ([10.0.50.71])
	by fgwmail6.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id n8U6qZrb016960
	for <linux-ext4@vger.kernel.org> (envelope-from toshi.okajima@jp.fujitsu.com);
	Wed, 30 Sep 2009 15:52:35 +0900
Received: from smail (m1 [127.0.0.1])
	by outgoing.m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 27CB845DE52
	for <linux-ext4@vger.kernel.org>; Wed, 30 Sep 2009 15:52:35 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by m1.gw.fujitsu.co.jp (Postfix) with ESMTP id B323945DE4E
	for <linux-ext4@vger.kernel.org>; Wed, 30 Sep 2009 15:52:34 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 93CE21DB8040
	for <linux-ext4@vger.kernel.org>; Wed, 30 Sep 2009 15:52:34 +0900 (JST)
Received: from m105.s.css.fujitsu.com (m105.s.css.fujitsu.com [10.249.87.105])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 4AC091DB803F
	for <linux-ext4@vger.kernel.org>; Wed, 30 Sep 2009 15:52:34 +0900 (JST)
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
 fs/ext2/super.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -Nurp linux-2.6.31.orig/fs/ext2/super.c linux-2.6.31/fs/ext2/super.c
--- linux-2.6.31.orig/fs/ext2/super.c	2009-09-10 07:13:59.000000000 +0900
+++ linux-2.6.31/fs/ext2/super.c	2009-09-16 14:44:06.000000000 +0900
@@ -109,6 +109,18 @@ void ext2_update_dynamic_rev(struct supe
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
 static void ext2_put_super (struct super_block * sb)
 {
 	int db_count;
@@ -140,6 +152,7 @@ static void ext2_put_super (struct super
 	sb->s_fs_info = NULL;
 	kfree(sbi->s_blockgroup_lock);
 	kfree(sbi);
+	ext2_print_umount_message(sb);
 
 	unlock_kernel();
 }
@@ -1063,6 +1076,7 @@ static int ext2_fill_super(struct super_
 		ext2_warning(sb, __func__,
 			"mounting ext3 filesystem as ext2");
 	ext2_setup_super (sb, es, sb->s_flags & MS_RDONLY);
+	ext2_print_mount_message(sb, 0);
 	return 0;
 
 cantfind_ext2:
@@ -1232,6 +1246,7 @@ static int ext2_remount (struct super_bl
 			sb->s_flags &= ~MS_RDONLY;
 	}
 	ext2_sync_super(sb, es);
+	ext2_print_mount_message(sb, 1);
 	unlock_kernel();
 	return 0;
 restore_opts:
