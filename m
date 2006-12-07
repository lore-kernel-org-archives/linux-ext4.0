From: akpm@osdl.org
Subject: [patch 327/354] Update ext[23] mailing list address
Date: Wed, 06 Dec 2006 20:40:49 -0800
Message-ID: <200612070440.kB74enfU030251@shell0.pdx.osdl.net>
Cc: akpm@osdl.org, erik@harddisk-recovery.com,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:47454 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968761AbWLGEkx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Dec 2006 23:40:53 -0500
To: torvalds@osdl.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

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
