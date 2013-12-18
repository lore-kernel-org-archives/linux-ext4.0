From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH v3 0/3] Add XIP support to ext4
Date: Wed, 18 Dec 2013 08:22:34 -0700
Message-ID: <20131218152234.GB9207@parisc-linux.org>
References: <cover.1387307259.git.matthew.r.wilcox@intel.com> <20131217223050.GB20579@dastard> <20131218023143.GA24491@parisc-linux.org> <20131218123319.GH31386@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131218123319.GH31386@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Dec 18, 2013 at 11:33:19PM +1100, Dave Chinner wrote:
> That's something that happens with a mmap page fault. I'm talking
> about read(2) calls which end up in xip_file_read() ->
> do_xip_mapping_read().

*light goes on*!  Thank you!  I'll spin up a patch to fix that.

One approach would be grabbing the i_mmap_mutex while we copy the data
to userspace.  That's not great from a scalability point of view, and I
think there's a great need to ensure we can't deadlock against a fault
(eg the classic read() into an mmap() of the same file), but I think
it's doable.

> There needs to be serialisation against truncate provided in some
> way, and that's what the page cache page locks provide non-XIP
> buffered read paths. We don't have them in the XIP infrastructure,
> and so there's a problem here.
> 
> Holding the i_mutex is not sufficient, as the locks that need to be
> held to provide this serialisation are owned by the filesystems, not
> the generic code. Hence XIP needs to use the normal .aio_read path
> and have the filesystems call do_xip_mapping_read() when the
> appropriate locks have been gained.
> 
> And, in fact, the XIP write(2) path needs to go through filesystems
> to be locked correctly just like the read path. Buffered writes need
> to be serialised against reads and other filesystem operations, and
> holding the i_mutex is not sufficient for that purpose - again, the
> locks tha tneed to be held are defined by the filesystem, not the
> XIP infrastructure....

I see, I see ... I'm going to have to think about this some more.

> The only saving grace is that XIP is so old it doesn't use the
> multi-block mapping code that all filesystems now provide to
> mpage_readpages(), and so once the blocks have been removed from the
> inode the mapping.

I think maybe you lost some words from that final sentence?  I have patches
that attempt to make the XIP code work in larger quantities than single
pages, so that's in progress.

> Like I said, the XIP code is needs a heap of infrastructure work
> before we can hook a modern filesystem up to it in a sane way.

Oh, I quite agree.  I was just so focused on the problems with mmap vs
truncate I didn't stop to consider the problems with read vs truncate.
I assumed the original designers had covered that (and in fairness,
maybe they did, but it got broken at some point in the last eight years).

> (*) As a side issue, the XIP ext4 block mapping code now has a call
> chain that looks like:
> 
> ext4_xip_get_mem
>   __ext4_get_block
>     ext4_get_block
>       _ext4_get_block
>         ....
> 
> You might want to have a think about some of the names and
> abstractions being used, because naming like that is going to make
> reading stack traces from kernels compiled without frame pointers
> a nightmare....

Yeah, I already took care of that in my tree ... just didn't get round
to postng it yet, plus as it stands it depends (purely textually) on
some other patches.

commit 7983604d53b5925aa2741beec05622266c4fbb9e
Author: Matthew Wilcox <matthew.r.wilcox@intel.com>
Date:   Tue Dec 17 15:47:38 2013 -0500

    ext2,ext4: Inline __ext*_get_block into ext*_get_xip_mem
    
    __ext*_get_block each only have one caller, and it's easier to read
    the code when they're inlined into their caller.
    
    Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>

diff --git a/fs/ext2/xip.c b/fs/ext2/xip.c
index fa40091..0ea6475 100644
--- a/fs/ext2/xip.c
+++ b/fs/ext2/xip.c
@@ -22,27 +22,6 @@ static inline long __inode_direct_access(struct inode *inode, sector_t block,
 	return ops->direct_access(bdev, sector, kaddr, pfn, size);
 }
 
