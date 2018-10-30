Return-Path: <SRS0=zKcc=NK=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from relay.sw.ru ([185.231.240.75]:45926 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725743AbeJaGwp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 31 Oct 2018 02:52:45 -0400
From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v2 00/11] ext4: number of long lived errors
To: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org
Message-ID: <52c35b13-6606-5240-137f-37915bc8aded@virtuozzo.com>
Date: Wed, 31 Oct 2018 00:57:26 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Last week I've investigated the reason of ext4 resize troubles
on RHEL6 and RHEL7 based OpenVZ kernels.
Failed resize generated lot of "access beyond end of device" messages
followed by warning in __brelse.

 EXT4-fs (dm-3): resizing filesystem from 2620416 to 4096256 blocks
 attempt to access beyond end of device
 dm-3: rw=1, want=32770056, limit=32770048
 attempt to access beyond end of device
 dm-3: rw=1, want=32770064, limit=32770048
 ...
 attempt to access beyond end of device
 dm-3: rw=1, want=32776216, limit=32770048
 EXT4-fs (dm-3): resized filesystem to 4096256
 WARNING: CPU: 2 PID: 113370 at fs/buffer.c:1171 __brelse+0x2e/0x50
 VFS: brelse: Trying to free free buffer

"access beyond end of device" was fixed in mainline by recent commit
f0a459dec5495a ("ext4: fix online resize's handling of a too-small final block group")
However fixed error did not affected bh accounting
and should not lead to warning in __brelse.

Then I've reviewed fs/ext4/resize.c and found a number of long-lived errors,
earliest of them was imported from ext3 in 2.6.19.

First patch in this patch-set fixes the observed problem:
sb_issue_zeroout() failed during attempt to write beyond end of device
rollback switched to "goto end" and called brelse(bh).
however bh was not assigned yet in current iteration,
the pointer was not cleaned properly and was inherited from previous iteration.
To fix the problem I've moved brelse() calls in body of the cycle 
to avoid having to call him on rollback.

Other patches fixes visually-found mistakes.

v2 changes:
 I've found error in one of v1 patches and fixed it,
 then I've found 4 additional issues, mostly related to iloc.bh accounting 

Vasily Averin (11):
  ext4 resise: extra brelse in setup_new_flex_group_blocks()
  ext4 resize: missing brelse() after errors in
    set_flexbg_block_bitmap()
  ext4 resize: brelse() cleanup in add_new_gdb_meta_bg()
  ext4 resize: lost brelse() in update_backups()
  ext4 resize: lost rollback in ext4_resize_fs()
  ext4 resize: lost resize_inode cleanup before retry in
    ext4_resize_fs()
  ext4: lost put_bh in ext4_mark_iloc_dirty()
  ext4: lost brelse in ext4_orphan_add()
  ext4: iloc.bh cleanup in add_new_gdb()
  ext4: remove useless brelse call in ext4_xattr_inode_update_ref()
  ext4: access to uninitialized bh fields in ext4_xattr_set_handle()

 fs/ext4/inode.c  |  5 +++--
 fs/ext4/namei.c  |  4 +++-
 fs/ext4/resize.c | 32 ++++++++++++++++++--------------
 fs/ext4/xattr.c  |  8 +++-----
 4 files changed, 27 insertions(+), 22 deletions(-)

-- 
2.17.1
