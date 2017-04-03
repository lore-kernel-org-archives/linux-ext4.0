From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [RFC PATCH 1/4] fs: new infrastructure for writeback error
 handling and reporting
Date: Mon, 03 Apr 2017 12:30:58 -0400
Message-ID: <1491237058.2673.3.camel@redhat.com>
References: <20170331192603.16442-1-jlayton@redhat.com>
         <20170331192603.16442-2-jlayton@redhat.com>
         <20170403144722.GB30811@bombadil.infradead.org>
         <1491232791.2673.1.camel@redhat.com>
         <20170403161547.GE30811@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, akpm@linux-foundation.org,
        tytso@mit.edu, jack@suse.cz, neilb@suse.com
To: Matthew Wilcox <willy@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:32950 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753999AbdDCQbC (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Apr 2017 12:31:02 -0400
Received: by mail-qk0-f182.google.com with SMTP id h67so20321302qke.0
        for <linux-ext4@vger.kernel.org>; Mon, 03 Apr 2017 09:31:02 -0700 (PDT)
In-Reply-To: <20170403161547.GE30811@bombadil.infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2017-04-03 at 09:15 -0700, Matthew Wilcox wrote:
> On Mon, Apr 03, 2017 at 11:19:51AM -0400, Jeff Layton wrote:
> > Yes, so just to be clear here if you bump a 32 bit counter every
> > microsecond you'll end up wrapping in a little over an hour. How fast
> > can DAX generate I/O errors? :)
> 
> I admit to not having picked through the code, but how often do we try
> to do writebacks?  And how often do we retry writebacks once an -EIO
> has happened?  Once we mark a page as PG_error, do we keep trying to
> write it back and set the AS error each time?
> 

It depends, but I think it could theoretically happen after trying to
sync out every page in a file. With something like DAX it seems like
you could do that pretty quickly.

One thing we could do is to try and push the filemap_set_wb_error calls
out of writepage ops and allow the callers to do that so we can avoid
bumping the counter unnecessarily. Not sure if that's enough to avoid
wrapping too quickly.

> > I'm fine with a 32 bit counter (and even with using the low order bits
> > to store error flags) if we're ok with that limitation. The big
> > question there is whether it's ok to continue reporting -EIO when there
> > has actually been nothing but -ENOSPC errors since the last fsync. I
> > think it's a corner case that's not of terribly great concern so I'm
> > fine with that.
> 
> Yeah, I was thinking about that, and I'm fine with it too.
> 
> > We could try to mitigate it by zeroing out the value when i_writecount
> > goes to zero though. Then if you close all of the fds on the file, the
> > error is cleared. Or maybe we could add a new ioctl to explicitly zero
> > it out?
> 
> I'm OK with zeroing the wb_err once i_writecount drops to 0.  Everybody
> who cares has already been notified.  The new ioctl feels like overkill.

That's my feeling too.
-- 
Jeff Layton <jlayton@redhat.com>
