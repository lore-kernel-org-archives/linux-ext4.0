From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH] direct-io: fix stale data exposure from concurrent
 buffered read
Date: Sat, 7 May 2016 11:04:00 +0800
Message-ID: <20160507030400.GC10350@eguan.usersys.redhat.com>
References: <1462033162-21837-1-git-send-email-guaneryu@gmail.com>
 <x49twic5m6m.fsf@segfault.boston.devel.redhat.com>
 <20160506104622.GB10350@eguan.usersys.redhat.com>
 <x49d1oz5l64.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Theodore T'so <tytso@google.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <x49d1oz5l64.fsf@segfault.boston.devel.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, May 06, 2016 at 10:13:39AM -0400, Jeff Moyer wrote:
> Eryu Guan <guaneryu@gmail.com> writes:
> 
> > On Thu, May 05, 2016 at 03:39:29PM -0400, Jeff Moyer wrote:
> >> I think this code operates on blocks for a reason: we're trying to
> >> determine if we'll trigger block allocation, right?  For example,
> >> consider a sparse file with i_size of 2k, and a write to offset 2k into
> >> the file, with a file system block size of 4k.  Should that have create
> >> set or not?
> >
> > Thanks for pointing this out! I think 'create' should be 0 in this case,
> > my test failed in this case, with both 4.6-rc6 stock kernel and my
> > patched kernel.
> >
> > I'm testing an updated patch now, hopefully it's doing the right thing.
> > It's basiclly something like:
> >
> > if (offset < i_size)
> > 	create = 0;
> > else if ((block_in_file >> blkfactor) == (i_size >> (blkbits + blkfactor)) &&
> > 	 (i_size & ((1 << (blkbits + blkfactor)) - 1)))
> > 	create = 0;
> 
> I think that can be simplified to a single check;  something like:
> 
> 	if (block_in_file < total_blocks_in_file)
> 		create = 0;

I may miss something, but this doesn't seem right to me. Still take your
example, on a 4k block size & 512 sector size filesystem

	xfs_io -f -c "truncate 2k" testfile
	xfs_io -d -c "pwrite 2k 2k" testfile

block_in_file is 4 (dio block size is 512 in this case, 4 blocks for 2k
size), total_blocks_in_file is 0, so 'create' is set, but it should be 0

> 
> >> > Also introduce some local variables to make the code
> >> > easier to read a little bit.
> >> 
> >> Please don't do this.  You're only making the change harder to review.
> >> Just submit the minimal fix.  You can submit cleanups as a follow-on.
> >
> > I think it's not a pure cleanup, it's needed as things like
> > 'sdio->block_in_file' are referenced multiple times in the function, and
> > they are making the lines too long to read/write. Maybe I should have
> > made it clear in the first place.
> 
> I still view that as a cleanup.  If you had submitted the minimal patch,
> I would have to look at a couple lines of change.  In code this tricky,
> I'd rather not have to stare at all the code movement to make sure
> you got that part right, too.
> 
> But do what you feel is right, I'll review it either way.  ;-)

Thanks very much! I'll split it to two patches, first one is a cleanup,
has no function change, second one is the real fix. This should make the
review easier.

Eryu
