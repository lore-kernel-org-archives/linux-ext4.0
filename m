From: Dave Chinner <david@fromorbit.com>
Subject: Re: page fault scalability (ext3, ext4, xfs)
Date: Fri, 16 Aug 2013 07:37:25 +1000
Message-ID: <20130815213725.GT6023@dastard>
References: <520BED7A.4000903@intel.com> <20130814230648.GD22316@thunk.org>
	<CALCETrVaRQ3WQ5++Uu_0JTaVnjUugAaAhqQK__7r5YWvLxpAhw@mail.gmail.com>
	<20130815011101.GA3572@thunk.org> <20130815021028.GM6023@dastard>
	<CALCETrUfuzgG9U=+eSzCGvbCx-ZskWw+MhQ-qmEyWZK=XWNVmg@mail.gmail.com>
	<20130815060149.GP6023@dastard>
	<CALCETrUF+dGhE3qv4LoYmc7A=a+ry93u-d-GgHSAwHXvYN+VNw@mail.gmail.com>
	<20130815071141.GQ6023@dastard>
	<CALCETrWyKSMDkgSbg20iWBRfHk0-oU+6A3X9xAEMg3vO=G_gDg@mail.gmail.com>
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
In-Reply-To: <CALCETrWyKSMDkgSbg20iWBRfHk0-oU+6A3X9xAEMg3vO=G_gDg@mail.gmail.com>
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

On Thu, Aug 15, 2013 at 08:17:18AM -0700, Andy Lutomirski wrote:
> On Thu, Aug 15, 2013 at 12:11 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Wed, Aug 14, 2013 at 11:14:37PM -0700, Andy Lutomirski wrote:
> >> On Wed, Aug 14, 2013 at 11:01 PM, Dave Chinner <david@fromorbit.com> wrote:
> >> > On Wed, Aug 14, 2013 at 09:32:13PM -0700, Andy Lutomirski wrote:
> >> >> On Wed, Aug 14, 2013 at 7:10 PM, Dave Chinner <david@fromorbit.com> wrote:
> >> >> > On Wed, Aug 14, 2013 at 09:11:01PM -0400, Theodore Ts'o wrote:
> >> >> >> On Wed, Aug 14, 2013 at 04:38:12PM -0700, Andy Lutomirski wrote:
> >> >> >> > > It would be better to write zeros to it, so we aren't measuring the
> >> >> >> > > cost of the unwritten->written conversion.
> >> >> >> >
> >> >> >> > At the risk of beating a dead horse, how hard would it be to defer
> >> >> >> > this part until writeback?
> >> >> >>
> >> >> >> Part of the work has to be done at write time because we need to
> >> >> >> update allocation statistics (i.e., so that we don't have ENOSPC
> >> >> >> problems).  The unwritten->written conversion does happen at writeback
> >> >> >> (as does the actual block allocation if we are doing delayed
> >> >> >> allocation).
> >> >> >>
> >> >> >> The point is that if the goal is to measure page fault scalability, we
> >> >> >> shouldn't have this other stuff happening as the same time as the page
> >> >> >> fault workload.
> >> >> >
> >> >> > Sure, but the real problem is not the block mapping or allocation
> >> >> > path - even if the test is changed to take that out of the picture,
> >> >> > we still have timestamp updates being done on every single page
> >> >> > fault. ext4, XFS and btrfs all do transactional timestamp updates
> >> >> > and have nanosecond granularity, so every page fault is resulting in
> >> >> > a transaction to update the timestamp of the file being modified.
> >> >>
> >> >> I have (unmergeable) patches to fix this:
> >> >>
> >> >> http://comments.gmane.org/gmane.linux.kernel.mm/92476
> >> >
> >> > The big problem with this approach is that not doing the
> >> > timestamp update on page faults is going to break the inode change
> >> > version counting because for ext4, btrfs and XFS it takes a
> >> > transaction to bump that counter. NFS needs to know the moment a
> >> > file is changed in memory, not when it is written to disk. Also, NFS
> >> > requires the change to the counter to be persistent over server
> >> > failures, so it needs to be changed as part of a transaction....
> >>
> >> I've been running a kernel that has the file_update_time call
> >> commented out for over a year now, and the only problem I've seen is
> >> that the timestamp doesn't get updated :)
> >>
> 
> [...]
> 
> > If a filesystem is providing an i_version value, then NFS uses it to
> > determine whether client side caches are still consistent with the
> > server state. If the filesystem does not provide an i_version, then
> > NFS falls back to checking c/mtime for changes. If files on the
> > server are being modified without either the tiemstamps or i_version
> > changing, then it's likely that there will be problems with client
> > side cache consistency....
> 
> I didn't think of that at all.
> 
> If userspace does:
> 
> ptr = mmap(...);
> ptr[0] = 1;
> sleep(1);
> ptr[0] = 2;
> sleep(1);
> munmap();
> 
> Then current kernels will mark the inode changed on (only) the ptr[0]
> = 1 line.  My patches will instead mark the inode changed when munmap
> is called (or after ptr[0] = 2 if writepages gets called for any
> reason).
> 
> I'm not sure which is better.  POSIX actually requires my behavior
> (which is most irrelevant).

Not by my reading of it. Posix states that c/mtime needs to be
updated between the first access and the next msync() call. We
update mtime on the first access, and so therefore we conform to the
posix requirement....

> My behavior also means that, if an NFS
> client reads and caches the file between the two writes, then it will
> eventually find out that the data is stale.

"eventually" is very different behaviour to the current behaviour.

My understanding is that NFS v4 delegations require the underlying
filesystem to bump the version count on *any* modification made to
the file so that delegations can be recalled appropriately. So not
informing the filesystem that the file data has been changed is
going to cause problems.

> The current behavior, on
> the other hand, means that a single pass of mmapped writes through the
> file will update the times much faster.
> 
> I could arrange for the first page fault to *also* update times when
> the FS is exported or if a particular mount option is set.  (The ext4
> change to request the new behavior is all of four lines, and it's easy
> to adjust.)

What does "first page fault" mean?

Cheers,

Dave
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
