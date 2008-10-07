From: Adrian Bunk <bunk@kernel.org>
Subject: Re: [RFC] Btrfs mainline plans
Date: Tue, 7 Oct 2008 23:25:39 +0300
Message-ID: <20081007202538.GC1610@cs181140183.pp.htv.fi>
References: <1222717460.30627.56.camel@think.oraclecorp.com> <20081003001859.e30af6a5.akpm@linux-foundation.org> <20081005122405.GA12047@cs181140183.pp.htv.fi> <20081005141113.GA6132@us.ibm.com> <20081005150957.GC12047@cs181140183.pp.htv.fi> <1223300403.16546.45.camel@think.oraclecorp.com> <20081007152740.GA31089@cs181140183.pp.htv.fi> <1223395284.16546.121.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp5.pp.htv.fi ([213.243.153.39]:54245 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148AbYJGU0M (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Oct 2008 16:26:12 -0400
Content-Disposition: inline
In-Reply-To: <1223395284.16546.121.camel@think.oraclecorp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 07, 2008 at 12:01:24PM -0400, Chris Mason wrote:
> On Tue, 2008-10-07 at 18:27 +0300, Adrian Bunk wrote:
> > On Mon, Oct 06, 2008 at 09:40:03AM -0400, Chris Mason wrote:
> >  
> > > 
> > > The btrfs timelines have always been aggressive, and as btrfs gets
> > > closer to feature complete, the testing matrix grows dramatically.  I
> > > can't promise my crazy timelines won't slip, but I've been hacking away
> > > in the basement for almost 18 months now and it's time for me to get off
> > > the pot and make it stable.
> > > 
> > > Ext4 has always had to deal with the ghost of ext3.  Both from a
> > > compatibility point of view and everyone's expectations of stability.  I
> > > believe that most of us underestimated how difficult it would be to move
> > > ext4 forward.
> > > 
> > > Btrfs is different for lots of reasons, and being in mainline will
> > > definitely increase the pressure on the btrfs developers to finish, and
> > > the resources available for us to finish with.
> > 
> > Your last sentence does not make sense:
> > 
> > According to your timeline btrfs 1.0 will be released in Q408 [1] - and
> > the merge window for 2.6.29 will be in Q109.
> 
> Planning for mainline inclusion is always a guessing game.

The 2.6.29 merge window will start in January - everything else is much
more unlikely than an incompetent chick from Alaska getting only one 
heart attack away from the big red button.

> Cutting 1.0
> is different from being in mainline, and the dates don't have to be the
> same.

Sure, but Andrew's "special-case treatment" suggestion does not apply if 
1.0 gets released before the 2.6.29 merge window.

>...
> -chris

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

