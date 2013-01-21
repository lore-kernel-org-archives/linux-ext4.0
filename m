From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/6] block: Optionally snapshot page contents to
 provide stable pages during write
Date: Mon, 21 Jan 2013 15:12:23 +0100
Message-ID: <20130121141223.GJ5588@quack.suse.cz>
References: <20130119011231.20902.55954.stgit@blackbox.djwong.org>
 <20130119011301.20902.41628.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe@kernel.dk, lucho@ionkov.net, jack@suse.cz, ericvh@gmail.com,
	viro@zeniv.linux.org.uk, rminnich@sandia.gov, tytso@mit.edu,
	martin.petersen@oracle.com, neilb@suse.de, david@fromorbit.com,
	gnehzuil.liu@gmail.com, linux-kernel@vger.kernel.org,
	hch@infradead.org, linux-fsdevel@vger.kernel.org,
	Andy Lutomirski <luto@amacapital.net>,
	adilger.kernel@dilger.ca, bharrosh@panasas.com, jlayton@samba.org,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	hirofumi@mail.parknet.co.jp
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57534 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755285Ab3AUOM3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Jan 2013 09:12:29 -0500
Content-Disposition: inline
In-Reply-To: <20130119011301.20902.41628.stgit@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 18-01-13 17:13:01, Darrick J. Wong wrote:
> This provides a band-aid to provide stable page writes on jbd without needing
> to backport the fixed locking and page writeback bit handling schemes of jbd2.
> The band-aid works by using bounce buffers to snapshot page contents instead of
> waiting.
> 
> For those wondering about the ext3 bandage -- fixing the jbd locking (which was
> done as part of ext4dev years ago) is a lot of surgery, and setting
> PG_writeback on data pages when we actually hold the page lock dropped ext3
> performance by nearly an order of magnitude.  If we're going to migrate iscsi
> and raid to use stable page writes, the complaints about high latency will
> likely return.  We might as well centralize their page snapshotting thing to
> one place.
> 
> Tested-by: Andy Lutomirski <luto@amacapital.net>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
  The patch looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  arch/tile/Kconfig       |    6 ------
