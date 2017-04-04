From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [RFC PATCH 0/4] fs: introduce new writeback error tracking
 infrastructure and convert ext4 to use it
Date: Tue, 04 Apr 2017 08:17:48 -0400
Message-ID: <1491308268.20445.4.camel@redhat.com>
References: <20170331192603.16442-1-jlayton@redhat.com>
         <87fuhqkti0.fsf@notabene.neil.brown.name>
         <1491215318.2724.3.camel@redhat.com>
         <20170403143257.GA30811@bombadil.infradead.org>
         <1491241657.2673.10.camel@redhat.com>
         <20170403191602.GF30811@bombadil.infradead.org>
         <1491250577.2673.20.camel@redhat.com>
         <87h924kh6t.fsf@notabene.neil.brown.name>
         <20170404115358.GH30811@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, akpm@linux-foundation.org,
        tytso@mit.edu, jack@suse.cz
To: Matthew Wilcox <willy@infradead.org>, NeilBrown <neilb@suse.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170404115358.GH30811@bombadil.infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2017-04-04 at 04:53 -0700, Matthew Wilcox wrote:
> On Tue, Apr 04, 2017 at 01:03:22PM +1000, NeilBrown wrote:
> > On Mon, Apr 03 2017, Jeff Layton wrote:
> > 
> > > On Mon, 2017-04-03 at 12:16 -0700, Matthew Wilcox wrote:
> > > > So, OK, that makes sense, we should keep allowing filesystems to report
> > > > ENOSPC as a writeback error.  But I think much of the argument below
> > > > still holds, and we should continue to have a prior EIO to be reported
> > > > over a new ENOSPC (even if the program has already consumed the EIO).
> > > 
> > > I'm fine with that (though I'd like Neil's thoughts before we decide
> > > anything) there.
> > 
> > I'd like there be a well defined time when old errors were forgotten.
> > It does make sense for EIO to persist even if ENOSPC or EDQUOT is
> > received, but not forever.
> > Clearing the remembered errors when put_write_access() causes
> > i_writecount to reach zero is one option (as suggested), but I'm not
> > sure I'm happy with it.
> > 
> > Local filesystems, or network filesystems which receive strong write
> > delegations, should only ever return EIO to fsync.  We should
> > concentrate on them first, I think.  As there is only one possible
> > error, the seq counter is sufficient to "clear" it once it has been
> > reported to fsync() (or write()?).
> > 
> > Other network filesystems could return a whole host of errors: ENOSPC
> > EDQUOT ESTALE EPERM EFBIG ...
> > Do we want to limit exactly which errors are allowed in generic code, or
> > do we just support EIO generically and expect the filesystem to sort out
> > the details for anything else?
> 
> I'd like us to focus on our POSIX compliance here and not return
> arbitrary errors.  The relevant pages are here:
> 
> http://pubs.opengroup.org/onlinepubs/9699919799/functions/fsync.html
> http://pubs.opengroup.org/onlinepubs/9699919799/functions/write.html
> http://pubs.opengroup.org/onlinepubs/9699919799/functions/close.html
> 
> For close(), we have to map every error to EIO.
> For fsync(), we can return any error that write() could have.  That limits
> us to:
> 
> EFBIG ENOSPC EIO ENOBUFS ENXIO
> 
> I think EFBIG really isn't a writeback error; are there any network
> filesystems that don't know the file size limit at the time they accept
> the original write?  ENOBUFS seems like a transient error (*this* call to
> fsync() failed, but the next one may succeed ... it's the equivalent of
> ENOMEM).  ENXIO seems to me like it's a submission error, not a writeback
> error.  So that leaves us with ENOSPC and EIO, as we have support today.
> 

Agreed that we should focus on POSIX compliance. I'll also note that
POSIX states:

"If more than one error occurs in processing a function call, any one
of the possible errors may be returned, as the order of
detection is undefined."

    http://pubs.opengroup.org/onlinepubs/9699919799/functions/V2_chap02.html#tag_15_03

So, I'd like to push back on this idea that we need to prefer reporting
-EIO over other errors. POSIX certainly doesn't mandate that. 

If we agree that that is the case, then I think the simplest thing to
do here would be to clear the other error flag(s) when we get a new
error, such that we only preserve the latest one. With that, we also
wouldn't need to clear anything out when i_writecount goes to zero
either. It would "just work" without that.

> > One possible approach a filesystem could take is just to allow a single
> > async writeback error.  After that error, all subsequent write()
> > system calls become synchronous. As write() or fsync() is called on each
> > file descriptor (which could possibly have sent the write which caused
> > the error), an error is returned and that fact is counted.  Once we have
> > returned as many errors as there are open file descriptors
> > (i_writecount?), and have seen a successful write, the filesystem
> > forgets all recorded errors and switches back to async writes (for that
> > inode).   NFS does this switch-to-sync-on-error.  See nfs_need_check_write().
> > 
> > The "which could possibly have sent the write which caused the error" is
> > an explicit reference to NFS.  NFS doesn't use the AS_EIO/AS_ENOSPC
> > flags to return async errors.  It allocates an nfs_open_context for each
> > user who opens a given inode, and stores an error in there.  Each dirty
> > pages is associated with one of these, so errors a sure to go to the
> > correct user, though not necessarily the correct fd at present.
> 
> ... and you need the nfs_open_context in order to use the correct
> credentials when writing a page to the server, correct?
> 

Yes, and it is expensive. I don't think we want to do that at the
generic VFS layer if we can at all help it.

> > When we specify the new behaviour we should be careful to be as vague as
> > possible while still saying what we need.  This allows filesystems some
> > flexibility.
> > 
> >   If an error happens during writeback, the next write() or fsync() (or
> >   ....) on the file descriptor to which data was written will return -1
> >   with errno set to EIO or some other relevant error.  Other file
> >   descriptors open on the same file may receive EIO or some other error
> >   on a subsequent appropriate system call.
> >   It should not be assumed that close() will return an error.  fsync()
> >   must be called before close() if writeback errors are important to the
> >   application.
> 

...and I also agree that we leave as much grey area as possible here to
allow for a wide range of implementations.
-- 
Jeff Layton <jlayton@redhat.com>
