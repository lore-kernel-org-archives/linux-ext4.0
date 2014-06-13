From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] ext4: Add support for SFITRIM, an ioctl for secure
 FITRIM.
Date: Fri, 13 Jun 2014 15:07:03 +1000
Message-ID: <20140613050703.GT4453@dastard>
References: <1402625647-31439-1-git-send-email-jpa@google.com>
 <539A63C1.8010809@redhat.com>
 <20140613031538.GR4453@dastard>
 <20140613033029.GS4453@dastard>
 <CAKP4w2QvVUNp18jnX69eP0hjA-T6zn2sT3TQ-P6zpu-EhXZPAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	Geremy Condra <gcondra@google.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: JP Abgrall <jpa@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:48637 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751509AbaFMFHU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Jun 2014 01:07:20 -0400
Content-Disposition: inline
In-Reply-To: <CAKP4w2QvVUNp18jnX69eP0hjA-T6zn2sT3TQ-P6zpu-EhXZPAQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 12, 2014 at 09:37:58PM -0700, JP Abgrall wrote:
> On Thu, Jun 12, 2014 at 8:30 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Fri, Jun 13, 2014 at 01:15:38PM +1000, Dave Chinner wrote:
> >> Indeed, mixing -o discard and SFITRIM is a recipe for
> >> confusion and leakage - "but I used secure trim on the device!" -
> >> and so all discards either have to be secure or not.
> 
> The idea was to keep on not using -o discard. And move from FITRIM to SFITRIM.

IOWs, you want either normal discard or secure discard, and not a
mix of both. IOWs, you don't need SFITRIM, you need a "block device
does secure discard only" configuration flag...

> > Oh, and while I think of it secure discard at the filesystem level
> > isn't even a guarantee that you'll get rid of all stale references
> > to a sector - if the filesystem has freed and then re-allocated a
> > block without having gone through a discard cycle on that block,
> > then the underlying device may have old copies of the block that it
> > hasn't garbage collected and SFITRIM won't clean those up because it
> > won't ask to trim in-use blocks....
> 
> Arg. So, if understand this correctly, if the eMMC chip won't get a
> secure discard/trim of a block that gets reassigned to the FS, then
						      ^^ within

> data duplicates within the eMMC related to that block are not cleared,
> and the next SFITRIM won't even reach that block or the duplicates as
> the FS says they are in use.

Pretty much.

And even using -o discard is no guarantee that the filesystem will
issue a discard between freeing and re-using a block e.g.  XFS
explicitly avoids issuing discards for blocks it re-uses immediately
because they are always considered "in-use" from a transactional
POV. Hence there is no place where the block is considered free, and
hence there isn't a point in time where a discard can be safely
issued on that block.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
