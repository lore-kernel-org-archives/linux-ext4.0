From: David Rientjes <rientjes@google.com>
Subject: Re: [patch 1/5] mm: add nofail variants of kmalloc kcalloc and
 kzalloc
Date: Tue, 24 Aug 2010 13:08:28 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1008241307190.21242@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1008240340010.18908@chino.kir.corp.google.com> <1282656558.2605.2742.camel@laptop>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Neil Brown <neilb@suse.de>, Alasdair G Kergon <agk@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	Steven Whitehouse <swhiteho@redhat.com>,
	Jens Axboe <jaxboe@fusionio.com>, Jan Kara <jack@suse.cz>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org,
	cluster-devel@redhat.com, linux-ext4@vger.kernel.org,
	reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.35]:45935 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094Ab0HXUIl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Aug 2010 16:08:41 -0400
In-Reply-To: <1282656558.2605.2742.camel@laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 24 Aug 2010, Peter Zijlstra wrote:

> > These were added as helper functions for documentation and auditability.
> > No future callers should be added.
> 
> git grep GFP_NOFAIL isn't auditable enough?
> 

I'm trying to remove that bit, and __GFP_REPEAT, to simplify and remove 
several branches from the page allocator.

> might as well declare these functions depricated if you really want to
> do this.
> 
> FWIW I think mason said he'd fix btrfs to not suck like this 'soon'.
> 

Great!
