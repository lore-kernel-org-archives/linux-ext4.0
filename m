From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: ext4: possible unsafe locking scenario
Date: Wed, 26 Nov 2014 23:59:51 +0900
Message-ID: <20141126145951.GA2750@swordfish>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

locked spew with the current -next.

[  427.152842] =============================================
[  427.152843] [ INFO: possible recursive locking detected ]
[  427.152847] 3.18.0-rc6-next-20141126-dbg-00001-gb80a67f-dirty #402 Not tainted
[  427.152848] ---------------------------------------------
[  427.152850] gcc/10495 is trying to acquire lock:
[  427.152851]  (&ei->i_data_sem){++++..}, at: [<ffffffff8119022f>] ext4_truncate+0x1cc/0x2bc
[  427.152862] 
but task is already holding lock:
[  427.152864]  (&ei->i_data_sem){++++..}, at: [<ffffffff8119022f>] ext4_truncate+0x1cc/0x2bc
[  427.152868] 
other info that might help us debug this:
[  427.152870]  Possible unsafe locking scenario:

[  427.152872]        CPU0
[  427.152873]        ----
[  427.152874]   lock(&ei->i_data_sem);
[  427.152875]   lock(&ei->i_data_sem);
[  427.152877] 
 *** DEADLOCK ***

[  427.152879]  May be due to missing lock nesting notation

[  427.152881] 5 locks held by gcc/10495:
[  427.152883]  #0:  (sb_writers#7){.+.+.+}, at: [<ffffffff81101e62>] mnt_want_write+0x1f/0x46
[  427.152891]  #1:  (sb_internal){.+.+..}, at: [<ffffffff8119119c>] ext4_evict_inode+0x1cb/0x3d6
[  427.152897]  #2:  (jbd2_handle){+.+...}, at: [<ffffffff811c4099>] start_this_handle+0x4e0/0x566
[  427.152902]  #3:  (&ei->i_data_sem){++++..}, at: [<ffffffff8119022f>] ext4_truncate+0x1cc/0x2bc
[  427.152907]  #4:  (sb_internal){.+.+..}, at: [<ffffffff8119119c>] ext4_evict_inode+0x1cb/0x3d6
[  427.152911] 
stack backtrace:
[  427.152915] CPU: 3 PID: 10495 Comm: gcc Not tainted 3.18.0-rc6-next-20141126-dbg-00001-gb80a67f-dirty #402
[  427.152917] Hardware name: Acer             Aspire 5741G    /Aspire 5741G    , BIOS V1.20 02/08/2011
[  427.152919]  ffffffff820f6e40 ffff880061a13908 ffffffff813cd7ff 0000000000000006
[  427.152922]  ffffffff820f6e40 ffff880061a139d8 ffffffff8106c27d ffff880152eb9c30
[  427.152925]  ffff880152eb9c30 ffff8800377a2000 ffff88014a6e47d8 0000000000000003
[  427.152928] Call Trace:
[  427.152934]  [<ffffffff813cd7ff>] dump_stack+0x4c/0x65
[  427.152938]  [<ffffffff8106c27d>] __lock_acquire+0x7b5/0x1a17
[  427.152941]  [<ffffffff8118eff7>] ? ext4_mark_iloc_dirty+0x70c/0x7ab
[  427.152944]  [<ffffffff8106db62>] lock_acquire+0x4f/0x6e
[  427.152946]  [<ffffffff8119022f>] ? ext4_truncate+0x1cc/0x2bc
[  427.152951]  [<ffffffff81058acf>] ? __might_sleep+0xac/0xb4
[  427.152955]  [<ffffffff813d1695>] down_write+0x3d/0x6d
[  427.152958]  [<ffffffff8119022f>] ? ext4_truncate+0x1cc/0x2bc
[  427.152961]  [<ffffffff8119022f>] ext4_truncate+0x1cc/0x2bc
[  427.152963]  [<ffffffff811912a2>] ext4_evict_inode+0x2d1/0x3d6
[  427.152967]  [<ffffffff810fd871>] evict+0x102/0x1ad
[  427.152969]  [<ffffffff810fe490>] ? iput+0x120/0x131
[  427.152971]  [<ffffffff810fe498>] iput+0x128/0x131
[  427.152974]  [<ffffffff8118ef21>] ext4_mark_iloc_dirty+0x636/0x7ab
[  427.152977]  [<ffffffff8118f1a3>] ext4_mark_inode_dirty+0x8a/0x1a2
[  427.152982]  [<ffffffff811a484a>] __ext4_ext_dirty+0x6d/0x79
[  427.152985]  [<ffffffff811a731f>] ext4_ext_remove_space+0x858/0xcdc
[  427.152988]  [<ffffffff811a8cc7>] ext4_ext_truncate+0x9a/0xbe
[  427.152991]  [<ffffffff81190250>] ext4_truncate+0x1ed/0x2bc
[  427.152994]  [<ffffffff811912a2>] ext4_evict_inode+0x2d1/0x3d6
[  427.152996]  [<ffffffff810fd871>] evict+0x102/0x1ad
[  427.152998]  [<ffffffff8106b837>] ? trace_hardirqs_on_caller+0x180/0x19c
[  427.153001]  [<ffffffff810fe490>] ? iput+0x120/0x131
[  427.153003]  [<ffffffff810fe498>] iput+0x128/0x131
[  427.153007]  [<ffffffff810f4449>] do_unlinkat+0x141/0x213
[  427.153013]  [<ffffffff8100da89>] ? syscall_trace_enter_phase1+0x112/0x122
[  427.153018]  [<ffffffff812166db>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  427.153021]  [<ffffffff810f4b84>] SyS_unlink+0x11/0x13
[  427.153025]  [<ffffffff813d34d6>] system_call_fastpath+0x16/0x1b

	-ss
