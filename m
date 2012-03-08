From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH, RFC] Don't do page stablization if
 !CONFIG_BLKDEV_INTEGRITY
Date: Thu, 8 Mar 2012 10:43:26 -0500
Message-ID: <20120308154326.GA6777@thunk.org>
References: <E1S5QTU-0005Cc-Kl@tytso-glaptop.cam.corp.google.com>
 <4F57FC14.5090207@panasas.com>
 <yq1zkbrhi2l.fsf@sermon.lab.mkp.net>
 <4F5837A2.8000306@panasas.com>
 <Pine.LNX.4.64.1203072207050.24564@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Boaz Harrosh <bharrosh@panasas.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Sage Weil <sage@newdream.net>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1203072207050.24564@cobra.newdream.net>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Mar 07, 2012 at 10:27:43PM -0800, Sage Weil wrote:
> 
> This avoids the problem for devices that don't need stable pages, but 
> doesn't help for those that do (btrfs, raid, iscsi, dif/dix, etc.).  It 
> seems to me like a more elegant solution would be to COW the page in the 
> address_space so that you get stable writeback pages without blocking.  
> That's clearly more complex, and I'm sure there are a range of issues 
> involved in making that work, but I would hope that it would be doable 
> with generic MM infrastructure so that everyone would benefit.

Well, even doing a COW (or anything that involves messing with page
tables) is not free.  So even if we can make the cost of stable
writeback pages cheaper, if we can completely avoid the cost, this
would be good.  I'd also rather fix the performance regression sooner
rather than later, and I suspect the COW solution is not something
that could be prepared in time for the upcoming merge window.

Martin, would you be willing to try to get your patch submitted for
the upcoming merge window?  Or I'd be willing to carry your patch and
then rework Darrick's to use the exported flag, and carry it in my
tree, maybe that would be better.

> I would love to talk to some MM people at LSF about what it would take to 
> make this work...

Sure, long term, I'm much more sympathetic to iSCSI than I am about
DIF/DIX (which due to drive manufacturer's pricing strategies I don't
think it will ever become mainstream --- which was my main concern;
why should we be inflicting pretty severe performance regressions for
the common case, just to improve things for obscure high-end hardware?
It's similar to how Solaris trashed 1 and 2 processor performance,
because they were optimizing things for their high margin SunFires).
So getting something which makes page stablization not suck so much in
the long term seems like a fine goal.  But even though we've worked on
improve SMP scalability in a way that didn't sacrifice 2 and 4-way
processors, we've still supported compiling with !CONFIG_SMP....

     		       	   	      - Ted

