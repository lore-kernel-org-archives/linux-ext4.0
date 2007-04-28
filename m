From: Matthias Andree <matthias.andree@gmx.de>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when
	FS is under heavy write load (massive starvation)
Date: Sat, 28 Apr 2007 10:44:29 +0200
Message-ID: <20070428084429.GA31196@merlin.emma.line.org>
References: <1177660767.6567.41.camel@Homer.simpson.net> <20070427013350.d0d7ac38.akpm@linux-foundation.org> <698310e10704270459t7663d39dp977cf055b8db9d2a@mail.gmail.com> <alpine.LFD.0.98.0704270819500.9964@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Marat Buharov <marat.buharov@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Galbraith <efault@gmx.de>,
	LKML <linux-kernel@vger.kernel.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:38465 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1161702AbXD1Iof (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 28 Apr 2007 04:44:35 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704270819500.9964@woody.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 27 Apr 2007, Linus Torvalds wrote:

> 
> 
> On Fri, 27 Apr 2007, Marat Buharov wrote:
> >
> > On 4/27/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > Aside: why the heck do applications think that their data is so important
> > > that they need to fsync it all the time.  I used to run a kernel on my
> > > laptop which had "return 0;" at the top of fsync() and fdatasync().  Most
> > > pleasurable.
> > 
> > So, if having fake fsync() and fdatasync() is pleasurable for laptop
> > and desktop, may be it's time to add option into Kconfig which
> > disables normal fsync behaviour in favor of robust desktop?
> 
> This really is an ext3 issue, not "fsync()".
> 
> On a good filesystem, when you do "fsync()" on a file, nothing at all 
> happens to any other files. On ext3, it seems to sync the global journal, 

This behavior has been in Linux and sort of official since the early
2.4.X days - remember the discussion on fsync()ing directory changes for
MTAs that led to the mount option "dirsync" for ext?fs so that rename(),
link() and stuff like that became synchronous even without fsync()ing
the parent directory? I can look up archive references if need be.

Surely four years ago, if not five (this is from the top of my head, not
a quotable fact I verified from the LKML archives though).

> I used to run reiserfs, and it had its problems, but this was the 
> "feature" of ext3 that I've disliked most. If you run a MUA with local 
> mail, it will do fsync's for most things, and things really hickup if you 
> are doing some other writes at the same time. In contrast, with reiser, if 
> you did a big untar or some other big write, if somebody fsync'ed a small 
> file, it wasn't even a blip on the radar - the fsync would sync just that 
> small thing.

It's not as though I'd recommend reiserfs. I have seen one major
corruption recently in openSUSE 10.2 with ext3, but I've had constant
headaches with reiserfs since the day it went into S.u.S.E. kernels at
the time until I switched away from reiserfs some years ago.

-- 
Matthias Andree
