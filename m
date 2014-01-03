From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e4defrag: choose the best available posix_fadvise variant
Date: Fri, 3 Jan 2014 11:23:44 -0500
Message-ID: <20140103162344.GD31411@thunk.org>
References: <23c2b99441922fe311235e241eca52e9701e54d4.1388645034.git.baruch@tkos.co.il>
 <20140103004710.GA31411@thunk.org>
 <20140103045747.GM6589@tarshish>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Baruch Siach <baruch@tkos.co.il>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45662 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358AbaACQXs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Jan 2014 11:23:48 -0500
Content-Disposition: inline
In-Reply-To: <20140103045747.GM6589@tarshish>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 03, 2014 at 06:57:48AM +0200, Baruch Siach wrote:
> 
> Thanks. You seem to have applied v1 of this patch without the #else comment 
> fix. I'll fix this up in a follow up patch. Please push your tree so I can 
> reference this commit in the log.

Oh, oops.  I'll find the other version of the patch and fix it up.  I
did notice that you had two different patches sent out, and I thought
I had picked the later one, but obviously I didn't.  (Or maybe I
replied to the wrong version.  I'll double check.)

In the future, it would be much appreciated if you included an
explicit v2 in the subject line of the e-mail.

> Another problem with this patch is that it doesn't takes into
> account the problem of passing 64bit values on 32bit
> architectures. See the discussion under NOTES in the syscall(2) man
> page for more information on that. I'll try to address this in
> another patch if you think it's worth it. The solution is likely to
> look quite ugly when taking the arch specific alignment requirements
> also into account. The alternative is to require C library support
> for fadvise64_64 on 32bit architectures.

Ugh.  I wonder how many libc's don't actually support posix_fadvise at
this point.  This hack was put in a at least back in September of
2009.  It's been over three years at this point.  Maybe it's just time
to blow out the build with the error and tell people who complain to
get an upgraded libc.

Even dietlibc has posix_fadvise at this point.  (And fadvise64(),
although interestingly, not posix_fadvise64).

Given how ugly it is to support the syscall, it may be that we're
better off trying to use posix_fadvise64, fadvise64, fadvise, in that
order, and giving up on the direct-call syscall approach.  After all,
syscall interfaces is the reason why we have a C library in the first
place.

You have more experience with uClibc --- are there any platforms where
it doesn't have posix_fadvise, posix_fadvise64, or some similarly
named variant?

Thanks,

						- Ted
