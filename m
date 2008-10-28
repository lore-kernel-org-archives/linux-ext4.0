From: tony.luck@intel.com
Subject: Re: [PATCH,RFC] ext3: Add support for non-native signed/unsigned htree hash algorithms
Date: Tue, 28 Oct 2008 10:30:57 -0700
Message-ID: <200810281730.m9SHUvD9002143@agluck-lia64.sc.intel.com>
References: <20081028142458.GC8869@mit.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	tony.luck@intel.com
To: Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:4970 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbYJ1Ra6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Oct 2008 13:30:58 -0400
In-Reply-To: <20081028142458.GC8869@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> I've added Tony Luck to the CC list since as the Itanium maintainer,
> he's most likely to be able to speak to both cross compilation issues
> especially as it relates to the Intel Compiler....

Sorry to disappoint ... but I'm not an expert on cross compilation (I
run all my builds natively) or on the Intel compiler (I just use gcc).

> Tony, Andrew has requested I clean up this compile-time test to
> determine whether variables of type char are signed or unsigned:

> 	char c;
> 	...
> 	c = (char) 255;
> 	if (((int) c) == -1) {
> 		...
> 	}

> ... since it results in this annoying gcc warning:

> > fs/ext3/super.c:1750: warning: comparison is always false due to limited range of data type

I don't see any code like this near line 1750 of fs/ext3/super.c so
I guess the offending lines have been moved up or down by recent
changes.

> Two possible solutions which come to mind is to use the C preprocessor
> macros CHAR_MIN/CHAR_MAX as defined in limits.h, or to use
> __CHAR_UNSIGNED__ which is defined by gcc on platforms where char's
> are unsigned (or if the gcc option --funsigned-char is given).  

> I believe at this point, it's settled that either of the above
> solutions should do the right thing for gcc, either in
> cross-compilation environments, or natively.  (I prefer
> __CHAR_UNSIGNED__ since it doesn't depend on the userspace header
> files, which might be screwy on some distributions, and depending on a
> macro set by gcc seems much more robust in cross-compilation
> environments.)

Either option seems OK to me. char is signed on Itanium, so
the Intel compiler doesn't need to provide __CHAR_UNSIGNED__.

> The question is whether this solution is likely to work on the Intel C
> compiler.  My understanding is that a kernel compiled with gcc is
> pathetically slow on the Itanic (not to mention taking aeons to
> compile), and so there has always been a desire to make sure that the
> Linux Kernel will compile on the Intel C compiler, at least for the
> Intanium platform.  Do you know if icc will do the right thing as far
> as defining __CHAR_UNSIGNED__ if necessary?  

The Linux kernel doesn't benefit hugely from being compiled by the
Intel compiler ... there just aren't that many loops that run
for many iterations, no floating point code, and little else that
can benefit.  I challenge the "aeons to compile" claim too.  Most
of the config files I build take about 2 minutes each (and this is
on a basic 4-socket machine ... not on a giant SGI box). Not
great by the "5 seconds to build" that Linus mentioned at KS,
but hardly "aeons".

> I don't even know if the Itanium is one of those wierd-sh*t platforms
> that tried to make char's unsigned, one of those really horrific
> design decisions perpetrated by the Arm and PowerPC platforms since it

"char" defaults to signed on Itanium (so in this respect at least it is
a "sane" architecture :-)

> tends to break compatibility with K&R C which doesn't even have a
> signed keyword (and for which char's were always signed).  If it's one
> of the sane platforms, then this might not matter so much.

This is incorrect.  K&R (first edition, (c) 1978) says (p. 183):
 "6.1 Characters and integers
	...
  Whether or not sign-extension occurs for characters is machine
  dependent, but it is guaranteed that a member of the standard
  character set is non-negative.  Of the machines treated by this
  manual, only the PDP-11 sign-extends."

-Tony
