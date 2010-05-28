From: Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 6/6] writeback: limit write_cache_pages integrity
 scanning to current EOF
Date: Fri, 28 May 2010 15:06:55 +1000
Message-ID: <20100528050655.GY22536@laptop>
References: <1274784852-30502-1-git-send-email-david@fromorbit.com>
 <1274784852-30502-7-git-send-email-david@fromorbit.com>
 <20100527143341.d4258798.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, tytso@mit.edu, jens.axboe@oracle.com
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48388 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088Ab0E1FHP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 28 May 2010 01:07:15 -0400
Content-Disposition: inline
In-Reply-To: <20100527143341.d4258798.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 27, 2010 at 02:33:41PM -0700, Andrew Morton wrote:
> On Tue, 25 May 2010 20:54:12 +1000
> Dave Chinner <david@fromorbit.com> wrote:
> 
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > sync can currently take a really long time if a concurrent writer is
> > extending a file. The problem is that the dirty pages on the address
> > space grow in the same direction as write_cache_pages scans, so if
> > the writer keeps ahead of writeback, the writeback will not
> > terminate until the writer stops adding dirty pages.

...

> That being said, I think the patch is insufficient.  If I create an
> enormous (possibly sparse) file with a 16TB hole (or a run of clean
> pages) in the middle and then start busily writing into that hole (run
> of clean pages), the problem will still occur.

Yep.

 
> One obvious fix for that (a) would be to add another radix-tree tag and
> do two passes across the radix-tree.

Yes this is the method I tried. Jan has taken it further and should
have the latest patches around. A good test case for the starvation
would be helpful.


> Another fix (b) would be to track the number of dirty pages per
> adddress_space, and only write that number of pages.
> 
> Another fix would be to work out how the code handled this situation
> before we broke it, and restore that in some fashion.  I guess fix (b)
> above kinda does that.

I took that out (and offered fix a in replacement but it was turned
down at the time). Because b stands for broken.

IIRC we were writing out no more than 2x the dirty pages of the file
during sync. The problem with that is more pages can be dirtied after
we calculate the number, and then we might write out those newly dirty
pages and miss old dirty pages.


