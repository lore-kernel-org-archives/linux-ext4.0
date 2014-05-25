From: Meelis Roos <mroos@linux.ee>
Subject: kernel BUG at fs/jbd2/journal.c:1951!
Date: Sun, 25 May 2014 22:50:53 +0300 (EEST)
Message-ID: <alpine.SOC.1.00.1405252240110.16480@math.ut.ee>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Linux Kernel list <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, sparclinux@vger.kernel.org
Return-path: <sparclinux-owner@vger.kernel.org>
Sender: sparclinux-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Tried yesterdays git v3.15-rc6-190-g1ee1cea on Sun Fire T2000 (32-thread 
sparc64) and got reproducibly stuck on boot with ext journal replay like 
below. Booting Debian 3.14.2-1 replayed the log and mounted FS fine. 
After that, my test kernel works fine too. SO I can not reproduce it any 
more but it seems like I hit a bug.

[   62.064329] EXT4-fs (sda1): INFO: recovery required on readonly filesystem
[   62.064395] EXT4-fs (sda1): write access will be enabled during recovery
[   62.077043] EXT4-fs (sda1): orphan cleanup on readonly fs
[   62.156585] EXT4-fs (sda1): 14 orphan inodes deleted
[   62.156645] EXT4-fs (sda1): recovery complete
[   62.156702] kernel BUG at fs/jbd2/journal.c:1951!
[   62.156752]               \|/ ____ \|/
[   62.156752]               "@'/ .. \`@"
[   62.156752]               /_| \__/ |_\
[   62.156752]                  \__U_/
[   62.156893] swapper/0(1): Kernel bad sw trap 5 [#1]
[   62.156943] CPU: 8 PID: 1 Comm: swapper/0 Not tainted 3.15.0-rc6+ #6
[   62.157004] task: ffffff8008677640 ti: ffffff800870c000 task.ti: ffffff800870c000
[   62.157079] TSTATE: 0000004480001605 TPC: 00000000005f3c00 TNPC: 00000000005f3c04 Y: 00000000    Not tainted
[   62.157180] TPC: <jbd2_journal_flush+0x11c/0x190>
[   62.157225] g0: 00000000009528c8 g1: 0000000000000000 g2: 0000000000a17f88 g3: 0000000000a17f80
[   62.157301] g4: ffffff8008677640 g5: ffffff83f6a4a000 g6: ffffff800870c000 g7: ffffff8008633fa0
[   62.157375] o0: 0000000000000025 o1: 0000000000961ed8 o2: 000000000000079f o3: ffffff83f3aab888
[   62.157451] o4: ffffff83ffb72000 o5: 0000000000961ed8 sp: ffffff800870ed11 ret_pc: 00000000005f3bf8
[   62.157530] RPC: <jbd2_journal_flush+0x114/0x190>
[   62.157575] l0: 0000000000000000 l1: 000000000000000e l2: 0000000010018001 l3: 000000000088e438
[   62.157650] l4: 00000000009528c8 l5: 000000000000ff00 l6: 0000000000ff0000 l7: 000000000095ee30
[   62.157726] i0: ffffff83f3aab800 i1: ffffff83f3aab824 i2: ffffff83f3aabb98 i3: ffffff83f3aab8e8
[   62.157801] i4: ffffff83f3aab824 i5: ffffff83f3aab8e8 i6: ffffff800870edc1 i7: 00000000005bd640
[   62.157887] I7: <ext4_mark_recovery_complete.isra.232+0x4c/0xb0>
[   62.157942] Call Trace:
[   62.157990]  [00000000005bd640] ext4_mark_recovery_complete.isra.232+0x4c/0xb0
[   62.158068]  [00000000005c3860] ext4_fill_super+0x303c/0x33e8
[   62.158132]  [0000000000538fc4] mount_bdev+0x124/0x18c
[   62.158192]  [0000000000539a4c] mount_fs+0x60/0x17c
[   62.158246]  [000000000055087c] vfs_kern_mount+0x48/0xe4
[   62.158309]  [0000000000552e24] do_mount+0x808/0x974
[   62.158370]  [00000000005531b0] SyS_mount+0x6c/0xa4
[   62.158427]  [0000000000a74cb8] mount_block_root+0x108/0x2ac
[   62.158490]  [0000000000a75180] prepare_namespace+0x180/0x1bc
[   62.158552]  [0000000000a74a80] kernel_init_freeable+0x208/0x218
[   62.158619]  [0000000000864724] kernel_init+0x4/0xf4
[   62.158684]  [0000000000406084] ret_from_fork+0x1c/0x2c
[   62.158738]  [0000000000000000]           (null)
[   62.158780] Disabling lock debugging due to kernel taint
[   62.158847] Caller[00000000005bd640]: ext4_mark_recovery_complete.isra.232+0x4c/0xb0
[   62.158926] Caller[00000000005c3860]: ext4_fill_super+0x303c/0x33e8
[   62.158990] Caller[0000000000538fc4]: mount_bdev+0x124/0x18c
[   62.159051] Caller[0000000000539a4c]: mount_fs+0x60/0x17c
[   62.159143] Caller[000000000055087c]: vfs_kern_mount+0x48/0xe4
[   62.159215] Caller[0000000000552e24]: do_mount+0x808/0x974
[   62.159279] Caller[00000000005531b0]: SyS_mount+0x6c/0xa4
[   62.159345] Caller[0000000000a74cb8]: mount_block_root+0x108/0x2ac
[   62.159411] Caller[0000000000a75180]: prepare_namespace+0x180/0x1bc
[   62.159475] Caller[0000000000a74a80]: kernel_init_freeable+0x208/0x218
[   62.159540] Caller[0000000000864724]: kernel_init+0x4/0xf4
[   62.159604] Caller[0000000000406084]: ret_from_fork+0x1c/0x2c
[   62.159660] Caller[0000000000000000]:           (null)
[   62.166652] Instruction DUMP: 901222d8  7ff8d20a  01000000 <91d02005> 11002587  921027a1  0af07ffb  901222d8  c45e2310
[   62.207443] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009


-- 
Meelis Roos (mroos@linux.ee)
