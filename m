From: David Rientjes <rientjes@google.com>
Subject: Re: [patch 1/5] mm: add nofail variants of kmalloc kcalloc and
 kzalloc
Date: Tue, 24 Aug 2010 13:12:51 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1008241311380.21242@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1008240340010.18908@chino.kir.corp.google.com> <1282656558.2605.2742.camel@laptop> <20100824135522.GK31488@dastard>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Neil Brown <neilb@suse.de>, Alasdair G Kergon <agk@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	Steven Whitehouse <swhiteho@redhat.com>,
	Jens Axboe <jaxboe@fusionio.com>, Jan Kara <jack@suse.cz>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org,
	cluster-devel@redhat.com, linux-ext4@vger.kernel.org,
	reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <reiserfs-devel-owner@vger.kernel.org>
In-Reply-To: <20100824135522.GK31488@dastard>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 24 Aug 2010, Dave Chinner wrote:

> > git grep GFP_NOFAIL isn't auditable enough?
> > 
> > might as well declare these functions depricated if you really want to
> > do this.
> 
> Also, if you are going to add tight loops, you might want to put a
> backoff in the loops like "congestion_wait(BLK_RW_ASYNC, HZ/50);" so
> that they don't spin....
> 

These loops don't actually loop at all, all users are passing 
order < PAGE_ALLOC_COSTLY_ORDER which implicitly loop forever in the page 
allocator without killing anything (they are all GFP_NOIO or GFP_NOFS, so 
the oom killer isn't involved).
