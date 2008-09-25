From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 4/10] xfs: Fix error handling in	write_super_lockfs/unlockfs
Date: Thu, 25 Sep 2008 16:22:17 -0500
Message-ID: <48DC0109.7070608__28824.4647709236$1222377841$gmane$org@sandeen.net>
References: <20080922195637t-sato@mail.jp.nec.com> <20080922234120.GV5811@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Takashi Sato <t-sato@yk.jp.nec.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:59054 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906AbYIYVWh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Sep 2008 17:22:37 -0400
In-Reply-To: <20080922234120.GV5811@disturbed>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dave Chinner wrote:

> xfs_fs_log_dummy() currently is void because it had nowhere to
> return errors to. It silently throws away errors because of this.
> Hence the correct thing to do here is to fix xfs_fs_log_dummy()
> to return the errors it currently ignores. i.e. catch the errors
> from xfs_trans_reserve() and xfs_trans_commit() calls in
> xfs_fs_log_dummy().
>
> Cheers,
>
> Dave.
>   
Here's that part in case it's helpful :)  Feel free to roll it into
your patch.

-Eric

Make xfs_fs_log_dummy() return errors which can then be returned by
xfs_fs_lockfs(), once it is capable of doing so.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

---

Index: linux-2.6/fs/xfs/xfs_fsops.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_fsops.c	2008-08-04 15:30:31.000000000 -0500
+++ linux-2.6/fs/xfs/xfs_fsops.c	2008-09-25 16:16:46.916001110 -0500
@@ -589,17 +589,19 @@ out:
 	return 0;
 }
 
-void
+int
 xfs_fs_log_dummy(
 	xfs_mount_t	*mp)
 {
 	xfs_trans_t	*tp;
 	xfs_inode_t	*ip;
+	int		error = 0;
 
 	tp = _xfs_trans_alloc(mp, XFS_TRANS_DUMMY1);
-	if (xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES(mp), 0, 0, 0)) {
+	error = xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES(mp), 0, 0, 0);
+	if (error) {
 		xfs_trans_cancel(tp, 0);
-		return;
+		return error;
 	}
 
 	ip = mp->m_rootip;
@@ -609,9 +611,10 @@ xfs_fs_log_dummy(
 	xfs_trans_ihold(tp, ip);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	xfs_trans_set_sync(tp);
-	xfs_trans_commit(tp, 0);
+	error = xfs_trans_commit(tp, 0);
 
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return error;
 }
 
 int
Index: linux-2.6/fs/xfs/xfs_fsops.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_fsops.h	2008-06-05 13:44:24.000000000 -0500
+++ linux-2.6/fs/xfs/xfs_fsops.h	2008-09-25 16:16:58.303000603 -0500
@@ -25,6 +25,6 @@ extern int xfs_fs_counts(xfs_mount_t *mp
 extern int xfs_reserve_blocks(xfs_mount_t *mp, __uint64_t *inval,
 				xfs_fsop_resblks_t *outval);
 extern int xfs_fs_goingdown(xfs_mount_t *mp, __uint32_t inflags);
-extern void xfs_fs_log_dummy(xfs_mount_t *mp);
+extern int xfs_fs_log_dummy(xfs_mount_t *mp);
 
 #endif	/* __XFS_FSOPS_H__ */


