From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC][PATCH] Re: [BUG] ext4: cannot unfreeze a filesystem due
 to a deadlock
Date: Wed, 6 Apr 2011 21:21:35 +1000
Message-ID: <20110406112135.GE31057@dastard>
References: <20110215172954.GK17313@quack.suse.cz>
 <20110216081746.54d146d1.toshi.okajima@jp.fujitsu.com>
 <20110216145627.GB5592@quack.suse.cz>
 <4D5C9B1B.2050304@jp.fujitsu.com>
 <20110217104552.GD4947@quack.suse.cz>
 <20110328170628.ffe314fb.toshi.okajima@jp.fujitsu.com>
 <20110331234050.GD2904@dastard>
 <20110401140856.GA5311@quack.suse.cz>
 <20110406054005.GD31057@dastard>
 <20110406061856.GC23285@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	Ted Ts'o <tytso@mit.edu>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:15872 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754224Ab1DFLVl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Apr 2011 07:21:41 -0400
Content-Disposition: inline
In-Reply-To: <20110406061856.GC23285@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 06, 2011 at 08:18:56AM +0200, Jan Kara wrote:
> On Wed 06-04-11 15:40:05, Dave Chinner wrote:
> > On Fri, Apr 01, 2011 at 04:08:56PM +0200, Jan Kara wrote:
> > > On Fri 01-04-11 10:40:50, Dave Chinner wrote:
> > > > If you don't allow the page to be dirtied in the fist place, then
> > > > nothing needs to be done to the writeback path because there is
> > > > nothing dirty for it to write back.
> > >   Sure but that's only the problem he was able to hit. But generally,
> > > there's a problem with needing s_umount for unfreezing because it isn't
> > > clear there aren't other code paths which can block with s_umount held
> > > waiting for fs to get unfrozen. And these code paths would cause the same
> > > deadlock. That's why I chose to get rid of s_umount during thawing.
> > 
> > Holding the s_umount lock while checking if frozen and sleeping
> > is essentially an ABBA lock inversion bug that can bite in many more
> > places that just thawing the filesystem.  Any where this is done should
> > be fixed, so I don't think just removing the s_umount lock from the thaw
> > path is sufficient to avoid problems.
>   That's easily said but hard to do - any transaction start in ext3/4 may
> block on filesystem being frozen (this seems to be similar for XFS as I'm
> looking into the code) and transaction start traditionally nests inside
> s_umount (and basically there's no way around that since sync() calls your
> fs code with s_umount held).

Sure, but the question must be asked - why is ext3/4 even starting a
transaction on a clean filesystem during sync? A frozen filesystem,
by definition, is a clean filesytem, and therefore sync calls of any
kind should not be trying to write to the FS or start transactions.
XFS does this just fine, so I'd consider such behaviour on a frozen
filesystem a bug in ext3/4...

> So I'm afraid we are not going to get rid of
> this ABBA dependency unless we declare that s_umount ranks above filesystem
> being frozen - but surely I'm open to suggestions.

Not sure I understand what you are saying there - this is already
the case, isn't it? i.e. it has to be held exclusive to freeze a
filesystem...

> Another possibility is just to hide the problem e.g. by checking for frozen
> filesystem whenever we try to get s_umount. But that looks a bit ugly to
> me.

And not necessary, AFAICT.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
