From: Ted Ts'o <tytso@mit.edu>
Subject: Re: ext4 memory leak?
Date: Tue, 7 Dec 2010 11:38:20 -0500
Message-ID: <20101207163820.GF24607@thunk.org>
References: <20101205064430.GA15027@localhost>
 <4CFB9BE1.3030902@redhat.com>
 <20101207131136.GA20366@localhost>
 <20101207143351.GA23377@localhost>
 <20101207152120.GA28220@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rik van Riel <riel@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Mason <chris.mason@oracle.com>,
	Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
	Jens Axboe <axboe@kernel.dk>, Mel Gorman <mel@csn.ul.ie>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Christoph Hellwig <hch@lst.de>, linux-mm <linux-mm@kvack.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20101207152120.GA28220@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Dec 07, 2010 at 11:21:20PM +0800, Wu Fengguang wrote:
> On Tue, Dec 07, 2010 at 10:33:51PM +0800, Wu Fengguang wrote:
> > > In a simple dd test on a 8p system with "mem=256M", I find the light
> > 
> > When increasing to 10 concurrent dd tasks, I managed to crash ext4..
> > (2 concurrent dd's are OK, with very good write performance.)

What was the dd command line?  Specifically, how big were the file
writes?  I haven't been able to replicate a leak.  I'll try on a small
system seeing if I can replicate an OOM kill, but I'm not seeing a
leak.  (i.e., after the dd if=/dev/zero of=/test/$i" jobs) are
finished, the memory utilization looks normal and I don't see any
obvious slab leaks.

       	      	       		    	- Ted
