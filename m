From: FD Cami <francois.cami@free.fr>
Subject: Re: [PATCH] extX: convert prink(KERN_WARNING) to extX_warning()
Date: Tue, 24 Jun 2008 00:20:23 +0200
Message-ID: <20080624002023.0fadc1d1@olorin>
References: <20080622201841.669ff882@olorin>
	<20080623203107.GD6239@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Kasper Sandberg <lkml@metanurb.dk>,
	Eric Sandeen <sandeen@redhat.com>,
	Randy Dunlap <randy.dunlap@oracle.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp5-g19.free.fr ([212.27.42.35]:45649 "EHLO smtp5-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbYFWWUV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Jun 2008 18:20:21 -0400
In-Reply-To: <20080623203107.GD6239@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi,

(Eric and Randy added as CC to keep track of this)

On Mon, 23 Jun 2008 14:31:07 -0600
Andreas Dilger <adilger@sun.com> wrote:

> On Jun 22, 2008  20:18 +0200, FD Cami wrote:
> > This patch takes a shot at replacing the direct use of printk(KERN_WARNING)
> > in extX by extX_warning. We now get the device number in the warning message :
> > "EXT3-fs warning (device hda1): ext3_setup_super: maximal mount count reached, running e2fsck is recommended"
> > It also adds the device information on a pair of printk(KERN_ERR) (this was
> > first suggested by Kasper two weeks ago).
> 
> The one issue is that KERN_ERR != KERN_WARNING, so these errors might
> not be visible on the console, or may not be saved to the syslog.

Hmmm, I did not replace any KERN_ERR by ext3_warning / KERN_WARNING, but
made those KERN_ERR calls more verbose. Does that change anything ?

For the record, I wanted to replace KERN_ERR calls by calls to a wrapper
much like ext3_warning (but obviously calling KERN_ERR), later on.

> The other minor difference is that the function name is also printed, and
> this makes the error message very long.

Ack, not pretty. Will fix that in next version.

> One suggestion is to create a separate macro that passes the KERN_*
> flag and __func__ to ext3_console_msg(), and call that from
> ext3_warning() and a new ext3_start_error() function.  I always found
> it annoying to have to specify __func__ as a parameter for every call.

OK, will do. Thanks for the suggestion.

> >  	ext3_warning(sb, __func__,
> > -		     "updating to rev %d because of new feature flag, "
> > -		     "running e2fsck is recommended",
> > -		     EXT3_DYNAMIC_REV);
> > +			"updating to rev %d because of new feature flag, "
> > +			"running e2fsck is recommended",
> > +			EXT3_DYNAMIC_REV);
> 
> Please don't change all of the indenting.  The old indending is proper
> linux coding style (aligned with previous '('), the new one is not.

Then this (old) coding style is not consistent within super.c , and not 
consistent with the example given in Documentation/CodingStyle either.
I will "fix" the indentation in a separate patch for the whole file, to
be merged or not.

> Note that you need to split up the patches for ext2, ext3, ext4 into
> separate emails.  I'd suggest just sending one of them until we agree
> on what is right, then submitting the rest afterward.

OK. I did ext3/ext4 at once because of what Andrew replied to Kasper :
"We like to keep ext3 and ext4 in sync as much as poss, please."
http://lkml.org/lkml/2008/6/9/79
But I can do ext3 first and then back / forward port to ext2 and ext4 as
well, as you suggest.

Thank you very much for replying.

Best,

Francois
