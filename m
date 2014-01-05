From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e4defrag: choose the best available posix_fadvise variant
Date: Sun, 5 Jan 2014 09:00:49 -0500
Message-ID: <20140105140049.GB5849@thunk.org>
References: <23c2b99441922fe311235e241eca52e9701e54d4.1388645034.git.baruch@tkos.co.il>
 <20140103004710.GA31411@thunk.org>
 <20140103045747.GM6589@tarshish>
 <20140103162344.GD31411@thunk.org>
 <20140105061233.GA5849@thunk.org>
 <20140105064631.GC5316@tarshish>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Baruch Siach <baruch@tkos.co.il>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46092 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139AbaAEOAx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Jan 2014 09:00:53 -0500
Content-Disposition: inline
In-Reply-To: <20140105064631.GC5316@tarshish>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 05, 2014 at 08:46:31AM +0200, Baruch Siach wrote:
> >     Rename the internal posix_fadvise() implementation to avoid collision with the
> >     C library signature that is sometimes present event when the implementation
> >     itself is not. This fixes build errors like:
> 
> This paragraph is not needed anymore, since the internal posix_fadvise is 
> completely removed.

Good point, thanks.  I'll remove it.

> > +	fadvise64
> 
> There is no such symbol in any C library that I know of (unlike fallocate64). 
> Where have you see this?

Dietlibc has it.  It's a little moot since at the moment e4defrag uses
a number of other functions which aren't supported by dietlibc.
(Including nftw64 and FTW_MOUNT/FTW_PHYS; nftw64 isn't a part of any
standard, but FTW_MOUNT and FTW_PHYS is guaranteed by the Single Unix
Specification. We could rewrite nftw64 in terms of nftw and stat64,
which would be supported by dietlibc, but that still leaves FTW_MOUNT
and FTW_PHYS.  But since that's missing standards-compliant
functionality, and it shouldn't be that hard to implement, I'm hopeful
the dietlibc maintianer will accept a patch to fix this at some point.)

The main reason why I like dietlibc is because it allows me to build a
stripped e2fsck.static in 433k on x86_64, instead of 1312k doing a
static build using glibc.  It's also useful as a convenient
"mini-libc", which makes it much more likely that e2fsprogs can be
compiled on non-glibc libc's, such as uClibc and Android's Bionic.
(I'd consider patches to the build system for other mini-libc's, but
dietlibc has the advantage of being available on almost all Debian
architectures, and it is very convenient for me to use.)

The other benefit of dietlibc, along with work such as Andreas' test
builds e2fsprogs on MacOS X, is that it helps ensure e2fsprogs's
portability across other operating systems.  So for example, although
I don't do any testing trying to build e2fsprogs for use with
Android/Cyanogen, I was pleased to find out that 1.42.9 built cleanly
against Bionic.

It turns out dietlibc support was silently broken a while back due to
changes in autoconf, so there were a couple fix ups I needed to make
e2fsprogs work well on dietlibc again.

> > - * fadvise() -		Give advice about file access.
> > +/* Local definitions of some syscalls glibc may not yet have
> 
> This comment becomes redundant. We now rely on the C library to provide the 
> system call.

Good point, I'll remove it.

> > +#define posix_fadvise	posix_fadvise
> 
> Also not needed.

Yup, will fix.

Thanks for the review!

						- Ted
