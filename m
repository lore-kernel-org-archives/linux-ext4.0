From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH 1/4] fs: new infrastructure for writeback error
 handling and reporting
Date: Mon, 3 Apr 2017 09:15:47 -0700
Message-ID: <20170403161547.GE30811@bombadil.infradead.org>
References: <20170331192603.16442-1-jlayton@redhat.com>
 <20170331192603.16442-2-jlayton@redhat.com>
 <20170403144722.GB30811@bombadil.infradead.org>
 <1491232791.2673.1.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, akpm@linux-foundation.org,
        tytso@mit.edu, jack@suse.cz, neilb@suse.com
To: Jeff Layton <jlayton@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1491232791.2673.1.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Apr 03, 2017 at 11:19:51AM -0400, Jeff Layton wrote:
> Yes, so just to be clear here if you bump a 32 bit counter every
> microsecond you'll end up wrapping in a little over an hour. How fast
> can DAX generate I/O errors? :)

I admit to not having picked through the code, but how often do we try
to do writebacks?  And how often do we retry writebacks once an -EIO
has happened?  Once we mark a page as PG_error, do we keep trying to
write it back and set the AS error each time?

> I'm fine with a 32 bit counter (and even with using the low order bits
> to store error flags) if we're ok with that limitation. The big
> question there is whether it's ok to continue reporting -EIO when there
> has actually been nothing but -ENOSPC errors since the last fsync. I
> think it's a corner case that's not of terribly great concern so I'm
> fine with that.

Yeah, I was thinking about that, and I'm fine with it too.

> We could try to mitigate it by zeroing out the value when i_writecount
> goes to zero though. Then if you close all of the fds on the file, the
> error is cleared. Or maybe we could add a new ioctl to explicitly zero
> it out?

I'm OK with zeroing the wb_err once i_writecount drops to 0.  Everybody
who cares has already been notified.  The new ioctl feels like overkill.
