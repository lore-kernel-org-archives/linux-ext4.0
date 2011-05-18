From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: do not disable ext4 discards on first discard failure? [was: Re:
 dm snapshot: ignore discards issued to the snapshot-origin target]
Date: Wed, 18 May 2011 08:16:31 -0400
Message-ID: <20110518121631.GC18433@redhat.com>
References: <20110429122454.GL32370@agk-dp.fab.redhat.com>
 <alpine.LFD.2.00.1105020857030.3778@dhcp-27-109.brq.redhat.com>
 <20110502081308.GC8642@agk-dp.fab.redhat.com>
 <20110502081925.GA11312@infradead.org>
 <alpine.LFD.2.00.1105021217080.3778@dhcp-27-109.brq.redhat.com>
 <yq1bozl420p.fsf@sermon.lab.mkp.net>
 <alpine.LFD.2.00.1105021631590.3778@dhcp-27-109.brq.redhat.com>
 <yq1tydd2g5h.fsf@sermon.lab.mkp.net>
 <alpine.LFD.2.00.1105031036090.4250@dhcp-27-109.brq.redhat.com>
 <yq1wri6zel9.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lukas Czerner <lczerner@redhat.com>, sandeen@redhat.com,
	Christoph Hellwig <hch@infradead.org>,
	device-mapper development <dm-devel@redhat.com>,
	DarkNovaNick@gmail.com, linux-lvm@redhat.com,
	linux-ext4@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755576Ab1ERMQr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 May 2011 08:16:47 -0400
Content-Disposition: inline
In-Reply-To: <yq1wri6zel9.fsf@sermon.lab.mkp.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hey Martin,

On Wed, May 04 2011 at 11:10am -0400,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Lukas" == Lukas Czerner <lczerner@redhat.com> writes:
> 
> Lukas> Nevertheless there is something weird going on, because even when
> Lukas> I create striped volume I get this:
> 
> Could you please try the following patch? It has a bunch of small tweaks
> to the discard stack in it. I'll split it up before posting for real but
> I'd like to know if it fixes your issue...

Would be ideal to get these fixes staged for 2.6.40.

Do you intend to split these patches up and post for 2.6.40 inclussion?

Please advise, thanks!


