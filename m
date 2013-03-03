From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 0/2] fixup bugs in e2fsprogs that is reported by xfstests #218
Date: Mon,  4 Mar 2013 00:26:16 +0800
Message-ID: <1362327978-30423-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f43.google.com ([209.85.210.43]:64553 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532Ab3CCQLQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 3 Mar 2013 11:11:16 -0500
Received: by mail-da0-f43.google.com with SMTP id u36so2156262dak.30
        for <linux-ext4@vger.kernel.org>; Sun, 03 Mar 2013 08:11:15 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

This patch series tries to fixup bugs in e2fsprogs that is reported by
xfstests #218 (This patch [1] need to be applied to fix a bug for #218).
The first commit tries to fix a e4defrag bug, which makes e4defrag to
defrag a ext4 file when orig_physcial_cnt == donor_physical_cnt.  The
second one fixes a bug in filefrag that miss calculates contiguous
extents.

After applied this patch series, #218 can pass in the following cass:

 4k Block
 4K Block w/ dioread_nolock

The following cases will fail because in #218 it use 'dd' command to
create a contiguous file.  But it could be failed.  After using 'xfs_io'
command, this failure disappears.

 4K Block w/ ^flex_bg, nodelalloc
 4K Block w/ ^has_journal

The following cases fail because of other reasons.

 * 4K Block w/ data=journal
218 3s ... - output mismatch (see 218.out.bad)
    --- 218.out	2013-02-07 22:56:14.000000000 +0800
    +++ 218.out.bad	2013-03-04 00:15:43.000000000 +0800
    @@ -10,7 +10,7 @@
     After: 1
     Write backwards sync, but contiguous - should defrag to 1 extent
     Before: 10
    -After: 1
    +After: 10
     Write backwards sync leaving holes - defrag should do nothing
     Before: 16
     ...
     (Run 'diff -u 218.out 218.out.bad' to see the entire diff)
Ran: 218
Failures: 218
Failed 1 of 1 tests

 * 4k Block w/ metadata_csum
FSTYP         -- ext4
PLATFORM      -- Linux/x86_64 lz-desktop 3.8.0
MKFS_OPTIONS  -- -O metadata_csum /dev/sda2
MOUNT_OPTIONS -- -o acl,user_xattr /dev/sda2 /mnt/sda2

218 2s ... [failed, exit status 1] - output mismatch (see 218.out.bad)
    --- 218.out	2013-02-07 22:56:14.000000000 +0800
    +++ 218.out.bad	2013-03-03 22:37:37.000000000 +0800
    @@ -10,10 +10,7 @@
     After: 1
     Write backwards sync, but contiguous - should defrag to 1 extent
     Before: 10
    -After: 1
    -Write backwards sync leaving holes - defrag should do nothing
    -Before: 16
    -After: 16
     ...
     (Run 'diff -u 218.out 218.out.bad' to see the entire diff)
Ran: 218
Failures: 218
Failed 1 of 1 tests 

kernel: EXT4-fs error (device sda2): __ext4_ext_check_block:480: inode #12: comm
filefrag: bad header/extent: extent tree corrupted - magic f30a, entries 1, max
340(340), depth 0(0)

 * 1k Block
FSTYP         -- ext4
PLATFORM      -- Linux/x86_64 lz-desktop 3.8.0
MKFS_OPTIONS  -- -b 1024 /dev/sda2
MOUNT_OPTIONS -- -o acl,user_xattr /dev/sda2 /mnt/sda2

218 2s ... - output mismatch (see 218.out.bad)
    --- 218.out	2013-02-07 22:56:14.000000000 +0800
    +++ 218.out.bad	2013-03-03 22:41:58.000000000 +0800
    @@ -9,7 +9,7 @@
     Before: 1
     After: 1
     Write backwards sync, but contiguous - should defrag to 1 extent
    -Before: 10
    +Before: 7
     After: 1
     Write backwards sync leaving holes - defrag should do nothing
     ...
     (Run 'diff -u 218.out 218.out.bad' to see the entire diff)
Ran: 218
Failures: 218
Failed 1 of 1 tests

1. http://permalink.gmane.org/gmane.comp.file-systems.ext4/37366

Regards,
						- Zheng

Zheng Liu (2):
  e4defrag: defrag a file when orig_physical_cnt == donor_physical_cnt
  filefrag: count a contiguous extent when both logical and physical
    blocks are contiguous

 misc/e4defrag.c |  2 +-
 misc/filefrag.c | 49 ++++++++++++++++++++++++++++++++-----------------
 2 files changed, 33 insertions(+), 18 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

