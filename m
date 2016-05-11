From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] direct-io: fix stale data exposure from concurrent
 buffered read
Date: Wed, 11 May 2016 18:57:15 +0200
Message-ID: <20160511165715.GH14744@quack2.suse.cz>
References: <1462033162-21837-1-git-send-email-guaneryu@gmail.com>
 <x49twic5m6m.fsf@segfault.boston.devel.redhat.com>
 <20160506104622.GB10350@eguan.usersys.redhat.com>
 <x49d1oz5l64.fsf@segfault.boston.devel.redhat.com>
 <20160507030400.GC10350@eguan.usersys.redhat.com>
 <x49futr72up.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eryu Guan <guaneryu@gmail.com>, Jan Kara <jack@suse.cz>,
	Theodore T'so <tytso@google.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <x49futr72up.fsf@segfault.boston.devel.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 09-05-16 09:55:26, Jeff Moyer wrote:
> Eryu Guan <guaneryu@gmail.com> writes:
> 
> > On Fri, May 06, 2016 at 10:13:39AM -0400, Jeff Moyer wrote:
> >> Eryu Guan <guaneryu@gmail.com> writes:
> >> 
> >> > On Thu, May 05, 2016 at 03:39:29PM -0400, Jeff Moyer wrote:
> >> >> I think this code operates on blocks for a reason: we're trying to
> >> >> determine if we'll trigger block allocation, right?  For example,
> >> >> consider a sparse file with i_size of 2k, and a write to offset 2k into
> >> >> the file, with a file system block size of 4k.  Should that have create
> >> >> set or not?
> >> >
> >> > Thanks for pointing this out! I think 'create' should be 0 in this case,
> >> > my test failed in this case, with both 4.6-rc6 stock kernel and my
> >> > patched kernel.
> >> >
> >> > I'm testing an updated patch now, hopefully it's doing the right thing.
> >> > It's basiclly something like:
> >> >
> >> > if (offset < i_size)
> >> > 	create = 0;
> >> > else if ((block_in_file >> blkfactor) == (i_size >> (blkbits + blkfactor)) &&
> >> > 	 (i_size & ((1 << (blkbits + blkfactor)) - 1)))
> >> > 	create = 0;
> >> 
> >> I think that can be simplified to a single check;  something like:
> >> 
> >> 	if (block_in_file < total_blocks_in_file)
> >> 		create = 0;
> >
> > I may miss something, but this doesn't seem right to me. Still take your
> > example, on a 4k block size & 512 sector size filesystem
> 
> ... where blocks are in file system block size units.  So:
> 
> if (fs_block_in_file < total_fs_blocks_in_file)

Agreed. The test should be:

	if (fs_startblk < (i_size_read(dio->inode) >>
					(sdio->blkbits + sdio->blkfactor)))

Sorry for not having a look earlier.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
