From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/2] dax: assert that i_rwsem is held exclusive for writes
Date: Tue, 10 Jan 2017 16:48:08 +0100
Message-ID: <1484063288-18255-3-git-send-email-hch@lst.de>
References: <1484063288-18255-1-git-send-email-hch@lst.de>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-nvdimm@lists.01.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1484063288-18255-1-git-send-email-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Make sure all callers follow the same locking protocol, given that DAX
transparantly replaced the normal buffered I/O path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/dax.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 5c74f60..04734da 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1061,8 +1061,12 @@ dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
 	loff_t pos = iocb->ki_pos, ret = 0, done = 0;
 	unsigned flags = 0;
 
-	if (iov_iter_rw(iter) == WRITE)
+	if (iov_iter_rw(iter) == WRITE) {
+		lockdep_assert_held_exclusive(&inode->i_rwsem);
 		flags |= IOMAP_WRITE;
+	} else {
+		lockdep_assert_held(&inode->i_rwsem);
+	}
 
 	while (iov_iter_count(iter)) {
 		ret = iomap_apply(inode, pos, iov_iter_count(iter), flags, ops,
-- 
2.1.4

