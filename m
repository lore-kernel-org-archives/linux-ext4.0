From: Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: [PATCH V2 7/7] Cleancache (was Transcendent Memory): ocfs2 hook
Date: Fri, 28 May 2010 10:37:31 -0700
Message-ID: <20100528173731.GA20227__5934.80306347391$1275068444$gmane$org@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: chris.mason@oracle.com, viro@zeniv.linux.org.uk,
	akpm@linux-foundation.org, adilger@sun.com, tytso@mit.edu,
	mfasheh@suse.com, joel.becker@oracle.com, matthew@wil.cx,
	linux-btrfs@vger.
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:57933 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932946Ab0E1Rjl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 May 2010 13:39:41 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[PATCH V2 7/7] Cleancache (was Transcendent Memory): ocfs2 hook

Filesystems must explicitly enable cleancache.  Ocfs2 is
currently the only user of the clustered filesystem
interface but nevertheless, the cleancache hooks in the
VFS layer are sufficient for ocfs2.

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Acked-by: Joel Becker <joel.becker@oracle.com>

Diffstat:
 super.c                                  |    3 +++
 1 file changed, 3 insertions(+)

--- linux-2.6.34/fs/ocfs2/super.c	2010-05-16 15:17:36.000000000 -0600
+++ linux-2.6.34-cleancache/fs/ocfs2/super.c	2010-05-24 12:14:44.000000000 -0600
@@ -42,6 +42,7 @@
 #include <linux/seq_file.h>
 #include <linux/quotaops.h>
 #include <linux/smp_lock.h>
+#include <linux/cleancache.h>
 
 #define MLOG_MASK_PREFIX ML_SUPER
 #include <cluster/masklog.h>
@@ -2233,6 +2234,8 @@ static int ocfs2_initialize_super(struct
 		mlog_errno(status);
 		goto bail;
 	}
+	sb->cleancache_poolid =
+		cleancache_init_shared_fs((char *)&uuid_net_key, PAGE_SIZE);
 
 bail:
 	mlog_exit(status);
