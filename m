From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/6] writeback: initial tracing support
Date: Thu, 27 May 2010 21:18:21 -0400
Message-ID: <1275009502.22648.582.camel@gandalf.stny.rr.com>
References: <1274784852-30502-1-git-send-email-david@fromorbit.com>
	 <1274784852-30502-2-git-send-email-david@fromorbit.com>
	 <20100527143233.836b2c47.akpm@linux-foundation.org>
Reply-To: rostedt@goodmis.org
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, tytso@mit.edu, jens.axboe@oracle.com
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:45635 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716Ab0E1BSY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 May 2010 21:18:24 -0400
In-Reply-To: <20100527143233.836b2c47.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2010-05-27 at 14:32 -0700, Andrew Morton wrote:

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

That's intended. It is documented in
samples/trace_events/trace-events-samples.h

The purpose of the TRACE_HEADER_MULTI_READ is to read the trace header
multi times. ;-)


You can also read about it here:

 http://lwn.net/Articles/379903/

here:

  http://lwn.net/Articles/381064/

and here:

   http://lwn.net/Articles/383362/

-- Steve

> 
> > +#define _TRACE_WRITEBACK_H
> > +
> > +#include <linux/backing-dev.h>
> > +#include <linux/writeback.h>
> > +

