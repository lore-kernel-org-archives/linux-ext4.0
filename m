From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 1/5] mm: add nofail variants of kmalloc kcalloc and
 kzalloc
Date: Wed, 25 Aug 2010 23:27:57 +0200
Message-ID: <1282771677.1975.138.camel@laptop>
References: <alpine.DEB.2.00.1008240340010.18908@chino.kir.corp.google.com>
	 <1282656558.2605.2742.camel@laptop> <4C73CA24.3060707@fusionio.com>
	 <alpine.DEB.2.00.1008241309170.21242@chino.kir.corp.google.com>
	 <20100825112433.GB4453@thunk.org> <1282736132.2605.3563.camel@laptop>
	 <20100825115709.GD4453@thunk.org>  <1282740516.2605.3644.camel@laptop>
	 <1282740778.2605.3652.camel@laptop>
	 <E25A6DCB-3188-4CF9-9DC4-631192B2F0E2@mit.edu>
	 <1282743090.2605.3696.camel@laptop>
	 <alpine.DEB.2.00.1008251340420.16484@chino.kir.corp.google.com>
	 <1282769729.1975.96.camel@laptop>
	 <alpine.DEB.2.00.1008251406260.20253@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
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
To: David Rientjes <rientjes@google.com>
Return-path: <reiserfs-devel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1008251406260.20253@chino.kir.corp.google.com>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2010-08-25 at 14:11 -0700, David Rientjes wrote:
> 
> There's still no hard guarantee that the memory will allocatable 
> (GFP_KERNEL, the compaction, then GFP_ATOMIC could all still fail), but I 
> don't see how continuously looping the page allocator is possibly supposed 
> to help in these situations. 

Why do you think I'm a proponent of that behaviour?

I've been arguing that the existance of GFP_NOFAIL is the bug, and I
started the whole discussion because your patchset didn't outline the
purpose of its existance, it merely changes __GFP_NOFAIL usage into
$foo_nofail() functions, which on its own is a rather daft change.

Optimizing the page allocator by removing those conditional from its
innards into an outer loop not used by most callers seems a fine goal,
but you didn't state that.

Also, I like the postfix proposed by Andi better: _i_suck() :-)
