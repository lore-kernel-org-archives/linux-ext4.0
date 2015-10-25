From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/9] ext4: Fix races between page faults and hole punching
Date: Sun, 25 Oct 2015 05:58:55 +0100
Message-ID: <20151025045855.GA28981@quack.suse.cz>
References: <1445501761-14528-1-git-send-email-jack@suse.com>
 <1445501761-14528-2-git-send-email-jack@suse.com>
 <20151024012135.GG7917@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
	Dan Williams <dan.j.williams@intel.com>,
	ross.zwisler@linux.intel.com, willy@linux.intel.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60326 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbbJYE7H (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 25 Oct 2015 00:59:07 -0400
Content-Disposition: inline
In-Reply-To: <20151024012135.GG7917@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 23-10-15 21:21:35, Ted Tso wrote:
> On Thu, Oct 22, 2015 at 10:15:53AM +0200, Jan Kara wrote:
> > Currently, page faults and hole punching are completely unsynchronized.
> > This can result in page fault faulting in a page into a range that we
> > are punching after truncate_pagecache_range() has been called and thus
> > we can end up with a page mapped to disk blocks that will be shortly
> > freed. Filesystem corruption will shortly follow. Note that the same
> > race is avoided for truncate by checking page fault offset against
> > i_size but there isn't similar mechanism available for punching holes.
> > 
> > Fix the problem by creating new rw semaphore i_mmap_sem in inode and
> > grab it for writing over truncate, hole punching, and other functions
> > removing blocks from extent tree and for read over page faults. We
> > cannot easily use i_data_sem for this since that ranks below transaction
> > start and we need something ranking above it so that it can be held over
> > the whole truncate / hole punching operation. Also remove various
> > workarounds we had in the code to reduce race window when page fault
> > could have created pages with stale mapping information.
> > 
> > Signed-off-by: Jan Kara <jack@suse.com>
> 
> This patch is causing ext4/001 to fail even using the standard 4k
> non-DAX test configuration.  You had mentioned that extent zeroing was
> getting suppressed for DAX file systems, but it looks like it's
> getting suppressed even in the non-DAX configuration:

I'll verify this in detail but if I remember correctly, this was caused by
some thing like that with my patches we don't bother to first write out pages
that aregoing to be zeroed out shortly because that's pretty pointless. But
as I said, I'll check again to be sure.

								Honza
> 
> % kvm-xfstests -c 4k ext4/001
> ...
> ext4/001		[21:11:29][    7.796142] run fstests ext4/001 at 2015-10-23 21:11:29
>  [21:11:32] - output mismatch (see /results/results-4k/ext4/001.out.bad)
>     --- tests/ext4/001.out	2015-10-18 23:46:49.000000000 -0400
>     +++ /results/results-4k/ext4/001.out.bad	2015-10-23 21:11:32.104276540 -0400
>     @@ -131,14 +131,10 @@
>      2: [32..39]: hole
>      daa100df6e6711906b61c9ab5aa16032
>      	11. data -> hole -> data
>     -0: [0..7]: data
>     -1: [8..31]: unwritten
>     -2: [32..39]: data
>     +0: [0..39]: data
>     ...
>     (Run 'diff -u tests/ext4/001.out /results/results-4k/ext4/001.out.bad'  to see the entire diff)
> 
> 
>       	  		     					       - Ted
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
