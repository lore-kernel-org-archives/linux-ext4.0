From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 3/6] dax: add tracepoint infrastructure, PMD tracing
Date: Fri, 25 Nov 2016 07:37:47 +0000
Message-ID: <20161125073747.GU1555@ZenIV.linux.org.uk>
References: <1479926662-21718-1-git-send-email-ross.zwisler@linux.intel.com>
 <1479926662-21718-4-git-send-email-ross.zwisler@linux.intel.com>
 <20161124173220.GR1555@ZenIV.linux.org.uk>
 <20161125024918.GX31101@dastard>
 <20161125041419.GT1555@ZenIV.linux.org.uk>
 <20161125070642.GZ31101@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.cz>,
        Matthew Wilcox <mawilcox@microsoft.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-nvdimm@lists.01.org,
        Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161125070642.GZ31101@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Nov 25, 2016 at 06:06:42PM +1100, Dave Chinner wrote:

> > Tell that to Linus.  You had been in the room, IIRC, when that had been
> > brought up this year in Santa Fe.
> 
> No, I wasn't at KS or plumbers, so this is all news to me.

Sorry, thought you had been at KS ;-/  My apologies...

[snip bloody good points I fully agree with]

> I understand why there is a desire for stable tracepoints, and
> that's why I suggested that there should be an in-kernel API to
> declare stable tracepoints. That way we can have the best of both
> worlds - tracepoints that applications need to be stable can be
> declared, reviewed and explicitly marked as stable in full knowledge
> of what that implies. The rest of the vast body of tracepoints can
> be left as mutable with no stability or existence guarantees so that
> developers can continue to treat them in a way that best suits
> problem diagnosis without compromising the future development of the
> code being traced. If userspace finds some of those tracepoints
> useful, then they can be taken through the process of making them
> into a maintainable stable form and being marked as such.

My impression is that nobody (at least kernel-side) wants them to be
a stable ABI, so long as nobody in userland screams about their code
being broken, everything is fine.  As usual, if nobody notices an ABI
change, it hasn't happened.  The question is what happens when somebody
does.

> We already have distros mounting the tracing subsystem on
> /sys/kernel/tracing. Expose all the stable tracepoints there, and
> leave all the other tracepoints under /sys/kernel/debug/tracing.
> Simple, clear separation between stable and mutable diagnostic
> tracepoints for users, combined with a simple, clear in-kernel API
> and process for making tracepoints stable....

Yep.  That kind of separation would be my preference as well - ideally,
with review for stable ones being a lot less casual that for unstable;
AFAICS what happens now is that we have no mechanisms for marking them as
stable or unstable and everything keeps going on hope that nobody will
cause a mess by creating such a userland dependency.  So far it's been mostly
working, but as the set of tracepoints (and their use) gets wider and wider,
IMO it's only matter of time until we get seriously screwed that way.

Basically, we are gambling on the next one to be cast in stone by userland
dependency being sane enough to make it possible to maintain it indefinitely
and I don't like the odds.
