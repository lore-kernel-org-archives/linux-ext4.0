From: Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: [PATCH V4 8/8] Cleancache: ocfs2 hook for cleancache
Date: Mon, 30 Aug 2010 15:34:04 -0700
Message-ID: <20100830223404.GA1381__16008.8102952161$1283207811$gmane$org@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: chris.mason@oracle.com, viro@zeniv.linux.org.uk,
	akpm@linux-foundation.org, adilger@sun.com, tytso@mit.edu,
	mfasheh@suse.com, joel.becker@oracle.com, matthew@wil.cx,
	linux-btrfs@vger.
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:58621 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab0H3Wg1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Aug 2010 18:36:27 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[PATCH V4 8/8] Cleancache: ocfs2 hook for cleancache

Filesystems must explicitly enable cleancache by calling
cleancache_init_fs anytime a instance of the filesystem
is mounted and must save the returned poolid.  Ocfs2 is
currently the only user of the clustered filesystem
interface but nevertheless, the cleancache hooks in the
VFS layer are sufficient for ocfs2 including
the matching cleancache_flush_fs hook which must be
called on unmount.

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Acked-by: Joel Becker <joel.becker@oracle.com>

Diffstat:
 super.c                                  |    3 +++
 1 file changed, 3 insertions(+)

--- linux-2.6.36-rc3/fs/ocfs2/super.c	2010-08-29 09:36:04.000000000 -0600
+++ linux-2.6.36-rc3-cleancache/fs/ocfs2/super.c	2010-08-30 09:20:43.000000000 -0600
@@ -42,6 +42,7 @@
 #include <linux/seq_file.h>
 #include <linux/quotaops.h>
 #include <linux/smp_lock.h>
+#include <linux/cleancache.h>
 
 #define MLOG_MASK_PREFIX ML_SUPER
 #include <cluster/masklog.h>
@@ -2284,6 +2285,8 @@ static int ocfs2_initialize_super(struct
 		mlog_errno(status);
 		goto bail;
 	}
+	sb->cleancache_poolid =
+		cleancache_init_shared_fs((char *)&uuid_net_key, PAGE_SIZE);
 
 bail:
 	mlog_exit(status);
