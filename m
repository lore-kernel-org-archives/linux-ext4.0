From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/9] ext4: Fix races between buffered IO and collapse /
 insert range
Date: Sat, 24 Oct 2015 00:59:26 -0400
Message-ID: <20151024045926.GM7917@thunk.org>
References: <1445501761-14528-1-git-send-email-jack@suse.com>
 <1445501761-14528-4-git-send-email-jack@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Dan Williams <dan.j.williams@intel.com>,
	ross.zwisler@linux.intel.com, willy@linux.intel.com
To: Jan Kara <jack@suse.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41836 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906AbbJXKvf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 24 Oct 2015 06:51:35 -0400
Content-Disposition: inline
In-Reply-To: <1445501761-14528-4-git-send-email-jack@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 22, 2015 at 10:15:55AM +0200, Jan Kara wrote:
> Current code implementing FALLOC_FL_COLLAPSE_RANGE and
> FALLOC_FL_INSERT_RANGE is prove to races with buffered writes and page
> faults. If buffered write or write via mmap manages to squeeze between
> filemap_write_and_wait_range() and truncate_pagecache() in the fallocate
> implementations, the written data is simply discarded by
> truncate_pagecache() although it should have been shifted.
> 
> Fix the problem by moving filemap_write_and_wait_range() call inside
> i_mutex and i_mmap_sem. That way we are protected against races with
> both buffered writes and page faults.
> 
> Signed-off-by: Jan Kara <jack@suse.com>

This patch is causing generic/091 to fail with a 1k block size.

BEGIN TEST 1k: Ext4 1k block Sat Oct 24 00:41:32 EDT 2015
DEVICE: /dev/vdd
MK2FS OPTIONS: -q -b 1024
MOUNT OPTIONS: -o block_validity
FSTYP         -- ext4
PLATFORM      -- Linux/i686 kvm-xfstests 4.3.0-rc2ext4-00028-g53834d8
MKFS_OPTIONS  -- -q -b 1024 /dev/vdc
MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity /dev/vdc /vdc

generic/091		[00:41:35][    8.942840] run fstests generic/091 at 2015-10-24 00:41:35
[    9.471531] xfs_io (3160) used greatest stack depth: 5636 bytes left
[   13.467847] fsx (3172) used greatest stack depth: 5632 bytes left
 [00:41:39] [failed, exit status 1] - output mismatch (see /results/results-1k/generic/091.out.bad)
    --- tests/generic/091.out	2015-10-18 23:46:49.000000000 -0400
    +++ /results/results-1k/generic/091.out.bad	2015-10-24 00:41:39.981112671 -0400
    @@ -1,7 +1,7124 @@
     QA output created by 091
     fsx -N 10000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
    -fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
    -fsx -N 10000 -o 32768 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
    -fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
    -fsx -N 10000 -o 32768 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
    -fsx -N 10000 -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -W
    ...
    (Run 'diff -u tests/generic/091.out /results/results-1k/generic/091.out.bad'  to see the entire diff)

An examination of results-1k/generic/091.full finds:

fsx -N 10000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
mapped writes DISABLED
skipping insert range behind EOF
skipping insert range behind EOF
truncating to largest ever: 0x11e00
truncating to largest ever: 0x2fa00
zero_range to largest ever: 0x4e869
truncating to largest ever: 0x68000
truncating to largest ever: 0x6c000
truncating to largest ever: 0x70200
truncating to largest ever: 0x74400
truncating to largest ever: 0x74e00
fallocating to largest ever: 0x75f20
fallocating to largest ever: 0x7a120
skipping insert range behind EOF
skipping collapse range behind EOF
skipping zero length zero range
skipping zero length zero range
READ BAD DATA: offset = 0x28000, size = 0xb000, fname = /vdd/junk
OFFSET	GOOD	BAD	RANGE
0x28b0f	0x0000	0xa793	0x    0
operation# (mod 256) for the bad data may be 147
0x28b10	0x0000	0x9398	0x    1
operation# (mod 256) for the bad data may be 147
0x28b11	0x0000	0x9893	0x    2
operation# (mod 256) for the bad data may be 147
0x28b12	0x0000	0x93d4	0x    3
operation# (mod 256) for the bad data may be 147
0x28b13	0x0000	0xd493	0x    4
...

Could you take a look?

						- Ted
						
