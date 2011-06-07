From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] mount.8: remove reprecated bh/nobh options from the manual page
Date: Tue,  7 Jun 2011 15:13:44 +0200
Message-ID: <1307452424-1453-1-git-send-email-lczerner@redhat.com>
Cc: kzak@redhat.com, linux-ext4@vger.kernel.org,
	Lukas Czerner <lczerner@redhat.com>
To: util-linu-ng@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067Ab1FGNNv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Jun 2011 09:13:51 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Bh and nobh mount option has been deprecated in ext4
(206f7ab4f49a2021fcb8687f25395be77711ddee) and in ext3
(4c4d3901225518ed1a4c938ba15ba09842a00770)
so remove those options from documentation.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 mount/mount.8 |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/mount/mount.8 b/mount/mount.8
index e2d8666..5f97328 100644
--- a/mount/mount.8
+++ b/mount/mount.8
@@ -1273,9 +1273,6 @@ if it is a directory itself.
 .BR grpquota | noquota | quota | usrquota
 These options are accepted but ignored.
 .TP
-.BR nobh
-Do not attach buffer_heads to file pagecache. (Since 2.5.49.)
-.TP
 .BR nouid32
 Disables 32-bit UIDs and GIDs.  This is for interoperability with older
 kernels which only store and expect 16-bit values.
@@ -1400,9 +1397,7 @@ filesystem.
 The options
 .B journal_dev, noload, data, commit, orlov, oldalloc, [no]user_xattr
 .B [no]acl, bsddf, minixdf, debug, errors, data_err, grpid, bsdgroups, nogrpid
-.B sysvgroups, resgid, resuid, sb, quota, noquota, grpquota, usrquota
-and
-.B [no]bh
+.B sysvgroups, resgid, resuid, sb, quota, noquota, grpquota and usrquota
 are backwardly compatible with ext3 or ext2.
 .TP
 .BR journal_checksum
@@ -1527,11 +1522,11 @@ Controls whether or not ext4 should use the DIO read locking. If the
 dioread_nolock option is specified ext4 will allocate uninitialized extent
 before buffer write and convert the extent to initialized after IO completes.
 This approach allows ext4 code to avoid using inode mutex, which improves
-scalability on high speed storages. However this does not work with nobh option
-and the mount will fail. Nor does it work with data journaling and
-dioread_nolock option will be ignored with kernel warning. Note that
-dioread_nolock code path is only used for extent-based files.  Because of the
-restrictions this options comprises it is off by default (e.g. dioread_lock).
+scalability on high speed storages. However this does not work with data
+journaling and dioread_nolock option will be ignored with kernel warning.
+Note that dioread_nolock code path is only used for extent-based files.
+Because of the restrictions this options comprises it is off by default
+(e.g. dioread_lock).
 .TP
 .BR i_version
 Enable 64-bit inode version support. This option is off by default.
-- 
1.7.4.4

