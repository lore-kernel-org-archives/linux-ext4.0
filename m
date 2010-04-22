From: Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: Cleancache [PATCH 4/7] (was Transcendent Memory): ext3 hook
Date: Thu, 22 Apr 2010 06:28:49 -0700
Message-ID: <20100422132849.GA27333__42946.0894818932$1271943154$gmane$org@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: chris.mason@oracle.com, viro@zeniv.linux.org.uk,
	akpm@linux-foundation.org, adilger@sun.com, tytso@mit.edu,
	mfasheh@suse.com, joel.becker@oracle.com, matthew@wil.cx,
	linux-btrfs@vger.
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:30948 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774Ab0DVN3b (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Apr 2010 09:29:31 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

(Sorry for resend... Mail server DNS problems sending to some recipients)

Cleancache [PATCH 4/7] (was Transcendent Memory): ext3 hook

Filesystems must explicitly enable cleancache.  For ext3,
all other cleancache hooks are in the VFS layer.

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>

Diffstat:
 super.c                                  |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.34-rc5/fs/ext3/super.c	2010-04-19 17:29:56.000000000 -0600
+++ linux-2.6.34-rc5-cleancache/fs/ext3/super.c	2010-04-21 10:06:48.000000000 -0600
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
 
