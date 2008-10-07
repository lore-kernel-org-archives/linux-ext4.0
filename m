From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC] Btrfs mainline plans
Date: Tue, 07 Oct 2008 12:01:24 -0400
Message-ID: <1223395284.16546.121.camel@think.oraclecorp.com>
References: <1222717460.30627.56.camel@think.oraclecorp.com>
	 <20081003001859.e30af6a5.akpm@linux-foundation.org>
	 <20081005122405.GA12047@cs181140183.pp.htv.fi>
	 <20081005141113.GA6132@us.ibm.com>
	 <20081005150957.GC12047@cs181140183.pp.htv.fi>
	 <1223300403.16546.45.camel@think.oraclecorp.com>
	 <20081007152740.GA31089@cs181140183.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>
To: Adrian Bunk <bunk@kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20081007152740.GA31089@cs181140183.pp.htv.fi>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2008-10-07 at 18:27 +0300, Adrian Bunk wrote:
> On Mon, Oct 06, 2008 at 09:40:03AM -0400, Chris Mason wrote:
>  
> > 
> > The btrfs timelines have always been aggressive, and as btrfs gets
> > closer to feature complete, the testing matrix grows dramatically.  I
> > can't promise my crazy timelines won't slip, but I've been hacking away
> > in the basement for almost 18 months now and it's time for me to get off
> > the pot and make it stable.
> > 
> > Ext4 has always had to deal with the ghost of ext3.  Both from a
> > compatibility point of view and everyone's expectations of stability.  I
> > believe that most of us underestimated how difficult it would be to move
> > ext4 forward.
> > 
> > Btrfs is different for lots of reasons, and being in mainline will
> > definitely increase the pressure on the btrfs developers to finish, and
> > the resources available for us to finish with.
> 
> Your last sentence does not make sense:
> 
> According to your timeline btrfs 1.0 will be released in Q408 [1] - and
> the merge window for 2.6.29 will be in Q109.
> 

Planning for mainline inclusion is always a guessing game.  Cutting 1.0
is different from being in mainline, and the dates don't have to be the
same.

> >...
> > > For people wanting to try WIP code you don't need it in mainline.
> > > 
> > > Stable kernels will anyway usually contain months old code of the
> > > WIP filesystem that is not usable for testing, so for any meaningful
> > > testing you will still have to follow the btrfs tree and not mainline.
> > 
> > For ext4 at least, the mainline code is very usable.  I hope to have
> > btrfs in shape for that by the 2.6.29 merge cycle.
> 
> One risk you should be aware of is that when btrfs is in 2.6.29 part of 
> the Linux press might pick it up and stress test and benchmark this new 
> filesystem.

I think the gains from early testing far outweigh the risks of bad early
press.

-chris


