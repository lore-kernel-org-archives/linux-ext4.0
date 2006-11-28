From: Eric Sandeen <sandeen@redhat.com>
Subject: xfs defragmentation writeup, for comparison
Date: Tue, 28 Nov 2006 15:04:20 -0600
Message-ID: <456CA454.8040401@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:37827 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1755523AbWK1VEW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Nov 2006 16:04:22 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.12.11.20060308/8.12.11) with ESMTP id kASL4Lub028501
	for <linux-ext4@vger.kernel.org>; Tue, 28 Nov 2006 16:04:21 -0500
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id kASL4LDv023230
	for <linux-ext4@vger.kernel.org>; Tue, 28 Nov 2006 16:04:21 -0500
Received: from [10.15.80.10] (neon.msp.redhat.com [10.15.80.10])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id kASL4Kcn020159
	for <linux-ext4@vger.kernel.org>; Tue, 28 Nov 2006 16:04:20 -0500
To: ext4 development <linux-ext4@vger.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

As promised, here is a writeup of xfs defragmentation routines.

I don't hold these up as the perfect or best way to do this task, but it
is worth looking at what has been done before, to get ideas, find better
ways, and avoid pitfalls for ext4.

XFS defragmentation interface.
=============================

xfs uses the xfs_fsr tool, found in the xfsdump (!) package, to
defragment files on the filesystem.

It has a few features for defragmenting a whole filesystem,
starting/stopping, etc, but I'll just sketch out how it defragments a
single file.

The xfs preallocation routines are central to this; fsr uses
preallocation to create the less-fragmented space for the file in
question.

The 10,000 foot overview is:

1. create a new temporary file - open & unlink
2. preallocate space for the new file to match the file to be defragmented
3. see if we got fewer extents than the original
4. do an O_DIRECT data copy into the new extents
5. call the kernel to swap the extents between the two, with sanity checks
6. close unlinked temporary file which now contains the fragmented extents.

userspace work is done in xfsdump/fsr/xfs_fsr.c
kernelspace work is done in fs/xfs/xfs_dfrag.c

In more detail...

in userspace, fsrfile_common() / packfile():

check for mandatory locks, skip this file if present
make sure there is room to copy the file
get inode attributes (ext2-style, append-only, immutable, etc)
 skip if immutable, append-only, or no-defrag set
get the current extent layout of the file (XFS_IOC_GETBMAP)
 stop if already best nr. of extents
open the temp file and immediately unlink it
set extended attributes on the temp file
set other extended inode flags on the temp file
set up buffers for direct IO
loop through original block map, preallocating extents for tmp file
 (this preserves holes as well)
double check that we have fewer extents
now loop through the block map, copying into temp file via O_DIRECT
truncate temp file to proper size (O_DIRECT alignment may have made it
larger)
switch to file owner's UID/GID to preserve quota information
set up swapext ioctl to swap extents
call kernel to swap extents between original & temp files:

typedef struct xfs_swapext
{
        __int64_t       sx_version;     /* swapext version */
        __int64_t       sx_fdtarget;    /* fd of target file */
        __int64_t       sx_fdtmp;       /* fd of tmp file */
        xfs_off_t       sx_offset;      /* offset into file */
        xfs_off_t       sx_length;      /* leng from offset */
        char            sx_pad[16];     /* pad space, unused */
        xfs_bstat_t     sx_stat;        /* stat of target b4 copy */
} xfs_swapext_t;

now in kernelspace, xfs_swapext() / xfs_swap_extents():

verify both files on same filesystem
verify that inode numbers differ
abort if filesystem is shut down
lock the inodes (ilock, ilock...)
check permissions on the files
verify that they both have the same format/type (S_IFMT, realtime, etc)
if temp file is cached, flush it
verify size of both files match
verify both files have extended attributes (or not)
compare change & modify times with what was passed in
 abort if they differ, file was changed before locking
abort if the original file is memory-mapped
set up transaction
swap the data forks of the inodes, fix up on-disk inode values
commit the transaction
unlock the inodes

-Eric
