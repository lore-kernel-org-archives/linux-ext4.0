From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RFC 0/3] Block reservation for ext3
Date: Tue, 12 Oct 2010 20:17:39 -0400
Message-ID: <20101013001739.GA4833@thunk.org>
References: <1286583147-14760-1-git-send-email-jack@suse.cz>
 <20101009180357.GG18454@thunk.org>
 <20101011142813.GC3830@quack.suse.cz>
 <20101011145945.166695e3.akpm@linux-foundation.org>
 <20101012231408.GC3812@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:47508 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335Ab0JMARs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Oct 2010 20:17:48 -0400
Content-Disposition: inline
In-Reply-To: <20101012231408.GC3812@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 13, 2010 at 01:14:08AM +0200, Jan Kara wrote:
> c) When we decide some reservation scheme is unavoidable, there is question
>    how to estimate amount of indirect blocks. My scheme is one possibility,
>    but there is a wider variety of tradeoffs between complexity and
>    accuracy. A special low effort, low impact possibility here might be to
>    just ignore the ENOSPC problem as we did so far, reserve only quota for
>    data block on page fault, and rely on the fact that there isn't going to
>    be that much metadata so user cannot exceed his quota limit by too
>    much... But when we already have the interface change, it seems a bit
>    stupid not to fix it properly and also handle ENOSPC with it.

We ultimately decided to do two different things for ENOSPC versus
EDQUOTA in ext4.  For quota overflow we just assume that the number of
metadata blocks won't be that many, and just allow them to go over
quota.  For ENOSPC, we would force writeback to see if it would free
space, and ultimately we would drop out of delayed allocation mode
when we were close to running out of space (and for non-root users we
would depend on the 5% blocks reserved for root). 

Yeah, that means if root application mmap's a huge 100GB sparse
region, and we only have 2GB free in the file system, and then the
application proceeds to write to all 100GB of mmap'ed region, there's
a chance data might get silently lost when we drop out of delalloc
mode and we then really do completely run out of memory.  But really,
what we are we supposed do?  Unless you have the kernel break out in
hysterical laughter and reject the mmap at allocation time, I suppose
the only other thing we could do, if silently dropping data is
unacceptable, is we can send the SEGV early even though we might have
a few blocks left.  That way the data loss isn't silent (the
application will probably drop core and die instead), so it's no
longer our problem.  :-)

						- Ted
