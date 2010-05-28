From: Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: [PATCH V2 4/7] Cleancache (was Transcendent Memory): ext3 hook
Date: Fri, 28 May 2010 10:36:31 -0700
Message-ID: <20100528173631.GA20080__35441.9054383927$1275068301$gmane$org@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: chris.mason@oracle.com, viro@zeniv.linux.org.uk,
	akpm@linux-foundation.org, adilger@Sun.COM, tytso@mit.edu,
	mfasheh@suse.com, joel.becker@oracle.com, matthew@wil.cx,
	linux-btrfs@vger.
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:54255 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888Ab0E1RhL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 May 2010 13:37:11 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[PATCH V2 4/7] Cleancache (was Transcendent Memory): ext3 hook

Filesystems must explicitly enable cleancache.  For ext3,
all other cleancache hooks are in the VFS layer.

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>

Diffstat:
 super.c                                  |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.34/fs/ext3/super.c	2010-05-16 15:17:36.000000000 -0600
+++ linux-2.6.34-cleancache/fs/ext3/super.c	2010-05-24 12:14:44.000000000 -0600
@@ -37,6 +37,7 @@
 #include <linux/quotaops.h>
 #include <linux/seq_file.h>
 #include <linux/log2.h>
+#include <linux/cleancache.h>
 
 #include <asm/uaccess.h>
 
@@ -1344,6 +1345,7 @@ static int ext3_setup_super(struct super
 	} else {
 		ext3_msg(sb, KERN_INFO, "using internal journal");
 	}
+	sb->cleancache_poolid = cleancache_init_fs(PAGE_SIZE);
 	return res;
 }
 
