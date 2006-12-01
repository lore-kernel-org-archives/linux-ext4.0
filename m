From: akpm@osdl.org
Subject: + ext3-4-dont-do-orphan-processing-on-readonly-devices.patch added to -mm tree
Date: Thu, 30 Nov 2006 23:05:00 -0800
Message-ID: <200612010705.kB1750dY004195@shell0.pdx.osdl.net>
Cc: sandeen@redhat.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:41133 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1759244AbWLAHFI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Dec 2006 02:05:08 -0500
To: mm-commits@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3/4: don't do orphan processing on readonly devices
has been added to the -mm tree.  Its filename is
     ext3-4-dont-do-orphan-processing-on-readonly-devices.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

Patches currently in -mm which might be from sandeen@redhat.com are

reject-corrupt-swapfiles-earlier.patch
handle-ext3-directory-corruption-better.patch
handle-ext4-directory-corruption-better.patch
ext3-4-dont-do-orphan-processing-on-readonly-devices.patch
