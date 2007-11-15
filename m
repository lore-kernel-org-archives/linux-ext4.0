From: akpm@linux-foundation.org
Subject: - fix-64kb-blocksize-in-ext3-directories-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 14 Nov 2007 16:45:38 -0800
Message-ID: <200711150045.lAF0jcdP002055@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: akpm@linux-foundation.org, jack@suse.cz,
	linux-ext4@vger.kernel.org, mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     fix-64kb-blocksize-in-ext3-directories-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     fix-64kb-blocksize-in-ext3-directories-checkpatch-fixes.patch

This patch was dropped because it was folded into fix-64kb-blocksize-in-ext3-directories.patch

------------------------------------------------------
Subject: fix-64kb-blocksize-in-ext3-directories-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#70: FILE: fs/ext3/namei.c:182:
+static inline struct ext3_dir_entry_2 *ext3_next_entry(struct ext3_dir_entry_2 *p)

ERROR: "(foo*)" should be "(foo *)"
#72: FILE: fs/ext3/namei.c:184:
+	return (struct ext3_dir_entry_2 *)((char*)p +

WARNING: line over 80 characters
#262: FILE: fs/ext3/namei.c:1806:
+	de->rec_len = ext3_rec_len_to_disk(inode->i_sb->s_blocksize-EXT3_DIR_REC_LEN(1));

total: 1 errors, 2 warnings, 289 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: <linux-ext4@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/namei.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN fs/ext3/namei.c~fix-64kb-blocksize-in-ext3-directories-checkpatch-fixes fs/ext3/namei.c
--- a/fs/ext3/namei.c~fix-64kb-blocksize-in-ext3-directories-checkpatch-fixes
+++ a/fs/ext3/namei.c
@@ -179,9 +179,10 @@ static int ext3_dx_add_entry(handle_t *h
 /*
  * p is at least 6 bytes before the end of page
  */
-static inline struct ext3_dir_entry_2 *ext3_next_entry(struct ext3_dir_entry_2 *p)
+static inline struct ext3_dir_entry_2 *
+ext3_next_entry(struct ext3_dir_entry_2 *p)
 {
-	return (struct ext3_dir_entry_2 *)((char*)p +
+	return (struct ext3_dir_entry_2 *)((char *)p +
 		ext3_rec_len_from_disk(p->rec_len));
 }
 
@@ -1803,7 +1804,8 @@ retry:
 	ext3_set_de_type(dir->i_sb, de, S_IFDIR);
 	de = ext3_next_entry(de);
 	de->inode = cpu_to_le32(dir->i_ino);
-	de->rec_len = ext3_rec_len_to_disk(inode->i_sb->s_blocksize-EXT3_DIR_REC_LEN(1));
+	de->rec_len = ext3_rec_len_to_disk(inode->i_sb->s_blocksize -
+					EXT3_DIR_REC_LEN(1));
 	de->name_len = 2;
 	strcpy (de->name, "..");
 	ext3_set_de_type(dir->i_sb, de, S_IFDIR);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
uml-update-address-space-affected-by-pud_clear.patch
proc-fix-proc_kill_inodes-to-kill-dentries-on-all-proc-superblocks.patch
acpi-make-acpi_procfs-default-to-y.patch
hugetlb-split-alloc_huge_page-into-private-and-shared-components.patch
revert-task-control-groups-example-cpu-accounting-subsystem.patch
mips-undo-locking-on-error-path-returns.patch
pidns-place-under-config_experimental.patch
fix-64kb-blocksize-in-ext3-directories.patch
fix-64kb-blocksize-in-ext3-directories-checkpatch-fixes.patch
file-capabilities-allow-sigcont-within-session-v2-checkpatch-fixes.patch
x86-disable-preemption-in-delay_tsc.patch
aic94xx_sds-rename-flash_size.patch
mips-pcspkr-build-fix.patch
