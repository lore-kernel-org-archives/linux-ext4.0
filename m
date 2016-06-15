From: Calvin Owens <calvinowens@fb.com>
Subject: WARNING at fs/ext4/inode.c ext4_evict_inode() triggers on 4.0
Date: Wed, 15 Jun 2016 16:49:39 -0400
Message-ID: <20160615204939.GA52455@calvinowens-mba.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Cc: <linux-ext4@vger.kernel.org>, <calvinowens@fb.com>,
	<kernel-team@fb.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54576 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751907AbcFOUt5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Jun 2016 16:49:57 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Jan,

I'm hitting the following warning on a 4.0 kernel:

  WARNING: CPU: 15 PID: 1005611 at fs/ext4/inode.c:233 ext4_evict_inode+0x4be/0x4d0()
  CPU: 15 PID: 1005611 Comm: rocksdb:bg0 Not tainted 4.0.9-60_fbk10_rc1_3974_g796b9b6 #1
  Call Trace: 
  [<ffffffff8176af8e>] dump_stack+0x4d/0x63
  [<ffffffff8106c4dc>] warn_slowpath_common+0x8c/0xd0
  [<ffffffff8106c5da>] warn_slowpath_null+0x1a/0x20
  [<ffffffff81242c0e>] ext4_evict_inode+0x4be/0x4d0
  [<ffffffff811d248b>] evict+0xbb/0x190 
  [<ffffffff811d2d6d>] iput+0x17d/0x1e0
  [<ffffffff811ce0e0>] __dentry_kill+0x190/0x1e0
  [<ffffffff811ce2d1>] dput+0x1a1/0x1f0
  [<ffffffff811b952a>] __fput+0x17a/0x210
  [<ffffffff811b960e>] ____fput+0xe/0x10
  [<ffffffff81086dbf>] task_work_run+0xbf/0x100 
  [<ffffffff81002bcc>] do_notify_resume+0x7c/0x90
  [<ffffffff81771529>] int_signal+0x12/0x17

Commit 822dbba ("ext4: fix warning in ext4_evict_inode()") proportedly fixed
this in 3.11. The check was entirely removed in 4.6.

Is it interesting to you that this triggers on 4.0? I can revert 600be30 and
see if I can reproduce it on upstream, but since the check got removed I
was wondering if there was post-4.0 work that makes it obsolete?

Thanks,
Calvin

--
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=822dbba
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=600be30
