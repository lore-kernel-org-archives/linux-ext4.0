From: Adrian Bunk <bunk@kernel.org>
Subject: Re: [RFC] Btrfs mainline plans
Date: Sun, 5 Oct 2008 18:09:57 +0300
Message-ID: <20081005150957.GC12047@cs181140183.pp.htv.fi>
References: <1222717460.30627.56.camel@think.oraclecorp.com> <20081003001859.e30af6a5.akpm@linux-foundation.org> <20081005122405.GA12047@cs181140183.pp.htv.fi> <20081005141113.GA6132@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Chris Mason <chris.mason@oracle.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp5.pp.htv.fi ([213.243.153.39]:53872 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670AbYJEPKT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Oct 2008 11:10:19 -0400
Content-Disposition: inline
In-Reply-To: <20081005141113.GA6132@us.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Oct 05, 2008 at 09:11:13AM -0500, Serge E. Hallyn wrote:
> Quoting Adrian Bunk (bunk@kernel.org):
> > On Fri, Oct 03, 2008 at 12:18:59AM -0700, Andrew Morton wrote:
> > > On Mon, 29 Sep 2008 15:44:20 -0400 Chris Mason <chris.mason@oracle.com> wrote:
> > > 
> > > > But, the code is very actively developed, and I believe the best way to
> > > > develop Btrfs from here is to get it into the mainline kernel (with a
> > > > large warning label about the disk format) and attract more extensive
> > > > review of both the disk format and underlying code.
> > > 
> > > For the record...  I have been encouraging Chris to get btrfs into
> > > mainline soon.  Get it into linux-next asap and merge it into 2.6.29.
> > > 
> > > And do this even though the on-disk format is still changing - we emit a
> > > loud printk at mount time and if someone comes to depend upon some
> > > intermediate format, well, that's their tough luck.
> > > 
> > > My thinking here is that btrfs probably has a future, and that an early
> > > merge will accelerate its development and will broaden its developer base. 
> > > If it ends up failing for some reason, well, we can just delete it
> > > again.
> > > 
> > > For various reasons this approach often isn't appropriate as a general
> > > policy thing, but I do think that Linux has needed a new local
> > > filesystem for some time, and btrfs might be The One, and hence is
> > > worth a bit of special-case treatment.
> > 
> > Let's try to learn from the past:
> > 
> > 6 days from today ext4 (another new local filesystem for Linux) 
> > celebrates the second birthday of it's inclusion into Linus' tree
> > as a similar special-case.
> > 
> > You claim "an early merge will accelerate its development and will 
> > broaden its developer base" for Btrfs.
> > 
> > Read the timeline Ted outlined back in June 2006 for ext4 [1].
> > When comparing with what happened in reality it kinda disproves
> > your "acceleration" point.
> 
> OTOH, maybe it's just me, but I think there is more excitement around
> btrfs.  Myself I'm dying for snapshot support, and can't wait to try
> btrfs on a separate data/scratch partition (where i don't mind losing
> data).  btrfs and nilfs - yay.  Ext4?  <yawn>  That can make all the
> difference.

"accelerate its development and will broaden its developer base" is not 
about users/testers but about people doing code development.

For people wanting to try WIP code you don't need it in mainline.

Stable kernels will anyway usually contain months old code of the
WIP filesystem that is not usable for testing, so for any meaningful
testing you will still have to follow the btrfs tree and not mainline.

This is not meant as a statement on the quality of ext4 or btrfs, or any 
comparison of the development times of ext4 and btrfs, but for ext4 the 
advantages Andrew thinks would happen with an early btrfs merge do not 
seem to have happened.

I just realize that I forgot to add Ted and the ext4 mailing list into 
the Cc of my first email. Adding them to the Cc, so if I'm talking 
nonsense about the experiences with ext4 they can correct me.

> -serge

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

