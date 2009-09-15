From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: [PATCH 2/3][RFC] ext3: add a message in remount/umount for ext3
Date: Tue, 15 Sep 2009 15:24:07 +0900
Message-ID: <20090915152407.dd0fe2c8.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sct@redhat.com, adilger@sun.com, linux-ext4@vger.kernel.org
To: tytso@mit.edu, akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57683 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbZIOG2R (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Sep 2009 02:28:17 -0400
Received: from m2.gw.fujitsu.co.jp ([10.0.50.72])
	by fgwmail6.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id n8F6SKAn004661
	for <linux-ext4@vger.kernel.org> (envelope-from toshi.okajima@jp.fujitsu.com);
	Tue, 15 Sep 2009 15:28:20 +0900
Received: from smail (m2 [127.0.0.1])
	by outgoing.m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 5A31545DE4F
	for <linux-ext4@vger.kernel.org>; Tue, 15 Sep 2009 15:28:20 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 2C81145DE4E
	for <linux-ext4@vger.kernel.org>; Tue, 15 Sep 2009 15:28:20 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 13B7F1DB803A
	for <linux-ext4@vger.kernel.org>; Tue, 15 Sep 2009 15:28:20 +0900 (JST)
Received: from ml13.s.css.fujitsu.com (ml13.s.css.fujitsu.com [10.249.87.103])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id C88EA1DF8005
	for <linux-ext4@vger.kernel.org>; Tue, 15 Sep 2009 15:28:16 +0900 (JST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>

ext3 doesn't log a record of having unmounted the filesystem. And ext3 doesn't 
log a record when the filesystem is remounted also with read-only. Therefore 
in the system log, we cannot judge whether or not at the certain time this 
filesystem user touches it.
For enterprise users, they often want to know when a certain filesystem is 
mounted/remounted/unmounted.

So, we output the message to the system log when the filesystem is 
remounted/unmounted.

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
---
 fs/ext3/super.c |   32 +++++++++++++++++++++++---------
 1 file changed, 23 insertions(+), 9 deletions(-)

diff -Nurp linux-2.6.31.orig/fs/ext3/super.c linux-2.6.31/fs/ext3/super.c
--- linux-2.6.31.orig/fs/ext3/super.c	2009-09-10 07:13:59.000000000 +0900
+++ linux-2.6.31/fs/ext3/super.c	2009-09-11 17:08:24.742407628 +0900
@@ -328,6 +328,26 @@ void ext3_update_dynamic_rev(struct supe
 	 */
 }
 
+static void ext3_print_mount_message(struct super_block *sb, 
+					int is_remount)
+{
+	printk(KERN_INFO "EXT3 FS %s on %s, ", 
+			is_remount? "remounted": "mounted", sb->s_id);
+	if (EXT3_SB(sb)->s_journal->j_inode == NULL) {
+		char b[BDEVNAME_SIZE];
+
+		printk("external journal on %s\n",
+			bdevname(EXT3_SB(sb)->s_journal->j_dev, b));
+	} else {
+		printk("internal journal\n");
+	}
+}
+
+static void ext3_print_umount_message(struct super_block *sb)
+{
+	printk(KERN_INFO "EXT3 FS unmounted from %s\n", sb->s_id);
+}
+
 /*
  * Open the external journal device
  */
@@ -448,6 +468,7 @@ static void ext3_put_super (struct super
 	sb->s_fs_info = NULL;
 	kfree(sbi->s_blockgroup_lock);
 	kfree(sbi);
+	ext3_print_umount_message(sb);
 
 	unlock_kernel();
 }
@@ -1296,15 +1317,6 @@ static int ext3_setup_super(struct super
 			EXT3_INODES_PER_GROUP(sb),
 			sbi->s_mount_opt);
 
-	printk(KERN_INFO "EXT3 FS on %s, ", sb->s_id);
-	if (EXT3_SB(sb)->s_journal->j_inode == NULL) {
-		char b[BDEVNAME_SIZE];
