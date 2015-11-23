From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: fuse2fs
Date: Mon, 23 Nov 2015 12:49:16 -0800
Message-ID: <20151123204916.GA10589@birch.djwong.org>
References: <EA601C64-3B42-4FA7-A572-6BD07443AEE1@lovstrand.com>
 <20151121141013.GA4741@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lennart =?iso-8859-1?Q?L=F6vstrand?= <lennart@lovstrand.com>,
	linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29710 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbbKWUt1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Nov 2015 15:49:27 -0500
Content-Disposition: inline
In-Reply-To: <20151121141013.GA4741@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Nov 21, 2015 at 09:10:13AM -0500, Theodore Ts'o wrote:
> Hi Lennart,
> 
> Apologies for the delay in getting back to you.  Things have been very
> busy this past month, and your e-mail slipped between the cracks.
> 
> > I got it to compile under OS X 10.11 with a few minor tweaks, but
> > when testing it, I noticed pretty quickly that I couldn't create new
> > files. I tracked it down to the UID & GID fields not being set on
> > new inodes. This caused them to be owned by root in op_create, which
> > in turn made its call to __op_open fail since it couldn't open the
> > file as the current user, which in turn made op_create fail (even
> > though the file actually was created). It seems like such a simple
> > and obvious error that I'm surprised it's there and it makes me
> > wonder if this code really has been used in read/write mode to any
> > large extent.

So far it's only been used as root...

...in any case, you're correct that op_create fails to set uid/gid on
the new inode.  Will send out a patch shortly; thank you for reporting
this!

--D

> > 
> > Could you advise?  I notice that it's marked with "Copyright
> > Oracle", so I'm assuming it was contributed by someone else and not
> > actually your own code.
> 
> Yes, if you had checked the git logs, you would have seen that Darrick
> contributed the code.
> 
> It looks like op_create is missing a call to set the inode uid/gid
> from the fuse_context's uid/gid fields, but I'm not an expert on FUSE;
> Darrick should be able to comment more intelligently on your bug
> report.
> 
> > BTW, if I were to create a decent .fs package for OS X, would you be
> > interested in making it part of the e2fsprogs source, or do you
> > think it would be better to make it a separate distribution?  What
> > kind of attribution would you like me to put into it in that case?
> > My intent would be to distribute it freely & openly, of course.
> 
> I'm not sure what a ".fs package" is.  Is this some kind of spec file
> ala the RPM spec file or the debian dpkg files that are used to
> build a package?  If so, sure, we could put something like that in the
> contrib directory along with directions of how to build a new OSX
> package from source.
> 
> Cheers,
> 
> 					- Ted
