From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Avoid lock inversion between
	i_mmap_mutex and transaction start
Date: Fri, 10 Oct 2014 16:23:13 +0200
Message-ID: <1412951028-4085-9-git-send-email-jack@suse.cz>
References: <1412951028-4085-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
        tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>,
        Mark Fasheh <mfasheh@suse.com>, Dave Chinner <david@fromorbit.com>,
        reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com,
        cluster-devel@redhat.com, Jan Kara <jack@suse.cz>,
        linux-ext4@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>,
        ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk
To: linux-fsdevel@vger.kernel.org
Return-path: <ocfs2-devel-bounces@oss.oracle.com>
In-Reply-To: <1412951028-4085-1-git-send-email-jack@suse.cz>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
List-Id: linux-ext4.vger.kernel.org

When DAX is enabled, it uses i_mmap_mutex as a protection against
truncate during page fault. This inevitably forces i_mmap_mutex to rank
outside of a transaction start and thus we have to avoid calling
pagecache purging operations when transaction is started.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8a064734e6eb..494a8645d63e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3631,13 +3631,19 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
 	if (IS_SYNC(inode))
 		ext4_handle_sync(handle);
 
-	/* Now release the pages again to reduce race window */
+	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
+	ext4_mark_inode_dirty(handle, inode);
+	ext4_journal_stop(handle);
+
+	/*
+	 * Now release the pages again to reduce race window. This has to happen
+	 * outside of a transaction to avoid lock inversion on i_mmap_mutex
+	 * when DAX is enabled.
+	 */
 	if (last_block_offset > first_block_offset)
 		truncate_pagecache_range(inode, first_block_offset,
 					 last_block_offset);
-
-	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
-	ext4_mark_inode_dirty(handle, inode);
+	goto out_dio;
 out_stop:
 	ext4_journal_stop(handle);
 out_dio:
-- 
1.8.1.4
