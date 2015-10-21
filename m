From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: memory leak: data=journal and {collapse,insert,zero}_range
Date: Wed, 21 Oct 2015 10:52:14 -0400
Message-ID: <20151021145214.GC2165@thunk.org>
References: <20151017160230.GA19968@thunk.org>
 <009301d10b2f$b410e6b0$1c32b410$@samsung.com>
 <20151020155443.GM2972@thunk.org>
 <011f01d10be5$099d38d0$1cd7aa70$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Namjae Jeon <namjae.jeon@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36116 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737AbbJUOwQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Oct 2015 10:52:16 -0400
Content-Disposition: inline
In-Reply-To: <011f01d10be5$099d38d0$1cd7aa70$@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 21, 2015 at 06:44:10PM +0900, Namjae Jeon wrote:
> > Interestingly we're not seeing these memory leaks on the truncate
> > path, so I suspect the issue is in how collapse range is clearing
> > pages from the page cache, especially pages that were freshly written
> > to the journal by the commit but which hadn't yet been writtten to
> > disk and then marked as complete so we can allow the relevant
> > transaction to be checkpointed.  (Although we're not leaking the
> > journal head structures, but only the buffer heads, so the story most
> > be a bit more complicated than that.)
> 
> Okay, Thanks for sharing your view and points !!
> 
> Currently I can reproduce memory leak issue without collase/insert/zero range.
> conditions like the following.(collase/insert/zero range are disable with -I -C -z option and add -y option instead of -W)
>   1. small size parition(1GB)
>   2. run fsx with these options "./fsx -N 30000 -o 128000 -l 500000 -r 4096 -t 512 -w 512 -Z -R -y -I -C -z testfile"
> And same result with generic/091 is showing (buffer_head leak)
> 
> So I am starting to find root-cause base on your points.
> I will share the result or the patch.

Thanks, that's very interesting data point.  So this makes it appear
that the problem *is* probably with how we deal with checkpointing
buffers after the pages get discarded using either a truncate or a
collapse_range, since the 'y' option causes a lot fsync's, and hence
commits, some of which are happening after a truncate command.

Thanks for a taking a look at this.  I really appreciate it.

Cheers,

					- Ted









