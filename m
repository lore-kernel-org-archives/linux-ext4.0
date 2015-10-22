From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 0/9 v2] ext4: Punch hole and DAX fixes
Date: Thu, 22 Oct 2015 12:09:10 -0600
Message-ID: <20151022180910.GA3358@linux.intel.com>
References: <1445501761-14528-1-git-send-email-jack@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>,
	Dan Williams <dan.j.williams@intel.com>,
	ross.zwisler@linux.intel.com, willy@linux.intel.com
To: Jan Kara <jack@suse.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:7683 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964928AbbJVSJM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Oct 2015 14:09:12 -0400
Content-Disposition: inline
In-Reply-To: <1445501761-14528-1-git-send-email-jack@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 22, 2015 at 10:15:52AM +0200, Jan Kara wrote:
> Hello,
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

In my setup generic/081 passes, but causes all sorts of errors reported in
syslog.  I think these errors are a normal part of the test because they happen
in the non-DAX case as well, but in the DAX case I think we end up in a bad
state.  After this, all other tests fail.

Here is a run of generic/081 and generic/082, where generic/082 dies as a
bystander of the bad state left by generic/081:

# ./check generic/081 generic/082
FSTYP         -- ext4
PLATFORM      -- Linux/x86_64 lorwyn 4.3.0-rc6_ext4_dax_v2+
MKFS_OPTIONS  -- /dev/pmem0p2
MOUNT_OPTIONS -- -o dax -o context=system_u:object_r:nfs_t:s0 /dev/pmem0p2 /mnt/xfstests_scratch

generic/081 2s ... 1s
generic/082 0s ... [failed, exit status 1] - output mismatch (see /root/xfstests/results//generic/082.out.bad)
    --- tests/generic/082.out	2015-10-02 10:20:40.816712128 -0600
    +++ /root/xfstests/results//generic/082.out.bad	2015-10-22 12:07:06.009024134 -0600
    @@ -1,3 +1,9 @@
     QA output created by 082
    -group quota on SCRATCH_MNT (SCRATCH_DEV) is on
    -user quota on SCRATCH_MNT (SCRATCH_DEV) is on
    +mount: /dev/pmem0p2 is already mounted or /mnt/xfstests_scratch busy
    +quotaon: Mountpoint (or device) /mnt/xfstests_scratch not found or has no quota enabled.
    +mount: /mnt/xfstests_scratch not mounted or bad option
    +
    ...
    (Run 'diff -u tests/generic/082.out /root/xfstests/results//generic/082.out.bad'  to see the entire diff)
Ran: generic/081 generic/082
Failures: generic/082
Failed 1 of 2 tests

When run by itself on a clean system with DAX generic/082 passes repeatedly.

After you get into this bad state, all other tests fail to run:

# ./check generic/082
FSTYP         -- ext4
PLATFORM      -- Linux/x86_64 lorwyn 4.3.0-rc6_ext4_dax_v2+
MKFS_OPTIONS  -- /dev/pmem0p2
MOUNT_OPTIONS -- -o dax -o context=system_u:object_r:nfs_t:s0 /dev/pmem0p2 /mnt/xfstests_scratch

our local _scratch_mkfs routine ...
mke2fs 1.42.12 (29-Aug-2014)
/dev/pmem0p2 is apparently in use by the system; will not make a filesystem here!
check: failed to mkfs $SCRATCH_DEV using specified options
Passed all 0 tests
