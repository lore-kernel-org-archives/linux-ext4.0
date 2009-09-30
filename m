From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: [PATCH 3/3][RFC](Repost) ext4: add a message in remount/umount for
 ext4
Date: Wed, 30 Sep 2009 15:49:31 +0900
Message-ID: <20090930154931.ef2a4760.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sandeen@redhat.com, linux-ext4@vger.kernel.org
To: tytso@mit.edu, akpm@linux-foundation.org, adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41661 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901AbZI3Gzw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Sep 2009 02:55:52 -0400
Received: from m2.gw.fujitsu.co.jp ([10.0.50.72])
	by fgwmail6.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id n8U6turb018252
	for <linux-ext4@vger.kernel.org> (envelope-from toshi.okajima@jp.fujitsu.com);
	Wed, 30 Sep 2009 15:55:56 +0900
Received: from smail (m2 [127.0.0.1])
	by outgoing.m2.gw.fujitsu.co.jp (Postfix) with ESMTP id DDE6145DE57
	for <linux-ext4@vger.kernel.org>; Wed, 30 Sep 2009 15:55:55 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 8E94545DE4E
	for <linux-ext4@vger.kernel.org>; Wed, 30 Sep 2009 15:55:55 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 6B2381DB803E
	for <linux-ext4@vger.kernel.org>; Wed, 30 Sep 2009 15:55:55 +0900 (JST)
Received: from m106.s.css.fujitsu.com (m106.s.css.fujitsu.com [10.249.87.106])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 1528BE78002
	for <linux-ext4@vger.kernel.org>; Wed, 30 Sep 2009 15:55:55 +0900 (JST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>

ext4 doesn't log a record of having unmounted the filesystem. And ext4 doesn't 
log a record when the filesystem is remounted also with read-only. Therefore 
in the system log, we cannot judge whether or not at the certain time this
filesystem user touches it.
For enterprise users, they often want to know when a certain filesystem is 
mounted/remounted/unmounted.

So, we output the message to the system log when the filesystem is 
remounted/unmounted.

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
---
 fs/ext4/super.c |   30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff -Nurp linux-2.6.31.orig/fs/ext4/super.c linux-2.6.31/fs/ext4/super.c
--- linux-2.6.31.orig/fs/ext4/super.c	2009-09-10 07:13:59.000000000 +0900
+++ linux-2.6.31/fs/ext4/super.c	2009-09-11 17:11:07.000000000 +0900
@@ -508,6 +508,25 @@ void ext4_update_dynamic_rev(struct supe
 	 */
 }
 
+static void ext4_print_mount_message(struct super_block *sb, 
+					int is_remount)
+{
+	if (EXT4_SB(sb)->s_journal) {
+		ext4_msg(sb, KERN_INFO, "%s, %s journal on %s",
+			is_remount? "remounted": "mounted",
+		       EXT4_SB(sb)->s_journal->j_inode ? "internal" :
+		       "external", EXT4_SB(sb)->s_journal->j_devname);
+	} else {
+		ext4_msg(sb, KERN_INFO, "%s, no journal",
+				is_remount? "remounted": "mounted");
+	}
+}
+
+static void ext4_print_umount_message(struct super_block *sb)
+{
+	ext4_msg(sb, KERN_INFO, "unmounted");
+}
+
 /*
  * Open the external journal device
  */
@@ -645,6 +664,7 @@ static void ext4_put_super(struct super_
 	 * Now that we are completely done shutting down the
 	 * superblock, we need to actually destroy the kobject.
 	 */
+	ext4_print_umount_message(sb);
 	unlock_kernel();
 	unlock_super(sb);
 	kobject_put(&sbi->s_kobj);
@@ -1645,14 +1665,6 @@ static int ext4_setup_super(struct super
 			EXT4_BLOCKS_PER_GROUP(sb),
 			EXT4_INODES_PER_GROUP(sb),
 			sbi->s_mount_opt);
-
-	if (EXT4_SB(sb)->s_journal) {
-		ext4_msg(sb, KERN_INFO, "%s journal on %s",
-		       EXT4_SB(sb)->s_journal->j_inode ? "internal" :
-		       "external", EXT4_SB(sb)->s_journal->j_devname);
-	} else {
-		ext4_msg(sb, KERN_INFO, "no journal");
-	}
 	return res;
 }
 
@@ -2806,6 +2818,7 @@ no_journal:
 	}
 
 	ext4_setup_super(sb, es, sb->s_flags & MS_RDONLY);
+	ext4_print_mount_message(sb, 0);
 
 	/* determine the minimum size of new large inodes, if present */
 	if (sbi->s_inode_size > EXT4_GOOD_OLD_INODE_SIZE) {
@@ -3547,6 +3560,7 @@ static int ext4_remount(struct super_blo
 		    old_opts.s_qf_names[i] != sbi->s_qf_names[i])
 			kfree(old_opts.s_qf_names[i]);
 #endif
+	ext4_print_mount_message(sb, 1);
 	unlock_super(sb);
 	unlock_kernel();
 	return 0;
