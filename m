From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 1/5] mm: add nofail variants of kmalloc kcalloc and
 kzalloc
Date: Wed, 25 Aug 2010 14:52:58 +0200
Message-ID: <1282740778.2605.3652.camel@laptop>
References: <alpine.DEB.2.00.1008240340010.18908@chino.kir.corp.google.com>
	 <1282656558.2605.2742.camel@laptop> <4C73CA24.3060707@fusionio.com>
	 <alpine.DEB.2.00.1008241309170.21242@chino.kir.corp.google.com>
	 <20100825112433.GB4453@thunk.org> <1282736132.2605.3563.camel@laptop>
	 <20100825115709.GD4453@thunk.org>  <1282740516.2605.3644.camel@laptop>
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
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1282740516.2605.3644.camel@laptop>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2010-08-25 at 14:48 +0200, Peter Zijlstra wrote:

> > > On Wed, 2010-08-25 at 07:24 -0400, Ted Ts'o wrote:

> > > > (a) retry the loop in the jbd layer (which Andrew really doesn't
> > > > like), (b) keep our own private cache of free memory so we don't fail
> > > > and/or loop, 

> Well (b) sounds a lot saner than either of those. Simply revert to a
> state that is sub-optimal but has bounded memory use and reserve that
> memory up-front. That way you can always get out of a tight memory spot.

Also, there's a good reason for disliking (a), its a deadlock scenario,
suppose we need to write out data to get free pages, but the writing out
is blocked on requiring free pages.

There's really nothing the page allocator can do to help you there, its
a situation you have to avoid getting into.


