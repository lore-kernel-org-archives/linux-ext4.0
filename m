From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: ext4 extent status tree LRU locking
Date: Wed, 12 Jun 2013 08:09:14 -0700
Message-ID: <51B88F1A.5000909@intel.com>
References: <51B7B128.60909@intel.com> <20130612071735.GB29898@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, Jan kara <jack@suse.cz>,
	gnehzuil.liu@gmail.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130612071735.GB29898@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 06/12/2013 12:17 AM, Zheng Liu wrote:
> On Tue, Jun 11, 2013 at 04:22:16PM -0700, Dave Hansen wrote:
>> I've got a test case which I intended to use to stress the VM a bit.  It
>> fills memory up with page cache a couple of times.  It essentially runs
>> 30 or so cp's in parallel.
> 
> Could you please share your test case with me? I am glad to look at it
> and think about how to improve LRU locking.

I'll look in to giving you the actual test case.  But I'm not sure of
the licensing on it.

Essentially, the test creates an (small (~256MB) ext4 fs on a
loopback-mounted ramfs device.  It then goes and creates 160 64GB sparse
files (one per cpu) and then cp's them all to /dev/null.

>> 98% of my CPU is system time, and 96% of _that_ is being spent on the
>> spinlock in ext4_es_lru_add().  I think the LRU list head and its lock
>> end up being *REALLY* hot cachelines and are *the* bottleneck on this
>> test.  Note that this is _before_ we go in to reclaim and actually start
>> calling in to the shrinker.  There is zero memory pressure in this test.
>>
>> I'm not sure the benefits of having a proper in-order LRU during reclaim
>> outweigh such a drastic downside for the common case.
> 
> A proper in-order LRU can help us to reclaim some memory from extent
> status tree when we are under heavy memory pressure.  When shrinker
> tries to reclaim extents from these trees, some extents of files that
> are accessed infrequnetly will be reclaimed because we hope that
> frequently accessed files' extents can be kept in memory as much as
> possible.  That is why we need a proper in-order LRU list.

Does it need to be _strictly_ in order, though?  In other words, do you
truly need a *global*, perfectly in-order LRU?

You could make per-cpu LRUs, and batch movement on and off the global
LRU once the local ones get to be a certain size.  Or, you could keep
them cpu-local *until* the shrinker is called, when the shrinker could
go drain all the percpu ones.

Or, you could tag each extent in memory with its last-used time.  You
write an algorithm to go and walk the tree and attempt to _generally_
free the oldest objects out of a limited window.
