From: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: ext4 data=writeback performs worse than data=ordered now
Date: Thu, 15 Dec 2011 09:00:10 +0800
Message-ID: <20111215010010.GA14805@localhost>
References: <20111214133400.GA18565@localhost>
 <20111214143014.GB18080@thunk.org>
 <1323910977.22361.423.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Ts'o <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
To: "Li, Shaohua" <shaohua.li@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1323910977.22361.423.camel@sli10-conroe>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> I found sometimes one disk hasn't any request inflight, but we can't
> send request to the disk, because the scsi host's resource (the queue
> depth) is used out, looks we send too many requests from other disks and
> leave some disks starved. The resource imbalance in scsi isn't a new
> problem, even 3.1 has such issue, so I'd think writeback introduces new
> imbalance between the 12 disks. In fact, if I limit disk's queue depth
> to 10, in this way the 12 disks will not impact each other in scsi
> layer, the performance regression fully disappears for both writeback
> and order mode.

I observe similar issue in MD. The default

        q->nr_requests = BLKDEV_MAX_RQ;

is too small for large arrays, and I end up doing

        echo 1280 > /sys/block/md0/queue/nr_requests

in my tests.

Thanks,
Fengguang
