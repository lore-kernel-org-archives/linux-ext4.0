From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/9 v2] ext4: Punch hole and DAX fixes
Date: Thu, 22 Oct 2015 23:14:36 +0200
Message-ID: <20151022211436.GD8670@quack.suse.cz>
References: <1445501761-14528-1-git-send-email-jack@suse.com>
 <20151022180910.GA3358@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>,
	Dan Williams <dan.j.williams@intel.com>, willy@linux.intel.com
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49964 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153AbbJVVOk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Oct 2015 17:14:40 -0400
Content-Disposition: inline
In-Reply-To: <20151022180910.GA3358@linux.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 22-10-15 12:09:10, Ross Zwisler wrote:
> On Thu, Oct 22, 2015 at 10:15:52AM +0200, Jan Kara wrote:
> > Hello,
> > 
> > This series fixes a long standing problem of racing punch hole and page fault
> > resulting in possible filesystem corruption or stale data exposure. We fix the
> > problem by using a new inode-private rw_semaphore i_mmap_sem to synchronize
> > page faults with truncate and punch hole operations.
> > 
> > When having this exclusion, the only remaining problem with DAX implementation
> > are races between two page faults zeroing out same block concurrently (where
> > the data written after the first fault finishes are possibly overwritten by
> > the second fault still doing zeroing).
> > 
> > Patch 1 introduces i_mmap_sem lock in ext4 inode and uses it to properly
> > serialize extent manipulation operations and page faults.
> > 
> > Patch 2 is mostly a preparatory cleanup patch which also avoids double lock /
> > unlock in unlocked DIO protections (currently harmless but nasty surprise).
> > 
> > Patches 3-4 fix further races of extent manipulation functions (such as zero
> > range, collapse range, insert range) with buffered IO, page writeback
> > 
> > Patch 5 documents locking order of ext4 filesystem locks.
> > 
> > Patch 6 removes locking abuse of i_data_sem from the get_blocks() path when
> > dioread_nolock is enabled since it is not needed anymore.
> > 
> > Patches 7-9 implement allocation of pre-zeroed blocks in ext4_map_blocks()
> > callback and use such blocks for allocations from DAX page faults.
> > 
> > The patches survived xfstests run both in dax and non-dax mode.
> > 
> > 								Honza
> 
> In my setup generic/081 passes, but causes all sorts of errors reported in
> syslog.  I think these errors are a normal part of the test because they happen
> in the non-DAX case as well, but in the DAX case I think we end up in a bad
> state.  After this, all other tests fail.

Thanks for report! I was using ramdisk for testing and test generic/081 got
skipped because the device doesn't have "sane flush". I'll retest with pmem
and debug what's going on.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
