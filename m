From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: fix trivial build warnings
Date: Sat, 18 Jul 2009 14:04:13 -0400
Message-ID: <20090718180413.GA2416@mit.edu>
References: <4A5D2BED.30009@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:45502 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbZGRSEX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 18 Jul 2009 14:04:23 -0400
Content-Disposition: inline
In-Reply-To: <4A5D2BED.30009@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 14, 2009 at 08:07:57PM -0500, Eric Sandeen wrote:
> Quite a lot of warnings have crept into the build; this fixes
> many of the trivial ones.  Mostly unused variables, a
> couple of header file inclusions, and one missing return
> value.
> 
> There are a few other warnings that I'll send patches for
> in a bit.

Most of these ones I had fixed in the e2fsprogs maint branch already,
except for this one:

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index a9b01cb..e10fd35 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -20,6 +20,7 @@
 
 #include <stdio.h>
 #include <string.h>
+#include <strings.h>
 #include <fcntl.h>
 #include <ctype.h>
 #include <time.h>

... which was in one of Val's patches as well, but for the life of me
I can't figure out what warnings it's supposed to suppress.  It
doesn't make a difference for me, and we're not using any of the
traditional functions which would be defined in strings.h as opposed
to string.h (i.e., bcopy, et. al.)

I assume this must be a Fedora header file thing?  What difference
does it make for you?

					- Ted
