From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/6] xfstests: Define fallocate flags locally in fsx
Date: Wed, 26 Feb 2014 17:07:33 +1100
Message-ID: <20140226060733.GT13647@dastard>
References: <1393355728-12056-1-git-send-email-lczerner@redhat.com>
 <1393355728-12056-5-git-send-email-lczerner@redhat.com>
 <20140225203922.GC13647@dastard>
 <20140225215616.GA29752@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:23222 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750943AbaBZGHi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Feb 2014 01:07:38 -0500
Content-Disposition: inline
In-Reply-To: <20140225215616.GA29752@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 25, 2014 at 01:56:16PM -0800, Christoph Hellwig wrote:
> On Wed, Feb 26, 2014 at 07:39:22AM +1100, Dave Chinner wrote:
> > > index b3c30db..331257e 100644
> > > --- a/ltp/fsx.c
> > > +++ b/ltp/fsx.c
> > > @@ -35,8 +35,13 @@
> > >  #endif
> > >  #ifdef FALLOCATE
> > >  #include <linux/falloc.h>
> > > +#ifndef FALLOC_FL_PUNCH_HOLE
> > > +#define FALLOC_FL_PUNCH_HOLE    0x02 /* de-allocates range */
> > > +#endif
> > > +#ifndef FALLOC_FL_ZERO_RANGE
> > > +#define FALLOC_FL_ZERO_RANGE    0x10 /* zeroes range */
> > > +#endif
> > >  #endif
> > 
> > This pattern is appearing all over the place in xfstests now.  I'd
> > suggest that this should really be handled by autoconf,
> > include/config.h and src/globals.h....
> 
> Can we handle this nicely using autoconf, especially in the case of O_
> flags that might be different for different architectures?

I think so, because config.h is generated from config.h.in and
ends up looking like:

#define HAVE_SOME_FUNCTION 1

src/globals.h is controlled directly by us, and ends up looking
like:

#ifdef HAVE_SOME_FUNCTION
#include <header_for_some_function.h>
#endif

If we add all the defines that may be missing that same ifdef
section, and make sure that all code includes globals.h, then
all the code will have the "HAVE_SOME_FUNCTION" defines and the
appropriate header files and definitions included.

> Either way having a single header for the various flags that might not
> be present in the system headers sounds like a good plan.

*nod*

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
