From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/1] iomap: Direct I/O for inline data
Date: Fri, 29 Jun 2018 10:56:15 +0200
Message-ID: <20180629085614.GB16042@lst.de>
References: <20180627003906.15571-1-agruenba@redhat.com>
	<20180627003906.15571-2-agruenba@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cluster-devel@redhat.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
To: Andreas Gruenbacher <agruenba@redhat.com>
Return-path: <cluster-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180627003906.15571-2-agruenba@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/cluster-devel>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=subscribe>
Sender: cluster-devel-bounces@redhat.com
Errors-To: cluster-devel-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

This looks generally fine.  But I think it might be worth refactoring
iomap_dio_actor a bit first, e.g. something like this new patch
before yours, which would also nicely solve your alignmnet concern
(entirely untested for now):

---
>From f8c58ffe79df63d23332376ce481cdc4753cc567 Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Fri, 29 Jun 2018 10:54:10 +0200
Subject: iomap: refactor iomap_dio_actor

Split the function up into two helpers for the bio based I/O and hole
case, and a small helper to call the two.  This separates the code a
little better in preparation for supporting I/O to inline data.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap.c | 88 ++++++++++++++++++++++++++++++++----------------------
 1 file changed, 52 insertions(+), 36 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index 7d1e9f45f098..f05c83773cbf 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -963,10 +963,9 @@ iomap_dio_zero(struct iomap_dio *dio, struct iomap *iomap, loff_t pos,
 }
 
 static loff_t
-iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
-		void *data, struct iomap *iomap)
+iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
+		struct iomap_dio *dio, struct iomap *iomap)
 {
-	struct iomap_dio *dio = data;
 	unsigned int blkbits = blksize_bits(bdev_logical_block_size(iomap->bdev));
 	unsigned int fs_block_size = i_blocksize(inode), pad;
 	unsigned int align = iov_iter_alignment(dio->submit.iter);
@@ -980,41 +979,27 @@ iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
 	if ((pos | length | align) & ((1 << blkbits) - 1))
 		return -EINVAL;
 
-	switch (iomap->type) {
-	case IOMAP_HOLE:
-		if (WARN_ON_ONCE(dio->flags & IOMAP_DIO_WRITE))
-			return -EIO;
-		/*FALLTHRU*/
-	case IOMAP_UNWRITTEN:
-		if (!(dio->flags & IOMAP_DIO_WRITE)) {
-			length = iov_iter_zero(length, dio->submit.iter);
-			dio->size += length;
-			return length;
-		}
+	if (iomap->type == IOMAP_UNWRITTEN) {
 		dio->flags |= IOMAP_DIO_UNWRITTEN;
 		need_zeroout = true;
-		break;
-	case IOMAP_MAPPED:
-		if (iomap->flags & IOMAP_F_SHARED)
-			dio->flags |= IOMAP_DIO_COW;
-		if (iomap->flags & IOMAP_F_NEW) {
-			need_zeroout = true;
-		} else {
-			/*
-			 * Use a FUA write if we need datasync semantics, this
-			 * is a pure data IO that doesn't require any metadata
-			 * updates and the underlying device supports FUA. This
-			 * allows us to avoid cache flushes on IO completion.
-			 */
-			if (!(iomap->flags & (IOMAP_F_SHARED|IOMAP_F_DIRTY)) &&
-			    (dio->flags & IOMAP_DIO_WRITE_FUA) &&
-			    blk_queue_fua(bdev_get_queue(iomap->bdev)))
-				use_fua = true;
-		}
-		break;
-	default:
-		WARN_ON_ONCE(1);
-		return -EIO;
+	}
+
+	if (iomap->flags & IOMAP_F_SHARED)
+		dio->flags |= IOMAP_DIO_COW;
+
+	if (iomap->flags & IOMAP_F_NEW) {
+		need_zeroout = true;
+	} else {
+		/*
+		 * Use a FUA write if we need datasync semantics, this
+		 * is a pure data IO that doesn't require any metadata
+		 * updates and the underlying device supports FUA. This
+		 * allows us to avoid cache flushes on IO completion.
+		 */
+		if (!(iomap->flags & (IOMAP_F_SHARED|IOMAP_F_DIRTY)) &&
+		    (dio->flags & IOMAP_DIO_WRITE_FUA) &&
+		    blk_queue_fua(bdev_get_queue(iomap->bdev)))
+			use_fua = true;
 	}
 
 	/*
@@ -1093,6 +1078,37 @@ iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
 	return copied;
 }
 
+static loff_t
+iomap_dio_hole_actor(loff_t length, struct iomap_dio *dio)
+{
+	length = iov_iter_zero(length, dio->submit.iter);
+	dio->size += length;
+	return length;
+}
+
+static loff_t
+iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
+		void *data, struct iomap *iomap)
+{
+	struct iomap_dio *dio = data;
+
+	switch (iomap->type) {
+	case IOMAP_HOLE:
+		if (WARN_ON_ONCE(dio->flags & IOMAP_DIO_WRITE))
+			return -EIO;
+		return iomap_dio_hole_actor(length, dio);
+	case IOMAP_UNWRITTEN:
+		if (!(dio->flags & IOMAP_DIO_WRITE))
+			return iomap_dio_hole_actor(length, dio);
+		return iomap_dio_bio_actor(inode, pos, length, dio, iomap);
+	case IOMAP_MAPPED:
+		return iomap_dio_bio_actor(inode, pos, length, dio, iomap);
+	default:
+		WARN_ON_ONCE(1);
+		return -EIO;
+	}
+}
+
 /*
  * iomap_dio_rw() always completes O_[D]SYNC writes regardless of whether the IO
  * is being issued as AIO or not.  This allows us to optimise pure data writes
-- 
2.17.1
