From: akpm@osdl.org
Subject: [patch 301/354] ext3/4: don't do orphan processing on readonly devices
Date: Wed, 06 Dec 2006 20:40:13 -0800
Message-ID: <200612070440.kB74eEpq030142@shell0.pdx.osdl.net>
Cc: akpm@osdl.org, sandeen@redhat.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:47386 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968757AbWLGEk2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Dec 2006 23:40:28 -0500
To: torvalds@osdl.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

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
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext3/super.c |    6 ++++++
 fs/ext4/super.c |    6 ++++++
 2 files changed, 12 insertions(+)

diff -puN fs/ext3/super.c~ext3-4-dont-do-orphan-processing-on-readonly-devices fs/ext3/super.c
--- a/fs/ext3/super.c~ext3-4-dont-do-orphan-processing-on-readonly-devices
+++ a/fs/ext3/super.c
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
diff -puN fs/ext4/super.c~ext3-4-dont-do-orphan-processing-on-readonly-devices fs/ext4/super.c
--- a/fs/ext4/super.c~ext3-4-dont-do-orphan-processing-on-readonly-devices
+++ a/fs/ext4/super.c
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
_