> 
> sage
> 
> 
> 
> > 
> > When submitted I will also send a patch to set .needs_stable_pages in 
> > iscsi when needed.
> > 
> > Thanks, Martin
> > Boaz
> > 
> > > diff --git a/block/blk-settings.c b/block/blk-settings.c
> > > index 5680b91..442a0df 100644
> > > --- a/block/blk-settings.c
> > > +++ b/block/blk-settings.c
> > > @@ -125,6 +125,7 @@ void blk_set_default_limits(struct queue_limits *lim)
> > >  	lim->io_opt = 0;
> > >  	lim->misaligned = 0;
> > >  	lim->cluster = 1;
> > > +	lim->needs_stable_pages = false;
> > >  }
> > >  EXPORT_SYMBOL(blk_set_default_limits);
> > >  
> > > @@ -571,6 +572,8 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
> > >  	t->cluster &= b->cluster;
> > >  	t->discard_zeroes_data &= b->discard_zeroes_data;
> > >  
> > > +	t->needs_stable_pages &= b->needs_stable_pages;
> > > +
> > >  	/* Physical block size a multiple of the logical block size? */
> > >  	if (t->physical_block_size & (t->logical_block_size - 1)) {
> > >  		t->physical_block_size = t->logical_block_size;
> > > diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> > > index 5b85d91..d464aca 100644
> > > --- a/block/blk-sysfs.c
> > > +++ b/block/blk-sysfs.c
> > > @@ -161,6 +161,11 @@ static ssize_t queue_discard_zeroes_data_show(struct request_queue *q, char *pag
> > >  	return queue_var_show(queue_discard_zeroes_data(q), page);
> > >  }
> > >  
> > > +static ssize_t queue_needs_stable_pages_show(struct request_queue *q, char *page)
> > > +{
> > > +	return queue_var_show(q->limits.needs_stable_pages, page);
> > > +}
> > > +
> > >  static ssize_t queue_write_same_max_show(struct request_queue *q, char *page)
> > >  {
> > >  	return sprintf(page, "%llu\n",
> > > @@ -364,6 +369,11 @@ static struct queue_sysfs_entry queue_discard_zeroes_data_entry = {
> > >  	.show = queue_discard_zeroes_data_show,
> > >  };
> > >  
> > > +static struct queue_sysfs_entry queue_needs_stable_pages_entry = {
> > > +	.attr = {.name = "needs_stable_pages", .mode = S_IRUGO },
> > > +	.show = queue_needs_stable_pages_show,
> > > +};
> > > +
> > >  static struct queue_sysfs_entry queue_write_same_max_entry = {
> > >  	.attr = {.name = "write_same_max_bytes", .mode = S_IRUGO },
> > >  	.show = queue_write_same_max_show,
> > > @@ -416,6 +426,7 @@ static struct attribute *default_attrs[] = {
> > >  	&queue_discard_granularity_entry.attr,
> > >  	&queue_discard_max_entry.attr,
> > >  	&queue_discard_zeroes_data_entry.attr,
> > > +	&queue_needs_stable_pages_entry.attr,
> > >  	&queue_write_same_max_entry.attr,
> > >  	&queue_nonrot_entry.attr,
> > >  	&queue_nomerges_entry.attr,
> > > diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> > > index 26eff46..146bed4 100644
> > > --- a/drivers/scsi/sd.c
> > > +++ b/drivers/scsi/sd.c
> > > @@ -1752,10 +1752,11 @@ static void sd_read_protection_type(struct scsi_disk *sdkp, unsigned char *buffe
> > >  		return;
> > >  	}
> > >  
> > > -	if (scsi_host_dif_capable(sdp->host, type))
> > > +	if (scsi_host_dif_capable(sdp->host, type)) {
> > >  		sd_printk(KERN_NOTICE, sdkp,
> > >  			  "Enabling DIF Type %u protection\n", type);
> > > -	else
> > > +		sdkp->disk->queue->limits.needs_stable_pages = true;
> > > +	} else
> > >  		sd_printk(KERN_NOTICE, sdkp,
> > >  			  "Disabling DIF Type %u protection\n", type);
> > >  }
> > > diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
> > > index 0cb39ff..9dc330c 100644
> > > --- a/drivers/scsi/sd_dif.c
> > > +++ b/drivers/scsi/sd_dif.c
> > > @@ -338,6 +338,8 @@ void sd_dif_config_host(struct scsi_disk *sdkp)
> > >  	sd_printk(KERN_NOTICE, sdkp,
> > >  		  "Enabling DIX %s protection\n", disk->integrity->name);
> > >  
> > > +	disk->queue->limits.needs_stable_pages = true;
> > > +
> > >  	/* Signal to block layer that we support sector tagging */
> > >  	if (dif && type && sdkp->ATO) {
> > >  		if (type == SD_DIF_TYPE3_PROTECTION)
> > > diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> > > index 92956b7..a5a33db 100644
> > > --- a/include/linux/blkdev.h
> > > +++ b/include/linux/blkdev.h
> > > @@ -266,6 +266,8 @@ struct queue_limits {
> > >  	unsigned char		discard_misaligned;
> > >  	unsigned char		cluster;
> > >  	unsigned char		discard_zeroes_data;
> > > +
> > > +	bool			needs_stable_pages;
> > >  };
> > >  
> > >  struct request_queue {
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > 
