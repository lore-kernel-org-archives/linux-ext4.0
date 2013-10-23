From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: fix build w/o quota
Date: Wed, 23 Oct 2013 11:22:51 -0400
Message-ID: <20131023152251.GC21448@thunk.org>
References: <52615CC0.7010007@redhat.com>
 <20131023125147.GA31449@orion.maiolino.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49711 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230Ab3JWPWz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Oct 2013 11:22:55 -0400
Content-Disposition: inline
In-Reply-To: <20131023125147.GA31449@orion.maiolino.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 23, 2013 at 10:51:48AM -0200, Carlos Maiolino wrote:
> Hey Eric,
> 
> I did a test here building the e2fsprogs -next tree without quota support and I
> didn't have any problems configuring and compiling it. Can you share the test
> you did and failed?
> 

I've been able to replicate the problem. You may need to rm -rf your
build directory and then run from scratch to see it.

Sorry for not responding sooner; I'm in Edinburgh this week and in
conference mode.

The reason why we have continud building libquota even when libsupport
is not defined is because the plan is to rename libquota to libsupport
once 1.42.x is released.  Libquota/libsupport is desinged to never be
built as a shared library, and the idea is to move things like
e2fsck/profile.c which is used by e2fsck and mke2fs, into libsupport.
The rational for that is that the functions in libquota are already
horribly e2fsprogs specific and aren't really set up to be usable as a
generic quota support library.  So we might as well make it be a
standardized place for internal support functions used by multiple
e2fsprogs programs.

I'll try to find a fix that minimizes deltas between the maint branch
and the next branch.

Cheers,

					- Ted
