From: Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v3 06/19] btrfs: convert to new i_version API
Date: Mon, 18 Dec 2017 10:11:43 -0500
Message-ID: <20171218151156.14565-7-jlayton@kernel.org>
References: <20171218151156.14565-1-jlayton@kernel.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org,
        linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org,
        jack-l3A5Bk7waGM@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org,
        adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org,
        linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, jbacik-b10kYP2dOMg@public.gmane.org,
        dsterba-IBi9RG/b67k@public.gmane.org, linux-integrity-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, dmitry.kasatkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
        linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        jaltman-hRzEac23uH1Wk0Htik3J/w@public.gmane.org
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171218151156.14565-1-jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/btrfs/delayed-inode.c | 7 +++++--
 fs/btrfs/file.c          | 1 +
 fs/btrfs/inode.c         | 7 +++++--
 fs/btrfs/ioctl.c         | 1 +
 fs/btrfs/tree-log.c      | 4 +++-
 fs/btrfs/xattr.c         | 1 +
 6 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 5d73f79ded8b..6a246ae2bcb2 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -18,6 +18,7 @@
  */
 
 #include <linux/slab.h>
+#include <linux/iversion.h>
 #include "delayed-inode.h"
 #include "disk-io.h"
 #include "transaction.h"
@@ -1700,7 +1701,8 @@ static void fill_stack_inode_item(struct btrfs_trans_handle *trans,
 	btrfs_set_stack_inode_nbytes(inode_item, inode_get_bytes(inode));
 	btrfs_set_stack_inode_generation(inode_item,
 					 BTRFS_I(inode)->generation);
-	btrfs_set_stack_inode_sequence(inode_item, inode->i_version);
+	btrfs_set_stack_inode_sequence(inode_item,
+				       inode_peek_iversion(inode));
 	btrfs_set_stack_inode_transid(inode_item, trans->transid);
 	btrfs_set_stack_inode_rdev(inode_item, inode->i_rdev);
 	btrfs_set_stack_inode_flags(inode_item, BTRFS_I(inode)->flags);
@@ -1754,7 +1756,8 @@ int btrfs_fill_inode(struct inode *inode, u32 *rdev)
 	BTRFS_I(inode)->generation = btrfs_stack_inode_generation(inode_item);
         BTRFS_I(inode)->last_trans = btrfs_stack_inode_transid(inode_item);
 
-	inode->i_version = btrfs_stack_inode_sequence(inode_item);
+	inode_set_iversion_queried(inode,
+				   btrfs_stack_inode_sequence(inode_item));
 	inode->i_rdev = 0;
 	*rdev = btrfs_stack_inode_rdev(inode_item);
 	BTRFS_I(inode)->flags = btrfs_stack_inode_flags(inode_item);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index eb1bac7c8553..c95d7b2efefb 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -31,6 +31,7 @@
 #include <linux/slab.h>
 #include <linux/btrfs.h>
 #include <linux/uio.h>
+#include <linux/iversion.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e1a7f3cb5be9..ac8692849a81 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -43,6 +43,7 @@
 #include <linux/posix_acl_xattr.h>
 #include <linux/uio.h>
 #include <linux/magic.h>
+#include <linux/iversion.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
@@ -3777,7 +3778,8 @@ static int btrfs_read_locked_inode(struct inode *inode)
 	BTRFS_I(inode)->generation = btrfs_inode_generation(leaf, inode_item);
 	BTRFS_I(inode)->last_trans = btrfs_inode_transid(leaf, inode_item);
 
-	inode->i_version = btrfs_inode_sequence(leaf, inode_item);
+	inode_set_iversion_queried(inode,
+				   btrfs_inode_sequence(leaf, inode_item));
 	inode->i_generation = BTRFS_I(inode)->generation;
 	inode->i_rdev = 0;
 	rdev = btrfs_inode_rdev(leaf, inode_item);
@@ -3945,7 +3947,8 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
 				     &token);
 	btrfs_set_token_inode_generation(leaf, item, BTRFS_I(inode)->generation,
 					 &token);
-	btrfs_set_token_inode_sequence(leaf, item, inode->i_version, &token);
+	btrfs_set_token_inode_sequence(leaf, item, inode_peek_iversion(inode),
+				       &token);
 	btrfs_set_token_inode_transid(leaf, item, trans->transid, &token);
 	btrfs_set_token_inode_rdev(leaf, item, inode->i_rdev, &token);
 	btrfs_set_token_inode_flags(leaf, item, BTRFS_I(inode)->flags, &token);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 2ef8acaac688..aa452c9e2eff 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -43,6 +43,7 @@
 #include <linux/uuid.h>
 #include <linux/btrfs.h>
 #include <linux/uaccess.h>
+#include <linux/iversion.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 7bf9b31561db..1b7d92075c1f 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -20,6 +20,7 @@
 #include <linux/slab.h>
 #include <linux/blkdev.h>
 #include <linux/list_sort.h>
+#include <linux/iversion.h>
 #include "tree-log.h"
 #include "disk-io.h"
 #include "locking.h"
@@ -3609,7 +3610,8 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
 	btrfs_set_token_inode_nbytes(leaf, item, inode_get_bytes(inode),
 				     &token);
 
-	btrfs_set_token_inode_sequence(leaf, item, inode->i_version, &token);
+	btrfs_set_token_inode_sequence(leaf, item,
+				       inode_peek_iversion(inode), &token);
 	btrfs_set_token_inode_transid(leaf, item, trans->transid, &token);
 	btrfs_set_token_inode_rdev(leaf, item, inode->i_rdev, &token);
 	btrfs_set_token_inode_flags(leaf, item, BTRFS_I(inode)->flags, &token);
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 2c7e53f9ff1b..5258c1714830 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -23,6 +23,7 @@
 #include <linux/xattr.h>
 #include <linux/security.h>
 #include <linux/posix_acl_xattr.h>
+#include <linux/iversion.h>
 #include "ctree.h"
 #include "btrfs_inode.h"
 #include "transaction.h"
-- 
2.14.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
