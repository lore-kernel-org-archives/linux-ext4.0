From: akpm@osdl.org
Subject: - update-ext-mailing-list-address.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:17:17 -0800
Message-ID: <200612072317.kB7NHH9P030911@shell0.pdx.osdl.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53802 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163841AbWLGXRW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Dec 2006 18:17:22 -0500
To: erik@harddisk-recovery.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     Update ext[23] mailing list address
has been removed from the -mm tree.  Its filename was
     update-ext-mailing-list-address.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Update ext[23] mailing list address
From: Erik Mouw <erik@harddisk-recovery.com>

The ext[23] mailing list moved from sf.net to vger.kernel.org so update
the MAINTAINERS file.

Signed-off-by: Erik Mouw <erik@harddisk-recovery.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 MAINTAINERS |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff -puN MAINTAINERS~update-ext-mailing-list-address MAINTAINERS
--- a/MAINTAINERS~update-ext-mailing-list-address
+++ a/MAINTAINERS
@@ -1091,13 +1091,19 @@ M:	miku@iki.fi
 S:	Maintained
 
 EXT2 FILE SYSTEM
-L:	ext2-devel@lists.sourceforge.net
+L:	linux-ext4@vger.kernel.org
 S:	Maintained
 
 EXT3 FILE SYSTEM
 P:	Stephen Tweedie, Andrew Morton
 M:	sct@redhat.com, akpm@osdl.org, adilger@clusterfs.com
-L:	ext2-devel@lists.sourceforge.net
+L:	linux-ext4@vger.kernel.org
+S:	Maintained
+
+EXT4 FILE SYSTEM
+P:	Stephen Tweedie, Andrew Morton
+M:	sct@redhat.com, akpm@osdl.org, adilger@clusterfs.com
+L:	linux-ext4@vger.kernel.org
 S:	Maintained
 
 F71805F HARDWARE MONITORING DRIVER
@@ -1673,7 +1679,7 @@ S:	Supported
 JOURNALLING LAYER FOR BLOCK DEVICES (JBD)
 P:	Stephen Tweedie, Andrew Morton
 M:	sct@redhat.com, akpm@osdl.org
-L:	ext2-devel@lists.sourceforge.net
+L:	linux-ext4@vger.kernel.org
 S:	Maintained
 
 K8TEMP HARDWARE MONITORING DRIVER
_

Patches currently in -mm which might be from erik@harddisk-recovery.com are

origin.patch
