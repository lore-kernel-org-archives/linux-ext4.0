From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 04/12 v2] xfs: pass LLONG_MAX to truncate_inode_pages_range
Date: Fri, 13 Jul 2012 15:19:07 +0200
Message-ID: <1342185555-21146-4-git-send-email-lczerner@redhat.com>
References: <1342185555-21146-1-git-send-email-lczerner@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, tytso@mit.edu,
	achender@linux.vnet.ibm.com, Lukas Czerner <lczerner@redhat.com>,
	Dave Chinner <dchinner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1342185555-21146-1-git-send-email-lczerner@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Currently we're passing -1 to truncate_inode_pages_range() which is
actually really confusing since the argument is signed so we do not get
"huge" number as one would expect, but rather just -1. To make things
clearer and easier for truncate_inode_pages_range() just pass LLONG_MAX
since it is actually what was intended anyway.

It also makes thing easier for allowing truncate_inode_pages_range() to
handle non page aligned regions. Moreover letting the lend argument to
be negative might actually hide some bugs.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Cc: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_fs_subr.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_fs_subr.c b/fs/xfs/xfs_fs_subr.c
index 652b875..6e9b052 100644
--- a/fs/xfs/xfs_fs_subr.c
+++ b/fs/xfs/xfs_fs_subr.c
@@ -34,7 +34,8 @@ xfs_tosspages(
 {
 	/* can't toss partial tail pages, so mask them out */
 	last &= ~(PAGE_SIZE - 1);
-	truncate_inode_pages_range(VFS_I(ip)->i_mapping, first, last - 1);
+	truncate_inode_pages_range(VFS_I(ip)->i_mapping, first,
+				   last == -1 ? LLONG_MAX : last);
 }
 
 int
@@ -53,7 +54,8 @@ xfs_flushinval_pages(
 	ret = filemap_write_and_wait_range(mapping, first,
 				last == -1 ? LLONG_MAX : last);
 	if (!ret)
-		truncate_inode_pages_range(mapping, first, last);
+		truncate_inode_pages_range(mapping, first,
+					   last == -1 ? LLONG_MAX : last);
 	return -ret;
 }
 
-- 
1.7.7.6

