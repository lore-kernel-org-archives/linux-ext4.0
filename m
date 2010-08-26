From: David Rientjes <rientjes@google.com>
Subject: Re: [patch 1/5] mm: add nofail variants of kmalloc kcalloc and
 kzalloc
Date: Thu, 26 Aug 2010 15:31:22 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1008261528160.5445@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1008240340010.18908@chino.kir.corp.google.com> <1282656558.2605.2742.camel@laptop> <4C73CA24.3060707@fusionio.com> <alpine.DEB.2.00.1008241309170.21242@chino.kir.corp.google.com> <20100825112433.GB4453@thunk.org>
 <1282736132.2605.3563.camel@laptop> <20100825115709.GD4453@thunk.org> <1282740516.2605.3644.camel@laptop> <20100825132417.GQ31488@dastard> <1282743342.2605.3707.camel@laptop> <alpine.DEB.2.00.1008251347550.16484@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1008251604120.24931@router.home> <alpine.DEB.2.00.1008251418590.20253@chino.kir.corp.google.com> <alpine.DEB.2.00.1008251630270.25660@router.home> <alpine.DEB.2.00.1008251604540.31521@chino.kir.corp.google.com> <alpine.DEB.2.00.1008252028030.32421@router.home>
 <alpine.DEB.2.00.1008252010260.10986@chino.kir.corp.google.com> <alpine.DEB.2.00.1008260914420.15852@router.home>
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
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:6777 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab0HZWba (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 26 Aug 2010 18:31:30 -0400
In-Reply-To: <alpine.DEB.2.00.1008260914420.15852@router.home>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 26 Aug 2010, Christoph Lameter wrote:

> > Because we can remove the flag, remove branches from the page allocator
> > slowpath, and none of these allocations actually are dependent on
> > __GFP_NOFAIL since they are all under PAGE_ALLOC_COSTLY_ORDER.
> 
> Then we can simply remove __GFP_NOFAIL? Functions are only needed for
> higher order allocs that can fail?
> 

Yes, that's the intent.  We'd like to add the 
WARN_ON_ONCE(get_order(size) >= PAGE_ALLOC_COSTLY_ORDER) warning, though, 
so we're ensured that redefinition of that #define doesn't cause 
allocations to fail to that don't have appropriate error handling or 
future callers use higher order allocs.  The _nofail() functions help that 
and do some due diligence in ensuring that we aren't changing gfp flags 
based only on the current page allocator implementation which may later 
change with very specialized corner cases.
