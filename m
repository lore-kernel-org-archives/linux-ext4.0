From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 1/1] iomap: Direct I/O for inline data
Date: Wed, 27 Jun 2018 02:39:06 +0200
Message-ID: <20180627003906.15571-2-agruenba@redhat.com>
References: <20180627003906.15571-1-agruenba@redhat.com>
Cc: cluster-devel@redhat.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Return-path: <cluster-devel-bounces@redhat.com>
In-Reply-To: <20180627003906.15571-1-agruenba@redhat.com>
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

Add support for reading from and writing to inline data to iomap_dio_rw.
This saves filesystems from having to implement fallback code for this
case.

The inline data is actually cached in the inode, so the I/O is only
direct in the sense that it doesn't go through the page cache.  The same
alignment restrictions as to non-inline data apply.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/iomap.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/fs/iomap.c b/fs/iomap.c
index d393bb0c7384..74668b3ca2ed 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -1231,6 +1231,32 @@ iomap_dio_zero(struct iomap_dio *dio, struct iomap *iomap, loff_t pos,
 	return submit_bio(bio);
 }
 
+static loff_t iomap_dio_actor_inline(struct inode *inode, struct iomap_dio *dio,
+		struct iomap *iomap, loff_t pos, loff_t length)
+{
+	struct iov_iter *iter = dio->submit.iter;
+	size_t copied;
+
+	BUG_ON(pos + length > PAGE_SIZE - offset_in_page(iomap->inline_data));
+
+	if (dio->flags & IOMAP_DIO_WRITE) {
+		loff_t size = inode->i_size;
+
+		if (pos > size)
+			memset(iomap->inline_data + size, 0, pos - size);
+		copied = copy_from_iter(iomap->inline_data + pos, length, iter);
+		if (copied) {
+			if (pos + copied > size)
+				i_size_write(inode, pos + copied);
+			mark_inode_dirty(inode);
+		}
+	} else {
+		copied = copy_to_iter(iomap->inline_data + pos, length, iter);
+	}
+	dio->size += copied;
+	return copied;
+}
+
 static loff_t
 iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
 		void *data, struct iomap *iomap)
@@ -1281,6 +1307,8 @@ iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
 				use_fua = true;
 		}
 		break;
+	case IOMAP_INLINE:
+		return iomap_dio_actor_inline(inode, dio, iomap, pos, length);
 	default:
 		WARN_ON_ONCE(1);
 		return -EIO;
-- 
2.17.1
