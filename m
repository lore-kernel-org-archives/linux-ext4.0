From: akpm@osdl.org
Subject: + update-ext-mailing-list-address.patch added to -mm tree
Date: Mon, 04 Dec 2006 12:55:52 -0800
Message-ID: <200612042055.kB4KtqLh003237@shell0.pdx.osdl.net>
Cc: erik@harddisk-recovery.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:47262 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759496AbWLDVBa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Dec 2006 16:01:30 -0500
To: mm-commits@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     Update ext[23] mailing list address
has been added to the -mm tree.  Its filename is
     update-ext-mailing-list-address.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Update ext[23] mailing list address
From: Erik Mouw <erik@harddisk-recovery.com>

The ext[23] mailing list moved from sf.net to vger.kernel.org so update
the MAINTAINERS file.

Signed-off-by: Erik Mouw <erik@harddisk-recovery.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 MAINTAINERS |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN MAINTAINERS~update-ext-mailing-list-address MAINTAINERS
--- a/MAINTAINERS~update-ext-mailing-list-address
+++ a/MAINTAINERS
@@ -1121,13 +1121,13 @@ M:	miku@iki.fi
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
 S:	Maintained
 
 F71805F HARDWARE MONITORING DRIVER
@@ -1718,7 +1718,7 @@ S:	Supported
 JOURNALLING LAYER FOR BLOCK DEVICES (JBD)
 P:	Stephen Tweedie, Andrew Morton
 M:	sct@redhat.com, akpm@osdl.org
-L:	ext2-devel@lists.sourceforge.net
+L:	linux-ext4@vger.kernel.org
 S:	Maintained
 
 K8TEMP HARDWARE MONITORING DRIVER
_

Patches currently in -mm which might be from erik@harddisk-recovery.com are

fix-rescan_partitions-to-return-errors-properly.patch
update-ext-mailing-list-address.patch
