From: Shaohua Li <shaohua.li@intel.com>
Subject: Re: ext4 data=writeback performs worse than data=ordered now
Date: Thu, 15 Dec 2011 09:02:57 +0800
Message-ID: <1323910977.22361.423.camel@sli10-conroe>
References: <20111214133400.GA18565@localhost>
	 <20111214143014.GB18080@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "Wu, Fengguang" <fengguang.wu@intel.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:44662 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758175Ab1LOAuZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Dec 2011 19:50:25 -0500
In-Reply-To: <20111214143014.GB18080@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2011-12-14 at 22:30 +0800, Ted Ts'o wrote:
> On Wed, Dec 14, 2011 at 09:34:00PM +0800, Wu Fengguang wrote:
> > Hi,
> > 
> > Shaohua recently found that ext4 writeback mode could perform worse
> > than ordered mode in some cases. It may not be a big problem, however
> > we'd like to share some information on our findings.
> > 
> > I tested both 3.2 and 3.1 kernels on normal SATA disks and USB key.
> > The interesting thing is, data=writeback used to run a bit faster
> > than data=ordered, however situation get inverted presumably by the
> > IO-less dirty throttling.
> 
> Interesting.  What sort of workloads are you using to do these
> measurements?  How many writer threads; I assume you are doing
> sequential writes which are extending one or more files, etc?
> 
> I suspect it's due to the throttling meaning that each thread is
> getting to send less data to the disk, and so there is more seeking
> going on with data=writeback, where as with data=ordered, at each
> journal commit we are forcing all of the dirty pages out to disk, one
> inode at a time, and this is resulting in a more efficient writeback
> compared to when the writeback code is getting to make its own choices
> about how much each inode gets to write out at at time.
> 
> It would be interesting to see what would happen if in
> ext4_da_writepages(), we completely ignore how many pages are
> requested to be written back by the writeback code, and just simply
> write back all of the dirty pages, and see if that brings the
> performance back.
I saw the issue in a machine with a LSI 1068e HBA card and 12 disks.
there is about 20% performance regression with data=writeback comparing
3.1 and 3.2-rc. with data=order, there is small regression too.
Reverting writeback changes recover the regression for both cases.

My investigation shows the block size writing to disk isn't changed with
data=writeback. The block size is still very big, 256k IIRC, which is
the max block size in the disks. And I just have one thread for each
disk, so seek definitely isn't a problem in my workload.

I found sometimes one disk hasn't any request inflight, but we can't
send request to the disk, because the scsi host's resource (the queue
depth) is used out, looks we send too many requests from other disks and
leave some disks starved. The resource imbalance in scsi isn't a new
problem, even 3.1 has such issue, so I'd think writeback introduces new
imbalance between the 12 disks. In fact, if I limit disk's queue depth
to 10, in this way the 12 disks will not impact each other in scsi
layer, the performance regression fully disappears for both writeback
and order mode.

Thanks,
Shaohua

