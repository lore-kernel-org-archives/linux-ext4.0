From: Dave Chinner <david@fromorbit.com>
Subject: Re: page fault scalability (ext3, ext4, xfs)
Date: Fri, 16 Aug 2013 08:18:07 +1000
Message-ID: <20130815221807.GW6023@dastard>
References: <CALCETrVaRQ3WQ5++Uu_0JTaVnjUugAaAhqQK__7r5YWvLxpAhw@mail.gmail.com>
	<20130815011101.GA3572@thunk.org> <20130815021028.GM6023@dastard>
	<CALCETrUfuzgG9U=+eSzCGvbCx-ZskWw+MhQ-qmEyWZK=XWNVmg@mail.gmail.com>
	<20130815060149.GP6023@dastard>
	<CALCETrUF+dGhE3qv4LoYmc7A=a+ry93u-d-GgHSAwHXvYN+VNw@mail.gmail.com>
	<20130815071141.GQ6023@dastard>
	<CALCETrWyKSMDkgSbg20iWBRfHk0-oU+6A3X9xAEMg3vO=G_gDg@mail.gmail.com>
	<20130815213725.GT6023@dastard>
	<CALCETrV7F-47_nRx1AVFqeF8sNoREutbo3kf78ddBLvKKmFCzg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Andi Kleen <ak@linux.intel.com>, Theodore Ts'o <tytso@mit.edu>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
	Dave Hansen <dave.hansen@intel.com>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Tim Chen <tim.c.chen@linux.intel.com>
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <CALCETrV7F-47_nRx1AVFqeF8sNoREutbo3kf78ddBLvKKmFCzg@mail.gmail.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

On Thu, Aug 15, 2013 at 02:43:09PM -0700, Andy Lutomirski wrote:
> On Thu, Aug 15, 2013 at 2:37 PM, Dave Chinner
> <david@fromorbit.com> wrote:
> > On Thu, Aug 15, 2013 at 08:17:18AM -0700, Andy Lutomirski wrote:
> >> My behavior also means that, if an NFS
> >> client reads and caches the file between the two writes, then it will
> >> eventually find out that the data is stale.
> >
> > "eventually" is very different behaviour to the current behaviour.
> >
> > My understanding is that NFS v4 delegations require the underlying
> > filesystem to bump the version count on *any* modification made to
> > the file so that delegations can be recalled appropriately. So not
> > informing the filesystem that the file data has been changed is
> > going to cause problems.
> 
> We don't do that right now (and we can't without utterly destroying
> performance) because we don't trap on every modification.  See
> below...

We don't trap every mmap modification. We trap every modification
that the filesystem is informed about. That includes a c/mtime
update on every write page fault. It's as fine grained as we can get
without introducing serious performance killing overhead.

And nobody has made any compelling argument that what we do now is
problematic - all we've got is a microbenchmark doesn't quite scale
linearly because filesystem updates through a global filesystem
structure (the journal) don't scale linearly.

> >> The current behavior, on
> >> the other hand, means that a single pass of mmapped writes through the
> >> file will update the times much faster.
> >>
> >> I could arrange for the first page fault to *also* update times when
> >> the FS is exported or if a particular mount option is set.  (The ext4
> >> change to request the new behavior is all of four lines, and it's easy
> >> to adjust.)
> >
> > What does "first page fault" mean?
> 
> The first write to the page triggers a page fault and marks the page
> writable.  The second write to the page (assuming no writeback happens
> in the mean time) does not trigger a page fault or notify the kernel
> in any way.

IIUC, you are saying is that you'll maintain the current behaviour
(i.e. clean->dirty does a timestamp update) if the filesystem
requires it? So the default behaviour of any filesystem that
supports NFSv4 is going to behave as it does now?

If that's the case, why bother changing anything as nfsv4 is the
default version that the kernel uses? (I'm playing devil's advocate
here).

> In current kernels, this chain of events won't work:
> 
>  - Server goes down
>  - Server comes up
>  - Userspace on server calls mmap and writes something
>  - Client reconnects and invalidates its cache
>  - Userspace on server writes something else *to the same page*
>
> The client will never notice the second write, because it won't update
> any inode state. 

That's wrong. The server wrote the dirty page before the client
reconnected, therefore it got marked clean. The second write to the
server page marks it dirty again, causing page_mkwrite to be
called, thereby updating the timestamp/i_version field. So, the NFS
client will notice the second change on the server, and it will
notice it immediately after the second access has occurred, not some
time later when:

> With my patches, the client will as soon as the
> server starts writeback.

Your patches introduce a 30+ second window where a file can be dirty
on the server but the NFS server doesn't know about it and can't
tell the clients about it because i_version doesn't get bumped until
writeback.....

> So I think that there are cases where my changes make things better
> and cases where they make things worse.

Right, and the issue is that there are important use cases that we
have to support in default configurations that it makes things
worse.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
