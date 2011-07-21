From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Problems building xfsprogs
Date: Thu, 21 Jul 2011 12:31:22 -0400
Message-ID: <20110721163122.GD3304@thunk.org>
References: <20110720175918.GB17971@thunk.org>
 <20110721090619.GA26263@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57044 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598Ab1GUQb1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Jul 2011 12:31:27 -0400
Content-Disposition: inline
In-Reply-To: <20110721090619.GA26263@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 21, 2011 at 05:06:19AM -0400, Christoph Hellwig wrote:
> I works fine for me on various releases of Debian, Fedsora, RHEL and
> SLES.  But all he machines I've quickly checked seem to have an autoconf
> that can handle -I, so could you please send this pach with a proper
> signoff and description?

Sure, will do.

> > b) By default xfsprogs builds with DEBUG, and this causes building
> > libxfs/xfs_ialloc.c to blow up since there a reference of
> > xfs_stack_trace() which is undefined under a #ifdef DEBUG.  The way to
> > fix this is to build with DEBUG=-DNDEBUG, but it took me an hour or
> > two figure this out....
> 
> The defaul actually is DEBUG=-DNDEBUG.  No sure how you go he debug
> build. but we surely should fix it.  I'll add the stub as soon as I get
> some time.

Well, the default from xfstest-dev/m4/package_globals.m4 is:

    DEBUG=${DEBUG:-'-DDEBUG'}					dnl  -DNDEBUG
    debug_build="$DEBUG"
    AC_SUBST(debug_build)

I'm guessing you're getting the default of DEBUG=-DNDEBUG because
you're getting the package_globals.m4 package from some other m4
directory....

						- Ted


