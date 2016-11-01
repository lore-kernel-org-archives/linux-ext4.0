From: Jan Kara <jack@suse.cz>
Subject: [PATCH 02/11] ext4: Allow unaligned unlocked DAX IO
Date: Tue,  1 Nov 2016 22:06:12 +0100
Message-ID: <1478034381-19037-3-git-send-email-jack@suse.cz>
References: <1478034381-19037-1-git-send-email-jack@suse.cz>
Cc: Ted Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
        linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>,
        Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1478034381-19037-1-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Currently we don't allow unaligned writes without inode_lock. This is
because zeroing of partial blocks could cause data corruption for racing
unaligned writes to the same block. However DAX handles zeroing during
block allocation and thus zeroing of partial blocks cannot race. Allow
DAX unaligned IO to run without inode_lock.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index a6a7becb9465..55f8b922b76d 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -161,7 +161,8 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 
 	iocb->private = &overwrite;
 	/* Check whether we do a DIO overwrite or not */
-	if (o_direct && ext4_should_dioread_nolock(inode) && !unaligned_aio &&
+	if (((o_direct && !unaligned_aio) || IS_DAX(inode)) &&
+	    ext4_should_dioread_nolock(inode) &&
 	    ext4_overwrite_io(inode, iocb->ki_pos, iov_iter_count(from)))
 		overwrite = 1;
 
-- 
2.6.6

