From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: [PATCH 01/11] ext4: Factor out checks from ext4_file_write_iter()
Date: Tue,  1 Nov 2016 22:06:11 +0100
Message-ID: <1478034381-19037-2-git-send-email-jack@suse.cz>
References: <1478034381-19037-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>,
 Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Ted Tso <tytso-3s7WtUTddSA@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
To: linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1478034381-19037-1-git-send-email-jack-AlSwsSmVLrQ@public.gmane.org>
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

Factor out checks of 'from' and whether we are overwriting out of
ext4_file_write_iter() so that the function is easier to follow.

Signed-off-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
---
 fs/ext4/file.c | 97 ++++++++++++++++++++++++++++++----------------------------
 1 file changed, 50 insertions(+), 47 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 2a822d30e73f..a6a7becb9465 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -88,6 +88,51 @@ ext4_unaligned_aio(struct inode *inode, struct iov_iter *from, loff_t pos)
 	return 0;
 }
 
+/* Is IO overwriting allocated and initialized blocks? */
+static bool ext4_overwrite_io(struct inode *inode, loff_t pos, loff_t len)
+{
+	struct ext4_map_blocks map;
+	unsigned int blkbits = inode->i_blkbits;
+	int err, blklen;
+
+	if (pos + len > i_size_read(inode))
+		return false;
+
+	map.m_lblk = pos >> blkbits;
+	map.m_len = EXT4_MAX_BLOCKS(len, pos, blkbits);
+	blklen = map.m_len;
+
+	err = ext4_map_blocks(NULL, inode, &map, 0);
+	/*
+	 * 'err==len' means that all of blocks has been preallocated no matter
+	 * they are initialized or not.  For excluding unwritten extents, we
+	 * need to check m_flags.
+	 */
+	return err == blklen && (map.m_flags & EXT4_MAP_MAPPED);
+}
+
+static ssize_t ext4_write_checks(struct kiocb *iocb, struct iov_iter *from)
+{
+	struct inode *inode = file_inode(iocb->ki_filp);
+	ssize_t ret;
+
+	ret = generic_write_checks(iocb, from);
+	if (ret <= 0)
+		return ret;
+	/*
+	 * If we have encountered a bitmap-format file, the size limit
+	 * is smaller than s_maxbytes, which is for extent-mapped files.
+	 */
+	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
+		struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+
+		if (iocb->ki_pos >= sbi->s_bitmap_maxbytes)
+			return -EFBIG;
+		iov_iter_truncate(from, sbi->s_bitmap_maxbytes - iocb->ki_pos);
+	}
+	return iov_iter_count(from);
+}
+
 static ssize_t
 ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 {
@@ -98,7 +143,7 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	ssize_t ret;
 
 	inode_lock(inode);
-	ret = generic_write_checks(iocb, from);
+	ret = ext4_write_checks(iocb, from);
 	if (ret <= 0)
 		goto out;
 
@@ -114,53 +159,11 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		ext4_unwritten_wait(inode);
 	}
 
-	/*
-	 * If we have encountered a bitmap-format file, the size limit
-	 * is smaller than s_maxbytes, which is for extent-mapped files.
-	 */
-	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
-		struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
-
-		if (iocb->ki_pos >= sbi->s_bitmap_maxbytes) {
-			ret = -EFBIG;
-			goto out;
-		}
-		iov_iter_truncate(from, sbi->s_bitmap_maxbytes - iocb->ki_pos);
-	}
-
 	iocb->private = &overwrite;
-	if (o_direct) {
-		size_t length = iov_iter_count(from);
-		loff_t pos = iocb->ki_pos;
-
-		/* check whether we do a DIO overwrite or not */
-		if (ext4_should_dioread_nolock(inode) && !unaligned_aio &&
-		    pos + length <= i_size_read(inode)) {
-			struct ext4_map_blocks map;
-			unsigned int blkbits = inode->i_blkbits;
-			int err, len;
-
-			map.m_lblk = pos >> blkbits;
-			map.m_len = EXT4_MAX_BLOCKS(length, pos, blkbits);
-			len = map.m_len;
-
-			err = ext4_map_blocks(NULL, inode, &map, 0);
-			/*
-			 * 'err==len' means that all of blocks has
-			 * been preallocated no matter they are
-			 * initialized or not.  For excluding
-			 * unwritten extents, we need to check
-			 * m_flags.  There are two conditions that
-			 * indicate for initialized extents.  1) If we
-			 * hit extent cache, EXT4_MAP_MAPPED flag is
-			 * returned; 2) If we do a real lookup,
-			 * non-flags are returned.  So we should check
-			 * these two conditions.
-			 */
-			if (err == len && (map.m_flags & EXT4_MAP_MAPPED))
-				overwrite = 1;
-		}
-	}
+	/* Check whether we do a DIO overwrite or not */
+	if (o_direct && ext4_should_dioread_nolock(inode) && !unaligned_aio &&
+	    ext4_overwrite_io(inode, iocb->ki_pos, iov_iter_count(from)))
+		overwrite = 1;
 
 	ret = __generic_file_write_iter(iocb, from);
 	inode_unlock(inode);
-- 
2.6.6