> block/libata/scsi: Various logical block provisioning fixes
> 
>  - Add sysfs documentation for the discard topology parameters
> 
>  - Fix discard stacking problem
> 
>  - Switch our libata SAT over to using the WRITE SAME limits
> 
>  - UNMAP alignment needs to be converted to bytes
> 
>  - Only report alignment and zeroes_data if the device supports discard
> 
> Reported-by: Lukas Czerner <lczerner@redhat.com>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> 
> diff --git a/Documentation/ABI/testing/sysfs-block b/Documentation/ABI/testing/sysfs-block
> index 4873c75..c1eb41c 100644
> --- a/Documentation/ABI/testing/sysfs-block
> +++ b/Documentation/ABI/testing/sysfs-block
> @@ -142,3 +142,67 @@ Description:
>  		with the previous I/O request are enabled. When set to 2,
>  		all merge tries are disabled. The default value is 0 -
>  		which enables all types of merge tries.
> +
> +What:		/sys/block/<disk>/discard_alignment
> +Date:		May 2011
> +Contact:	Martin K. Petersen <martin.petersen@oracle.com>
> +Description:
> +		Devices that support discard functionality may
> +		internally allocate space in units that are bigger than
> +		the exported logical block size. The discard_alignment
> +		parameter indicates how many bytes the beginning of the
> +		device is offset from the internal allocation unit's
> +		natural alignment.
> +
> +What:		/sys/block/<disk>/<partition>/discard_alignment
> +Date:		May 2011
> +Contact:	Martin K. Petersen <martin.petersen@oracle.com>
> +Description:
> +		Devices that support discard functionality may
> +		internally allocate space in units that are bigger than
> +		the exported logical block size. The discard_alignment
> +		parameter indicates how many bytes the beginning of the
> +		partition is offset from the internal allocation unit's
> +		natural alignment.
> +
> +What:		/sys/block/<disk>/queue/discard_granularity
> +Date:		May 2011
> +Contact:	Martin K. Petersen <martin.petersen@oracle.com>
> +Description:
> +		Devices that support discard functionality may
> +		internally allocate space using units that are bigger
> +		than the logical block size. The discard_granularity
> +		parameter indicates the size of the internal allocation
> +		unit in bytes if reported by the device. Otherwise the
> +		discard_granularity will be set to match the device's
> +		physical block size. A discard_granularity of 0 means
> +		that the device does not support discard functionality.
> +
> +What:		/sys/block/<disk>/queue/discard_max_bytes
> +Date:		May 2011
> +Contact:	Martin K. Petersen <martin.petersen@oracle.com>
> +Description:
> +		Devices that support discard functionality may have
> +		internal limits on the number of bytes that can be
> +		trimmed or unmapped in a single operation. Some storage
> +		protocols also have inherent limits on the number of
> +		blocks that can be described in a single command. The
> +		discard_max_bytes parameter is set by the device driver
> +		to the maximum number of bytes that can be discarded in
> +		a single operation. Discard requests issued to the
> +		device must not exceed this limit. A discard_max_bytes
> +		value of 0 means that the device does not support
> +		discard functionality.
> +
> +What:		/sys/block/<disk>/queue/discard_zeroes_data
> +Date:		May 2011
> +Contact:	Martin K. Petersen <martin.petersen@oracle.com>
> +Description:
> +		Devices that support discard functionality may return
> +		stale or random data when a previously discarded block
> +		is read back. This can cause problems if the filesystem
> +		expects discarded blocks to be explicitly cleared. If a
> +		device reports that it deterministically returns zeroes
> +		when a discarded area is read the discard_zeroes_data
> +		parameter will be set to one. Otherwise it will be 0 and
> +		the result of reading a discarded area is undefined.
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index 1fa7692..42d3bf5 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -120,7 +120,7 @@ void blk_set_default_limits(struct queue_limits *lim)
>  	lim->discard_granularity = 0;
>  	lim->discard_alignment = 0;
>  	lim->discard_misaligned = 0;
> -	lim->discard_zeroes_data = -1;
> +	lim->discard_zeroes_data = 1;
>  	lim->logical_block_size = lim->physical_block_size = lim->io_min = 512;
>  	lim->bounce_pfn = (unsigned long)(BLK_BOUNCE_ANY >> PAGE_SHIFT);
>  	lim->alignment_offset = 0;
> @@ -166,6 +166,7 @@ void blk_queue_make_request(struct request_queue *q, make_request_fn *mfn)
>  
>  	blk_set_default_limits(&q->limits);
>  	blk_queue_max_hw_sectors(q, BLK_SAFE_MAX_SECTORS);
> +	q->limits.discard_zeroes_data = 0;
>  
>  	/*
>  	 * by default assume old behaviour and bounce for any highmem page
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index e2f57e9e..30ea95f 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -2138,7 +2138,7 @@ static unsigned int ata_scsiop_inq_b0(struct ata_scsi_args *args, u8 *rbuf)
>  	 * with the unmap bit set.
>  	 */
>  	if (ata_id_has_trim(args->id)) {
> -		put_unaligned_be32(65535 * 512 / 8, &rbuf[20]);
> +		put_unaligned_be64(65535 * 512 / 8, &rbuf[36]);
>  		put_unaligned_be32(1, &rbuf[28]);
>  	}
>  
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index bd0806e..cc081dd 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -490,7 +490,8 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
>  	unsigned int max_blocks = 0;
>  
>  	q->limits.discard_zeroes_data = sdkp->lbprz;
> -	q->limits.discard_alignment = sdkp->unmap_alignment;
> +	q->limits.discard_alignment = sdkp->unmap_alignment *
> +		(logical_block_size >> 9);
>  	q->limits.discard_granularity =
>  		max(sdkp->physical_block_size,
>  		    sdkp->unmap_granularity * logical_block_size);
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 2ad95fa..1416e3c 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -257,7 +257,7 @@ struct queue_limits {
>  	unsigned char		misaligned;
>  	unsigned char		discard_misaligned;
>  	unsigned char		cluster;
> -	signed char		discard_zeroes_data;
> +	unsigned char		discard_zeroes_data;
>  };
>  
>  struct request_queue
> @@ -1066,13 +1066,16 @@ static inline int queue_limit_discard_alignment(struct queue_limits *lim, sector
>  {
>  	unsigned int alignment = (sector << 9) & (lim->discard_granularity - 1);
>  
> +	if (!lim->max_discard_sectors)
> +		return 0;
> +
>  	return (lim->discard_granularity + lim->discard_alignment - alignment)
>  		& (lim->discard_granularity - 1);
>  }
>  
>  static inline unsigned int queue_discard_zeroes_data(struct request_queue *q)
>  {
> -	if (q->limits.discard_zeroes_data == 1)
> +	if (q->limits.max_discard_sectors && q->limits.discard_zeroes_data == 1)
>  		return 1;
>  
>  	return 0;
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
