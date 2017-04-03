From: Jeremy Allison <jra@samba.org>
Subject: Re: [RFC PATCH 0/4] fs: introduce new writeback error tracking
 infrastructure and convert ext4 to use it
Date: Mon, 3 Apr 2017 11:36:48 -0700
Message-ID: <20170403183648.GH37923@jra3>
References: <20170331192603.16442-1-jlayton@redhat.com>
 <87fuhqkti0.fsf@notabene.neil.brown.name>
 <1491215318.2724.3.camel@redhat.com>
 <20170403143257.GA30811@bombadil.infradead.org>
 <1491241657.2673.10.camel@redhat.com>
 <20170403180908.GG37923@jra3>
 <1491243524.2673.15.camel@redhat.com>
Reply-To: Jeremy Allison <jra@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matthew Wilcox <willy@infradead.org>, NeilBrown <neilb@suse.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, akpm@linux-foundation.org,
        tytso@mit.edu, jack@suse.cz
To: Jeff Layton <jlayton@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1491243524.2673.15.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Apr 03, 2017 at 02:18:44PM -0400, Jeff Layton wrote:
> On Mon, 2017-04-03 at 11:09 -0700, Jeremy Allison wrote:
> > On Mon, Apr 03, 2017 at 01:47:37PM -0400, Jeff Layton wrote:
> > > On Mon, 2017-04-03 at 07:32 -0700, Matthew Wilcox wrote:
> > > > On Mon, Apr 03, 2017 at 06:28:38AM -0400, Jeff Layton wrote:
> > > > > On Mon, 2017-04-03 at 14:25 +1000, NeilBrown wrote:
> > > > > > Also I think that EIO should always over-ride ENOSPC as the possible
> > > > > > responses are different.  That probably means you need a separate seq
> > > > > > number for each, which isn't ideal.
> > > > > > 
> > > > > 
> > > > > I'm not quite convinced that it's really useful to do anything but
> > > > > report the latest error.
> > > > > 
> > > > > But...if we did need to prefer one over another, could we get away with
> > > > > always reporting -EIO once that error occurs? If so, then we'd still
> > > > > just need a single sequence counter.
> > > > 
> > > > I wonder whether it's even worth supporting both EIO and ENOSPC for a
> > > > writeback problem.  If I understand correctly, at the time of write(),
> > > > filesystems check to see if they have enough blocks to satisfy the
> > > > request, so ENOSPC only comes up in the writeback context for thinly
> > > > provisioned devices.
> > > > 
> > > > Programs have basically no use for the distinction.  In either case,
> > > > the situation is the same.  The written data is safely in RAM and cannot
> > > > be written to the storage.  If one were to make superhuman efforts,
> > > > one could mmap the file and write() it to a different device, but that
> > > > is incredibly rare.  For most programs, the response is to just die and
> > > > let the human deal with the corrupted file.
> > > > 
> > > > From a sysadmin point of view, of course the situation is different,
> > > > and the remedy is different, but they should be getting that information
> > > > through a different mechanism than monitoring the errno from every
> > > > system call.
> > > > 
> > > > If we do want to continue to support both EIO and ENOSPC from writeback,
> > > > then let's have EIO override ENOSPC as an error.  ie if an ENOSPC comes
> > > > in after an EIO is set, it only bumps the counter and applications will
> > > > see EIO, not ENOSPC on fresh calls to fsync().
> > > 
> > > 
> > > No, ENOSPC on writeback can certainly happen with network filesystems.
> > > NFS and CIFS have no way to reserve space. You wouldn't want to have to
> > > do an extra RPC on every buffered write. :)
> > 
> > CIFS has a way to reserve space. Look into "allocation size" on create.
> 
> That won't help here as it's done on open().
> 
> The problem here is that we might create a file (and not preallocate
> anything), then write a bunch of stuff to the cache under an oplock.
> Then when we go to write back, we get the CIFS equivalent of -ENOSPC.
> 
> What local filesystems do (AIUI) is preallocate so that you can catch
> an ENOSPC condition earlier, when you're dirtying new pages in the
> cache. That's pretty much impossible to do on a network filesystem
> though.

There's also SMB_SET_FILE_ALLOCATION_INFO which can be
done over SMB1/2/3 on an open file handle.
