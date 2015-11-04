From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 0/9 v3] ext4: Punch hole and DAX fixes
Date: Wed, 4 Nov 2015 11:51:02 -0700
Message-ID: <20151104185102.GA26753@linux.intel.com>
References: <1446653920-23127-1-git-send-email-jack@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	dan.j.williams@intel.com
To: Jan Kara <jack@suse.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:26497 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031041AbbKDSvD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Nov 2015 13:51:03 -0500
Content-Disposition: inline
In-Reply-To: <1446653920-23127-1-git-send-email-jack@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 04, 2015 at 05:18:31PM +0100, Jan Kara wrote:
> Hello,
> 
> Another version of my ext4 fixes. I've fixed up all the failures Ted reported
> except for ext4/001 failures which are false positive (will send fixes for that
> test shortly) and generic/269 in nodelalloc mode which I just wasn't able to
> reproduce.
> 
> Note that testing with 1 KB blocksize on ramdisk is broken since brd has
> buggy discard implementation. It took me quite some time to figure this out.
> Fix is submitted but bear this in mind just in case.
> 
> Changes since v2:
> * Fixed collaps range to truncate pagecache properly with blocksize < pagesize
> * Fixed assertion in ext4_get_blocks_overwrite
> 
> Patch set description
> 
> This series fixes a long standing problem of racing punch hole and page fault
> resulting in possible filesystem corruption or stale data exposure. We fix the
> problem by using a new inode-private rw_semaphore i_mmap_sem to synchronize
> page faults with truncate and punch hole operations.
> 
> When having this exclusion, the only remaining problem with DAX implementation
> are races between two page faults zeroing out same block concurrently (where
> the data written after the first fault finishes are possibly overwritten by
> the second fault still doing zeroing).
> 
> Patch 1 introduces i_mmap_sem lock in ext4 inode and uses it to properly
> serialize extent manipulation operations and page faults.
> 
> Patch 2 is mostly a preparatory cleanup patch which also avoids double lock /
> unlock in unlocked DIO protections (currently harmless but nasty surprise).
> 
> Patches 3-4 fix further races of extent manipulation functions (such as zero
> range, collapse range, insert range) with buffered IO, page writeback
> 
> Patch 5 documents locking order of ext4 filesystem locks.
> 
> Patch 6 removes locking abuse of i_data_sem from the get_blocks() path when
> dioread_nolock is enabled since it is not needed anymore.
> 
> Patches 7-9 implement allocation of pre-zeroed blocks in ext4_map_blocks()
> callback and use such blocks for allocations from DAX page faults.
> 
> The patches survived xfstests run both in dax and non-dax mode.
> 
> 								Honza

This passed all my testing as well.

Tested-by: Ross Zwisler <ross.zwisler@linux.intel.com>
