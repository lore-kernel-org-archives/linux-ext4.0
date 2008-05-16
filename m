From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 4/4] ext4: call blkdev_issue_flush on fsync
Date: Fri, 16 May 2008 14:09:56 -0500
Message-ID: <482DDC04.7020706@redhat.com>
References: <482DDA56.6000301@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jamie Lokier <jamie@shareable.org>
To: ext4 development <linux-ext4@vger.kernel.org>,
	linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <482DDA56.6000301@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

To ensure that bits are truly on-disk after an fsync,
we should call blkdev_issue_flush if barriers are supported.

Inspired by an old thread on barriers, by reiserfs & xfs
which do the same, and by a patch SuSE ships with their kernel

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/ext4/fsync.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 1c8ba48..a45c373 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -27,6 +27,7 @@
 #include <linux/sched.h>
 #include <linux/writeback.h>
 #include <linux/jbd2.h>
+#include <linux/blkdev.h>
 #include "ext4.h"
 #include "ext4_jbd2.h"
 
@@ -45,6 +46,7 @@
 int ext4_sync_file(struct file * file, struct dentry *dentry, int datasync)
 {
 	struct inode *inode = dentry->d_inode;
+	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
 	int ret = 0;
 
 	J_ASSERT(ext4_journal_current_handle() == NULL);
@@ -85,6 +87,8 @@ int ext4_sync_file(struct file * file, struct dentry *dentry, int datasync)
 			.nr_to_write = 0, /* sys_fsync did this */
 		};
 		ret = sync_inode(inode, &wbc);
+		if (journal && (journal->j_flags & JBD2_BARRIER))
+			blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
 	}
 out:
 	return ret;
-- 1.5.3.6

