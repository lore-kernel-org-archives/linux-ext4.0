From: Alexander Beregalov <a.beregalov@gmail.com>
Subject: 2.6.29-git: cannot mount ext4/loop
Date: Thu, 2 Apr 2009 01:23:28 +0400
Message-ID: <a4423d670904011423x4174a81cj901bc140944412ea@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:35289 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756609AbZDAVXc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Apr 2009 17:23:32 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Theodore, Jens

kernel is 2.6.29-07099-g8b53ef3

Mount failed:

EXT4-fs: barriers enabled
kjournald2 starting: pid 1867, dev loop0:8, commit interval 5 seconds
EXT4-fs error (device loop0): ext4_iget: block reference 2703228928 >=
max (524288) in inode #2, offset=0
EXT4-fs: get root inode failed
EXT4-fs (device loop0): mount failed

=====================================
[ BUG: bad unlock balance detected! ]
-------------------------------------
mount/1865 is trying to release lock (&lo->lo_ctl_mutex) at:
[<00000000006fa1c0>] mutex_unlock+0x10/0x20
but there are no more locks to release!

other info that might help us debug this:
1 lock held by mount/1865:
 #0:  (&bdev->bd_mutex){+.+.+.}, at: [<00000000004dd570>]
__blkdev_put+0x1c/0x14c

stack backtrace:
Call Trace:
 [0000000000477538] print_unlock_inbalance_bug+0xe8/0xf8
 [0000000000477624] lock_release_non_nested+0xdc/0x290
 [0000000000477984] lock_release+0x1ac/0x1d8
 [00000000006fa120] __mutex_unlock_slowpath+0xe8/0x178
 [00000000006fa1c0] mutex_unlock+0x10/0x20
 [0000000000621e38] lo_release+0x70/0x80
 [00000000004dd5fc] __blkdev_put+0xa8/0x14c
 [00000000004dd6b8] blkdev_put+0x18/0x2c
 [00000000004dd704] blkdev_close+0x38/0x4c
 [00000000004b6f0c] __fput+0xfc/0x1e4
 [00000000004b701c] fput+0x28/0x38
 [00000000004b4198] filp_close+0x74/0x88
 [00000000004529e0] put_files_struct+0x9c/0xfc
 [0000000000452a70] exit_files+0x30/0x40
 [000000000045406c] do_exit+0x160/0x734
 [00000000004546cc] do_group_exit+0x8c/0xc4
