From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Bug#692104: linux-image-3.2.0-3-amd64: NULL pointer dereference
 in ext4fs
Date: Thu, 8 Nov 2012 10:30:48 -0500
Message-ID: <20121108153048.GA32709@thunk.org>
References: <50938953.6010001@gaast.net>
 <1351866830.13356.100.camel@deadeye.wl.decadent.org.uk>
 <509440A3.5020604@gaast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-ext4@vger.kernel.org,
	692104@bugs.debian.org
To: Wilmer van der Gaast <wilmer@gaast.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60061 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757103Ab2KHWAA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Nov 2012 17:00:00 -0500
Content-Disposition: inline
In-Reply-To: <509440A3.5020604@gaast.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 02, 2012 at 10:52:35PM +0100, Wilmer van der Gaast wrote:
> >
> Oh yes, definitely. Sorry for not being clear.
> 
> Also, this has just happened again. This time, after me not having
> touched the laptop for over ten hours. I'm starting to wonder
> whether my filesystem is corrupted. I'll make an LVM snapshot and
> then do a full fsck.

Did you perform another on-line resize on the file system before it
failed?

It looks like a problem which I ran into (and fixed) when adding
support for online resizing for > 16TB file systems, but I was pretty
sure it couldn't happen with until we added support for resizing very
large file systems using the new meta_bg resizing scheme.  The commit
where I cleaned this up (but which was not backported to stable
kernels since it was part of a new feature and I didn't think it could
be triggered w/o the new feature) was:

commit 28623c2f5b0dca3c3ea34fd6108940661352e276
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Wed Sep 5 01:31:50 2012 -0400

    ext4: grow the s_group_info array as needed
    
    Previously we allocated the s_group_info array with enough space for
    any future possible growth of the file system via online resize.  This
    is unfortunate because it wastes memory, and it doesn't work for the
    meta_bg scheme, since there is no limit based on the number of
    reserved gdt blocks.  So add the code to grow the s_group_info array
    as needed.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

How big was the file system before the resize, and how much larger did
you resize it?  If it is this bug, the s_group_info array is allocated
based on the file system size when the file system is mounted.  So it
would only be happening after a online resize and before the file
system is unmounted and/or the system is rebooted and the file system
is mounted again.

						- Ted
