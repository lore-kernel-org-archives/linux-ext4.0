From: Jan Kara <jack@suse.cz>
Subject: [PATCH 4/8] xfs: Move ilock before transaction start in xfs_setattr_size()
Date: Fri, 20 Jan 2012 21:34:42 +0100
Message-ID: <1327091686-23177-5-git-send-email-jack@suse.cz>
References: <1327091686-23177-1-git-send-email-jack@suse.cz>
Cc: Eric Sandeen <sandeen@sandeen.net>,
	Dave Chinner <dchinner@redhat.com>,
	Surbhi Palande <csurbhi@gmail.com>,
	Kamal Mostafa <kamal@canonical.com>,
	Christoph Hellwig <hch@infradead.org>,
	LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1327091686-23177-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

In xfs we first take ilock and start transaction afterwards. We should obey
this order in all places because otherwise we can create the following deadlock
with filesystem freezing: One process holds ilock and blocks on s_frozen ==
SB_FREEZE_TRANS in xfs_trans_alloc(), another process has a transaction started
(thus blocking freezing) and blocks on ilock. So we have to take ilock earlier
in xfs_setattr_size().

CC: Ben Myers <bpm@sgi.com>
CC: Alex Elder <elder@kernel.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_iops.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 23ce927..3579bc8 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -850,6 +850,9 @@ xfs_setattr_size(
 	if (error)
 		goto out_unlock;
 
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	lock_flags |= XFS_ILOCK_EXCL;
+
 	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_SIZE);
 	error = xfs_trans_reserve(tp, 0, XFS_ITRUNCATE_LOG_RES(mp), 0,
 				 XFS_TRANS_PERM_LOG_RES,
@@ -860,9 +863,6 @@ xfs_setattr_size(
 	truncate_setsize(inode, iattr->ia_size);
 
 	commit_flags = XFS_TRANS_RELEASE_LOG_RES;
-	lock_flags |= XFS_ILOCK_EXCL;
-
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
 
 	xfs_trans_ijoin(tp, ip, 0);
 
-- 
1.7.1
