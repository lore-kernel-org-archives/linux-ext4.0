From: Shaohua Li <shaohua.li@intel.com>
Subject: Re: ext4 data=writeback performs worse than data=ordered now
Date: Fri, 16 Dec 2011 09:47:22 +0800
Message-ID: <1324000042.22361.445.camel@sli10-conroe>
References: <20111214133400.GA18565@localhost>
	 <20111214143014.GB18080@thunk.org>
	 <1323910977.22361.423.camel@sli10-conroe>
	 <20111215012039.GC8233@tux1.beaverton.ibm.com>
	 <1323913345.22361.442.camel@sli10-conroe>
	 <20111215181044.GD8233@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Ted Ts'o <tytso@mit.edu>, "Wu, Fengguang" <fengguang.wu@intel.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: "djwong@us.ibm.com" <djwong@us.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20111215181044.GD8233@tux1.beaverton.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2011-12-16 at 02:10 +0800, Darrick J. Wong wrote:
> On Thu, Dec 15, 2011 at 09:42:25AM +0800, Shaohua Li wrote:
> > On Thu, 2011-12-15 at 09:20 +0800, Darrick J. Wong wrote:
> > > On Thu, Dec 15, 2011 at 09:02:57AM +0800, Shaohua Li wrote:
> > > > On Wed, 2011-12-14 at 22:30 +0800, Ted Ts'o wrote:
> > > > > On Wed, Dec 14, 2011 at 09:34:00PM +0800, Wu Fengguang wrote:
> > > > > > Hi,
> > > > > > 
> > > > > > Shaohua recently found that ext4 writeback mode could perform worse
> > > > > > than ordered mode in some cases. It may not be a big problem, however
> > > > > > we'd like to share some information on our findings.
> > > > > > 
> > > > > > I tested both 3.2 and 3.1 kernels on normal SATA disks and USB key.
> > > > > > The interesting thing is, data=writeback used to run a bit faster
> > > > > > than data=ordered, however situation get inverted presumably by the
> > > > > > IO-less dirty throttling.
> > > > > 
> > > > > Interesting.  What sort of workloads are you using to do these
> > > > > measurements?  How many writer threads; I assume you are doing
> > > > > sequential writes which are extending one or more files, etc?
> > > > > 
> > > > > I suspect it's due to the throttling meaning that each thread is
> > > > > getting to send less data to the disk, and so there is more seeking
> > > > > going on with data=writeback, where as with data=ordered, at each
> > > > > journal commit we are forcing all of the dirty pages out to disk, one
> > > > > inode at a time, and this is resulting in a more efficient writeback
> > > > > compared to when the writeback code is getting to make its own choices
> > > > > about how much each inode gets to write out at at time.
> > > > > 
> > > > > It would be interesting to see what would happen if in
> > > > > ext4_da_writepages(), we completely ignore how many pages are
> > > > > requested to be written back by the writeback code, and just simply
> > > > > write back all of the dirty pages, and see if that brings the
> > > > > performance back.
> > > > I saw the issue in a machine with a LSI 1068e HBA card and 12 disks.
> > > > there is about 20% performance regression with data=writeback comparing
> > > > 3.1 and 3.2-rc. with data=order, there is small regression too.
> > > > Reverting writeback changes recover the regression for both cases.
> > > > 
> > > > My investigation shows the block size writing to disk isn't changed with
> > > > data=writeback. The block size is still very big, 256k IIRC, which is
> > > > the max block size in the disks. And I just have one thread for each
> > > > disk, so seek definitely isn't a problem in my workload.
> > > > 
> > > > I found sometimes one disk hasn't any request inflight, but we can't
> > > > send request to the disk, because the scsi host's resource (the queue
> > > > depth) is used out, looks we send too many requests from other disks and
> > > > leave some disks starved. The resource imbalance in scsi isn't a new
> > > 
> > > I wonder, does the patch in:
> > > http://lkml.indiana.edu/hypermail/linux/kernel/1105.3/02339.html
> > > help with this starvation problem?  I noticed a similar problem and sent a
> > > patch, but LSI folks never responded.  Maybe two complaining users can change
> > > that.  The biggest MaxQ I've seen on LSI SAS is 511, and the driver clamps the
> > > value it passes to the SCSI layer to whatever the controller reports as its
> > > MaxQ (in /proc/mpt/summary).
> > this should recover the regression too. But I'm afraid it's just a
> > workaround and will hide some issues. what if I have 120 disks instead
> > of 12 disks? I observed one disk can burst 20 requests while the total
> > the scsi host queue depth is 127, leaving other disks starved. I'm
> > hoping to understand why there is such imbalance.
> 
> <shrug> I didn't say it would /fix/ the imbalanced-starvation problem, but we
> might as well take full advantage of the hardware.  Even if all it does is
> enable the user to plug in more disks before things get whacky, I was hoping
> that someone else could at least give it a spin and say "Yes, this does what
> it's alleged to do, and without breaking things". :)

Ok, I tested your patch, it works. So next time you repost the patch,
you can add my Tested-by: Shaohua Li <shaohua.li@intel.com>

> afaict SCSI doesn't try to balance requests heading towards the HBA; it's all
> FCFS.

The scsi starvation list tries to do the balance, but apparently not
enough.

Thanks,
Shaohua

