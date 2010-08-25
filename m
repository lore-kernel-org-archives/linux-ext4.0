From: David Rientjes <rientjes@google.com>
Subject: Re: [patch 1/5] mm: add nofail variants of kmalloc kcalloc and
 kzalloc
Date: Wed, 25 Aug 2010 14:11:38 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1008251406260.20253@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1008240340010.18908@chino.kir.corp.google.com> <1282656558.2605.2742.camel@laptop> <4C73CA24.3060707@fusionio.com> <alpine.DEB.2.00.1008241309170.21242@chino.kir.corp.google.com> <20100825112433.GB4453@thunk.org>
 <1282736132.2605.3563.camel@laptop> <20100825115709.GD4453@thunk.org>  <1282740516.2605.3644.camel@laptop> <1282740778.2605.3652.camel@laptop> <E25A6DCB-3188-4CF9-9DC4-631192B2F0E2@mit.edu> <1282743090.2605.3696.camel@laptop>
 <alpine.DEB.2.00.1008251340420.16484@chino.kir.corp.google.com> <1282769729.1975.96.camel@laptop>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Theodore Tso <tytso@mit.edu>, Jens Axboe <jaxboe@fusionio.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Neil Brown <neilb@suse.de>, Alasdair G Kergon <agk@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	Steven Whitehouse <swhiteho@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"cluster-devel@redhat.com" <cluster-devel@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"reiserfs-devel@vger.kernel.org" <reiserfs-devel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.35]:55772 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408Ab0HYVLq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Aug 2010 17:11:46 -0400
In-Reply-To: <1282769729.1975.96.camel@laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 25 Aug 2010, Peter Zijlstra wrote:

> > The cpusets case is actually the easiest to fix: use GFP_ATOMIC.  
> 
> I don't think that's a valid usage of GFP_ATOMIC, I think we should
> fallback to outside the cpuset for kernel allocations by default.

Cpusets doesn't enforce isolation for only user memory, it's always bound 
_all_ allocations that aren't atomic or in irq context (or oom killed 
tasks).  Allowing slab, for example, to be allocated in other cpusets 
could cause them to oom themselves since they are bound by the same memory 
isolation policy that all other cpusets are.  We'd get random oom 
conditions in cpusets only depending on where the slab was allocated at 
now fault to those applications themselves, and that's certainly not a 
situation we want.  The memory controller cgroup also has slab accounting 
on their TODO list.

If you think GFP_ATOMIC is inappropriate in these contexts, then they are 
by definition blockable.  So this seems like a good candidate for using 
memory compaction since we're talking only about PAGE_ALLOC_COSTLY_ORDER 
and higher allocs, even though it's only currently configurable for 
hugepages.

There's still no hard guarantee that the memory will allocatable 
(GFP_KERNEL, the compaction, then GFP_ATOMIC could all still fail), but I 
don't see how continuously looping the page allocator is possibly supposed 
to help in these situations.
