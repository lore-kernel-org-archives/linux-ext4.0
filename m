From: Jan Kara <jack@suse.cz>
Subject: Re: Why is 64bit option always on by default now?
Date: Wed, 4 Jan 2017 17:18:39 +0100
Message-ID: <20170104161839.GB3607@quack2.suse.cz>
References: <CAKnMEmEd0hdS_ajNhsr9t9GvCZXG4MD6-K-tsx5YKRX9gsQDmw@mail.gmail.com>
 <20161223024537.4sg2ck2bmkgsn2ry@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dan Arena <ddan39@gmail.com>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50679 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751958AbdADQeC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 4 Jan 2017 11:34:02 -0500
Content-Disposition: inline
In-Reply-To: <20161223024537.4sg2ck2bmkgsn2ry@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 22-12-16 21:45:37, Ted Tso wrote:
> 64-bit support has been around for 7 years (since e2fsprogs 1.41).
> And yes, e2fsprogs 1.43 now has the ability to convert a file system
> from 32-bit to 64-bit, but this is an inherently dangerous thing to
> do, since it requires rewriting the inode table.  If you ever crash or
> power fail during the conversion, *boom*, you can lose all or most of
> your data.  So the conversion can be used as a short cut where you
> back up the whole file system, and then try to convert to 64-bit, and
> if it succeeds, then you don't have to do the restore step.  If it
> crashes and you lose everything, then you can reformat the file system
> and restore from backups.  :-)
> 
> In general, I assume that embedded developers are more sophisticated
> than users (who will use the mke2fs in the installer to install thier
> root file system, which will be a matched set with the bootloader).  I
> also can't be responsible for crappy, obsolete bootloader on embedded
> devices, some of which have device drivers only available in ancient
> BSP kernels using 3.10, etc.

Just to add some more data, we have actually got similar reports few months
ago for openSUSE once we shipped updated e2fsprogs. And the bootloader they
used (u-boot) does not support 64-bit feature at all. My answer has been
similar to yours - either update the bootloader or change mke2fs.conf in
your setup. There's one guy working on implementing 64-bit support in
u-boot BTW.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
