From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/6] writeback: initial tracing support
Date: Thu, 27 May 2010 21:20:57 -0400
Message-ID: <1275009657.22648.584.camel@gandalf.stny.rr.com>
References: <1274784852-30502-1-git-send-email-david@fromorbit.com>
	 <1274784852-30502-2-git-send-email-david@fromorbit.com>
	 <20100527143233.836b2c47.akpm@linux-foundation.org>
	 <20100528004416.GV12087@dastard>
Reply-To: rostedt@goodmis.org
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	tytso@mit.edu, jens.axboe@oracle.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62515 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786Ab0E1BVA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 May 2010 21:21:00 -0400
In-Reply-To: <20100528004416.GV12087@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2010-05-28 at 10:44 +1000, Dave Chinner wrote:
> On Thu, May 27, 2010 at 02:32:33PM -0700, Andrew Morton wrote:
> >
> > > --- /dev/null
> > > +++ b/include/trace/events/writeback.h
> > > @@ -0,0 +1,171 @@
> > > +#undef TRACE_SYSTEM
> > > +#define TRACE_SYSTEM writeback
> > > +
> > > +#if !defined(_TRACE_WRITEBACK_H) || defined(TRACE_HEADER_MULTI_READ)
> > 
> > Seems wrong.  If you define TRACE_HEADER_MULTI_READ then include this
> > header twice, things explode.  Which negates the purpose of
> > _TRACE_WRITEBACK_H.
> 
> Every other trace event header does this, so if it's wrong then the
> same mistake is in at least 30 files now. I don't know enough about
> the tracing code to know why this is done, and I'm not keen to
> address such a mistake here...

It's all part of the CPP voodoo ritual. You don't want to know why, just
do it, otherwise you may find dancing CPP skulls running around your
bathtub.

If you want to be a CPP Voodoo Witch doctor too, read up on LWN, I
describe some of the magic there.

-- Steve


