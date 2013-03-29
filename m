From: Dave Jones <davej@redhat.com>
Subject: ext4 object already free.
Date: Fri, 29 Mar 2013 11:58:55 -0400
Message-ID: <20130329155855.GB5313@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Just hit this very quickly after boot while fuzzing.
(top of tree is 0776ce03b1348d39ba3035ea3ee3d268a42912ce)

[   93.602628] =============================================================================
[   93.603689] BUG kmalloc-64 (Not tainted): Object already free
[   93.604441] -----------------------------------------------------------------------------
[   93.604441] 
[   93.605674] Disabling lock debugging due to kernel taint
[   93.606377] INFO: Allocated in ext4_htree_store_dirent+0x34/0x120 age=3 cpu=2 pid=2120
[   93.607400] 	__slab_alloc+0x44a/0x502
[   93.607870] 	__kmalloc+0x323/0x3e0
[   93.608330] 	ext4_htree_store_dirent+0x34/0x120
[   93.608925] 	htree_dirblock_to_tree+0x169/0x1c0
[   93.609526] 	ext4_htree_fill_tree+0x77/0x1e0
[   93.610093] 	ext4_readdir+0x51c/0x820
[   93.610586] 	vfs_readdir+0xb8/0xf0
[   93.611046] 	sys_getdents+0x8f/0x120
[   93.611528] 	system_call_fastpath+0x16/0x1b
[   93.612085] INFO: Freed in free_rb_tree_fname+0x6c/0xd0 age=3 cpu=2 pid=2120
[   93.612999] 	__slab_free+0x41/0x3a0
[   93.613469] 	kfree+0x2ca/0x300
[   93.613885] 	free_rb_tree_fname+0x6c/0xd0
[   93.614420] 	ext4_release_dir+0x1e/0x30
[   93.614935] 	__fput+0xf5/0x2d0
[   93.615352] 	____fput+0xe/0x10
[   93.615769] 	task_work_run+0xa4/0xd0
[   93.616251] 	do_notify_resume+0x71/0xb0
[   93.616764] 	int_signal+0x12/0x17
[   93.617212] INFO: Slab 0xffffea0002665f80 objects=20 used=12 fp=0xffff88009997fb90 flags=0x3000000000004081
[   93.618457] INFO: Object 0xffff88009997e620 @offset=1568 fp=0xffff88009997f570
[   93.618457] 
[   93.619575] Bytes b4 ffff88009997e610: fd ae ff ff 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a  ........ZZZZZZZZ
[   93.620789] Object ffff88009997e620: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   93.621983] Object ffff88009997e630: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   93.623176] Object ffff88009997e640: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   93.624341] Object ffff88009997e650: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5  kkkkkkkkkkkkkkk.
[   93.625505] Redzone ffff88009997e660: bb bb bb bb bb bb bb bb                          ........
[   93.626594] Padding ffff88009997e7a0: 5a 5a 5a 5a 5a 5a 5a 5a                          ZZZZZZZZ
[   93.627684] Pid: 1850, comm: trinity-child37 Tainted: G    B        3.9.0-rc4+ #7
[   93.628623] Call Trace:
[   93.628943]  [<ffffffff81199b74>] print_trailer+0x154/0x210
[   93.629648]  [<ffffffff81190014>] ? hugetlb_fault+0x494/0x6b0
[   93.630373]  [<ffffffff816bb538>] free_debug_processing+0x134/0x22b
[   93.631164]  [<ffffffff810b3b8e>] ? put_lock_stats.isra.27+0xe/0x40
[   93.631955]  [<ffffffff816c50e5>] ? _raw_spin_unlock_irqrestore+0x65/0x80
[   93.632808]  [<ffffffff812c20f1>] ? free_msg+0x21/0x40
[   93.635318]  [<ffffffff812c20f1>] ? free_msg+0x21/0x40
[   93.637800]  [<ffffffff816bb670>] __slab_free+0x41/0x3a0
[   93.640304]  [<ffffffff810b6ced>] ? trace_hardirqs_on+0xd/0x10
[   93.642868]  [<ffffffff816c50c2>] ? _raw_spin_unlock_irqrestore+0x42/0x80
[   93.645524]  [<ffffffff81355425>] ? debug_check_no_obj_freed+0x155/0x250
[   93.648134]  [<ffffffff8119d11d>] ? kfree+0x9d/0x300
[   93.650521]  [<ffffffff812c20f1>] ? free_msg+0x21/0x40
[   93.652924]  [<ffffffff8119d34a>] kfree+0x2ca/0x300
[   93.655294]  [<ffffffff8134a010>] ? delay_tsc+0x90/0xe0
[   93.657696]  [<ffffffff812c20f1>] free_msg+0x21/0x40
[   93.660059]  [<ffffffff812c289f>] freeque+0xcf/0x140
[   93.662400]  [<ffffffff812c2a93>] msgctl_down.constprop.9+0x183/0x200
[   93.664918]  [<ffffffff810767cf>] ? up_read+0x1f/0x40
[   93.667261]  [<ffffffff816c8f94>] ? __do_page_fault+0x214/0x5b0
[   93.669717]  [<ffffffff810b94be>] ? lock_release_non_nested+0x23e/0x320
[   93.672257]  [<ffffffff812c2da9>] sys_msgctl+0x139/0x400
[   93.674641]  [<ffffffff816c5d4d>] ? retint_swapgs+0xe/0x13
[   93.677056]  [<ffffffff810b6c55>] ? trace_hardirqs_on_caller+0x115/0x1a0
[   93.679626]  [<ffffffff8134b39e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   93.682159]  [<ffffffff816cd942>] system_call_fastpath+0x16/0x1b
[   93.799329] FIX kmalloc-64: Object at 0xffff88009997e620 not freed
