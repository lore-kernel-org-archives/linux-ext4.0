From: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: ext4 data=writeback performs worse than data=ordered now
Date: Thu, 15 Dec 2011 09:34:56 +0800
Message-ID: <20111215013456.GB17920@localhost>
References: <20111214133400.GA18565@localhost>
 <20111214143014.GB18080@thunk.org>
 <1323910977.22361.423.camel@sli10-conroe>
 <20111215010010.GA14805@localhost>
 <20111215122759.7ce0b7b5@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Li, Shaohua" <shaohua.li@intel.com>, Ted Ts'o <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	Jens Axboe <axboe@kernel.dk>
To: NeilBrown <neilb@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:63607 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758439Ab1LOBpA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Dec 2011 20:45:00 -0500
Content-Disposition: inline
In-Reply-To: <20111215122759.7ce0b7b5@notabene.brown>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 15, 2011 at 09:27:59AM +0800, NeilBrown wrote:
> On Thu, 15 Dec 2011 09:00:10 +0800 Wu Fengguang <fengguang.wu@intel.com>
> wrote:
> 
> > > I found sometimes one disk hasn't any request inflight, but we can't
> > > send request to the disk, because the scsi host's resource (the queue
> > > depth) is used out, looks we send too many requests from other disks and
> > > leave some disks starved. The resource imbalance in scsi isn't a new
> > > problem, even 3.1 has such issue, so I'd think writeback introduces new
> > > imbalance between the 12 disks. In fact, if I limit disk's queue depth
> > > to 10, in this way the 12 disks will not impact each other in scsi
> > > layer, the performance regression fully disappears for both writeback
> > > and order mode.
> > 
> > I observe similar issue in MD. The default
> > 
> >         q->nr_requests = BLKDEV_MAX_RQ;
> > 
> > is too small for large arrays, and I end up doing
> > 
> >         echo 1280 > /sys/block/md0/queue/nr_requests
> > 
> > in my tests.
> 
> And you find this makes a difference?
> 
> That is very surprising because md devices don't use requests (and really use
> the 'queue' at all) and definitely don't make use of nr_requests.

Ah OK. Hope that I was wrong. I've just kicked off the tests to make sure.

Thanks,
Fengguang
