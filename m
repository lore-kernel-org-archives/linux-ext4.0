From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 6/6] writeback: limit write_cache_pages integrity
 scanning to current EOF
Date: Tue, 1 Jun 2010 17:54:17 +0200
Message-ID: <20100601155417.GA7425@quack.suse.cz>
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
Received: from cantor.suse.de ([195.135.220.2]:60309 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755601Ab0FAPyd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Jun 2010 11:54:33 -0400
Content-Disposition: inline
In-Reply-To: <20100527143341.d4258798.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 27-05-10 14:33:41, Andrew Morton wrote:
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
> 
> <looks at Jens>
> 
> The really was a pretty basic bug.  It's writeback 101 to test that case :(
  The code has this live-lock since Nick fixed data integrity issues in
write_cache_pages which was (digging) commit 05fe478d ("mm:
write_cache_pages integrity fix") in January 2009. Jens just kept the code
as it was...

...
> That being said, I think the patch is insufficient.  If I create an
> enormous (possibly sparse) file with a 16TB hole (or a run of clean
> pages) in the middle and then start busily writing into that hole (run
> of clean pages), the problem will still occur.
> 
> One obvious fix for that (a) would be to add another radix-tree tag and
> do two passes across the radix-tree.
> 
> Another fix (b) would be to track the number of dirty pages per
> adddress_space, and only write that number of pages.
> 
> Another fix would be to work out how the code handled this situation
> before we broke it, and restore that in some fashion.  I guess fix (b)
> above kinda does that.
  (b) does not work for data integrity sync (see changelog of the above
mentioned commit). I was sending a patch doing (a) in February but in
particular you raised concerns whether it's not too expensive... Since
it indeed has some cost (although I was not able to measure any performance
impact) and I didn't know a better solution, I just postponed the patches.
But I guess it's time to revive the series and maybe we'll get further with
it.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
