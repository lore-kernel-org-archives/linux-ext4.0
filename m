From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: If a journal checksum error is detected,
	propagate the error to ext4
Date: Thu, 5 Jun 2008 12:21:17 -0400
Message-ID: <20080605162117.GD25477@mit.edu>
References: <20080604234057.GA9641@mit.edu> <1212623794-10183-1-git-send-email-tytso@mit.edu> <1212623794-10183-2-git-send-email-tytso@mit.edu> <20080605031712.GK2961@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Girish.Shilamkar@sun.com
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:47191 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760802AbYFEQVT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Jun 2008 12:21:19 -0400
Content-Disposition: inline
In-Reply-To: <20080605031712.GK2961@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 04, 2008 at 09:17:12PM -0600, Andreas Dilger wrote:
> On Jun 04, 2008  19:56 -0400, Theodore Ts'o wrote:
> > If a journal checksum error is detected, the ext4 filesystem will call
> > ext4_error(), and the mount will either continue, become a read-only
> > mount, or cause a kernel panic based on the superblock flags
> > indicating the user's preference of what to do in case of filesystem
> > corruption being detected.
> > 
> > XXX should we simply fail the mount instead in the panic case?
> 
> It does seem that if someone has a bad ext4 root filesystem it would be
> easy to get an unusable system.  That is why there are no "ext3_error"
> or "ext4_error" calls anywhere in ext[34]_fill_super().  They are all
> instead "printk(KERN_ERR ...)" and the mount fails.

Well, failing the mount or panic'ing as the same result for the root
filesystem.  It is rude to panic when mounting a corrupt filesystem,
especially when you could just fail the mount, though.  I'll make that change.

> 
> > diff --git a/scripts/package/Makefile b/scripts/package/Makefile
> > index 5e32607..f758b75 100644
> > --- a/scripts/package/Makefile
> > +++ b/scripts/package/Makefile
> 
> Not sure what the rest of this patch is...
> 

Some ditritus casued by make-kpkg that slipped in.  Oops, sorry about
that.

						- Ted
