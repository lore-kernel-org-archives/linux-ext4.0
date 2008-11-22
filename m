From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fsck: ignore differing NEEDS_RECOVERY flag on backup sbs
Date: Sat, 22 Nov 2008 09:02:48 -0600
Message-ID: <49281F18.7080404@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:60565 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758206AbYKVPCv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 22 Nov 2008 10:02:51 -0500
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id mAMF2pQZ015851
	for <linux-ext4@vger.kernel.org>; Sat, 22 Nov 2008 10:02:51 -0500
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAMF2oAP013475
	for <linux-ext4@vger.kernel.org>; Sat, 22 Nov 2008 10:02:50 -0500
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id mAMF2nOU012817
	for <linux-ext4@vger.kernel.org>; Sat, 22 Nov 2008 10:02:49 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is for RH bugzilla 471925 -  Complete scan of filesystems expanded online

When we resize online, the primary superblock gets copied to all
the backups, and of course since we're mounted the NEEDS_RECOVERY
flag is set.  A subsequent fsck will find the backups have the
NEEDS_RECOVERY flag set while the primary does not, and this
forces a full fsck pass.

I think this flag can be safely ignored in the flag comparisons.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: e2fsprogs/e2fsck/super.c
===================================================================
--- e2fsprogs.orig/e2fsck/super.c	2008-11-22 07:54:47.000000000 -0600
+++ e2fsprogs/e2fsck/super.c	2008-11-22 08:59:45.953060973 -0600
@@ -860,7 +860,8 @@ void check_super_block(e2fsck_t ctx)
  * try to discourage it in the future.  In particular, for the newer
  * ext4 files, especially EXT4_FEATURE_RO_COMPAT_DIR_NLINK and
  * EXT3_FEATURE_INCOMPAT_EXTENTS.  So some of these may go away in the
- * future.
+ * future.  EXT3_FEATURE_INCOMPAT_RECOVER may also get set when
+ * copying the primary superblock during online resize.
  *
  * The kernel will set EXT2_FEATURE_COMPAT_EXT_ATTR, but
  * unfortunately, we shouldn't ignore it since if it's not set in the
@@ -869,7 +870,8 @@ void check_super_block(e2fsck_t ctx)
  */
 #define FEATURE_RO_COMPAT_IGNORE	(EXT2_FEATURE_RO_COMPAT_LARGE_FILE| \
 					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK)
-#define FEATURE_INCOMPAT_IGNORE		(EXT3_FEATURE_INCOMPAT_EXTENTS)
+#define FEATURE_INCOMPAT_IGNORE		(EXT3_FEATURE_INCOMPAT_EXTENTS| \
+					 EXT3_FEATURE_INCOMPAT_RECOVER)
 
 int check_backup_super_block(e2fsck_t ctx)
 {

