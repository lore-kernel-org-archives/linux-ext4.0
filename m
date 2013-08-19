From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: page fault scalability (ext3, ext4, xfs)
Date: Mon, 19 Aug 2013 18:17:16 -0400
Message-ID: <20130819221716.GA17869@fieldses.org>
References: <520BB9EF.5020308@linux.intel.com>
	<20130814194359.GA22316@thunk.org> <520BED7A.4000903@intel.com>
	<20130814230648.GD22316@thunk.org>
	<CALCETrVaRQ3WQ5++Uu_0JTaVnjUugAaAhqQK__7r5YWvLxpAhw@mail.gmail.com>
	<20130815011101.GA3572@thunk.org> <20130815021028.GM6023@dastard>
	<CALCETrUfuzgG9U=+eSzCGvbCx-ZskWw+MhQ-qmEyWZK=XWNVmg@mail.gmail.com>
	<20130815060149.GP6023@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, Dave Hansen <dave.hansen@linux.intel.com>,
	LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
	Dave Hansen <dave.hansen@intel.com>, Andi Kleen <ak@linux.intel.com>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, Andy Lutomirski <luto@amacapital.net>,
	Tim Chen <tim.c.chen@linux.intel.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <20130815060149.GP6023@dastard>
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

On Thu, Aug 15, 2013 at 04:01:49PM +1000, Dave Chinner wrote:
> On Wed, Aug 14, 2013 at 09:32:13PM -0700, Andy Lutomirski wrote:
> > On Wed, Aug 14, 2013 at 7:10 PM, Dave Chinner <david@fromorbit.com> wrote:
> > > On Wed, Aug 14, 2013 at 09:11:01PM -0400, Theodore Ts'o wrote:
> > >> On Wed, Aug 14, 2013 at 04:38:12PM -0700, Andy Lutomirski wrote:
> > >> > > It would be better to write zeros to it, so we aren't measuring the
> > >> > > cost of the unwritten->written conversion.
> > >> >
> > >> > At the risk of beating a dead horse, how hard would it be to defer
> > >> > this part until writeback?
> > >>
> > >> Part of the work has to be done at write time because we need to
> > >> update allocation statistics (i.e., so that we don't have ENOSPC
> > >> problems).  The unwritten->written conversion does happen at writeback
> > >> (as does the actual block allocation if we are doing delayed
> > >> allocation).
> > >>
> > >> The point is that if the goal is to measure page fault scalability, we
> > >> shouldn't have this other stuff happening as the same time as the page
> > >> fault workload.
> > >
> > > Sure, but the real problem is not the block mapping or allocation
> > > path - even if the test is changed to take that out of the picture,
> > > we still have timestamp updates being done on every single page
> > > fault. ext4, XFS and btrfs all do transactional timestamp updates
> > > and have nanosecond granularity, so every page fault is resulting in
> > > a transaction to update the timestamp of the file being modified.
> > 
> > I have (unmergeable) patches to fix this:
> > 
> > http://comments.gmane.org/gmane.linux.kernel.mm/92476
> 
> The big problem with this approach is that not doing the
> timestamp update on page faults is going to break the inode change
> version counting because for ext4, btrfs and XFS it takes a
> transaction to bump that counter. NFS needs to know the moment a
> file is changed in memory, not when it is written to disk.

I don't think the in-memory updates of the data and the version have to
be completely atomic, if that's what you mean.

> Also, NFS
> requires the change to the counter to be persistent over server
> failures, so it needs to be changed as part of a transaction....

I'm not sure those two updates have to be a single atomic transaction on
disk, either.

(Though the reboot cases are more complicated, I may not have thought it
through.)

(By the way, I wonder what happens if we reuse a change attribute value
after a crash?  There's probably a (hard to hit) bug there.)

--b.

> 
> IOWs, fixing the "filesystems need a transaction on each page_mkwrite
> call" problem isn't as simple as changing how timestamps are
> updated.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
