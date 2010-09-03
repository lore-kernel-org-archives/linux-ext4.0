From: Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: [PATCH V5 7/8] Cleancache: ext4 hook for cleancache
Date: Fri, 3 Sep 2010 13:04:43 -0700
Message-ID: <20100903200443.GA4728__5948.15811277858$1283544452$gmane$org@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: chris.mason@oracle.com, viro@zeniv.linux.org.uk,
	akpm@linux-foundation.org, adilger@sun.com, tytso@mit.edu,
	mfasheh@suse.com, joel.becker@oracle.com, matthew@wil.cx,
	linux-btrfs@vger.
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:55160 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab0ICUHZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Sep 2010 16:07:25 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[PATCH V5 7/8] Cleancache: ext4 hook for cleancache

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

--- linux-2.6.36-rc3/fs/ext4/super.c	2010-08-29 09:36:04.000000000 -0600
+++ linux-2.6.36-rc3-cleancache/fs/ext4/super.c	2010-08-31 10:27:04.000000000 -0600
@@ -39,6 +39,7 @@
 #include <linux/ctype.h>
 #include <linux/log2.h>
 #include <linux/crc16.h>
+#include <linux/cleancache.h>
 #include <asm/uaccess.h>
 
 #include "ext4.h"
@@ -1849,6 +1850,7 @@ static int ext4_setup_super(struct super
 			EXT4_INODES_PER_GROUP(sb),
 			sbi->s_mount_opt);
 
+	cleancache_init_fs(sb);
 	return res;
 }
 
