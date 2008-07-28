From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: partially uptodate page reads
Date: Mon, 28 Jul 2008 17:22:39 +1000
Message-ID: <200807281722.40100.nickpiggin@yahoo.com.au>
References: <200807250117.11331.nickpiggin@yahoo.com.au> <200807281656.37908.nickpiggin@yahoo.com.au> <20080728000908.869c3e85.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
	Christoph Hellwig <hch@infradead.org>, jack@ucw.cz,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20080728000908.869c3e85.akpm@linux-foundation.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Monday 28 July 2008 17:09, Andrew Morton wrote:
> On Mon, 28 Jul 2008 16:56:37 +1000 Nick Piggin <nickpiggin@yahoo.com.au> 
wrote:
> > On Monday 28 July 2008 16:51, Andrew Morton wrote:
> > > On Mon, 28 Jul 2008 13:34:12 +0900 Hisashi Hifumi

> > Yeah, thanks for the numbers.
> >
> > > OK, thanks.  Those are pretty nice numbers for what is probably a
> > > fairly common workload.
> >
> > What kind of workloads does this kind of thing?
>
> Various databases?  (confused).

I guess so, I was thinking of direct IO, but I guess there are
good open source ones which go through pagecache.


> More likely pattern is 8k IOs with 16k pagesize or thereabouts.

Right, but it won't be a completely random workload. Also, it would
be interesting to know if there are any 8k database block size databases
on 4k block size filesystems, running on 16k page size machines, which
are very performance critical ;)

But I guess it is only a small amount of code in order to get a pretty
good speedup. So while those are probably very few installations, it is
probably as much because we do a bad job of it as it just isn't a good
idea in general ;)

The improvement is quite significant, even if it is the artificial best
possible case... I suppose let's just merge it then?
