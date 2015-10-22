From: Jan Kara <jack@suse.com>
Subject: [PATCH 0/9 v2] ext4: Punch hole and DAX fixes
Date: Thu, 22 Oct 2015 10:15:52 +0200
Message-ID: <1445501761-14528-1-git-send-email-jack@suse.com>
Cc: Ted Tso <tytso@mit.edu>, Dan Williams <dan.j.williams@intel.com>,
	ross.zwisler@linux.intel.com, willy@linux.intel.com,
	Jan Kara <jack@suse.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52161 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756803AbbJVIQV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Oct 2015 04:16:21 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

This series fixes a long standing problem of racing punch hole and page fault
resulting in possible filesystem corruption or stale data exposure. We fix the
problem by using a new inode-private rw_semaphore i_mmap_sem to synchronize
page faults with truncate and punch hole operations.

When having this exclusion, the only remaining problem with DAX implementation
are races between two page faults zeroing out same block concurrently (where
the data written after the first fault finishes are possibly overwritten by
the second fault still doing zeroing).

Patch 1 introduces i_mmap_sem lock in ext4 inode and uses it to properly
serialize extent manipulation operations and page faults.

Patch 2 is mostly a preparatory cleanup patch which also avoids double lock /
unlock in unlocked DIO protections (currently harmless but nasty surprise).

Patches 3-4 fix further races of extent manipulation functions (such as zero
range, collapse range, insert range) with buffered IO, page writeback

Patch 5 documents locking order of ext4 filesystem locks.

Patch 6 removes locking abuse of i_data_sem from the get_blocks() path when
dioread_nolock is enabled since it is not needed anymore.

Patches 7-9 implement allocation of pre-zeroed blocks in ext4_map_blocks()
callback and use such blocks for allocations from DAX page faults.

The patches survived xfstests run both in dax and non-dax mode.

								Honza
