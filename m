From: Andreas Dilger <adilger@sun.com>
Subject: Re: ext3 metaclustering performance numbers and updated patch
Date: Sat, 10 Nov 2007 00:52:54 -0700
Message-ID: <20071110075254.GL3966@webber.adilger.int>
References: <d9885f0f0711091733i374d33efq8704d01fbb67036@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Abhishek Rai <abhishekrai@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:39699 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbXKJHw4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 10 Nov 2007 02:52:56 -0500
Content-Disposition: inline
In-Reply-To: <d9885f0f0711091733i374d33efq8704d01fbb67036@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Nov 09, 2007  17:33 -0800, Abhishek Rai wrote:
> All measurements were taken 10 times or more until standard deviation
> was <2%. Machine was rebooted between runs and file system freshly
> formatted, also we made sure that there was nothing running on the
> machine at the time of the test.
> 
> RAM: 8GB
> Disk: 400GB disk.
> CPU: Dual core hyperthreaded
>
> Notation:
> - 'vanilla': regular ext3 without any changes
> - 'mc': metaclustering ext3
> 
> Benchmark 1: Sequential write to a 10GB file followed by 'sync'
> 1. vanilla:
>    Total: 3m9.0s
>    User: 0.08
>    System: 23s-48s (very high variance)
> 2. mc:
>    Total: 3m6.1s
>    User: 0.08s
>    System: 48.1s
[snip similar results]
> Benchmark 5: fsck
> Description: Prepare a newly formated 400GB disk as follows: create
> 200 files of 0.5GB each, 100 files of 1GB each, 40 files of 2.5GB ech,
> and 10 files of 10GB each. fsck command line: fsck -f -n
> 1. vanilla:
>    Total: 12m18.1s
>    User: 15.9s
>    System: 18.3s
> 2. mc:
>    Total: 4m47.0s
>    User: 16.0s
>    System: 17.1s

The fsck improvement is quite impressive.

Do you have any benchmarks with small files 64kB-1MB in size
(e.g. kernbench or mongo)?  I'm wondering if there are any drawbacks
from the metaclustering block reservation of blocks if the files are
relatively small because of the extra seeking involved.

Also, it took me a while to determine whether the metacluster is
done on a per-group basis instead of per-file or per-filesystem.
It is counter-intuitive because the ext3_get_metacluster_range()
function only takes the superblock as a parameter and not e.g. the
group or inode number.

> In comparison, approaches that optimize inode table reads or bitmap
> block reads deliver little performance gains on such disks with lots
> of data as they target only a small fraction of the total e2fsck
> latency. However, such approaches (e.g., uninit_groups), deliver
> substantial improvement for disks with little data, but e2fsck on such
> disks doesn't take "too long" anyway and hence may not be considered a
> serious issue in the first place.

Did you do a comparison of the metacluster code with extents?  That
should also improve the e2fsck time in a similar manner by virtue of
not needing as many (or any) indirect blocks.  In ideal allocation
cases a single extent can represent a whole block group of blocks,
and files up to 480MB might not even need any index blocks.

I understand you aren't very keen on changing the on-disk format, but
it would be interesting to compare the relative benefits of the two
on identical hardware.

I also suspect that using ext3_new_indirect_block() for extent
index blocks on large files would have a similar positive impact for
ext4 extents in the case where they are needed).

While your patch is fairly complex, I personally don't have a big objection
to it going into the kernel, but there was a lot of vocal opposition to
ext3 changes in the past so you may have an uphill battle with other
kernel developers.

> @@ -1713,6 +1783,161 @@ ext3_fsblk_t ext3_new_block(handle_t *ha
> +int ext3_new_indirect_blocks(handle_t *handle, struct inode *inode,
> +			unsigned long group_no, unsigned long *count,
> +			ext3_fsblk_t new_blocks[])
> +{
> +	if (err && err != -ENOSPC)
> +		printk("ext3_new_indirect_blocks: error %d", err);

Should this be an ext3_error() instead of a printk() or do all of the
functions that generate errors already call ext3_error()?  If there is
a good reason NOT to make it an ext3_error() you are missing a KERN_*
error level.

> +typedef struct {
> +	__le32	*p;
> +	__le32	key;
> +	struct buffer_head *bh;
> +} Indirect;

Typedefs are frowned upon in Linux kernel code.

> @@ -233,12 +255,6 @@ no_delete:
> -typedef struct {
> -	__le32	*p;
> -	__le32	key;
> -	struct buffer_head *bh;
> -} Indirect;

Though, hmm, it seems you didn't invent this yourself...

> -static ext3_fsblk_t ext3_find_near(struct inode *inode, Indirect *ind)
> +static inline ext3_fsblk_t ext3_find_near(struct inode *inode, Indirect *ind)

Function is much too large to inline, even if it has just a single callsite.

> +/*
> + * ext3_read_indblocks_async --
> + *      Synchronously read at most count indirect blocks listed in
> + *      ind_blocks[]. This function calls ext3_read_indblocks_async() to do all
> + *      the hard work. It waits for read to complete on first_bh before
> + *      returning.
> +static int ext3_read_indblocks_sync(struct super_block *sb,

Comment function name does not match actual function name.

> + * ext3_get_metacluster_range:
> + *
> + * 	Determines metacluster block range for all block groups of the file
> + * 	system. Number of metacluster blocks:
> + *	= 2 * (blocks_per_group / block_pointers_per_metablock)
> + *	= 2 * (blocks_per_group / (block_size / 4))
> + *	= (8 * blocks_per_group) / block_size

This works out to 64 blocks for a default-formatted 4kB filesystem.
Do you have any stats from your previous testing on what the average
number of indirect blocks/group is?  For large files (> 8MB or so)
I suspect the above will be sufficient, but for small files (< 2MB)
this wouldn't be enough as the indirect blocks will not be filled.
I guess it isn't harmful in the case where these reserved blocks run
out...

> +ext3_get_metacluster_range(struct super_block *sb,
> +				ext3_grpblk_t *mc_start,
> +				ext3_grpblk_t *mc_end)	/* exclusive */
> +{
> +	*mc_start = EXT3_BLOCKS_PER_GROUP(sb) / 2;

Have you tested with mc_start right after the inode table?  For e2fsck
that might be slightly better positioning as it could potentially be
read into cache without a seek, and it avoids breaking up the group in
the middle if you are creating large files.

Cheers, Andreas
--
Andreas Dilger
Sr. Software Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
