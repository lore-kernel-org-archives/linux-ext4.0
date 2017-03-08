From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 5/8] nowait aio: return on congested block device
Date: Wed, 8 Mar 2017 16:28:06 +0100
Message-ID: <20170308152806.GA9288@quack2.suse.cz>
References: <20170228233610.25456-1-rgoldwyn@suse.de>
 <20170228233610.25456-6-rgoldwyn@suse.de>
 <0d1ba678-69c0-16ce-6c3e-475cd8da203c@grimberg.me>
 <44cc02b1-f7ac-cbc6-6f09-726ae8225358@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sagi Grimberg <sagi@grimberg.me>, jack@suse.com, hch@infradead.org,
        linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <44cc02b1-f7ac-cbc6-6f09-726ae8225358@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 08-03-17 09:00:09, Goldwyn Rodrigues wrote:
> 
> 
> On 03/08/2017 01:03 AM, Sagi Grimberg wrote:
> > 
> >> -        if (likely(blk_queue_enter(q, false) == 0)) {
> >> +        if (likely(blk_queue_enter(q, bio_flagged(bio, BIO_NOWAIT))
> >> == 0)) {
> >>              ret = q->make_request_fn(q, bio);
> > 
> > I think that for ->make_request to not block we'd need to set
> > BLK_MQ_REQ_NOWAIT in blk_mq_alloc_data to avoid blocking on a tag
> > allocation.
> > 
> > Something like the untested addition below:
> 
> I did that in the first series, but there are too many reasons to block
> in blk-mq [1]. I dropped blk-mq work in v2.
> 
> [1] https://patchwork.kernel.org/patch/9571051/

Well, that's not really good. If we cannot support this for both blk-mq and
legacy block layer the feature will not be usable. So please work on blk-mq
support as well.

								Honza 

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
