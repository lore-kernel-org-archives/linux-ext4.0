From: Jan Kara <jack@suse.cz>
Subject: Re: page fault scalability (ext3, ext4, xfs)
Date: Thu, 15 Aug 2013 09:45:31 +0200
Message-ID: <20130815074531.GA2147@quack.suse.cz>
References: <20130814194359.GA22316@thunk.org>
 <520BED7A.4000903@intel.com>
 <20130814230648.GD22316@thunk.org>
 <CALCETrVaRQ3WQ5++Uu_0JTaVnjUugAaAhqQK__7r5YWvLxpAhw@mail.gmail.com>
 <20130815011101.GA3572@thunk.org>
 <20130815021028.GM6023@dastard>
 <CALCETrUfuzgG9U=+eSzCGvbCx-ZskWw+MhQ-qmEyWZK=XWNVmg@mail.gmail.com>
 <20130815060149.GP6023@dastard>
 <CALCETrUF+dGhE3qv4LoYmc7A=a+ry93u-d-GgHSAwHXvYN+VNw@mail.gmail.com>
 <20130815071141.GQ6023@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andy Lutomirski <luto@amacapital.net>,
	Theodore Ts'o <tytso@mit.edu>,
	Dave Hansen <dave.hansen@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	xfs@oss.sgi.com,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Andi Kleen <ak@linux.intel.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130815071141.GQ6023@dastard>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu 15-08-13 17:11:42, Dave Chinner wrote:
> On Wed, Aug 14, 2013 at 11:14:37PM -0700, Andy Lutomirski wrote:
> > On Wed, Aug 14, 2013 at 11:01 PM, Dave Chinner <david@fromorbit.com> wrote:
> > > On Wed, Aug 14, 2013 at 09:32:13PM -0700, Andy Lutomirski wrote:
> > >> On Wed, Aug 14, 2013 at 7:10 PM, Dave Chinner <david@fromorbit.com> wrote:
> > >> > On Wed, Aug 14, 2013 at 09:11:01PM -0400, Theodore Ts'o wrote:
> > >> >> On Wed, Aug 14, 2013 at 04:38:12PM -0700, Andy Lutomirski wrote:
> > >> >> > > It would be better to write zeros to it, so we aren't measuring the
> > >> >> > > cost of the unwritten->written conversion.
> > >> >> >
> > >> >> > At the risk of beating a dead horse, how hard would it be to defer
> > >> >> > this part until writeback?
> > >> >>
> > >> >> Part of the work has to be done at write time because we need to
> > >> >> update allocation statistics (i.e., so that we don't have ENOSPC
> > >> >> problems).  The unwritten->written conversion does happen at writeback
> > >> >> (as does the actual block allocation if we are doing delayed
> > >> >> allocation).
> > >> >>
> > >> >> The point is that if the goal is to measure page fault scalability, we
> > >> >> shouldn't have this other stuff happening as the same time as the page
> > >> >> fault workload.
> > >> >
> > >> > Sure, but the real problem is not the block mapping or allocation
> > >> > path - even if the test is changed to take that out of the picture,
> > >> > we still have timestamp updates being done on every single page
> > >> > fault. ext4, XFS and btrfs all do transactional timestamp updates
> > >> > and have nanosecond granularity, so every page fault is resulting in
> > >> > a transaction to update the timestamp of the file being modified.
> > >>
> > >> I have (unmergeable) patches to fix this:
> > >>
> > >> http://comments.gmane.org/gmane.linux.kernel.mm/92476
> > >
> > > The big problem with this approach is that not doing the
> > > timestamp update on page faults is going to break the inode change
> > > version counting because for ext4, btrfs and XFS it takes a
> > > transaction to bump that counter. NFS needs to know the moment a
> > > file is changed in memory, not when it is written to disk. Also, NFS
> > > requires the change to the counter to be persistent over server
> > > failures, so it needs to be changed as part of a transaction....
> > 
> > I've been running a kernel that has the file_update_time call
> > commented out for over a year now, and the only problem I've seen is
> > that the timestamp doesn't get updated :)
> > 
> > I think I must be misunderstanding you (or vice versa).  I'm currently
> 
> Yup, you are.
> 
> > redoing the patches, and this time I'll do it for just the mm core and
> > ext4.  The only change I'm proposing to ext4's page_mkwrite is to
> > remove the file_update_time call.
> 
> Right. Where does that end up? All the way down in
> ext4_mark_iloc_dirty(), and that does:
> 
>         if (IS_I_VERSION(inode))
> 		inode_inc_iversion(inode);
> 
> The XFS transaction code is the same - deep inside it where an inode
> is marked as dirty in the transaction, it bumps the same counter and
> adds it to the transaction.
  Yeah, I'd just add that ext4 maintains i_version only if it has been
mounted with i_version mount option. But then NFS server would depend on
c/mtime update so it won't help you much - you still should update at least
one of i_version, ctime, mtime on page fault. OTOH if the filesystem isn't
exported, you could avoid this relatively expensive dance and defer things
as Andy suggests.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
