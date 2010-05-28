From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/6] writeback: initial tracing support
Date: Fri, 28 May 2010 10:44:16 +1000
Message-ID: <20100528004416.GV12087@dastard>
References: <1274784852-30502-1-git-send-email-david@fromorbit.com>
 <1274784852-30502-2-git-send-email-david@fromorbit.com>
 <20100527143233.836b2c47.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	tytso@mit.edu, jens.axboe@oracle.com
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:56452 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754260Ab0E1Aof (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 May 2010 20:44:35 -0400
Content-Disposition: inline
In-Reply-To: <20100527143233.836b2c47.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 27, 2010 at 02:32:33PM -0700, Andrew Morton wrote:
> On Tue, 25 May 2010 20:54:07 +1000
> Dave Chinner <david@fromorbit.com> wrote:
> 
> > From: From: Jens Axboe <jens.axboe@oracle.com>
> > 
> > Trace queue/sched/exec parts of the writeback loop.
> 
> It would be most useful if this patchset's description provided sample
> tracing output, so we can see what the patch is actually providing us.

This is just a forward port of Jen's patch. I guess I'll have to
clean it up some more...

> 
> > -#define inode_to_bdi(inode)	((inode)->i_mapping->backing_dev_info)
> > -
> > -/*
> > - * We don't actually have pdflush, but this one is exported though /proc...
> > - */
> > -int nr_pdflush_threads;
> > -
> >  /*
> >   * Passed into wb_writeback(), essentially a subset of writeback_control
> >   */
> > @@ -63,6 +57,16 @@ struct bdi_work {
> >  	unsigned long state;		/* flag bits, see WS_* */
> >  };
> >  
> > +#define CREATE_TRACE_POINTS
> > +#include <trace/events/writeback.h>
> > +
> > +#define inode_to_bdi(inode)	((inode)->i_mapping->backing_dev_info)
> 
> Could/should be implemented in C.

OK.

> 
> > +/*
> > + * We don't actually have pdflush, but this one is exported though /proc...
> > + */
> > +int nr_pdflush_threads;
> 
> So this is always zero now?

I guess so. I'd forgotten that this was in the original patch....

> We don't want to keep it forever.  Add a
> printk_once("nr_pdflush_threads is deprecated") when someone reads it,
> remove it in 2014.

OK.

> > --- /dev/null
> > +++ b/include/trace/events/writeback.h
> > @@ -0,0 +1,171 @@
> > +#undef TRACE_SYSTEM
> > +#define TRACE_SYSTEM writeback
> > +
> > +#if !defined(_TRACE_WRITEBACK_H) || defined(TRACE_HEADER_MULTI_READ)
> 
> Seems wrong.  If you define TRACE_HEADER_MULTI_READ then include this
> header twice, things explode.  Which negates the purpose of
> _TRACE_WRITEBACK_H.

Every other trace event header does this, so if it's wrong then the
same mistake is in at least 30 files now. I don't know enough about
the tracing code to know why this is done, and I'm not keen to
address such a mistake here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
