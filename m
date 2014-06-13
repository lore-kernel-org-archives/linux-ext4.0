From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] ext4: Add support for SFITRIM, an ioctl for secure
 FITRIM.
Date: Fri, 13 Jun 2014 13:30:29 +1000
Message-ID: <20140613033029.GS4453@dastard>
References: <1402625647-31439-1-git-send-email-jpa@google.com>
 <539A63C1.8010809@redhat.com>
 <20140613031538.GR4453@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: JP Abgrall <jpa@google.com>, linux-ext4@vger.kernel.org,
	gcondra@google.com,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:5162 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750777AbaFMDao (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Jun 2014 23:30:44 -0400
Content-Disposition: inline
In-Reply-To: <20140613031538.GR4453@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 13, 2014 at 01:15:38PM +1000, Dave Chinner wrote:
> On Thu, Jun 12, 2014 at 09:36:49PM -0500, Eric Sandeen wrote:
> > On 6/12/14, 9:14 PM, JP Abgrall wrote:
> > > This provides an interface for issuing secure trims to parallel
> > > the existing interface for non-secure trim.
> > 
> > Which does what?  A bit of digging through git history tells
> > me, but an idiot reader like myself doesn't know what a
> > "secure trim" is.  ;)  Would be nice to have that info,
> > and the reason for elevating it from a block-level ioctl
> > to an fs-level ioctl in the commit log.
> > 
> > IOWS: your commit log says what, but not why.
> 
> "Secure discard" is only "secure" if every discard that is issued is
> secure. Filesystems optimise away repeated discards for freed
> regions, so FITRIM followed by SFITRIM means the regions trimmed by
> the initial FITRIM are not securely erased from the underlying
> media, and you can't get then to be securely erased until
> <hand-wave> stuff happens.
> 
> Indeed, mixing -o discard and SFITRIM is a recipe for
> confusion and leakage - "but I used secure trim on the device!" -
> and so all discards either have to be secure or not.
> 
> Further, some filesystems may other copies of stale data in the
> discarded ranges (e.g. data from unlinked files in the journal or
> even in unused portions of metadata blocks), so you can't really say
> that secure TRIM provides any sort of security against leakage at
> the filesystem layer...

Oh, and while I think of it secure discard at the filesystem level
isn't even a guarantee that you'll get rid of all stale references
to a sector - if the filesystem has freed and then re-allocated a
block without having gone through a discard cycle on that block,
then the underlying device may have old copies of the block that it
hasn't garbage collected and SFITRIM won't clean those up because it
won't ask to trim in-use blocks....

So, really, secure trim from a filesystem perspective can leak stale
data at multiple layers....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