-static inline int
-__ext2_get_block(struct inode *inode, pgoff_t pgoff, int create,
-		   sector_t *result)
-{
-	struct buffer_head tmp;
-	int rc;
-
-	memset(&tmp, 0, sizeof(struct buffer_head));
-	tmp.b_size = 1 << inode->i_blkbits;
-	rc = ext2_get_block(inode, pgoff, &tmp, create);
-	*result = tmp.b_blocknr;
-
-	/* did we get a sparse block (hole in the file)? */
-	if (!tmp.b_blocknr && !rc) {
-		BUG_ON(create);
-		rc = -ENODATA;
-	}
-
-	return rc;
-}
-
 int
 ext2_clear_xip_target(struct inode *inode, sector_t block)
 {
@@ -73,15 +52,22 @@ void ext2_xip_verify_sb(struct super_block *sb)
 int ext2_get_xip_mem(struct address_space *mapping, pgoff_t pgoff, int create,
 				void **kmem, unsigned long *pfn)
 {
+	struct inode *inode = mapping->host;
+	struct buffer_head bh;
 	long rc;
-	sector_t block;
 
-	/* first, retrieve the sector number */
-	rc = __ext2_get_block(mapping->host, pgoff, create, &block);
+	/* Convert file offset to block number */
+	memset(&bh, 0, sizeof(bh));
+	bh.b_size = 1 << inode->i_blkbits;
+	rc = ext2_get_block(inode, pgoff, &bh, create);
 	if (rc)
 		return rc;
+	if (!buffer_mapped(&bh)) {
+		BUG_ON(create);
+		return -ENODATA;
+	}
 
 	/* retrieve address of the target data */
-	rc = __inode_direct_access(mapping->host, block, kmem, pfn, PAGE_SIZE);
+	rc = __inode_direct_access(inode, bh.b_blocknr, kmem, pfn, PAGE_SIZE);
 	return (rc < 0) ? rc : 0;
 }
diff --git a/fs/ext4/xip.c b/fs/ext4/xip.c
index 0868a40..0192f20 100644
--- a/fs/ext4/xip.c
+++ b/fs/ext4/xip.c
@@ -22,27 +22,6 @@ static inline long __inode_direct_access(struct inode *inode, sector_t block,
 	return ops->direct_access(bdev, sector, kaddr, pfn, size);
 }
 
-static inline int
-__ext4_get_block(struct inode *inode, pgoff_t pgoff, int create,
-		   sector_t *result)
-{
-	struct buffer_head bh;
-	int rc;
-
-	memset(&bh, 0, sizeof(bh));
-	bh.b_size = inode->i_sb->s_blocksize;
-	rc = ext4_get_block(inode, pgoff, &bh, create);
-	*result = bh.b_blocknr;
-
-	/* did we get a sparse block (hole in the file)? */
-	if (!rc && !buffer_mapped(&bh)) {
-		BUG_ON(create);
-		rc = -ENODATA;
-	}
-
-	return rc;
-}
-
 int ext4_clear_xip_target(struct inode *inode, sector_t block)
 {
 	void *kaddr;
@@ -59,15 +38,22 @@ int ext4_clear_xip_target(struct inode *inode, sector_t block)
 int ext4_get_xip_mem(struct address_space *mapping, pgoff_t pgoff, int create,
 				void **kmem, unsigned long *pfn)
 {
+	struct inode *inode = mapping->host;
+	struct buffer_head bh;
 	long rc;
-	sector_t block;
 
-	/* first, retrieve the sector number */
-	rc = __ext4_get_block(mapping->host, pgoff, create, &block);
+	/* Convert file offset to block number */
+	memset(&bh, 0, sizeof(bh));
+	bh.b_size = inode->i_sb->s_blocksize;
+	rc = ext4_get_block(inode, pgoff, &bh, create);
 	if (rc)
 		return rc;
+	if (!buffer_mapped(&bh)) {
+		BUG_ON(create);
+		return -ENODATA;
+	}
 
 	/* retrieve address of the target data */
-	rc = __inode_direct_access(mapping->host, block, kmem, pfn, PAGE_SIZE);
+	rc = __inode_direct_access(inode, bh.b_blocknr, kmem, pfn, PAGE_SIZE);
 	return (rc < 0) ? rc : 0;
 }

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
