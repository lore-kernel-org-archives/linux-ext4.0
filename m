From: Adrian Bunk <bunk@kernel.org>
Subject: Re: [RFC] Btrfs mainline plans
Date: Tue, 7 Oct 2008 18:27:40 +0300
Message-ID: <20081007152740.GA31089@cs181140183.pp.htv.fi>
References: <1222717460.30627.56.camel@think.oraclecorp.com> <20081003001859.e30af6a5.akpm@linux-foundation.org> <20081005122405.GA12047@cs181140183.pp.htv.fi> <20081005141113.GA6132@us.ibm.com> <20081005150957.GC12047@cs181140183.pp.htv.fi> <1223300403.16546.45.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp4.pp.htv.fi ([213.243.153.38]:51756 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753762AbYJGP2N (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Oct 2008 11:28:13 -0400
Content-Disposition: inline
In-Reply-To: <1223300403.16546.45.camel@think.oraclecorp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 06, 2008 at 09:40:03AM -0400, Chris Mason wrote:
> On Sun, 2008-10-05 at 18:09 +0300, Adrian Bunk wrote:
> > On Sun, Oct 05, 2008 at 09:11:13AM -0500, Serge E. Hallyn wrote:
> > > Quoting Adrian Bunk (bunk@kernel.org):
> > >
> 
> [ when to merge btrfs ]
> 
> > > > Let's try to learn from the past:
> > > > 
> > > > 6 days from today ext4 (another new local filesystem for Linux) 
> > > > celebrates the second birthday of it's inclusion into Linus' tree
> > > > as a similar special-case.
> > > > 
> > > > You claim "an early merge will accelerate its development and will 
> > > > broaden its developer base" for Btrfs.
> > > > 
> > > > Read the timeline Ted outlined back in June 2006 for ext4 [1].
> > > > When comparing with what happened in reality it kinda disproves
> > > > your "acceleration" point.
> > > 
> 
> The btrfs timelines have always been aggressive, and as btrfs gets
> closer to feature complete, the testing matrix grows dramatically.  I
> can't promise my crazy timelines won't slip, but I've been hacking away
> in the basement for almost 18 months now and it's time for me to get off
> the pot and make it stable.
> 
> Ext4 has always had to deal with the ghost of ext3.  Both from a
> compatibility point of view and everyone's expectations of stability.  I
> believe that most of us underestimated how difficult it would be to move
> ext4 forward.
> 
> Btrfs is different for lots of reasons, and being in mainline will
> definitely increase the pressure on the btrfs developers to finish, and
> the resources available for us to finish with.

Your last sentence does not make sense:

According to your timeline btrfs 1.0 will be released in Q408 [1] - and
the merge window for 2.6.29 will be in Q109.

>...
> > For people wanting to try WIP code you don't need it in mainline.
> > 
> > Stable kernels will anyway usually contain months old code of the
> > WIP filesystem that is not usable for testing, so for any meaningful
> > testing you will still have to follow the btrfs tree and not mainline.
> 
> For ext4 at least, the mainline code is very usable.  I hope to have
> btrfs in shape for that by the 2.6.29 merge cycle.

One risk you should be aware of is that when btrfs is in 2.6.29 part of 
the Linux press might pick it up and stress test and benchmark this new 
filesystem.

JFS still suffers from from not being that good when it was
initially merged.

> -chris

cu
Adrian

[1] http://btrfs.wiki.kernel.org/index.php/Development_timeline

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

