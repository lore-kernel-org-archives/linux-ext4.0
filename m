From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 5/9] ext4: ext4_change_inode_journal_flag error handling
Date: Tue,  5 Sep 2017 16:35:37 -0600
Message-ID: <20170905223541.20594-6-ross.zwisler@linux.intel.com>
References: <20170905223541.20594-1-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
 Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org,
 stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>,
 linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170905223541.20594-1-ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-ext4.vger.kernel.org

Rework the error handling in ext4_change_inode_journal_flag() so that
multiple paths can re-use portions of the same cleanup code via gotos
instead of each path doing their own cleanup.  This will benefit later
patches that add more paths to this function that must be unwound on error.

Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
CC: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 fs/ext4/inode.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 864fb94..d218991 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5953,11 +5953,8 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 	if (val) {
 		down_write(&EXT4_I(inode)->i_mmap_sem);
 		err = filemap_write_and_wait(inode->i_mapping);
-		if (err < 0) {
-			up_write(&EXT4_I(inode)->i_mmap_sem);
-			ext4_inode_resume_unlocked_dio(inode);
-			return err;
-		}
+		if (err < 0)
+			goto out_unlock;
 	}
 
 	percpu_down_write(&sbi->s_journal_flag_rwsem);
@@ -5975,12 +5972,8 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 		ext4_set_inode_flag(inode, EXT4_INODE_JOURNAL_DATA);
 	else {
 		err = jbd2_journal_flush(journal);
-		if (err < 0) {
-			jbd2_journal_unlock_updates(journal);
-			percpu_up_write(&sbi->s_journal_flag_rwsem);
-			ext4_inode_resume_unlocked_dio(inode);
-			return err;
-		}
+		if (err < 0)
+			goto out_journal_unlock;
 		ext4_clear_inode_flag(inode, EXT4_INODE_JOURNAL_DATA);
 	}
 	ext4_set_aops(inode);
@@ -6009,6 +6002,15 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 	ext4_std_error(inode->i_sb, err);
 
 	return err;
+
+out_journal_unlock:
+	jbd2_journal_unlock_updates(journal);
+	percpu_up_write(&sbi->s_journal_flag_rwsem);
+out_unlock:
+	if (val)
+		up_write(&EXT4_I(inode)->i_mmap_sem);
+	ext4_inode_resume_unlocked_dio(inode);
+	return err;
 }
 
 static int ext4_bh_unmapped(handle_t *handle, struct buffer_head *bh)
-- 
2.9.5
