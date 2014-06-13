From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] ext4: Add support for SFITRIM, an ioctl for secure
 FITRIM.
Date: Fri, 13 Jun 2014 13:15:38 +1000
Message-ID: <20140613031538.GR4453@dastard>
References: <1402625647-31439-1-git-send-email-jpa@google.com>
 <539A63C1.8010809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: JP Abgrall <jpa@google.com>, linux-ext4@vger.kernel.org,
	gcondra@google.com,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <539A63C1.8010809@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jun 12, 2014 at 09:36:49PM -0500, Eric Sandeen wrote:
> On 6/12/14, 9:14 PM, JP Abgrall wrote:
> > This provides an interface for issuing secure trims to parallel
> > the existing interface for non-secure trim.
> 
> Which does what?  A bit of digging through git history tells
> me, but an idiot reader like myself doesn't know what a
> "secure trim" is.  ;)  Would be nice to have that info,
> and the reason for elevating it from a block-level ioctl
> to an fs-level ioctl in the commit log.
> 
> IOWS: your commit log says what, but not why.

"Secure discard" is only "secure" if every discard that is issued is
secure. Filesystems optimise away repeated discards for freed
regions, so FITRIM followed by SFITRIM means the regions trimmed by
the initial FITRIM are not securely erased from the underlying
media, and you can't get then to be securely erased until
<hand-wave> stuff happens.

Indeed, mixing -o discard and SFITRIM is a recipe for
confusion and leakage - "but I used secure trim on the device!" -
and so all discards either have to be secure or not.

Further, some filesystems may other copies of stale data in the
discarded ranges (e.g. data from unlinked files in the journal or
even in unused portions of metadata blocks), so you can't really say
that secure TRIM provides any sort of security against leakage at
the filesystem layer...

Hence I think secure discard should be a block layer property and
controlled at that layer rather than giving an incorrect impression
that FITRIM provides protection against unintentional data leakage
from the filesystem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
