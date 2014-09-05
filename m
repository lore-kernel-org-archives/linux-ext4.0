From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCHv4 0/3] new APIs to allocate buffer-cache with user
 specific flag
Date: Fri, 5 Sep 2014 10:48:09 +0900
Message-ID: <20140905014808.GA26070@js1304-P5Q-DELUXE>
References: <1409815781-28011-1-git-send-email-gioh.kim@lge.com>
 <20140904151612.7bf5b813069ff78973e01571@linux-foundation.org>
 <540905B1.1050200@lge.com>
 <20140905011419.GE4364@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>, Gioh Kim <gioh.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>, jack@suse.cz,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
	paulmck@linux.vnet.ibm.com, peterz@infradead.org,
	adilger.kernel@dilger.ca, minchan@kernel.org, gunho.lee@lge.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140905011419.GE4364@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Sep 04, 2014 at 09:14:19PM -0400, Theodore Ts'o wrote:
> On Fri, Sep 05, 2014 at 09:37:05AM +0900, Gioh Kim wrote:
> > >But what were the problems which were observed in standard kernels and
> > >what effect did this patchset have upon them?  Some quantitative
> > >measurements will really help here.
> > 
> > The problem is that I cannot allocate entire CMA memory.
> > >
> > Actually the problem is not found without Joonsoo's patch:
> > https://lkml.org/lkml/2014/5/28/64.  Without it CMA memory is free
> > and every CMA-memory allocation is successed.
> > 
> > If the Joonsoo's patch is applied, the CMA memory is allocated
> > generally when system boots-up.
> 
> As I said earlier, I'm happy to carry this patch in the ext4 tree,
> because as it turns out I could use this facility for another purpose
> (to cause a few buffer cache allocations to happen with __GFP_NOFAIL).
> 
> I do have one question; I note that Joonsoo's patch dates back to May,
> and yet this has not hit the mainline kernel, and I haven't seen any
> discussions about this patch after May.  Has there been some pushback
> from the mm maintainers about Joonsoo's approach with respect to this
> patch?   What is the current status of that patch set?

Hello,

That patchset is postponed, but will be continued. The reason is that
another bugs turn up frequently if that patchset is applied. I will
fix this bug first and will re-submit that patchset. Following is
the attempt to fix this bug.

https://lkml.org/lkml/2014/8/26/147

Thanks.
