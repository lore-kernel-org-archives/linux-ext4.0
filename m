From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] don't do orphan processing on readonly devices
Date: Thu, 30 Nov 2006 11:02:17 -0600
Message-ID: <456F0E99.4060008@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:22759 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1030727AbWK3RCU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Nov 2006 12:02:20 -0500
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

If you do something like:

# touch foo
# tail -f foo &
# rm foo
# <take snapshot>
# <mount snapshot>

you'll panic, because ext3/4 tries to do orphan list processing on the 
readonly snapshot device, and:

kernel: journal commit I/O error
kernel: Assertion failure in journal_flush_Rsmp_e2f189ce() at journal.c:1356: "!journal->j_checkpoint_transactions"
kernel: Kernel panic: Fatal exception

for a truly readonly underlying device, it's reasonable and necessary 
to just skip orphan list processing.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Index: linux-2.6.18/fs/ext3/super.c
===================================================================
--- linux-2.6.18.orig/fs/ext3/super.c
+++ linux-2.6.18/fs/ext3/super.c
@@ -1264,6 +1264,12 @@ static void ext3_orphan_cleanup (struct 
 		return;
 	}
 
+	if (bdev_read_only(sb->s_bdev)) {
+		printk(KERN_ERR "EXT3-fs: write access "
+			"unavailable, skipping orphan cleanup.\n");
+		return;
+	}
+
 	if (EXT3_SB(sb)->s_mount_state & EXT3_ERROR_FS) {
 		if (es->s_last_orphan)
 			jbd_debug(1, "Errors on filesystem, "
Index: linux-2.6.18/fs/ext4/super.c
===================================================================
--- linux-2.6.18.orig/fs/ext4/super.c
+++ linux-2.6.18/fs/ext4/super.c
@@ -1321,6 +1321,12 @@ static void ext4_orphan_cleanup (struct 
 		return;
 	}
 
+	if (bdev_read_only(sb->s_bdev)) {
+		printk(KERN_ERR "EXT4-fs: write access "
+			"unavailable, skipping orphan cleanup.\n");
+		return;
+	}
+
 	if (EXT4_SB(sb)->s_mount_state & EXT4_ERROR_FS) {
 		if (es->s_last_orphan)
 			jbd_debug(1, "Errors on filesystem, "
