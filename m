From: Salman Qazi <sqazi@google.com>
Subject: [PATCH 0/2] ext4: Fix some crashes on umount
Date: Tue, 29 May 2012 16:36:04 -0700
Message-ID: <20120529233422.12259.959.stgit@dungbeetle.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: Ted Ts'o <tytso@google.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:60157 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897Ab2E2XgF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 May 2012 19:36:05 -0400
Received: by ggeh3 with SMTP id h3so467290gge.1
        for <linux-ext4@vger.kernel.org>; Tue, 29 May 2012 16:36:05 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The following series fixes two potential ways to get crashes
during umount;  The crash signature is:

[  189.910292] RIP: 0010:[<ffffffff8118a490>]  [<ffffffff8118a490>] clear_inode+0x60/0x70
.
.
.
[  189.910292]  [<ffffffff812342fe>] ext4_clear_inode+0x1e/0x80
[  189.910292]  [<ffffffff8121944e>] ext4_evict_inode+0x7e/0x4a0
[  189.910292]  [<ffffffff8118af5f>] evict+0xaf/0x1b0
[  189.910292]  [<ffffffff8118b163>] iput+0x103/0x210
[  189.910292]  [<ffffffff81248ddb>] ext4_mb_release+0x26b/0x3c0
[  189.910292]  [<ffffffff815479bd>] ? wait_for_completion+0x1d/0x20
[  189.910292]  [<ffffffff81233abb>] ext4_put_super+0x9b/0x350
[  189.910292]  [<ffffffff8118bc8f>] ? evict_inodes+0xbf/0x120
[  189.910292]  [<ffffffff81173f12>] generic_shutdown_super+0x62/0xf0
[  189.910292]  [<ffffffff81173fd0>] kill_block_super+0x30/0x80
[  189.910292]  [<ffffffff811741e5>] deactivate_locked_super+0x45/0x70
[  189.910292]  [<ffffffff8117444e>] deactivate_super+0x4e/0x70
[  189.910292]  [<ffffffff8118efa1>] mntput_no_expire+0xf1/0x140
[  189.910292]  [<ffffffff8118fd4e>] sys_umount+0x6e/0x380
[  189.910292]  [<ffffffff810750da>] ? sys32_stat64+0x1a/0x40
[  189.910292]  [<ffffffff81190070>] sys_oldumount+0x10/0x20
[  189.910292]  [<ffffffff81551edf>] sysenter_dispatch+0x7/0x1a

and happens because the buddy cache inode still has pages at the
time of umount.  One way for this to happen is for pages to leak
in an error path.  The second way, which we reproduced involves
a race with reading the mb_groups proc file.


---

Salman Qazi (2):
      ext4: Add ext4_mb_unload_buddy in the error path
      ext4: remove mb_groups before tearing buddy_cache


 fs/ext4/mballoc.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

-- 
Salman Qazi
