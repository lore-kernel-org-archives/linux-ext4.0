From: Ted Ts'o <tytso@mit.edu>
Subject: Patch to issue pure flushes directly (Was: Re: [PATCH v6 0/4]
 ext4: Coordinate data-only flush requests sent) by fsync
Date: Fri, 7 Jan 2011 18:54:49 -0500
Message-ID: <20110107235449.GT21922@thunk.org>
References: <20101129220536.12401.16581.stgit@elm3b57.beaverton.ibm.com>
 <20101130164124.GA30858@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <djwong@us.ibm.com>,
	Jens Axboe <axboe@kernel.dk>, Neil Brown <neilb@suse.de>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Alasdair G Kergon <agk@redhat.com>, Jan Kara <jack@suse.cz>,
	Mike Snitzer <snitzer@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-raid@vger.kernel.org, Keith Mannthey <kmannth@us.ibm.com>,
	dm-devel@redhat.com, Mingming Cao <cmm@us.ibm.com>,
	Tejun Heo <tj@kernel.org>, linux-ext4@vger.kernel.org,
	Ric Wheeler <rwheeler@redhat.com>,
	Josef Bacik <josef@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:57852 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779Ab1AGXzQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Jan 2011 18:55:16 -0500
Content-Disposition: inline
In-Reply-To: <20101130164124.GA30858@lst.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch seemed like a good idea to me; I just checked linux-next,
and looks like nothing like this is planned to be merged.  Just
thought I would send a prod-o-gram to see what the current thinking
was around adding something like this.

Thanks,

						- Ted


On Tue, Nov 30, 2010 at 05:41:24PM +0100, Christoph Hellwig wrote:
> FYI, here's an updated version of my patch to not run pure flushes
> that also works on SCSI/ATA and not just virtio.  I suspect the patch
> alone might not be enough, but together with a variant of Neil's
> suggestion might do the trick, with my patch taking care of the
> highend-devices and Neil's scheme of taking care of stupid SATA disks.
> 
> 
> Index: linux-2.6/block/blk-flush.c
> ===================================================================
> --- linux-2.6.orig/block/blk-flush.c	2010-11-30 17:27:33.108254088 +0100
> +++ linux-2.6/block/blk-flush.c	2010-11-30 17:27:38.790004333 +0100
> @@ -143,6 +143,17 @@ struct request *blk_do_flush(struct requ
>  	unsigned skip = 0;
>  
>  	/*
> +	 * Just issue pure flushes directly.
> +	 */
> +	if (!blk_rq_sectors(rq)) {
> +		if (!do_preflush) {
> +			__blk_end_request_all(rq, 0);
> +			return NULL;
> +		}
> +		return rq;
> +	}
> +
> +	/*
>  	 * Special case.  If there's data but flush is not necessary,
>  	 * the request can be issued directly.
>  	 *
> Index: linux-2.6/drivers/scsi/scsi_lib.c
> ===================================================================
> --- linux-2.6.orig/drivers/scsi/scsi_lib.c	2010-11-30 17:27:33.120254298 +0100
> +++ linux-2.6/drivers/scsi/scsi_lib.c	2010-11-30 17:27:38.791003634 +0100
> @@ -1060,7 +1060,7 @@ int scsi_setup_blk_pc_cmnd(struct scsi_d
>  	 * that does not transfer data, in which case they may optionally
>  	 * submit a request without an attached bio.
>  	 */
> -	if (req->bio) {
> +	if (req->bio && !(req->cmd_flags & REQ_FLUSH)) {
>  		int ret;
>  
>  		BUG_ON(!req->nr_phys_segments);
