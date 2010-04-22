From: Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: Cleancache [PATCH 6/7] (was Transcendent Memory): ext4 hook
Date: Thu, 22 Apr 2010 06:29:29 -0700
Message-ID: <20100422132929.GA27380__44310.4333630346$1271943152$gmane$org@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: chris.mason@oracle.com, viro@zeniv.linux.org.uk,
	akpm@linux-foundation.org, adilger@sun.com, tytso@mit.edu,
	mfasheh@suse.com, joel.becker@oracle.com, matthew@wil.cx,
	linux-btrfs@vger.
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:33514 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688Ab0DVNbJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Apr 2010 09:31:09 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Cleancache [PATCH 6/7] (was Transcendent Memory): ext4 hook

Filesystems must explicitly enable cleancache.  For ext4,
all other cleancache hooks are in the VFS layer.

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>

Diffstat:
 super.c                                  |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.34-rc5/fs/ext4/super.c	2010-04-19 17:29:56.000000000 -0600
+++ linux-2.6.34-rc5-cleancache/fs/ext4/super.c	2010-04-21 10:13:00.000000000 -0600
@@ -39,6 +39,7 @@
 #include <linux/ctype.h>
 #include <linux/log2.h>
 #include <linux/crc16.h>
+#include <linux/cleancache.h>
 #include <asm/uaccess.h>
 
 #include "ext4.h"
@@ -1784,6 +1785,7 @@ static int ext4_setup_super(struct super
 			EXT4_INODES_PER_GROUP(sb),
 			sbi->s_mount_opt);
 
+	sb->cleancache_poolid = cleancache_init_fs(PAGE_SIZE);
 	return res;
 }
 
