From: David Rientjes <rientjes@google.com>
Subject: Re: [patch 1/5] mm: add nofail variants of kmalloc kcalloc and
 kzalloc
Date: Wed, 25 Aug 2010 14:23:26 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1008251418590.20253@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1008240340010.18908@chino.kir.corp.google.com> <1282656558.2605.2742.camel@laptop> <4C73CA24.3060707@fusionio.com> <alpine.DEB.2.00.1008241309170.21242@chino.kir.corp.google.com> <20100825112433.GB4453@thunk.org>
 <1282736132.2605.3563.camel@laptop> <20100825115709.GD4453@thunk.org> <1282740516.2605.3644.camel@laptop> <20100825132417.GQ31488@dastard> <1282743342.2605.3707.camel@laptop> <alpine.DEB.2.00.1008251347550.16484@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1008251604120.24931@router.home>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Peter Zijlstra <peterz@infradead.org>,
	Dave Chinner <david@fromorbit.com>, "Ted Ts'o" <tytso@mit.edu>,
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
To: Christoph Lameter <cl@linux.com>
Return-path: <reiserfs-devel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1008251604120.24931@router.home>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 25 Aug 2010, Christoph Lameter wrote:

> We already have __GFP_NOFAIL behavior for slab allocations since
> a __GFP_NOFAIL flag is passed through to the page allocator if no objects
> are available.
> 

It all depends on what flags are passed to kmalloc(), slab nor slub 
enforce __GFP_NOFAIL behavior themselves.  In slab, cache_grow() will 
return NULL depending on whether the page allocator returns NULL, and that 
would only happen for __GFP_NORETRY or
cachep->gfp->gfporder >= PAGE_ALLOC_COSTLY_ORDER.  In slub, the default 
order is tried with __GFP_NORETRY and if it returns NULL, the higher order 
alloc will fail under the same circumstances.  So the nofail behavior for 
slab depends only on the flags passed from the caller.
