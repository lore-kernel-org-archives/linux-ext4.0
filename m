From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: [PATCH 2/3][RFC](Repost) ext3: add a message in remount/umount for
 ext3
Date: Wed, 30 Sep 2009 15:48:20 +0900
Message-ID: <20090930154820.6254ed77.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sandeen@redhat.com, linux-ext4@vger.kernel.org
To: tytso@mit.edu, akpm@linux-foundation.org, adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:32853 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbZI3Gym (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Sep 2009 02:54:42 -0400
Received: from m5.gw.fujitsu.co.jp ([10.0.50.75])
	by fgwmail5.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id n8U6sigm006475
	for <linux-ext4@vger.kernel.org> (envelope-from toshi.okajima@jp.fujitsu.com);
	Wed, 30 Sep 2009 15:54:44 +0900
Received: from smail (m5 [127.0.0.1])
	by outgoing.m5.gw.fujitsu.co.jp (Postfix) with ESMTP id 4608D45DE57
	for <linux-ext4@vger.kernel.org>; Wed, 30 Sep 2009 15:54:44 +0900 (JST)
Received: from s5.gw.fujitsu.co.jp (s5.gw.fujitsu.co.jp [10.0.50.95])
	by m5.gw.fujitsu.co.jp (Postfix) with ESMTP id 0314345DE56
	for <linux-ext4@vger.kernel.org>; Wed, 30 Sep 2009 15:54:44 +0900 (JST)
Received: from s5.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s5.gw.fujitsu.co.jp (Postfix) with ESMTP id BCA2E1DB8043
	for <linux-ext4@vger.kernel.org>; Wed, 30 Sep 2009 15:54:43 +0900 (JST)
Received: from ml13.s.css.fujitsu.com (ml13.s.css.fujitsu.com [10.249.87.103])
	by s5.gw.fujitsu.co.jp (Postfix) with ESMTP id 544361DB805D
	for <linux-ext4@vger.kernel.org>; Wed, 30 Sep 2009 15:54:43 +0900 (JST)
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
 fs/ext3/super.c |   30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff -Nurp linux-2.6.31.orig/fs/ext3/super.c linux-2.6.31/fs/ext3/super.c
--- linux-2.6.31.orig/fs/ext3/super.c	2009-09-10 07:13:59.000000000 +0900
+++ linux-2.6.31/fs/ext3/super.c	2009-09-16 14:52:03.000000000 +0900
@@ -328,6 +328,24 @@ void ext3_update_dynamic_rev(struct supe
 	 */
 }
 
+static void ext3_print_mount_message(struct super_block *sb, 
+					int is_remount)
+{
+	char jbuf[BDEVNAME_SIZE + 20] = "internal journal";
+
+	if (EXT3_SB(sb)->s_journal->j_inode == NULL) {
+		sprintf(jbuf, "external journal on ");
+		(void)bdevname(EXT3_SB(sb)->s_journal->j_dev, jbuf + 20);
+	}
+	printk(KERN_INFO "EXT3 FS %s on %s, %s\n", 
+			is_remount? "remounted": "mounted", sb->s_id, jbuf);
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
@@ -448,6 +466,7 @@ static void ext3_put_super (struct super
 	sb->s_fs_info = NULL;
 	kfree(sbi->s_blockgroup_lock);
 	kfree(sbi);
+	ext3_print_umount_message(sb);
 
 	unlock_kernel();
 }
@@ -1296,15 +1315,6 @@ static int ext3_setup_super(struct super
 			EXT3_INODES_PER_GROUP(sb),
 			sbi->s_mount_opt);
 
-	printk(KERN_INFO "EXT3 FS on %s, ", sb->s_id);
-	if (EXT3_SB(sb)->s_journal->j_inode == NULL) {
-		char b[BDEVNAME_SIZE];
