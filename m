From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 1/5] mm: add nofail variants of kmalloc kcalloc and
 kzalloc
Date: Wed, 25 Aug 2010 15:31:30 +0200
Message-ID: <1282743090.2605.3696.camel@laptop>
References: <alpine.DEB.2.00.1008240340010.18908@chino.kir.corp.google.com>
	 <1282656558.2605.2742.camel@laptop> <4C73CA24.3060707@fusionio.com>
	 <alpine.DEB.2.00.1008241309170.21242@chino.kir.corp.google.com>
	 <20100825112433.GB4453@thunk.org> <1282736132.2605.3563.camel@laptop>
	 <20100825115709.GD4453@thunk.org>  <1282740516.2605.3644.camel@laptop>
	 <1282740778.2605.3652.camel@laptop>
	 <E25A6DCB-3188-4CF9-9DC4-631192B2F0E2@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: David Rientjes <rientjes@google.com>,
	Jens Axboe <jaxboe@fusionio.com>,
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
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <reiserfs-devel-owner@vger.kernel.org>
In-Reply-To: <E25A6DCB-3188-4CF9-9DC4-631192B2F0E2@mit.edu>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2010-08-25 at 09:20 -0400, Theodore Tso wrote:
> On Aug 25, 2010, at 8:52 AM, Peter Zijlstra wrote:
> > Also, there's a good reason for disliking (a), its a deadlock scenario,
> > suppose we need to write out data to get free pages, but the writing out
> > is blocked on requiring free pages.
> > 
> > There's really nothing the page allocator can do to help you there, its
> > a situation you have to avoid getting into.
> 
> Well, if all of these users start having their own private pools of
> emergency memory, I'm not sure that's such a great idea either.
> 
> And in some cases, there *is* extra memory.  For example, if the
> reason why the page allocator failed is because there isn't enough
> memory in the current process's cgroup, maybe it's important enough
> that the kernel code might decide to say, "violate the cgroup
> constraints --- it's more important that we not bring down the entire
> system" than to honor whatever yahoo decided that a particular cgroup
> has been set down to something ridiculous like 512mb, when there's
> plenty of free physical memory --- but not in that cgroup.

I'm not sure, but I think the cgroup thing doesn't account kernel
allocations, in which case the above problem doesn't exist.

For the cpuset case we punch through the cpuset constraints for kernel
allocations (unless __GFP_HARDWALL).
