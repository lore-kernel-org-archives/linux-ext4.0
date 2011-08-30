From: Dave Young <hidave.darkstar@gmail.com>
Subject: lockdep warnings - possible circular locking
Date: Tue, 30 Aug 2011 17:09:11 +0800
Message-ID: <CABqxG0e6EXfDUEeno6e70Orgye+0EGq6x7qsFJ2q8Og3vt+aiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

I got following lockdep warnings, ext4 related?

=======================================================
[11038.258992] [ INFO: possible circular locking dependency detected ]
[11038.258996] 3.1.0-rc3-00283-gc11a7e2 #264
[11038.258998] -------------------------------------------------------
[11038.259002] soffice.bin/3022 is trying to acquire lock:
[11038.259005]  (&sb->s_type->i_mutex_key#4){+.+.+.}, at:
[<ffffffff811836d3>] ext4_evict_inode+0x4a/0x2ff
[11038.259019]
[11038.259020] but task is already holding lock:
[11038.259024]  (&group->notification_mutex){+.+...}, at:
[<ffffffff8112f838>] fsnotify_flush_notify+0x22/0x115
[11038.259034]
[11038.259034] which lock already depends on the new lock.
[11038.259036]
[11038.259039]
[11038.259039] the existing dependency chain (in reverse order) is:
[11038.259043]
[11038.259044] -> #1 (&group->notification_mutex){+.+...}:
[11038.259051]        [<ffffffff8106c21d>] lock_acquire+0xd9/0x105
[11038.259057]        [<ffffffff81532ac2>] _raw_spin_lock+0x2c/0x38
[11038.259064]        [<ffffffff810f72fa>] __slab_alloc+0x105/0x374
[11038.259070]        [<ffffffff810f7fd6>] kmem_cache_alloc+0x82/0xf1
[11038.259075]        [<ffffffff81112c34>] __d_alloc+0x24/0x16e
[11038.259081]        [<ffffffff81112de9>] d_alloc+0x1c/0x7e
[11038.259086]        [<ffffffff81112ead>] d_alloc_name+0x62/0x64
[11038.259092]        [<ffffffff8115fb06>] devpts_pty_new+0x16a/0x207
[11038.259098]        [<ffffffff813015b6>] ptmx_open+0xac/0x106
[11038.259104]        [<ffffffff81103983>] chrdev_open+0x138/0x157
[11038.259110]        [<ffffffff810fee11>] __dentry_open+0x1af/0x2bd
[11038.259116]        [<ffffffff810fefd5>] nameidata_to_filp+0x53/0x62
[11038.259122]        [<ffffffff8110c449>] do_last+0x491/0x590
[11038.259128]        [<ffffffff8110c615>] path_openat+0xcd/0x345
[11038.259134]        [<ffffffff8110c982>] do_filp_open+0x38/0x86
[11038.259139]        [<ffffffff810feb1d>] do_sys_open+0x6c/0xf6
[11038.259145]        [<ffffffff810febd0>] sys_open+0x1b/0x1d
[11038.259150]        [<ffffffff81539b52>] system_call_fastpath+0x16/0x1b
[11038.259157]
[11038.259158] -> #0 (&sb->s_type->i_mutex_key#4){+.+.+.}:
[11038.259165]        [<ffffffff8106ba31>] __lock_acquire+0xb78/0xe95
[11038.259172]        [<ffffffff8106c21d>] lock_acquire+0xd9/0x105
[11038.259177]        [<ffffffff81531c7a>] __mutex_lock_common+0x48/0x355
[11038.259183]        [<ffffffff81532030>] mutex_lock_nested+0x26/0x2b
[11038.259188]        [<ffffffff811836d3>] ext4_evict_inode+0x4a/0x2ff
[11038.259194]        [<ffffffff81115133>] evict+0xa7/0x163
[11038.259199]        [<ffffffff811153be>] iput+0x1cf/0x1d7
[11038.259204]        [<ffffffff811130d5>] dentry_kill+0x174/0x192
[11038.259209]        [<ffffffff81113a73>] dput+0x103/0x113
[11038.259214]        [<ffffffff8110937c>] path_put+0x15/0x21
[11038.259220]        [<ffffffff8112f6fe>] fsnotify_put_event+0x53/0x90
[11038.259230]        [<ffffffff8112f8f7>] fsnotify_flush_notify+0xe1/0x115
[11038.259233]        [<ffffffff8112fc27>]
fsnotify_final_destroy_group+0x11/0x2f
[11038.259236]        [<ffffffff8112fc82>] fsnotify_put_group+0x3d/0x43
[11038.259239]        [<ffffffff8113157b>] inotify_release+0x48/0x4e
[11038.259242]        [<ffffffff81101721>] fput+0x10b/0x1a8
[11038.259245]        [<ffffffff810fe98b>] filp_close+0x6d/0x78
[11038.259248]        [<ffffffff8103cd4c>] put_files_struct+0xa9/0x141
[11038.259252]        [<ffffffff8103ce2b>] exit_files+0x47/0x50
[11038.259254]        [<ffffffff8103e7f7>] do_exit+0x281/0x7b1
[11038.259257]        [<ffffffff8103eda6>] do_group_exit+0x7f/0xab
[11038.259260]        [<ffffffff8103ede4>] sys_exit_group+0x12/0x16
[11038.259263]        [<ffffffff81539b52>] system_call_fastpath+0x16/0x1b
[11038.259266]
[11038.259266] other info that might help us debug this:
[11038.259267]
[11038.259269]  Possible unsafe locking scenario:
[11038.259269]
[11038.259271]        CPU0                    CPU1
[11038.259272]        ----                    ----
[11038.259273]   lock(&group->notification_mutex);
[11038.259276]                                lock(&sb->s_type->i_mutex_key);
[11038.259279]                                lock(&group->notification_mutex);
[11038.259282]   lock(&sb->s_type->i_mutex_key);
[11038.259284]
[11038.259284]  *** DEADLOCK ***
[11038.259285]
[11038.259287] 1 lock held by soffice.bin/3022:
[11038.259288]  #0:  (&group->notification_mutex){+.+...}, at:
[<ffffffff8112f838>] fsnotify_flush_notify+0x22/0x115
[11038.259294]
[11038.259294] stack backtrace:
[11038.259297] Pid: 3022, comm: soffice.bin Not tainted
3.1.0-rc3-00283-gc11a7e2 #264
[11038.259299] Call Trace:
[11038.259302]  [<ffffffff8106aea8>] print_circular_bug+0x20e/0x21f
[11038.259305]  [<ffffffff8106ba31>] __lock_acquire+0xb78/0xe95
[11038.259309]  [<ffffffff8106c21d>] lock_acquire+0xd9/0x105
[11038.259312]  [<ffffffff811836d3>] ? ext4_evict_inode+0x4a/0x2ff
[11038.259315]  [<ffffffff81531c7a>] __mutex_lock_common+0x48/0x355
[11038.259318]  [<ffffffff811836d3>] ? ext4_evict_inode+0x4a/0x2ff
[11038.259321]  [<ffffffff811836d3>] ? ext4_evict_inode+0x4a/0x2ff
[11038.259324]  [<ffffffff81532030>] mutex_lock_nested+0x26/0x2b
[11038.259326]  [<ffffffff811836d3>] ext4_evict_inode+0x4a/0x2ff
[11038.259329]  [<ffffffff81115133>] evict+0xa7/0x163
[11038.259332]  [<ffffffff811153be>] iput+0x1cf/0x1d7
[11038.259335]  [<ffffffff811130d5>] dentry_kill+0x174/0x192
[11038.259338]  [<ffffffff81113a73>] dput+0x103/0x113
[11038.259340]  [<ffffffff8110937c>] path_put+0x15/0x21
[11038.259343]  [<ffffffff8112f6fe>] fsnotify_put_event+0x53/0x90
[11038.259346]  [<ffffffff8112f8f7>] fsnotify_flush_notify+0xe1/0x115
[11038.259349]  [<ffffffff81531ade>] ? mutex_unlock+0x9/0xb
[11038.259352]  [<ffffffff8112fc27>] fsnotify_final_destroy_group+0x11/0x2f
[11038.259355]  [<ffffffff8112fc82>] fsnotify_put_group+0x3d/0x43
[11038.259357]  [<ffffffff8113157b>] inotify_release+0x48/0x4e
[11038.259360]  [<ffffffff81101721>] fput+0x10b/0x1a8
[11038.259363]  [<ffffffff810fe98b>] filp_close+0x6d/0x78
[11038.259366]  [<ffffffff8103cd4c>] put_files_struct+0xa9/0x141
[11038.259368]  [<ffffffff8103ccc5>] ? put_files_struct+0x22/0x141
[11038.259372]  [<ffffffff81291a55>] ? do_raw_spin_unlock+0x8f/0x96
[11038.259375]  [<ffffffff8103ce2b>] exit_files+0x47/0x50
[11038.259378]  [<ffffffff8103e7f7>] do_exit+0x281/0x7b1
[11038.259380]  [<ffffffff8103eda6>] do_group_exit+0x7f/0xab
[11038.259383]  [<ffffffff8103ede4>] sys_exit_group+0x12/0x16
[11038.259386]  [<ffffffff81539b52>] system_call_fastpath+0x16/0x1b

-- 
Regards
Yang RuiRui
