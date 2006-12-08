From: akpm@osdl.org
Subject: - ext3-4-dont-do-orphan-processing-on-readonly-devices.patch removed from -mm tree
Date: Fri, 08 Dec 2006 00:33:08 -0800
Message-ID: <200612080833.kB88X83F013527@shell0.pdx.osdl.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:35847 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425164AbWLHId1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Dec 2006 03:33:27 -0500
To: sandeen@redhat.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3/4: don't do orphan processing on readonly devices
has been removed from the -mm tree.  Its filename was
     ext3-4-dont-do-orphan-processing-on-readonly-devices.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ext3/4: don't do orphan processing on readonly devices
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
@@ -1270,6 +1270,12 @@ static void ext3_orphan_cleanup (struct 
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
@@ -1327,6 +1327,12 @@ static void ext4_orphan_cleanup (struct 
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

Patches currently in -mm which might be from sandeen@redhat.com are

origin.patch
ext3-4-dont-do-orphan-processing-on-readonly-devices.patch
