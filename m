From: "Boylston, Brian" <brian.boylston@hpe.com>
Subject: RE: [PATCH 0/9 v4] ext4: Punch hole and DAX fixes
Date: Tue, 17 Nov 2015 17:41:55 +0000
Message-ID: <80B02B5F638F054B8B1358323FECDE0A5EA7097A@G2W2437.americas.hpqcorp.net>
References: <1447185059-16166-1-git-send-email-jack@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>
To: Jan Kara <jack@suse.com>, Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:50183 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320AbbKQRrS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Nov 2015 12:47:18 -0500
Received: from g2t2353.austin.hp.com (g2t2353.austin.hp.com [15.217.128.52])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id D2BDA62298
	for <linux-ext4@vger.kernel.org>; Tue, 17 Nov 2015 17:47:17 +0000 (UTC)
In-Reply-To: <1447185059-16166-1-git-send-email-jack@suse.com>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 10, 2015 at 2:51 PM, Jan Kara wrote:
> Another version of my ext4 fixes. Since previous version I have fixed DAX block
> mapping to really avoid races for parallel page faults so that the test program
> by Brian passes. Note that you'll see ext4/001 failures - xfstests updates were

Thanks for the updated patches!

> submitted. Also note that testing with 1 KB blocksize on ramdisk is broken
> since brd has buggy discard implementation - Jens has a fix queued.
> 
> Change since v3:
> * Fixed ext4_dax_mmap_get_block() to not return buffer_new buffer and thus
>   avoid racy zeroing in generic dax code
> * Fixed ext4_map_blocks() to zeroout blocks before inserting entry into
>   extent status tree to avoid racy lookups of blocks.
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

Is this still a problem for this version of the patch set?

Thanks!
Brian

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

