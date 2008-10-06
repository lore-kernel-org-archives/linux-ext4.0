From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC] Btrfs mainline plans
Date: Mon, 06 Oct 2008 09:40:03 -0400
Message-ID: <1223300403.16546.45.camel@think.oraclecorp.com>
References: <1222717460.30627.56.camel@think.oraclecorp.com>
	 <20081003001859.e30af6a5.akpm@linux-foundation.org>
	 <20081005122405.GA12047@cs181140183.pp.htv.fi>
	 <20081005141113.GA6132@us.ibm.com>
	 <20081005150957.GC12047@cs181140183.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>
To: Adrian Bunk <bunk@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:52786 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbYJFNoj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Oct 2008 09:44:39 -0400
In-Reply-To: <20081005150957.GC12047@cs181140183.pp.htv.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 2008-10-05 at 18:09 +0300, Adrian Bunk wrote:
> On Sun, Oct 05, 2008 at 09:11:13AM -0500, Serge E. Hallyn wrote:
> > Quoting Adrian Bunk (bunk@kernel.org):
> >

[ when to merge btrfs ]

> > > Let's try to learn from the past:
> > > 
> > > 6 days from today ext4 (another new local filesystem for Linux) 
> > > celebrates the second birthday of it's inclusion into Linus' tree
> > > as a similar special-case.
> > > 
> > > You claim "an early merge will accelerate its development and will 
> > > broaden its developer base" for Btrfs.
> > > 
> > > Read the timeline Ted outlined back in June 2006 for ext4 [1].
> > > When comparing with what happened in reality it kinda disproves
> > > your "acceleration" point.
> > 

The btrfs timelines have always been aggressive, and as btrfs gets
closer to feature complete, the testing matrix grows dramatically.  I
can't promise my crazy timelines won't slip, but I've been hacking away
in the basement for almost 18 months now and it's time for me to get off
the pot and make it stable.

Ext4 has always had to deal with the ghost of ext3.  Both from a
compatibility point of view and everyone's expectations of stability.  I
believe that most of us underestimated how difficult it would be to move
ext4 forward.

Btrfs is different for lots of reasons, and being in mainline will
definitely increase the pressure on the btrfs developers to finish, and
the resources available for us to finish with.

> > OTOH, maybe it's just me, but I think there is more excitement around
> > btrfs.  Myself I'm dying for snapshot support, and can't wait to try
> > btrfs on a separate data/scratch partition (where i don't mind losing
> > data).  btrfs and nilfs - yay.  Ext4?  <yawn>  That can make all the
> > difference.
> 
> "accelerate its development and will broaden its developer base" is not 
> about users/testers but about people doing code development.
> 

People want btrfs for different reasons.  I want btrfs in the kernel
because when you're in the kernel more people look at it, and when
people look at it they send me email with the mistakes they found.

For example, see the streaming write patches I sent to fsdevel last
week.  I wouldn't test against ext4 as often if I had to hunt down
external repos just to get something consistent with the current
development kernels.  ext4 in mainline makes it much easier for me to
kick the tires.

> For people wanting to try WIP code you don't need it in mainline.
> 
> Stable kernels will anyway usually contain months old code of the
> WIP filesystem that is not usable for testing, so for any meaningful
> testing you will still have to follow the btrfs tree and not mainline.

For ext4 at least, the mainline code is very usable.  I hope to have
btrfs in shape for that by the 2.6.29 merge cycle.

-chris


