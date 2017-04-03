From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [RFC PATCH 0/4] fs: introduce new writeback error tracking
 infrastructure and convert ext4 to use it
Date: Mon, 03 Apr 2017 06:28:38 -0400
Message-ID: <1491215318.2724.3.camel@redhat.com>
References: <20170331192603.16442-1-jlayton@redhat.com>
         <87fuhqkti0.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        akpm@linux-foundation.org, tytso@mit.edu, jack@suse.cz,
        willy@infradead.org
To: NeilBrown <neilb@suse.com>, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:36133 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752474AbdDCK2n (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Apr 2017 06:28:43 -0400
Received: by mail-qt0-f180.google.com with SMTP id r45so107632764qte.3
        for <linux-ext4@vger.kernel.org>; Mon, 03 Apr 2017 03:28:42 -0700 (PDT)
In-Reply-To: <87fuhqkti0.fsf@notabene.neil.brown.name>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2017-04-03 at 14:25 +1000, NeilBrown wrote:
> On Fri, Mar 31 2017, Jeff Layton wrote:
> 
> > During LSF/MM this year, we had a discussion about the current sorry
> > state of writeback error reporting, and what could be done to improve
> > the situation. This patchset represents a first pass at the proposal
> > I made there.
> > 
> > It first adds a new set of writeback error tracking infrastructure to
> > ensure that errors are properly stored and reported at fsync time. It
> > also makes a small but significant change to ensure that writeback
> > errors are reported on all file descriptors, not just on the first one
> > where fsync is called.
> > 
> > Note that this is a _very_ rough draft at this point. I did some by-hand
> > testing with dm-error to ensure that it does the right thing there.
> > Mostly I'm interested in early feedback at this point -- does this basic
> > approach make sense?
> 
> I think that having ->wb_err_seq and returning errors to all file
> descriptors is a good idea.
> I don't like ->wb_err, particularly that you allow it to be set
> to zero:
>  +	/*
>  +	 * This should be called with the error code that we want to return
>  +	 * on fsync. Thus, it should always be <= 0.
>  +	 */
>  +	WARN_ON(err > 0);
> 
> Why is that ??
> 

It's because I wasn't thinking about all of the places that currently
call mapping_set_error with an error of 0. This worked for ext4 since we
only call this when there is an actual error. You're correct here -- we
should only set the error when it's non-zero. I'll fix that.

> Also I think that EIO should always over-ride ENOSPC as the possible
> responses are different.  That probably means you need a separate seq
> number for each, which isn't ideal.
> 

I'm not quite convinced that it's really useful to do anything but
report the latest error.

But...if we did need to prefer one over another, could we get away with
always reporting -EIO once that error occurs? If so, then we'd still
just need a single sequence counter.

> I don't like that you need to add a 'flush' handler to every filesystem,
> most of which just call
>  +	return filemap_report_wb_error(file);
> 
> Could we just have
> 	if (filp->f_op->flush)
> 		retval = filp->f_op->flush(filp, id);
> +	else
> +		retval = filemap_report_wb_error(filp);
> in flip_close() ??
> 

Sure, that's possible.

I'm leery of making too much in the way of changes to the generic VFS
layer code just yet. After making several abortive attempts to try to
fix some of this with large, sweeping changes to the code, I think the
approach of doing this on a per-filesystem basis will be saner.

My concern there for now is that some code (e.g. fs/buffer.c) is shared
between filesystems and will need to call both routines in the interim.
Suppose we have a filesystem (ext2?) that is using the older routines
for now. Making the change to filp_close above might subtly change its
behavior, and I don't think we want to do that.

Once we have everything converted to use the newer API, we should be
able to collapse a lot of the flush routines into the above though.

> ... or maybe it is wrong to return this error on close().
> After all, the file actually does get closed, so no error occurred.
> If an application cares about EIO, it should always call fsync() before
> close().
> 

Applications should, but the close(2) manpage does say:

       Not  checking  the return value of close() is a common
       but nevertheless serious  programming  error.   It  is
       quite  possible  that  errors  on  a previous write(2)
       operation are first reported  at  the  final  close().
       Not  checking  the  return value when closing the file
       may lead to silent loss of data.

POSIX seems to say that that behavior is optional, but I think reporting
errors at close is a good idea. There are programs that do check for
that, but whether they do anything useful with the error is a little
less clear.

> > 
> > Jeff Layton (4):
> >   fs: new infrastructure for writeback error handling and reporting
> >   dax: set errors in mapping when writeback fails
> >   buffer: set wb errors using both new and old infrastructure for now
> >   ext4: wire it up to the new writeback error reporting infrastructure
> > 
> >  Documentation/filesystems/vfs.txt | 14 +++++++--
> >  fs/buffer.c                       |  6 +++-
> >  fs/dax.c                          |  4 ++-
> >  fs/ext4/dir.c                     |  1 +
> >  fs/ext4/ext4.h                    |  1 +
> >  fs/ext4/file.c                    |  1 +
> >  fs/ext4/fsync.c                   | 15 +++++++---
> >  fs/ext4/inode.c                   |  2 +-
> >  fs/ext4/page-io.c                 |  4 +--
> >  fs/open.c                         |  3 ++
> >  include/linux/fs.h                |  5 ++++
> >  mm/filemap.c                      | 61 +++++++++++++++++++++++++++++++++++++++
> >  12 files changed, 106 insertions(+), 11 deletions(-)
> > 
> > -- 
> > 2.9.3

-- 
Jeff Layton <jlayton@redhat.com>
