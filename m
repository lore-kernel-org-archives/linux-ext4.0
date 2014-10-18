From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [RFC PATCH] block: make BLKZEROOUT invalidate page cache contents
Date: Fri, 17 Oct 2014 17:03:30 -0700
Message-ID: <20141018000330.GA13083@birch.djwong.org>
References: <20141015100257.GB30308@thunk.org>
 <yq1a94x7cw5.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Dave Chinner <david@fromorbit.com>,
	Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1a94x7cw5.fsf@sermon.lab.mkp.net>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

All right, how's this for a first stab at invalidating the page cache?  Since
userspace doesn't really have a good way to find out which behavior it'll get,
just define a new ioctl with the range in-parameters declared a little more
explicitly.

Userspace apps can either call the new BLKZEROOUT_INV ioctl by itself; failing
that, they can call either BLKZEROOUT* with O_DIRECT set on the fd; or if they
don't care for O_DIRECT, they can {fsync(); ioctl(BLKZEROOUT);
posix_fadvise(DONTNEED);}, keeping in mind that a future kernel could ignore
the DONTNEED.

(I'll fix discard/secdiscard in a similar fashion if this sticks.)

--D
---
The BLKZEROOUT ioctl behaves similarly to O_DIRECT writes in that the
writes are issued directly to disks without touching the page cache.
However, the ioctl neither requires O_DIRECT to be set on the file
descriptor (i.e. the fd can be in buffered mode) nor does it
invalidate the appropriate parts of the page cache.  Since it also
guarantees that future reads return zeroes, the broken cache coherency
gives the ioctl semantics that can trap unsuspecting users.

Therefore, try to invalidate the page cache entries for the zeroed
range, and set the user's length parameter to zero on success to show
that the kernel took care of the invalidation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 block/ioctl.c           |   29 +++++++++++++++++++++++------
 include/uapi/linux/fs.h |    1 +
 2 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index d6cda81..d3688c0 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -188,17 +188,33 @@ static int blk_ioctl_discard(struct block_device *bdev, uint64_t start,
 static int blk_ioctl_zeroout(struct block_device *bdev, uint64_t start,
 			     uint64_t len)
 {
+	int ret;
+	struct address_space *mapping;
+	uint64_t end = start + len - 1;
+
 	if (start & 511)
 		return -EINVAL;
 	if (len & 511)
 		return -EINVAL;
-	start >>= 9;
-	len >>= 9;
-
-	if (start + len > (i_size_read(bdev->bd_inode) >> 9))
+	if (end >= i_size_read(bdev->bd_inode))
 		return -EINVAL;
 
-	return blkdev_issue_zeroout(bdev, start, len, GFP_KERNEL);
+	mapping = bdev->bd_inode->i_mapping;
+	ret = filemap_fdatawrite_range(mapping, start, end);
+	if (ret)
+		goto out;
+	ret = filemap_fdatawait_range(mapping, start, end);
+	if (ret)
+		goto out;
+
+	ret = blkdev_issue_zeroout(bdev, start >> 9, len >> 9, GFP_KERNEL);
+	if (ret)
+		goto out;
+
+	ret = invalidate_inode_pages2_range(mapping, start >> PAGE_CACHE_SHIFT,
+					    end >> PAGE_CACHE_SHIFT);
+out:
+	return ret;
 }
 
 static int put_ushort(unsigned long arg, unsigned short val)
@@ -317,7 +333,8 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 		return blk_ioctl_discard(bdev, range[0], range[1],
 					 cmd == BLKSECDISCARD);
 	}
-	case BLKZEROOUT: {
+	case BLKZEROOUT:
+	case BLKZEROOUT_INV: {
 		uint64_t range[2];
 
 		if (!(mode & FMODE_WRITE))
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index ca1a11b..370b719 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -149,6 +149,7 @@ struct inodes_stat_t {
 #define BLKSECDISCARD _IO(0x12,125)
 #define BLKROTATIONAL _IO(0x12,126)
 #define BLKZEROOUT _IO(0x12,127)
+#define BLKZEROOUT_INV _IOR(0x12, 127, uint64_t[2])
 
 #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
 #define FIBMAP	   _IO(0x00,1)	/* bmap access */
