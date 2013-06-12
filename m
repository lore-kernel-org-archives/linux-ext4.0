From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: ext4 extent status tree LRU locking
Date: Wed, 12 Jun 2013 15:17:35 +0800
Message-ID: <20130612071735.GB29898@gmail.com>
References: <51B7B128.60909@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, Jan kara <jack@suse.cz>
To: Dave Hansen <dave.hansen@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51B7B128.60909@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Dave

Thanks for reporting this.

On Tue, Jun 11, 2013 at 04:22:16PM -0700, Dave Hansen wrote:
> I've got a test case which I intended to use to stress the VM a bit.  It
> fills memory up with page cache a couple of times.  It essentially runs
> 30 or so cp's in parallel.

Could you please share your test case with me? I am glad to look at it
and think about how to improve LRU locking.

> 
> 98% of my CPU is system time, and 96% of _that_ is being spent on the
> spinlock in ext4_es_lru_add().  I think the LRU list head and its lock
> end up being *REALLY* hot cachelines and are *the* bottleneck on this
> test.  Note that this is _before_ we go in to reclaim and actually start
> calling in to the shrinker.  There is zero memory pressure in this test.
> 
> I'm not sure the benefits of having a proper in-order LRU during reclaim
> outweigh such a drastic downside for the common case.

A proper in-order LRU can help us to reclaim some memory from extent
status tree when we are under heavy memory pressure.  When shrinker
tries to reclaim extents from these trees, some extents of files that
are accessed infrequnetly will be reclaimed because we hope that
frequently accessed files' extents can be kept in memory as much as
possible.  That is why we need a proper in-order LRU list.

Regards,
                                                - Zheng
