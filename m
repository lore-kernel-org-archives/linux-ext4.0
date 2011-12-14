From: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: ext4 data=writeback performs worse than data=ordered now
Date: Wed, 14 Dec 2011 22:49:27 +0800
Message-ID: <20111214144927.GA24288@localhost>
References: <20111214133400.GA18565@localhost>
 <20111214143014.GB18080@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ted Ts'o <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, Li Shaohua <shaohua.li@intel.com>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20111214143014.GB18080@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Dec 14, 2011 at 10:30:14PM +0800, Theodore Ts'o wrote:
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

Yes it's mostly simple dd's, and some fio workloads.

The test scripts and fio jobs can be found in

        https://github.com/fengguang/writeback-tests

For example, the run_dd() in
https://github.com/fengguang/writeback-tests/blob/master/dd-common.sh

and some fio jobs:
https://github.com/fengguang/writeback-tests/blob/master/fio_fat_rates
https://github.com/fengguang/writeback-tests/blob/master/fio_fat_mmap_randwrite_4k
https://github.com/fengguang/writeback-tests/blob/master/fio_fat_mmap_randwrite_64k

The meanings in the dirs:

       hostname     dirty_background_bytes
         |   dirty_bytes  |   FS data=writeback                                                           
         |          |     |    |   |  # of dd tasks                                    
         |          |     |    |   |   |      kernel version                                   
        fat/thresh=1000M:999M/ext4:wb-100dd-1-3.1.0+
                                            |
                                            1st test run
                                 (each test can be repreated several times)

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

I can provide more tracing data or test patches on your request.
But for now, I have to go to bed :-)

Thanks,
Fengguang