>  block/blk-core.c        |    8 +++++---
>  fs/ext3/super.c         |    1 +
>  include/uapi/linux/fs.h |    3 +++
>  mm/Kconfig              |   13 +++++++++++++
>  mm/bounce.c             |   48 +++++++++++++++++++++++++++++++++++++++++++----
>  mm/page-writeback.c     |    4 ++++
>  7 files changed, 70 insertions(+), 13 deletions(-)
> 
> 
> diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
> index 875d008..c671fda 100644
> --- a/arch/tile/Kconfig
> +++ b/arch/tile/Kconfig
> @@ -410,12 +410,6 @@ config TILE_USB
>  	  Provides USB host adapter support for the built-in EHCI and OHCI
>  	  interfaces on TILE-Gx chips.
>  
> -# USB OHCI needs the bounce pool since tilegx will often have more
> -# than 4GB of memory, but we don't currently use the IOTLB to present
> -# a 32-bit address to OHCI.  So we need to use a bounce pool instead.
> -config NEED_BOUNCE_POOL
> -	def_bool USB_OHCI_HCD
> -
>  source "drivers/pci/hotplug/Kconfig"
>  
>  endmenu
> diff --git a/block/blk-core.c b/block/blk-core.c
> index c973249..277134c 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1474,6 +1474,11 @@ void blk_queue_bio(struct request_queue *q, struct bio *bio)
>  	 */
>  	blk_queue_bounce(q, &bio);
>  
> +	if (bio_integrity_enabled(bio) && bio_integrity_prep(bio)) {
> +		bio_endio(bio, -EIO);
> +		return;
> +	}
> +
>  	if (bio->bi_rw & (REQ_FLUSH | REQ_FUA)) {
>  		spin_lock_irq(q->queue_lock);
>  		where = ELEVATOR_INSERT_FLUSH;
> @@ -1714,9 +1719,6 @@ generic_make_request_checks(struct bio *bio)
>  	 */
>  	blk_partition_remap(bio);
>  
> -	if (bio_integrity_enabled(bio) && bio_integrity_prep(bio))
> -		goto end_io;
> -
>  	if (bio_check_eod(bio, nr_sectors))
>  		goto end_io;
>  
> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> index 6e50223..4ba2683 100644
> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -2065,6 +2065,7 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
>  		test_opt(sb,DATA_FLAGS) == EXT3_MOUNT_JOURNAL_DATA ? "journal":
>  		test_opt(sb,DATA_FLAGS) == EXT3_MOUNT_ORDERED_DATA ? "ordered":
>  		"writeback");
> +	sb->s_flags |= MS_SNAP_STABLE;
>  
>  	return 0;
>  
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index 780d4c6..c7fc1e6 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -86,6 +86,9 @@ struct inodes_stat_t {
>  #define MS_KERNMOUNT	(1<<22) /* this is a kern_mount call */
>  #define MS_I_VERSION	(1<<23) /* Update inode I_version field */
>  #define MS_STRICTATIME	(1<<24) /* Always perform atime updates */
> +
> +/* These sb flags are internal to the kernel */
> +#define MS_SNAP_STABLE	(1<<27) /* Snapshot pages during writeback, if needed */
>  #define MS_NOSEC	(1<<28)
>  #define MS_BORN		(1<<29)
>  #define MS_ACTIVE	(1<<30)
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 278e3ab..7901d83 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -258,6 +258,19 @@ config BOUNCE
>  	def_bool y
>  	depends on BLOCK && MMU && (ZONE_DMA || HIGHMEM)
>  
> +# On the 'tile' arch, USB OHCI needs the bounce pool since tilegx will often
> +# have more than 4GB of memory, but we don't currently use the IOTLB to present
> +# a 32-bit address to OHCI.  So we need to use a bounce pool instead.
> +#
> +# We also use the bounce pool to provide stable page writes for jbd.  jbd
> +# initiates buffer writeback without locking the page or setting PG_writeback,
> +# and fixing that behavior (a second time; jbd2 doesn't have this problem) is
> +# a major rework effort.  Instead, use the bounce buffer to snapshot pages
> +# (until jbd goes away).  The only jbd user is ext3.
> +config NEED_BOUNCE_POOL
> +	bool
> +	default y if (TILE && USB_OHCI_HCD) || (BLK_DEV_INTEGRITY && JBD)
> +
>  config NR_QUICK
>  	int
>  	depends on QUICKLIST
> diff --git a/mm/bounce.c b/mm/bounce.c
> index 0420867..5f89017 100644
> --- a/mm/bounce.c
> +++ b/mm/bounce.c
> @@ -178,8 +178,45 @@ static void bounce_end_io_read_isa(struct bio *bio, int err)
>  	__bounce_end_io_read(bio, isa_page_pool, err);
>  }
>  
> +#ifdef CONFIG_NEED_BOUNCE_POOL
> +static int must_snapshot_stable_pages(struct request_queue *q, struct bio *bio)
> +{
> +	struct page *page;
> +	struct backing_dev_info *bdi;
> +	struct address_space *mapping;
> +	struct bio_vec *from;
> +	int i;
> +
> +	if (bio_data_dir(bio) != WRITE)
> +		return 0;
> +
> +	if (!bdi_cap_stable_pages_required(&q->backing_dev_info))
> +		return 0;
> +
> +	/*
> +	 * Based on the first page that has a valid mapping, decide whether or
> +	 * not we have to employ bounce buffering to guarantee stable pages.
> +	 */
> +	bio_for_each_segment(from, bio, i) {
> +		page = from->bv_page;
> +		mapping = page_mapping(page);
> +		if (!mapping)
> +			continue;
> +		bdi = mapping->backing_dev_info;
> +		return mapping->host->i_sb->s_flags & MS_SNAP_STABLE;
> +	}
> +
> +	return 0;
> +}
> +#else
> +static int must_snapshot_stable_pages(struct request_queue *q, struct bio *bio)
> +{
> +	return 0;
> +}
> +#endif /* CONFIG_NEED_BOUNCE_POOL */
> +
>  static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
> -			       mempool_t *pool)
> +			       mempool_t *pool, int force)
>  {
>  	struct page *page;
>  	struct bio *bio = NULL;
> @@ -192,7 +229,7 @@ static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
>  		/*
>  		 * is destination page below bounce pfn?
>  		 */
> -		if (page_to_pfn(page) <= queue_bounce_pfn(q))
> +		if (page_to_pfn(page) <= queue_bounce_pfn(q) && !force)
>  			continue;
>  
>  		/*
> @@ -270,6 +307,7 @@ static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
>  
>  void blk_queue_bounce(struct request_queue *q, struct bio **bio_orig)
>  {
> +	int must_bounce;
>  	mempool_t *pool;
>  
>  	/*
> @@ -278,13 +316,15 @@ void blk_queue_bounce(struct request_queue *q, struct bio **bio_orig)
>  	if (!bio_has_data(*bio_orig))
>  		return;
>  
> +	must_bounce = must_snapshot_stable_pages(q, *bio_orig);
> +
>  	/*
>  	 * for non-isa bounce case, just check if the bounce pfn is equal
>  	 * to or bigger than the highest pfn in the system -- in that case,
>  	 * don't waste time iterating over bio segments
>  	 */
>  	if (!(q->bounce_gfp & GFP_DMA)) {
> -		if (queue_bounce_pfn(q) >= blk_max_pfn)
> +		if (queue_bounce_pfn(q) >= blk_max_pfn && !must_bounce)
>  			return;
>  		pool = page_pool;
>  	} else {
> @@ -295,7 +335,7 @@ void blk_queue_bounce(struct request_queue *q, struct bio **bio_orig)
>  	/*
>  	 * slow path
>  	 */
> -	__blk_queue_bounce(q, bio_orig, pool);
> +	__blk_queue_bounce(q, bio_orig, pool, must_bounce);
>  }
>  
>  EXPORT_SYMBOL(blk_queue_bounce);
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 9c5af4d..75a13f3 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -2305,6 +2305,10 @@ void wait_for_stable_page(struct page *page)
>  
>  	if (!bdi_cap_stable_pages_required(bdi))
>  		return;
> +#ifdef CONFIG_NEED_BOUNCE_POOL
> +	if (mapping->host->i_sb->s_flags & MS_SNAP_STABLE)
> +		return;
> +#endif /* CONFIG_NEED_BOUNCE_POOL */
>  
>  	wait_on_page_writeback(page);
>  }
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
