From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/6] xfstests: Define fallocate flags locally in fsx
Date: Tue, 25 Feb 2014 13:56:16 -0800
Message-ID: <20140225215616.GA29752@infradead.org>
References: <1393355728-12056-1-git-send-email-lczerner@redhat.com>
 <1393355728-12056-5-git-send-email-lczerner@redhat.com>
 <20140225203922.GC13647@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140225203922.GC13647@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Feb 26, 2014 at 07:39:22AM +1100, Dave Chinner wrote:
> > index b3c30db..331257e 100644
> > --- a/ltp/fsx.c
> > +++ b/ltp/fsx.c
> > @@ -35,8 +35,13 @@
> >  #endif
> >  #ifdef FALLOCATE
> >  #include <linux/falloc.h>
> > +#ifndef FALLOC_FL_PUNCH_HOLE
> > +#define FALLOC_FL_PUNCH_HOLE    0x02 /* de-allocates range */
> > +#endif
> > +#ifndef FALLOC_FL_ZERO_RANGE
> > +#define FALLOC_FL_ZERO_RANGE    0x10 /* zeroes range */
> > +#endif
> >  #endif
> 
> This pattern is appearing all over the place in xfstests now.  I'd
> suggest that this should really be handled by autoconf,
> include/config.h and src/globals.h....

Can we handle this nicely using autoconf, especially in the case of O_
flags that might be different for different architectures?

Either way having a single header for the various flags that might not
be present in the system headers sounds like a good plan.

