From: piaojun <piaojun@huawei.com>
Subject: question about jbd2 abnormal handle
Date: Thu, 16 Mar 2017 11:37:29 +0800
Message-ID: <58CA0879.4050405@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <tytso@mit.edu>, <jack@suse.com>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([45.249.212.188]:3886 "EHLO
        dggrg02-dlp.huawei.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751127AbdCPDlW (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 15 Mar 2017 23:41:22 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I found a problem that 'ls /mnt/ocfs2/' failed, error log as below:

# ls: /mnt/ocfs2: Input/output error

kernel log as below:
Mar 16 10:27:45 linux-yxqzUv kernel: [169213.398778] (ls,19875,0):ocfs2_read_blocks:388 ERROR: E9854523FF8343F9AF043F1A5505B1E1: iblock(17), bh->state(0x44828)
Mar 16 10:27:45 linux-yxqzUv kernel: [169213.398787] (ls,19875,0):ocfs2_assign_bh:776 ERROR: status = -5
Mar 16 10:27:45 linux-yxqzUv kernel: [169213.398795] (ls,19875,0):ocfs2_dlm_inode_lock_full_nested:1937 ERROR: status = -5
Mar 16 10:27:45 linux-yxqzUv kernel: [169213.398799] (ls,19875,0):ocfs2_xattr_get:1334 ERROR: status = -5
Mar 16 10:27:45 linux-yxqzUv kernel: [169213.402691] (ls,19875,0):ocfs2_read_blocks:388 ERROR: E9854523FF8343F9AF043F1A5505B1E1: iblock(17), bh->state(0x44828)
Mar 16 10:27:45 linux-yxqzUv kernel: [169213.402704] (ls,19875,0):ocfs2_dir_foreach_blk_id:1789 ERROR: E9854523FF8343F9AF043F1A5505B1E1: Unable to read inode block for dir 17

Test Environment:
OS: suse11 sp3
kernel: 3.0.93-0.8.2
filesystem: ocfs2

test step:
1. mount device to /mnt/ocfs2/
2. cut down the storage link of device
3. mkdir /mnt/ocfs2/123
4. recover the storage link of device
5. ls /mnt/ocfs2/123, then failed

The 'bh' is submitted to jbd2 after 'mkdir', and then the write-back
thread of device submit the 'bh' to disk and failed due to bad storage
link. At last 'bh' state is marked as BH_Write_EIO. the jbd2 won't
release 'bh' in this case. so when ocfs2_read_blocks() is called, found
'bh' still in jbd2 but marked as BH_Write_EIO and return fail.

I wonder if jbd2 should handle this problem or ocfs2 filesystem should
do it?

thanks,
Jun
