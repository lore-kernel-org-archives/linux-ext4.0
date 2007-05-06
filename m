From: Theodore Tso <tytso@mit.edu>
Subject: Re: PATCH: use CFLAGS when linking always
Date: Sun, 6 May 2007 09:54:31 -0400
Message-ID: <20070506135431.GA4004@thunk.org>
References: <200705050920.56558.dennis@ausil.us> <20070505192647.GC21049@thunk.org> <200705052206.08371.dennis@ausil.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dennis Gilmore <dennis@ausil.us>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:34285 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754736AbXEFNyi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 6 May 2007 09:54:38 -0400
Content-Disposition: inline
In-Reply-To: <200705052206.08371.dennis@ausil.us>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, May 05, 2007 at 10:06:01PM -0500, Dennis Gilmore wrote:
> Once upon a time Saturday 05 May 2007, Theodore Tso wrote:
> > On Sat, May 05, 2007 at 09:20:47AM -0500, Dennis Gilmore wrote:
> > > for multilib archs default CFLAGS may be inappropriate  and reslut in
> > > binaries unable to be linked.  since e2fsprogs uses gcc for linking I
> > > noticed this while building for sparc64.  patch has been tested and
> > > applied in Aurora SPARC Linux.
> >
> > What options do you need, and why don't you just specify them via:
> >
> > configure --with-ldopts="--foo-ld-flag"
> >
> > 					- Ted
> 
> defaults on sparc64  result in 64 bit objects  but gcc trying to create a 32 
> bit binary.  as a result the build blows up horribly.  the patch ensures that 
> CFLAGS is used in linking.  since gcc is used to link it is needed.
> 

What CFLAGS are you passing to configure, exactly?  And why can't you
also pass them to configure via --with-ldopts?

						- Ted
