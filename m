From: Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: [PATCH V3 7/8] Cleancache: ext4 hook for cleancache
Date: Mon, 21 Jun 2010 16:21:40 -0700
Message-ID: <20100621232140.GA27990__37650.8255642422$1277162659$gmane$org@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: chris.mason@oracle.com, viro@zeniv.linux.org.uk,
	akpm@linux-foundation.org, adilger@sun.com, tytso@mit.edu,
	mfasheh@suse.com, joel.becker@oracle.com, matthew@wil.cx,
	linux-btrfs@vger.
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:48795 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758343Ab0FUXXX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Jun 2010 19:23:23 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[PATCH V3 7/8] Cleancache: ext4 hook for cleancache

Filesystems must explicitly enable cleancache by calling
cleancache_init_fs anytime a instance of the filesystem
is mounted and must save the returned poolid.  For ext4,
all other cleancache hooks are in the VFS layer including
the matching cleancache_flush_fs hook which must be
called on unmount.

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Acked-by: Andreas Dilger <adilger@sun.com>

Diffstat:
 super.c                                  |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.35-rc2/fs/ext4/super.c	2010-06-05 21:43:24.000000000 -0600
+++ linux-2.6.35-rc2-cleancache/fs/ext4/super.c	2010-06-11 09:01:37.000000000 -0600
@@ -39,6 +39,7 @@
 #include <linux/ctype.h>
 #include <linux/log2.h>
 #include <linux/crc16.h>
+#include <linux/cleancache.h>
 #include <asm/uaccess.h>
 
 #include "ext4.h"
@@ -1789,6 +1790,7 @@ static int ext4_setup_super(struct super
 			EXT4_INODES_PER_GROUP(sb),
 			sbi->s_mount_opt);
 
+	sb->cleancache_poolid = cleancache_init_fs(PAGE_SIZE);
 	return res;
 }
 
