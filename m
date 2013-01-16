From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/6] block: Optionally snapshot page contents to
 provide stable pages during write
Date: Wed, 16 Jan 2013 03:00:00 +0100
Message-ID: <20130116020000.GA25806@quack.suse.cz>
References: <20130115054235.1563.12967.stgit@blackbox.djwong.org>
 <20130115054305.1563.48197.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe@kernel.dk, lucho@ionkov.net, jack@suse.cz, ericvh@gmail.com,
	tytso@mit.edu, viro@zeniv.linux.org.uk, rminnich@sandia.gov,
	martin.petersen@oracle.com, neilb@suse.de, david@fromorbit.com,
	gnehzuil.liu@gmail.com, linux-kernel@vger.kernel.org,
	hch@infradead.org, linux-fsdevel@vger.kernel.org,
	Andy Lutomirski <luto@amacapital.net>,
	adilger.kernel@dilger.ca, bharrosh@panasas.com, jlayton@samba.org,
	linux-ext4@vger.kernel.org, hirofumi@mail.parknet.co.jp
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54963 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637Ab3APCAG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jan 2013 21:00:06 -0500
Content-Disposition: inline
In-Reply-To: <20130115054305.1563.48197.stgit@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 14-01-13 21:43:05, Darrick J. Wong wrote:
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
> ---
>  arch/tile/Kconfig       |    6 ------
>  block/blk-core.c        |    8 +++++---
>  fs/ext3/super.c         |    1 +
>  include/uapi/linux/fs.h |    1 +
>  mm/Kconfig              |   13 +++++++++++++
>  mm/bounce.c             |   47 +++++++++++++++++++++++++++++++++++++++++++----
>  mm/page-writeback.c     |    4 ++++
>  7 files changed, 67 insertions(+), 13 deletions(-)
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
  Umm, why did you move this hunk?

>  	if (bio_check_eod(bio, nr_sectors))
>  		goto end_io;

> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index 780d4c6..0144fbb 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -69,6 +69,7 @@ struct inodes_stat_t {
>  #define MS_REMOUNT	32	/* Alter flags of a mounted FS */
>  #define MS_MANDLOCK	64	/* Allow mandatory locks on an FS */
>  #define MS_DIRSYNC	128	/* Directory modifications are synchronous */
> +#define MS_SNAP_STABLE	256	/* Snapshot pages during writeback, if needed */
>  #define MS_NOATIME	1024	/* Do not update access times. */
>  #define MS_NODIRATIME	2048	/* Do not update directory access times */
>  #define MS_BIND		4096
  Please don't mix MS_SNAP_STABLE flag among flags passed by mount(2)
syscall. I think putting it at 1 << 27 might be acceptable. I remember
Al Viro saying something along the lines that kernel internal superblock
flags should be separated from those passed from userspace into a special
superblock entry but that's a different story I guess.

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
> index 0420867..a5b30f9 100644
> --- a/mm/bounce.c
> +++ b/mm/bounce.c
> @@ -178,8 +178,44 @@ static void bounce_end_io_read_isa(struct bio *bio, int err)
>  	__bounce_end_io_read(bio, isa_page_pool, err);
>  }
>  
> +#ifdef CONFIG_NEED_BOUNCE_POOL
> +static int must_snapshot_stable_pages(struct bio *bio)
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
> +		if (!bdi_cap_stable_pages_required(bdi))
> +			return 0;
> +		return mapping->host->i_sb->s_flags & MS_SNAP_STABLE;
> +	}
> +
> +	return 0;
> +}
  How about using q->backing_dev_info for the
bdi_cap_stable_pages_required() check? It will be a fast path and this check
will be faster..

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
