From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] Update ext3/4 mount options
Date: Thu,  9 Jan 2014 15:34:50 -0200
Message-ID: <1389288890-17282-1-git-send-email-cmaiolino@redhat.com>
To: util-linux@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557AbaAIRfC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 Jan 2014 12:35:02 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add missing mount options to ext3 and ext4 filesystems. This also remove resize
option information from the man page.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 sys-utils/mount.8 | 42 +++++++++++++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 11 deletions(-)

diff --git a/sys-utils/mount.8 b/sys-utils/mount.8
index 6a5edd0..0aa3608 100644
--- a/sys-utils/mount.8
+++ b/sys-utils/mount.8
@@ -1466,12 +1466,12 @@ journal file;  ext3 will create a new journal, overwriting the old contents
 of the file whose inode number is
 .IR inum .
 .TP
-.BR journal_dev=devnum
+.BR journal_dev=devnum / journal_path=path
 When the external journal device's major/minor numbers
-have changed, this option allows the user to specify
+have changed, these options allows the user to specify
 the new journal location.  The journal device is
-identified through its new major/minor numbers encoded
-in devnum.
+identified through euther its new major/minor numbers encoded
+in devnum, or via a path to the device.
 .TP
 .BR norecovery / noload
 Don't load the journal on mounting.  Note that
@@ -1504,6 +1504,13 @@ internal filesystem integrity, however it can allow old data to appear
 in files after a crash and journal recovery.
 .RE
 .TP
+.BR data_err=ignore
+Just print an error message if an error occurs in a file data buffer in
+ordered mode.
+.TP
+.BR data_err=abort
+Abort the journal if an error occurs in a file data buffer in ordered mode.
+.TP
 .BR barrier=0 " / "  barrier=1 "
 This enables/disables barriers.  barrier=0 disables it, barrier=1 enables it.
 Write barriers enforce proper on-disk ordering of journal commits, making
@@ -1541,7 +1548,7 @@ incorporates scalability and reliability enhancements for supporting large
 filesystem.
 
 The options
-.B journal_dev, noload, data, commit, orlov, oldalloc, [no]user_xattr
+.B journal_dev, norecovery, noload, data, commit, orlov, oldalloc, [no]user_xattr
 .B [no]acl, bsddf, minixdf, debug, errors, data_err, grpid, bsdgroups, nogrpid
 .B sysvgroups, resgid, resuid, sb, quota, noquota, grpquota, usrquota
 .B usrjquota, grpjquota and jqfmt
@@ -1637,6 +1644,17 @@ operation is committed.  This provides roughly the same level of guarantees as
 ext3, and avoids the "zero-length" problem that can happen when a system
 crashes before the delayed allocation blocks are forced to disk.
 .TP
+.BR noinit_itable
+Do not initialize any uninitialized inode table blocks in the background. This
+feature may be used by installation CD's so that the install process can
+complete as quickly as possible; the inode table initialization process would
+then be deferred until the next time the filesystem is mounted.
+.TP
+.BR init_itable=n
+The lazy itable init code will wait n times the number of milliseconds it took
+to zero out the previous block group's inode table. This minimizes the impact on
+the system performance while filesystem's inode table is being initialized.
+.TP
 .BR discard / nodiscard
 Controls whether ext4 should issue discard/TRIM commands to the underlying
 block device when blocks are freed.  This is useful for SSD devices and
@@ -1648,12 +1666,6 @@ Disables 32-bit UIDs and GIDs.  This is for
 interoperability  with  older kernels which only
 store and expect 16-bit values.
 .TP
-.BR resize
-Allows to resize filesystem to the end of the last
-existing block group, further resize has to be done
-with resize2fs either online, or offline. It can be
-used only with conjunction with remount.
-.TP
 .BR block_validity / noblock_validity
 This options allows to enables/disables the in-kernel facility for tracking
 filesystem metadata blocks within internal data structures. This allows multi-
@@ -1672,6 +1684,14 @@ Note that dioread_nolock code path is only used for extent-based files.
 Because of the restrictions this options comprises it is off by default
 (e.g. dioread_lock).
 .TP
+.BR max_dir_size_kb=n
+This limits the size of the directories so that any attempt to expand them
+beyond the specified limit in kilobytes will cause an ENOSPC error. This is
+useful in memory constrained environments, where a very large directory can
+cause severe performance problems or even provoke the Out Of Memory killer. (For
+example, if there is only 512mb memory available, a 176mb directory may
+seriously cramp the system's style).
+.TP
 .BR i_version
 Enable 64-bit inode version support. This option is off by default.
 
-- 
1.8.1.4

