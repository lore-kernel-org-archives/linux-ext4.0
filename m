From: David Rientjes <rientjes@google.com>
Subject: Re: [patch v2 1/5] mm: add nofail variants of kmalloc kcalloc and
 kzalloc
Date: Mon, 6 Sep 2010 02:05:27 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1009060204001.10552@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1008240340010.18908@chino.kir.corp.google.com> <alpine.DEB.2.00.1009011757360.24694@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Neil Brown <neilb@suse.de>, Alasdair G Kergon <agk@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	Steven Whitehouse <swhiteho@redhat.com>,
	Jens Axboe <jaxboe@fusionio.com>, Jan Kara <jack@suse.cz>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org,
	cluster-devel@redhat.com, linux-ext4@vger.kernel.org,
	reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.35]:12283 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab0IFJFe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Sep 2010 05:05:34 -0400
In-Reply-To: <alpine.DEB.2.00.1009011757360.24694@chino.kir.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 1 Sep 2010, David Rientjes wrote:

> Add kmalloc_nofail(), kcalloc_nofail(), and kzalloc_nofail().  These
> functions are equivalent to kmalloc(), kcalloc(), and kzalloc(),
> respectively, except that they will never return NULL and instead loop
> forever trying to allocate memory.
> 
> If the first allocation attempt fails because the page allocator doesn't 
> implicitly loop, a warning will be emitted, including a call trace.
> Subsequent failures will suppress this warning.
> 
> These were added as helper functions for documentation and auditability.
> No future callers should be added.
> 

Are there any objections to merging this series through -mm with the 
exception of the fifth patch for ntfs?  That particular patch needs to 
have its WARN_ON_ONCE() condition rewritten since it fallbacks to 
vmalloc for high order allocs.

Thanks.
