From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Why is 64bit option always on by default now?
Date: Thu, 22 Dec 2016 21:45:37 -0500
Message-ID: <20161223024537.4sg2ck2bmkgsn2ry@thunk.org>
References: <CAKnMEmEd0hdS_ajNhsr9t9GvCZXG4MD6-K-tsx5YKRX9gsQDmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dan Arena <ddan39@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53366 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752549AbcLWCpp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 22 Dec 2016 21:45:45 -0500
Content-Disposition: inline
In-Reply-To: <CAKnMEmEd0hdS_ajNhsr9t9GvCZXG4MD6-K-tsx5YKRX9gsQDmw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

64-bit support has been around for 7 years (since e2fsprogs 1.41).
And yes, e2fsprogs 1.43 now has the ability to convert a file system
from 32-bit to 64-bit, but this is an inherently dangerous thing to
do, since it requires rewriting the inode table.  If you ever crash or
power fail during the conversion, *boom*, you can lose all or most of
your data.  So the conversion can be used as a short cut where you
back up the whole file system, and then try to convert to 64-bit, and
if it succeeds, then you don't have to do the restore step.  If it
crashes and you lose everything, then you can reformat the file system
and restore from backups.  :-)

In general, I assume that embedded developers are more sophisticated
than users (who will use the mke2fs in the installer to install thier
root file system, which will be a matched set with the bootloader).  I
also can't be responsible for crappy, obsolete bootloader on embedded
devices, some of which have device drivers only available in ancient
BSP kernels using 3.10, etc.

Also, people who care can always edit /etc/mke2fs.conf to adjust the
defaults.

> While doing some research I read that it also broke compatibility with
> a few other things. I am not sure what the best solution is, I was
> just surprised how this compatibility-breaking change was made with as
> far as I know not much warning to the community or when running the
> command or something.

It's documented in the Release Notes.  You're the first person who has
complained.  Part of it is that community distributions have a much
lower threshold of compatibility requirements compared with, say,
enterprise distributions.  Enterprise distribution vendors are free to
edit /etc/mke2fs.conf in their packages if they want to be more
conservative.  Similarly, with Debian, we enabled the meta checksum
feature in the testing distribution precisely so we could get more
users testing the code and submitting bug report.

Community distributions have always been more aggressive --- so in
general, users aren't whining when Fedora 25 ships Wayland which might
have some incompatibilities with hardware and software.  Instead they
are (in general) happy that Fedora is taking an aggressive stance with
Wayland.  Someone has to be first to release software....

	  	      	    	     	     - Ted
