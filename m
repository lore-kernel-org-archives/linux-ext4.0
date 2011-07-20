From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Problems building xfsprogs
Date: Wed, 20 Jul 2011 13:32:16 -0500
Message-ID: <4E271F30.6070102@redhat.com>
References: <20110720175918.GB17971@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508Ab1GTScU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Jul 2011 14:32:20 -0400
In-Reply-To: <20110720175918.GB17971@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/20/2011 12:59 PM, Ted Ts'o wrote:
> I was trying to build xfsprogs in preparation for building xfstests in
> an hermetic environment (as opposed to depending on magic XFS headers
> being installed in /usr/include...)
> 
> What I found first of all (building on Ubuntu 10.10) was
> 
> a) "make configure" doesn't work until I patch the top-level Makefile:
> 
> diff --git a/Makefile b/Makefile
> index c40fb2c..37973f5 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -82,7 +82,7 @@ configure:
>  	libtoolize -c $(LIBTOOLIZE_INSTALL) -f
>  	cp include/install-sh .
>  	aclocal -I m4
> -	autoconf
> +	autoconf -I m4
>  
>  include/builddefs: configure
>  	./configure $$LOCAL_CONFIGURE_OPTIONS

How does it fail?  Works here(tm):

[sandeen@sandeen tmp]$ git clone
git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
[sandeen@sandeen xfsprogs-dev]$ cd xfsprogs-dev
[sandeen@sandeen xfsprogs-dev]$ make
...
aclocal -I m4
autoconf
./configure $LOCAL_CONFIGURE_OPTIONS
checking build system type... x86_64-redhat-linux-gnu
checking host system type... x86_64-redhat-linux-gnu
...
    [CC]     attrset.o
    [LD]     xfs_db
[sandeen@sandeen xfsprogs-dev]$

Wonder what the difference is...

> b) By default xfsprogs builds with DEBUG, and this causes building
> libxfs/xfs_ialloc.c to blow up since there a reference of
> xfs_stack_trace() which is undefined under a #ifdef DEBUG.  The way to
> fix this is to build with DEBUG=-DNDEBUG, but it took me an hour or
> two figure this out....

Odd, libxfs/Makefile has:

DEBUG = -DNDEBUG

But to be honest, the DEBUG stuff has been a thorn in my side for Fedora
too, with the extra CFLAGS it sets, something gets goobered up by
default, and I build with -DNDEBUG for those packages too.

I just haven't sorted it out yet ....

So things to look into, but can you also describe how building xfstests
fails for you when you have all the ubuntu xfsprogs-related packages
installed?

-Eric


> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

