From: tytso@mit.edu
Subject: Re: Using parts of ext2_fs.h in BSD licensed code
Date: Mon, 15 Mar 2010 14:23:38 -0400
Message-ID: <20100315182338.GG4484@thunk.org>
References: <e1e08eb01003150942s6350c04fn6b3d696fed8b7fc1@mail.gmail.com>
 <e1e08eb01003151026q1352c02btf12d7cd6d84c3f21@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Evgeniy Ivanov <lolkaantimat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:36316 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965653Ab0COSzt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Mar 2010 14:55:49 -0400
Content-Disposition: inline
In-Reply-To: <e1e08eb01003151026q1352c02btf12d7cd6d84c3f21@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 15, 2010 at 08:26:16PM +0300, Evgeniy Ivanov wrote:
> Just found, that recently FreeBSD got this:
> http://www.freebsd.org/cgi/cvsweb.cgi/src/sys/fs/ext2fs/ext2fs.h
> It looks like I can easily include it to the BSD-licensed project and
> no GPL violation. But I dunno how did they wrote ext2fs.h, since it
> still must be based on ext2_fs.h

Constants and code points aren't subject to copyright, so they don't
have ask any question.  The places where things start to get dicy is
with inline function and CPP macros, especially when the code starts
become non-trivial.  i.e., there's only one way to do "(foo & MASK) !=
0", so that's probably not subject to copyright.  A complicated 20
line function, even if it's in a header file, is probably going to be
subject to copyright.  What is and isn't a matter of copyright is
something you'd have to get a lawyer to answer for you.

You can of couse also request permission, but that can get tricky,
especially if the person who originally wrote it can't easily be
tracked down (I haven't talked or e-mailed with Remy in years), or if
it was done by someone while being paid by their employer, in which
case some corporate lawyers might have to be dragged in to give
permission.

Fortunately I don't think there's much in the way of complicated code
in the header files that you would have to deal with.

Best regards,

						- Ted
