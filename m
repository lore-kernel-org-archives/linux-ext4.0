From: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH] ext4: Fix an incorrect comment about i_mutex
Date: Fri, 21 Dec 2012 11:24:58 -0800
Message-ID: <1323a2735a9106cf0fa1a6ffee938ce432aa085d.1356117764.git.luto@amacapital.net>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

i_mutex is not held when ->sync_file is called.

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 fs/ext4/fsync.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index be1d89f..8c15642 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -113,8 +113,6 @@ static int __sync_inode(struct inode *inode, int datasync)
  *
  * What we do is just kick off a commit and wait on it.  This will snapshot the
  * inode to disk.
- *
- * i_mutex lock is held when entering and exiting this function
  */
 
 int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
-- 
1.7.11.7
