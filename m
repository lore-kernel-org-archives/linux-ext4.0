From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH-v3 4/6] vfs: add lazytime tracepoints for better debugging
Date: Tue, 25 Nov 2014 00:34:32 -0500
Message-ID: <1416893674-419-5-git-send-email-tytso@mit.edu>
References: <1416893674-419-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux btrfs Developers List <linux-btrfs@vger.kernel.org>,
	XFS Developers <xfs@oss.sgi.com>, Theodore Ts'o <tytso@mit.edu>
To: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1416893674-419-1-git-send-email-tytso@mit.edu>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/fs-writeback.c | 5 ++++-
 fs/inode.c        | 5 +++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index eb04277..cab2d6d 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -27,6 +27,7 @@
 #include <linux/backing-dev.h>
 #include <linux/tracepoint.h>
 #include <linux/device.h>
+#include <trace/events/fs.h>
 #include "internal.h"
 
 /*
@@ -1304,8 +1305,10 @@ static void flush_sb_dirty_time(struct super_block *sb)
 		iput(old_inode);
 		old_inode = inode;
 
-		if (dirty_time)
+		if (dirty_time) {
+			trace_fs_lazytime_flush(inode);
 			mark_inode_dirty(inode);
+		}
 		cond_resched();
 		spin_lock(&inode_sb_list_lock);
 	}
diff --git a/fs/inode.c b/fs/inode.c
index 34a443f..6319ead 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -20,6 +20,9 @@
 #include <linux/list_lru.h>
 #include "internal.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/fs.h>
+
 /*
  * Inode locking rules:
  *
@@ -544,6 +547,7 @@ static void evict(struct inode *inode)
 			mark_inode_dirty(inode);
 			inode->i_sb->s_op->write_inode(inode, &wbc);
 		}
+		trace_fs_lazytime_evict(inode);
 	}
 
 	if (!list_empty(&inode->i_wb_list))
@@ -1550,6 +1554,7 @@ static int update_time(struct inode *inode, struct timespec *time, int flags)
 			inode->i_state |= I_DIRTY_TIME;
 			spin_unlock(&inode->i_lock);
 			inode->i_ts_dirty_day = daycode;
+			trace_fs_lazytime_defer(inode);
 			return 0;
 		}
 	}
-- 
2.1.0

