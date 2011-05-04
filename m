From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: do not disable ext4 discards on first discard failure? [was: Re:
 dm snapshot: ignore discards issued to the snapshot-origin target]
Date: Wed, 4 May 2011 12:02:32 -0400
Message-ID: <20110504160231.GD31241@redhat.com>
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
Received: from mx1.redhat.com ([209.132.183.28]:62166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387Ab1EDQCr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 May 2011 12:02:47 -0400
Content-Disposition: inline
In-Reply-To: <yq1wri6zel9.fsf@sermon.lab.mkp.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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
> 
> 
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

lim->discard_zeroes_data = -1; was suspect to me too.
But why default to 1 here?

> @@ -166,6 +166,7 @@ void blk_queue_make_request(struct request_queue *q, make_request_fn *mfn)
>  
>  	blk_set_default_limits(&q->limits);
>  	blk_queue_max_hw_sectors(q, BLK_SAFE_MAX_SECTORS);
> +	q->limits.discard_zeroes_data = 0;
>  
>  	/*
>  	 * by default assume old behaviour and bounce for any highmem page

Only to then reset to 0 here?  Shouldn't we default to 0 and only set to
1 where applicable (e.g. sd_config_discard)?
