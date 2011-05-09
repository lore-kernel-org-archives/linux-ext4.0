From: amir73il@users.sourceforge.net
Subject: [PATCH RFC 00/30] Ext4 snapshots - core patches
Date: Mon,  9 May 2011 19:41:18 +0300
Message-ID: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33538 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab1EIQmN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 May 2011 12:42:13 -0400
Received: by wya21 with SMTP id 21so4026020wya.19
        for <linux-ext4@vger.kernel.org>; Mon, 09 May 2011 09:42:12 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The following patch series includes all the changes to core ext4 files,
which are needed for snapshots support. It adds some ~2K lines of code,
which will never be executed unless the following 2 conditions apply:
1. ext4 is built with CONFIG_EXT4_FS_SNAPSHOT
2. HAS_SNAPSHOT and EXCLUDE_BITMAP features are set by mke2fs/tune2fs

The remaining ~5K lines of code, added in new snapshot* files, were omitted
from this series to simplify the review and becasue they are not needed
when building ext4 without CONFIG_EXT4_FS_SNAPSHOT.
the full patches will be posted soon after I recieve some comments.

Ted has concluded my ext4 snapshots talk on LPC 2010 with the statement that
as long as the snapshot patches don't break anything when snapshot support
is disabled, he will pull them, so the main goal when reviewing this series
should be to prove that it is safe to pull the patches.

REVIEWING
---------
To make it easy for reviewers, I will provide some pointers:
- EXT4_SNAPSHOTS(sb) is defined to (0) (in snapshot.h) when ext4 is built
  without snapshots support.
- EXT4_SNAPSHOTS(sb) is defined to test the HAS_SNAPSHOT feature when ext4
  is built with snapshots support.
- All the ext4_snapshot_XXX function added by the patches, are defined to
  NOP macros in snapshot.h when ext4 is built without snapshots support.
- Various flags defined by the patches (like EXT4_MB_HINT_COWING) will never
  get set if EXT4_SNAPSHOTS(sb) is false, so testing them will also be false.

MERGING
-------
These patches are based on Ted's current master branch + alloc_semp removal
patches. Although the alloc_semp removal is an independent (and in my eyes
a good) change, it is also required by snapshot patches, to avoid circular
locking dependency during COW allocations.

Merging with Allison's punch holes patches should be straight forward, since
the hard part, namely Yongqiang's split extent refactoring patches, was
already merged by Ted.

Merging with Ted's big alloc patches is going to be a bit more challenging,
since big alloc patches make a lot of renaming and refactoring. However,
since has_snapshots and big_alloc features will never work together,
at least testing the code together is not a big concern.

TESTING
-------
Apart from the extensive testing for the snapshots feature functionality, we
also ran xfstests with snapshots and while taking a snapshot every 1 minute.
More importantly, we ran xfstests with snapshots support disabled in compile
time and with snapshot support enabled but without has_snapshot feature.
These xfstests were run with blocksize 1K and 4K and on X86 and X86_64.
The 1K blocksize tests are important for the alloc_semp removal patches.
No problems were found apart from one (test 225 hung), which is already
existing in master branch.

CREDITS
-------
The snapshots patches originate in my implementation of the Next3 filesystem
for CTERA networks.
The porting of the Next3 snapshot patches to ext4 patches is attributed to
Aditya Dani, Shardul Mangade, Piyush Nimbalkar and Harshad Shirwadkar from
the Pune Institute of Computer Technology (PICT).
The implementation of extents move-on-write, delayed move-on-write and much
of the cleanup work on these patches was carried out by Yongqiang Yang from
the Institute of Computing Technology, Chinese Academy of Sciences.


[PATCH RFC 01/30] ext4: EXT4 snapshots (Experimental)
[PATCH RFC 02/30] ext4: snapshot debugging support
[PATCH RFC 03/30] ext4: snapshot hooks - inside JBD hooks
[PATCH RFC 04/30] ext4: snapshot hooks - block bitmap access
[PATCH RFC 05/30] ext4: snapshot hooks - delete blocks
[PATCH RFC 06/30] ext4: snapshot hooks - move data blocks
[PATCH RFC 07/30] ext4: snapshot hooks - direct I/O
[PATCH RFC 08/30] ext4: snapshot hooks - move extent file data blocks
[PATCH RFC 09/30] ext4: snapshot file
[PATCH RFC 10/30] ext4: snapshot file - read through to block device
[PATCH RFC 11/30] ext4: snapshot file - permissions
[PATCH RFC 12/30] ext4: snapshot file - store on disk
[PATCH RFC 13/30] ext4: snapshot file - increase maximum file size limit to 16TB
[PATCH RFC 14/30] ext4: snapshot block operations
[PATCH RFC 15/30] ext4: snapshot block operation - copy blocks to snapshot
[PATCH RFC 16/30] ext4: snapshot block operation - move blocks to snapshot
[PATCH RFC 17/30] ext4: snapshot control
[PATCH RFC 18/30] ext4: snapshot control - fix new snapshot
[PATCH RFC 19/30] ext4: snapshot control - reserve disk space for snapshot
[PATCH RFC 20/30] ext4: snapshot journaled - increase transaction credits
[PATCH RFC 21/30] ext4: snapshot journaled - implement journal_release_buffer()
[PATCH RFC 22/30] ext4: snapshot journaled - bypass to save credits
[PATCH RFC 23/30] ext4: snapshot journaled - trace COW/buffer credits
[PATCH RFC 24/30] ext4: snapshot list support
[PATCH RFC 25/30] ext4: snapshot race conditions - concurrent COW operations
[PATCH RFC 26/30] ext4: snapshot race conditions - tracked reads
[PATCH RFC 27/30] ext4: snapshot exclude - the exclude bitmap
[PATCH RFC 28/30] ext4: snapshot cleanup
[PATCH RFC 29/30] ext4: snapshot cleanup - shrink deleted snapshots
[PATCH RFC 30/30] ext4: snapshot rocompat - enable rw mount
