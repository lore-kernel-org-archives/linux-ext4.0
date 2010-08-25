From: David Rientjes <rientjes@google.com>
Subject: Re: [patch 1/5] mm: add nofail variants of kmalloc kcalloc and
 kzalloc
Date: Wed, 25 Aug 2010 16:11:38 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1008251606450.31521@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1008240340010.18908@chino.kir.corp.google.com> <1282656558.2605.2742.camel@laptop> <4C73CA24.3060707@fusionio.com> <alpine.DEB.2.00.1008241309170.21242@chino.kir.corp.google.com> <20100825112433.GB4453@thunk.org>
 <1282736132.2605.3563.camel@laptop> <20100825115709.GD4453@thunk.org>  <1282740516.2605.3644.camel@laptop> <1282740778.2605.3652.camel@laptop> <E25A6DCB-3188-4CF9-9DC4-631192B2F0E2@mit.edu> <1282743090.2605.3696.camel@laptop>
 <alpine.DEB.2.00.1008251340420.16484@chino.kir.corp.google.com> <1282769729.1975.96.camel@laptop> <alpine.DEB.2.00.1008251406260.20253@chino.kir.corp.google.com> <1282771677.1975.138.camel@laptop>
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
Return-path: <reiserfs-devel-owner@vger.kernel.org>
In-Reply-To: <1282771677.1975.138.camel@laptop>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 25 Aug 2010, Peter Zijlstra wrote:

> > There's still no hard guarantee that the memory will allocatable 
> > (GFP_KERNEL, the compaction, then GFP_ATOMIC could all still fail), but I 
> > don't see how continuously looping the page allocator is possibly supposed 
> > to help in these situations. 
> 
> Why do you think I'm a proponent of that behaviour?
> 

I don't, I was agreeing with what you're saying :)

> I've been arguing that the existance of GFP_NOFAIL is the bug, and I
> started the whole discussion because your patchset didn't outline the
> purpose of its existance, it merely changes __GFP_NOFAIL usage into
> $foo_nofail() functions, which on its own is a rather daft change.
> 

I originally pushed these to the callers, but Andrew thought it would be 
better so that we could audit the existing users that have no fallback 
behavior, even though they could go implement it on their own (like 
getblk() which actually does try _some_ memory freeing).  It eliminates 
the flag from the page allocator and saves branches in the slowpath.  We 
don't need this logic in the allocator itself, it can exist at a higher 
level and, with deprecation, will hopefully be incentive enough for those 
subsystems to fix the issue.

I'll repropose the patchset with __deprecated as you suggested.  Thanks!
