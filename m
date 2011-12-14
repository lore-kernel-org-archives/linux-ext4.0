From: Ted Ts'o <tytso@mit.edu>
Subject: Re: ext4 data=writeback performs worse than data=ordered now
Date: Wed, 14 Dec 2011 09:30:14 -0500
Message-ID: <20111214143014.GB18080@thunk.org>
References: <20111214133400.GA18565@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, Li Shaohua <shaohua.li@intel.com>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20111214133400.GA18565@localhost>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Dec 14, 2011 at 09:34:00PM +0800, Wu Fengguang wrote:
> Hi,
> 
> Shaohua recently found that ext4 writeback mode could perform worse
> than ordered mode in some cases. It may not be a big problem, however
> we'd like to share some information on our findings.
> 
> I tested both 3.2 and 3.1 kernels on normal SATA disks and USB key.
> The interesting thing is, data=writeback used to run a bit faster
> than data=ordered, however situation get inverted presumably by the
> IO-less dirty throttling.

Interesting.  What sort of workloads are you using to do these
measurements?  How many writer threads; I assume you are doing
sequential writes which are extending one or more files, etc?

I suspect it's due to the throttling meaning that each thread is
getting to send less data to the disk, and so there is more seeking
going on with data=writeback, where as with data=ordered, at each
journal commit we are forcing all of the dirty pages out to disk, one
inode at a time, and this is resulting in a more efficient writeback
compared to when the writeback code is getting to make its own choices
about how much each inode gets to write out at at time.

It would be interesting to see what would happen if in
ext4_da_writepages(), we completely ignore how many pages are
requested to be written back by the writeback code, and just simply
write back all of the dirty pages, and see if that brings the
performance back.

      	       	    	       	  	       - Ted
