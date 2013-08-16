From: Dave Chinner <david@fromorbit.com>
Subject: Re: page fault scalability (ext3, ext4, xfs)
Date: Fri, 16 Aug 2013 10:14:35 +1000
Message-ID: <20130816001435.GZ6023@dastard>
References: <20130815021028.GM6023@dastard>
 <CALCETrUfuzgG9U=+eSzCGvbCx-ZskWw+MhQ-qmEyWZK=XWNVmg@mail.gmail.com>
 <20130815060149.GP6023@dastard>
 <CALCETrUF+dGhE3qv4LoYmc7A=a+ry93u-d-GgHSAwHXvYN+VNw@mail.gmail.com>
 <20130815071141.GQ6023@dastard>
 <CALCETrWyKSMDkgSbg20iWBRfHk0-oU+6A3X9xAEMg3vO=G_gDg@mail.gmail.com>
 <20130815213725.GT6023@dastard>
 <CALCETrV7F-47_nRx1AVFqeF8sNoREutbo3kf78ddBLvKKmFCzg@mail.gmail.com>
 <20130815221807.GW6023@dastard>
 <CALCETrVgSsJD8L5kDUp8JAhhjEoAZYCfOfAE7Mx-=2pbFnPESQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Dave Hansen <dave.hansen@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	xfs@oss.sgi.com,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Andi Kleen <ak@linux.intel.com>
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrVgSsJD8L5kDUp8JAhhjEoAZYCfOfAE7Mx-=2pbFnPESQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Aug 15, 2013 at 03:26:09PM -0700, Andy Lutomirski wrote:
> On Thu, Aug 15, 2013 at 3:18 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Thu, Aug 15, 2013 at 02:43:09PM -0700, Andy Lutomirski wrote:
> >> On Thu, Aug 15, 2013 at 2:37 PM, Dave Chinner
> >> <david@fromorbit.com> wrote:
> >> > On Thu, Aug 15, 2013 at 08:17:18AM -0700, Andy Lutomirski wrote:
> >> >> My behavior also means that, if an NFS
> >> >> client reads and caches the file between the two writes, then it will
> >> >> eventually find out that the data is stale.
> >> >
> >> > "eventually" is very different behaviour to the current behaviour.
> >> >
> >> > My understanding is that NFS v4 delegations require the underlying
> >> > filesystem to bump the version count on *any* modification made to
> >> > the file so that delegations can be recalled appropriately. So not
> >> > informing the filesystem that the file data has been changed is
> >> > going to cause problems.
> >>
> >> We don't do that right now (and we can't without utterly destroying
> >> performance) because we don't trap on every modification.  See
> >> below...
> >
> > We don't trap every mmap modification. We trap every modification
> > that the filesystem is informed about. That includes a c/mtime
> > update on every write page fault. It's as fine grained as we can get
> > without introducing serious performance killing overhead.
> >
> > And nobody has made any compelling argument that what we do now is
> > problematic - all we've got is a microbenchmark doesn't quite scale
> > linearly because filesystem updates through a global filesystem
> > structure (the journal) don't scale linearly.
> 
> I don't personally care about scaling.  I care about sleeping in write
> faults, and starting journal transactions sleeps, and this is an
> absolute show-stopper for me.  (It's a real-time latency problem, not
> a throughput or scalability thing.)

Different problem, then. And one that does actaully have a solution
that is already implemented but not exposed to userspace -
O_NOCMTIME. i.e. we actually support turning off c/mtime updates on
a per file basis - the XFS open-by-handle interface sets this flag
by default on files opened that way.....

Expose that to open/fcntl and your problem is solved without
impacting anyone else or default behaviours of filesystems.

> >> In current kernels, this chain of events won't work:
> >>
> >>  - Server goes down
> >>  - Server comes up
> >>  - Userspace on server calls mmap and writes something
> >>  - Client reconnects and invalidates its cache
> >>  - Userspace on server writes something else *to the same page*
> >>
> >> The client will never notice the second write, because it won't update
> >> any inode state.
> >
> > That's wrong. The server wrote the dirty page before the client
> > reconnected, therefore it got marked clean.
> 
> Why would it write the dirty page?

Terminology mismatch - you said it "writes something", not "dirties
the page". So, it's easy to take that as "does writeback" as opposed
to "dirties memory".

As to what woudl write it? Memory pressure, a user running sync,
ENOSPC conditions, all sorts of things that you can't control. You
cannot rely on writeback only happening periodically and therefore
being predictable and deterministic.

> > The second write to the
> > server page marks it dirty again, causing page_mkwrite to be
> > called, thereby updating the timestamp/i_version field. So, the NFS
> > client will notice the second change on the server, and it will
> > notice it immediately after the second access has occurred, not some
> > time later when:
> >
> >> With my patches, the client will as soon as the
> >> server starts writeback.
> >
> > Your patches introduce a 30+ second window where a file can be dirty
> > on the server but the NFS server doesn't know about it and can't
> > tell the clients about it because i_version doesn't get bumped until
> > writeback.....
> 
> I claim that there's an infinite window right now, and that 30 seconds
> is therefore an improvement.

You're talking about after the second change is made. I'm talking
about the difference in behaviour after the *initial change* is
made. Your changes will result in the client not doing an
invalidation because timestamps don't get changed for 30s with your
patches.  That's the problem - the first change of a file needs to
bump the i_version immediately, not in 30s time.

That's why delaying timestamp updates doesn't fix the scalability
problem that was reported. It might fix a different problem, but it
doesn't void the *requirment* that filesystems need to do
transactional updates during page faults....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
