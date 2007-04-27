From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when FS
 is under heavy write load (massive starvation)
Date: Fri, 27 Apr 2007 08:30:55 -0700 (PDT)
Message-ID: <alpine.LFD.0.98.0704270819500.9964@woody.linux-foundation.org>
References: <1177660767.6567.41.camel@Homer.simpson.net>
 <20070427013350.d0d7ac38.akpm@linux-foundation.org>
 <698310e10704270459t7663d39dp977cf055b8db9d2a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Mike Galbraith <efault@gmx.de>,
	LKML <linux-kernel@vger.kernel.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Marat Buharov <marat.buharov@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42107 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755998AbXD0PbQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Apr 2007 11:31:16 -0400
In-Reply-To: <698310e10704270459t7663d39dp977cf055b8db9d2a@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



On Fri, 27 Apr 2007, Marat Buharov wrote:
>
> On 4/27/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > Aside: why the heck do applications think that their data is so important
> > that they need to fsync it all the time.  I used to run a kernel on my
> > laptop which had "return 0;" at the top of fsync() and fdatasync().  Most
> > pleasurable.
> 
> So, if having fake fsync() and fdatasync() is pleasurable for laptop
> and desktop, may be it's time to add option into Kconfig which
> disables normal fsync behaviour in favor of robust desktop?

This really is an ext3 issue, not "fsync()".

On a good filesystem, when you do "fsync()" on a file, nothing at all 
happens to any other files. On ext3, it seems to sync the global journal, 
which means that just about *everything* that writes even a single byte 
(well, at least anything journalled, which would be all the normal 
directory ops etc) to disk will just *stop* dead cold!

It's horrid. And it really is ext3, not "fsync()".

I used to run reiserfs, and it had its problems, but this was the 
"feature" of ext3 that I've disliked most. If you run a MUA with local 
mail, it will do fsync's for most things, and things really hickup if you 
are doing some other writes at the same time. In contrast, with reiser, if 
you did a big untar or some other big write, if somebody fsync'ed a small 
file, it wasn't even a blip on the radar - the fsync would sync just that 
small thing.

Maybe I'm wrong on the exact details (I'm not really up on the ext3 
journal handling ;^), but you don't even have to know about any internals 
at all: you can just test it. Gaak.

			Linus
