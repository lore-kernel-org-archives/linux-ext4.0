From: kernel test robot <rong.a.chen@intel.com>
Subject: [LKP] acc9eb0a60 [ 76.294850] WARNING: possible circular locking
 dependency detected
Date: Wed, 19 Dec 2018 18:21:42 +0800
Message-ID: <20181219102142.GH23332@shao2-debian>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="3IyuMspwcGTbYISR"
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, LKP <lkp@01.org>
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--3IyuMspwcGTbYISR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Greetings,

0day kernel testing robot got the below dmesg and the first bad commit is

https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master

commit acc9eb0a607300be08639fd4449bf51225239c7d
Author:     Eric Biggers <ebiggers@google.com>
AuthorDate: Thu Nov 1 15:52:29 2018 -0700
Commit:     Theodore Ts'o <tytso@mit.edu>
CommitDate: Wed Nov 28 18:09:25 2018 -0500

    ext4: add fs-verity read support
    
    Make ext4_mpage_readpages() verify data as it is read from fs-verity
    files, using the helper functions from fs/verity/.
    
    To be compatible with fscrypt, like in the corresponding f2fs patch this
    required refactoring the decryption workflow into a generic "post-read
    processing" workflow, which can do decryption, verification, or both.
    
    Co-developed-by: Theodore Ts'o <tytso@mit.edu>
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>
    Signed-off-by: Eric Biggers <ebiggers@google.com>
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

bff49d3e9a  ext4: add basic fs-verity support
acc9eb0a60  ext4: add fs-verity read support
285053b5a4  Add linux-next specific files for 20181218
+-------------------------------------------------------+------------+------------+---------------+
|                                                       | bff49d3e9a | acc9eb0a60 | next-20181218 |
+-------------------------------------------------------+------------+------------+---------------+
| boot_successes                                        | 45         | 10         | 6             |
| boot_failures                                         | 1          | 11         | 11            |
| RIP:strncpy_from_user                                 | 1          |            |               |
| Mem-Info                                              | 1          | 1          |               |
| WARNING:possible_circular_locking_dependency_detected | 0          | 10         | 11            |
| invoked_oom-killer:gfp_mask=0x                        | 0          | 1          |               |
| WARNING:at_kernel/locking/lockdep.c:#lock_downgrade   | 0          | 2          | 2             |
| RIP:lock_downgrade                                    | 0          | 1          | 2             |
+-------------------------------------------------------+------------+------------+---------------+

[child1:862] vm86 (166:[32BIT]) returned ENOSYS, marking as inactive.
[child1:862] acct (51:[32BIT]) returned ENOSYS, marking as inactive.
[   72.903984] VFS: Warning: trinity-c2 using old stat() call. Recompile your binary.
[   76.274082] 
[   76.279556] ======================================================
[   76.294850] WARNING: possible circular locking dependency detected
[   76.310053] 4.20.0-rc4-00022-gacc9eb0 #1 Not tainted
[   76.319011] ------------------------------------------------------
[   76.328475] trinity-c1/894 is trying to acquire lock:
[   76.336320] (____ptrval____) (slab_mutex){+.+.}, at: slab_attr_store+0x59/0xcb
[   76.347769] 
[   76.347769] but task is already holding lock:
[   76.357140] (____ptrval____) (kn->count#39){++++}, at: kernfs_fop_write+0xc2/0x148
[   76.368828] 
[   76.368828] which lock already depends on the new lock.
[   76.368828] 
[   76.381855] 
[   76.381855] the existing dependency chain (in reverse order) is:
[   76.393371] 
[   76.393371] -> #1 (kn->count#39){++++}:
[   76.402088]        kernfs_remove_by_name_ns+0x54/0x6d
[   76.409899]        sysfs_slab_add+0xde/0x239
[   76.416774]        __kmem_cache_create+0xd9/0xfc
[   76.424126]        create_cache+0x132/0x170
[   76.430840]        kmem_cache_create_usercopy+0x19c/0x1e7
[   76.439230]        kmem_cache_create+0xd/0xf
[   76.446230]        f2fs_init_post_read_processing+0x1b/0x69
[   76.454683]        init_f2fs_fs+0xa4/0xf9
[   76.461192]        do_one_initcall+0xc2/0x223
[   76.468272]        kernel_init_freeable+0x1d6/0x260
[   76.475985]        kernel_init+0x5/0xeb
[   76.482272]        ret_from_fork+0x24/0x30
[   76.488975] 
[   76.488975] -> #0 (slab_mutex){+.+.}:
[   76.497533]        __mutex_lock+0x7e/0x37a
[   76.504174]        slab_attr_store+0x59/0xcb
[   76.511138]        kernfs_fop_write+0xff/0x148
[   76.518415]        __vfs_write+0x1c/0xa2
[   76.524769]        vfs_write+0xad/0xd6
[   76.630277]        ksys_write+0x4b/0x79
[   76.636749]        do_syscall_64+0x54/0x62
[   76.643389]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
[   76.652053] 
[   76.652053] other info that might help us debug this:
[   76.652053] 
[   76.664818]  Possible unsafe locking scenario:
[   76.664818] 
[   76.674442]        CPU0                    CPU1
[   76.681673]        ----                    ----
[   76.688839]   lock(kn->count#39);
[   76.716415]                                lock(slab_mutex);
[   76.725218]                                lock(kn->count#39);
[   76.734094]   lock(slab_mutex);
[   76.739445] 
[   76.739445]  *** DEADLOCK ***
[   76.739445] 
[   76.749627] 4 locks held by trinity-c1/894:
[   76.756341]  #0: (____ptrval____) (&f->f_pos_lock){+.+.}, at: __fdget_pos+0x31/0x37
[   76.768140]  #1: (____ptrval____) (sb_writers#5){.+.+}, at: vfs_write+0x8f/0xd6
[   76.779479]  #2: (____ptrval____) (&of->mutex){+.+.}, at: kernfs_fop_write+0xb9/0x148
[   76.791501]  #3: (____ptrval____) (kn->count#39){++++}, at: kernfs_fop_write+0xc2/0x148
[   76.804124] 
[   76.804124] stack backtrace:
[   76.811660] CPU: 1 PID: 894 Comm: trinity-c1 Not tainted 4.20.0-rc4-00022-gacc9eb0 #1
[   76.823761] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
[   76.836396] Call Trace:
[   76.840872]  dump_stack+0x5e/0x84
[   76.846647]  print_circular_bug+0x1c7/0x1d4
[   76.854295]  __lock_acquire+0xc5a/0xf41
[   76.860710]  ? check_chain_key+0x78/0xc1
[   76.867359]  ? lock_acquire+0x11c/0x17b
[   76.873707]  lock_acquire+0x11c/0x17b
[   76.879739]  ? slab_attr_store+0x59/0xcb
[   76.886234]  __mutex_lock+0x7e/0x37a
[   76.892199]  ? slab_attr_store+0x59/0xcb
[   76.898660]  ? __mutex_lock+0x86/0x37a
[   76.904873]  ? slab_attr_store+0x59/0xcb
[   76.911409]  ? __lock_is_held+0x40/0x71
[   76.917711]  ? slab_attr_store+0x59/0xcb
[   76.924089]  slab_attr_store+0x59/0xcb
[   76.930468]  kernfs_fop_write+0xff/0x148
[   76.936993]  __vfs_write+0x1c/0xa2
[   76.942752]  ? rcu_read_lock_sched_held+0x58/0x5e
[   76.950243]  ? rcu_sync_lockdep_assert+0x23/0x49
[   76.957573]  ? __sb_start_write+0x128/0x157
[   76.964382]  ? vfs_write+0x8f/0xd6
[   76.970195]  vfs_write+0xad/0xd6
[   76.975703]  ksys_write+0x4b/0x79
[   76.981433]  do_syscall_64+0x54/0x62
[   76.987428]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[   76.995386] RIP: 0033:0x457389
[   77.000891] Code: 00 f3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 2b 84 00 00 c3 66 2e 0f 1f 84 00 00 00 00
[   77.027760] RSP: 002b:00007ffff4980f98 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[   77.039498] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 0000000000457389
[   77.050042] RDX: 0000000000000afd RSI: 0000000002c0cfb0 RDI: 0000000000000055
[   77.060535] RBP: 00007ffff4981040 R08: fffffffffffffff7 R09: 000000000000003d
[   77.071050] R10: 00000000000000b4 R11: 0000000000000246 R12: 0000000000000002
[   77.081588] R13: 00007fa257ca8058 R14: 00000000028c7830 R15: 00007fa257ca8000
[child1:894] kcmp (349:[32BIT]) returned ENOSYS, marking as inactive.
BusyBox v1.19.4 (2012-04-22 08:49:11 PDT) multi-call binary.

                                                          # HH:MM RESULT GOOD BAD GOOD_BUT_DIRTY DIRTY_NOT_BAD
git bisect start 285053b5a4c0204840fb92cfaba06352718e2eed 7566ec393f4161572ba6f11ad5171fd5d59b0fbd --
git bisect  bad 88bbac9a05685ee52454b7805c8f0d44383b5c91  # 01:42  B      0     2   17   0  Merge remote-tracking branch 'ieee1394/for-next'
git bisect good 2c49a9ccbf72d7d10c31e2b834df0807b8243413  # 02:02  G     17     0    7   7  Merge remote-tracking branch 'samsung-krzk/for-next'
git bisect  bad 9848e584efb4265ec368b27727bf935fe2f394eb  # 02:12  B      0     1   16   0  Merge remote-tracking branch 'ext4/dev'
git bisect good c13559eda3e569671267ce120f80879d66d7f58c  # 02:34  G     16     0    3   3  Merge remote-tracking branch 'parisc-hd/for-next'
git bisect  bad 70c4cd6a639a51bd1c7974db16fcc20589896630  # 02:47  B      0     2   17   0  Merge remote-tracking branch 'fscrypt/master'
git bisect good e2c8659b744c86f723497b6fcad33a014b2044b8  # 03:17  G     17     0    3   3  Merge remote-tracking branch 's390/features'
git bisect good 5c31d40d1968118bc17f572487b7274ff51cef8c  # 03:36  G     16     0    5   5  Merge remote-tracking branch 'sparc-next/master'
git bisect good 8f916e7c561872d65ff93932b011c57ad686c4ed  # 03:56  G     17     0    1   1  Merge remote-tracking branch 'xtensa/xtensa-for-next'
git bisect good 0c9ff58d6b2c795225531c6d5e12fd3e4eaffa03  # 04:19  G     17     0    2   2  fs-verity: support builtin file signatures
git bisect  bad f3fd6cd74fedf99b6060f75df00943fda13b65f2  # 04:40  B      1     8    0   0  fscrypt: remove filesystem specific build config option
git bisect  bad 50ee9e5d8e3ef15fc4bed781df9a6b2f708230ff  # 05:06  B      0     6   21   0  f2fs: fs-verity support
git bisect  bad acc9eb0a607300be08639fd4449bf51225239c7d  # 05:39  B      7    10    1   1  ext4: add fs-verity read support
git bisect good bff49d3e9affae6f9e38a9103a4166ade2c310dd  # 06:09  G     16     0    0   0  ext4: add basic fs-verity support
# first bad commit: [acc9eb0a607300be08639fd4449bf51225239c7d] ext4: add fs-verity read support
git bisect good bff49d3e9affae6f9e38a9103a4166ade2c310dd  # 06:12  G     50     0    7   7  ext4: add basic fs-verity support
# extra tests with debug options
git bisect  bad acc9eb0a607300be08639fd4449bf51225239c7d  # 06:37  B      0     6   21   0  ext4: add fs-verity read support
# extra tests on HEAD of linux-next/master
git bisect  bad 285053b5a4c0204840fb92cfaba06352718e2eed  # 06:38  B      1    11    0   0  Add linux-next specific files for 20181218
# extra tests on tree/branch linux-next/master
git bisect  bad 285053b5a4c0204840fb92cfaba06352718e2eed  # 06:38  B      1    11    0   0  Add linux-next specific files for 20181218

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/lkp                          Intel Corporation

--3IyuMspwcGTbYISR
Content-Type: application/gzip
Content-Disposition: attachment; filename="dmesg-yocto-vm-yocto-236:20181219053930:x86_64-randconfig-u0-12181957:4.20.0-rc4-00022-gacc9eb0:1.gz"
Content-Transfer-Encoding: base64

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
LkbP1LfP39Pj1v8D7+23JfEFAQA=

--3IyuMspwcGTbYISR
Content-Type: application/gzip
Content-Disposition: attachment; filename="dmesg-yocto-vm-yocto-114:20181219060955:x86_64-randconfig-u0-12181957:4.20.0-rc4-00021-gbff49d3:2.gz"
Content-Transfer-Encoding: base64

H4sICPx2GVwAA2RtZXNnLXlvY3RvLXZtLXlvY3RvLTExNDoyMDE4MTIxOTA2MDk1NTp4ODZf
NjQtcmFuZGNvbmZpZy11MC0xMjE4MTk1Nzo0LjIwLjAtcmM0LTAwMDIxLWdiZmY0OWQzOjIA
7Fxbc9u4kn4++RXYOg9j77FkAARJUFs6dWxZTlS2Y43lZLKTSqkoEpQ5pkgNL46dX7/dICVS
t8ie87K7JVVlJBLoDw2g0Te0R7lp9EK8JM6SSJEwJpnKizm88NU7td6mnvPU9fLxo0pjFb0L
43mRj303dzuEPtPFx5ATm3uyao5UvNJKHeHZjv8uKXJoXmli5VfVtEHJAstyXPmuHH2cJ7kb
jbPwh1odnXMLQYDT2TyJwliNDT4JV0cCLnzs9O5CeclsnqosC+MpuQ7j4rndbpOhm+oX/etL
fPSTWLXfnSdJji/zB0VKHtrvvhL40HaJ+a0EIE8KqJOYiDaHplbqiRa0ctaaToJAOL5Bjh4n
RRj5/4oe561YPVPrmBxNPW9JabZFmxFOmc1gVcjRhZqELr42Ac84PiZ/52R0MyS/KZ/AFAhz
CLU6lHeYTXqje6SU67z1ktnMjX2CS9IhKUyme+qrp1NYJ0oeing6zt3scTx349DrMuKrSTEl
7hweyp/ZS5b+OXaj7+5LNlaxO4lg8NQr5iAAqg0/xt68GGewKbA34UzBLnZhR0ms8nYYxO5M
ZV1K5mkY549tGPhxlk27MNdywBYjWRLkUeI9FvMlE/EsHH93c+/BT6Zd/ZIkyTyrfkaJ64+B
fT/MHrscoGEr8+ULSvx04rdnYZykYy8p4rwrcRK5mvntKJmCfD2pqKvSlIRT6KPG8FK/W4h8
N89fKNGnoGQbX4zoCWMmh4k1etUvn6ZuF8BmbkTS77jWj91TT80fguy03PPTtIhbfxaqUKcv
iZcnradZS/84fZbW2BKtFDYJoINw2ipoi3EmmWPapxGKFgpL3pm5MIm0UwmTctwgcJUVOMqQ
rsOo4QpmWa6vuGcw6vudSZgpL2+VCAY/bT/N8PeP1msRWihPwIlDLepQu2XQzirvLcYEmQDn
3kO3ZvS0ZJSc397ejwc3Z+/73dP547Scyp7pwmlomaevZfB0MaPdR26LMKDwqjRoZw9F7iff
4y5dPzPA42kwLzpkVMznSaqP/5fR2ec+CZSbF6nSSoV1yC/P0iYBCKTuMk9AWkiqpiHOP/vl
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
WMrjPgIA

--3IyuMspwcGTbYISR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="reproduce-yocto-vm-yocto-236:20181219053930:x86_64-randconfig-u0-12181957:4.20.0-rc4-00022-gacc9eb0:1"

#!/bin/bash

kernel=$1
initrd=yocto-trinity-x86_64.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/yocto/$initrd

kvm=(
	qemu-system-x86_64
	-enable-kvm
	-cpu Haswell,+smep,+smap
	-kernel $kernel
	-initrd $initrd
	-m 512
	-smp 2
	-device e1000,netdev=net0
	-netdev user,id=net0
	-boot order=nc
	-no-reboot
	-watchdog i6300esb
	-watchdog-action debug
	-rtc base=localtime
	-serial stdio
	-display none
	-monitor null
)

append=(
	root=/dev/ram0
	hung_task_panic=1
	debug
	apic=debug
	sysrq_always_enabled
	rcupdate.rcu_cpu_stall_timeout=100
	net.ifnames=0
	printk.devkmsg=on
	panic=-1
	softlockup_panic=1
	nmi_watchdog=panic
	oops=panic
	load_ramdisk=2
	prompt_ramdisk=0
	drbd.minor_count=8
	systemd.log_level=err
	ignore_loglevel
	console=tty0
	earlyprintk=ttyS0,115200
	console=ttyS0,115200
	vga=normal
	rw
	drbd.minor_count=8
	rcuperf.shutdown=0
)

"${kvm[@]}" -append "${append[*]}"

--3IyuMspwcGTbYISR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-4.20.0-rc4-00022-gacc9eb0"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 4.20.0-rc4 Kernel Configuration
#

#
# Compiler: gcc-5 (Debian 5.5.0-3) 5.4.1 20171010
#
CONFIG_CC_IS_GCC=y
CONFIG_GCC_VERSION=50401
CONFIG_CLANG_VERSION=0
CONFIG_CONSTRUCTORS=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y
CONFIG_THREAD_INFO_IN_TASK=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
# CONFIG_COMPILE_TEST is not set
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_BUILD_SALT=""
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_KERNEL_LZ4=y
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_USELIB=y
# CONFIG_AUDIT is not set
CONFIG_HAVE_ARCH_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_MIGRATION=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_HIERARCHY=y
CONFIG_GENERIC_IRQ_MATRIX_ALLOCATOR=y
CONFIG_GENERIC_IRQ_RESERVATION_MODE=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_GENERIC_IRQ_DEBUGFS=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_ARCH_CLOCKSOURCE_INIT=y
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
# CONFIG_NO_HZ_FULL is not set
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
# CONFIG_PSI is not set
# CONFIG_CPU_ISOLATION is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
CONFIG_RCU_EXPERT=y
CONFIG_SRCU=y
CONFIG_TREE_SRCU=y
CONFIG_TASKS_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_NEED_SEGCBLIST=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=20
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_PRINTK_SAFE_LOG_BUF_SHIFT=13
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_CGROUPS=y
CONFIG_PAGE_COUNTER=y
CONFIG_MEMCG=y
# CONFIG_MEMCG_SWAP is not set
CONFIG_MEMCG_KMEM=y
# CONFIG_BLK_CGROUP is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_CGROUP_PIDS=y
CONFIG_CGROUP_RDMA=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_CGROUP_PERF=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_SOCK_CGROUP_DATA=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
# CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BPF=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
CONFIG_MULTIUSER=y
CONFIG_SGETMASK_SYSCALL=y
CONFIG_SYSFS_SYSCALL=y
CONFIG_FHANDLE=y
CONFIG_POSIX_TIMERS=y
CONFIG_PRINTK=y
CONFIG_PRINTK_NMI=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_FUTEX_PI=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_ADVISE_SYSCALLS=y
CONFIG_MEMBARRIER=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_ABSOLUTE_PERCPU=y
CONFIG_KALLSYMS_BASE_RELATIVE=y
# CONFIG_BPF_SYSCALL is not set
# CONFIG_USERFAULTFD is not set
CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE=y
CONFIG_RSEQ=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLAB_MERGE_DEFAULT is not set
# CONFIG_SLAB_FREELIST_RANDOM is not set
# CONFIG_SLAB_FREELIST_HARDENED is not set
CONFIG_SLUB_CPU_PARTIAL=y
CONFIG_SYSTEM_DATA_VERIFICATION=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_MMU=y
CONFIG_ARCH_MMAP_RND_BITS_MIN=28
CONFIG_ARCH_MMAP_RND_BITS_MAX=32
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN=8
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MAX=16
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_FILTER_PGPROT=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_64_SMP=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_PGTABLE_LEVELS=4
CONFIG_CC_HAS_SANE_STACKPROTECTOR=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_FEATURE_NAMES=y
# CONFIG_X86_X2APIC is not set
# CONFIG_X86_MPPARSE is not set
CONFIG_GOLDFISH=y
# CONFIG_RETPOLINE is not set
CONFIG_INTEL_RDT=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_VSMP is not set
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_X86_AMD_PLATFORM_DEVICE is not set
# CONFIG_IOSF_MBI is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
# CONFIG_XEN is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_JAILHOUSE_GUEST is not set
# CONFIG_MK8 is not set
CONFIG_MPSC=y
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=7
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_P6_NOP=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_HYGON=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_GART_IOMMU is not set
# CONFIG_CALGARY_IOMMU is not set
CONFIG_MAXSMP=y
CONFIG_NR_CPUS_RANGE_BEGIN=8192
CONFIG_NR_CPUS_RANGE_END=8192
CONFIG_NR_CPUS_DEFAULT=8192
CONFIG_NR_CPUS=8192
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_SCHED_MC_PRIO is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
# CONFIG_X86_MCELOG_LEGACY is not set
# CONFIG_X86_MCE_INTEL is not set
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set

#
# Performance monitoring
#
CONFIG_PERF_EVENTS_INTEL_UNCORE=y
CONFIG_PERF_EVENTS_INTEL_RAPL=y
CONFIG_PERF_EVENTS_INTEL_CSTATE=y
CONFIG_PERF_EVENTS_AMD_POWER=y
CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
CONFIG_X86_VSYSCALL_EMULATION=y
CONFIG_I8K=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
# CONFIG_X86_5LEVEL is not set
# CONFIG_X86_CPA_STATISTICS is not set
CONFIG_ARCH_HAS_MEM_ENCRYPT=y
# CONFIG_AMD_MEM_ENCRYPT is not set
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
# CONFIG_X86_PMEM_LEGACY is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
CONFIG_X86_INTEL_UMIP=y
CONFIG_X86_INTEL_MPX=y
# CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS is not set
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
CONFIG_KEXEC_FILE=y
CONFIG_ARCH_HAS_KEXEC_PURGATORY=y
CONFIG_KEXEC_VERIFY_SIG=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_COMPAT_VDSO is not set
CONFIG_LEGACY_VSYSCALL_EMULATE=y
# CONFIG_LEGACY_VSYSCALL_NONE is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_MODIFY_LDT_SYSCALL=y
CONFIG_HAVE_LIVEPATCH=y
CONFIG_ARCH_HAS_ADD_PAGES=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_ARCH_ENABLE_THP_MIGRATION=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
# CONFIG_HIBERNATION is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
CONFIG_PM_CLK=y
CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
CONFIG_ARCH_SUPPORTS_ACPI=y
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=y
# CONFIG_ACPI_DEBUGGER is not set
CONFIG_ACPI_SPCR_TABLE=y
CONFIG_ACPI_LPIT=y
# CONFIG_ACPI_PROCFS_POWER is not set
CONFIG_ACPI_REV_OVERRIDE_POSSIBLE=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_CPU_FREQ_PSS=y
CONFIG_ACPI_PROCESSOR_CSTATE=y
CONFIG_ACPI_PROCESSOR_IDLE=y
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ARCH_HAS_ACPI_TABLE_UPGRADE=y
CONFIG_ACPI_TABLE_UPGRADE=y
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
CONFIG_ACPI_HOTPLUG_IOAPIC=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_NFIT is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
# CONFIG_ACPI_APEI is not set
# CONFIG_DPTF_POWER is not set
# CONFIG_PMIC_OPREGION is not set
# CONFIG_ACPI_CONFIGFS is not set
CONFIG_X86_PM_TIMER=y
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_ATTR_SET=y
CONFIG_CPU_FREQ_GOV_COMMON=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
CONFIG_CPU_FREQ_GOV_SCHEDUTIL=y

#
# CPU frequency scaling drivers
#
# CONFIG_CPUFREQ_DT is not set
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_P4_CLOCKMOD=y

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
# CONFIG_CPU_IDLE_GOV_MENU is not set
# CONFIG_INTEL_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_MMCONF_FAM10H=y
# CONFIG_PCIEPORTBUS is not set
# CONFIG_PCI_MSI is not set
CONFIG_PCI_QUIRKS=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_STUB is not set
CONFIG_PCI_LOCKLESS_CONFIG=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_P2PDMA is not set
CONFIG_PCI_LABEL=y
# CONFIG_HOTPLUG_PCI is not set

#
# PCI controller drivers
#

#
# Cadence PCIe controllers support
#
# CONFIG_PCIE_CADENCE_HOST is not set
# CONFIG_PCIE_CADENCE_EP is not set
# CONFIG_PCI_FTPCI100 is not set
# CONFIG_PCI_HOST_GENERIC is not set
# CONFIG_PCIE_XILINX is not set

#
# DesignWare PCI Core Support
#

#
# PCI Endpoint
#
CONFIG_PCI_ENDPOINT=y
CONFIG_PCI_ENDPOINT_CONFIGFS=y
CONFIG_PCI_EPF_TEST=m

#
# PCI switch controller drivers
#
# CONFIG_PCI_SW_SWITCHTEC is not set
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
# CONFIG_RAPIDIO is not set
# CONFIG_X86_SYSFB is not set

#
# Binary Emulations
#
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
CONFIG_X86_X32=y
CONFIG_COMPAT_32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_HAVE_GENERIC_GUP=y

#
# Firmware Drivers
#
CONFIG_EDD=m
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_FW_CFG_SYSFS is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# Tegra firmware driver
#
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set

#
# General architecture-dependent options
#
CONFIG_CRASH_CORE=y
CONFIG_KEXEC_CORE=y
CONFIG_HOTPLUG_SMT=y
CONFIG_OPROFILE=y
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
CONFIG_STATIC_KEYS_SELFTEST=y
CONFIG_OPTPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_FUNCTION_ERROR_INJECTION=y
CONFIG_HAVE_NMI=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_ARCH_HAS_FORTIFY_SOURCE=y
CONFIG_ARCH_HAS_SET_MEMORY=y
CONFIG_HAVE_ARCH_THREAD_STRUCT_WHITELIST=y
CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_RSEQ=y
CONFIG_HAVE_FUNCTION_ARG_ACCESS_API=y
CONFIG_HAVE_CLK=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_HAVE_ARCH_JUMP_LABEL_RELATIVE=y
CONFIG_HAVE_RCU_TABLE_FREE=y
CONFIG_HAVE_RCU_TABLE_INVALIDATE=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_ARCH_STACKLEAK=y
CONFIG_HAVE_STACKPROTECTOR=y
CONFIG_CC_HAS_STACKPROTECTOR_NONE=y
# CONFIG_STACKPROTECTOR is not set
CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD=y
CONFIG_HAVE_ARCH_HUGE_VMAP=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_HAVE_MOD_ARCH_SPECIFIC=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
CONFIG_HAVE_ARCH_MMAP_RND_BITS=y
CONFIG_HAVE_EXIT_THREAD=y
CONFIG_ARCH_MMAP_RND_BITS=28
CONFIG_HAVE_ARCH_MMAP_RND_COMPAT_BITS=y
CONFIG_ARCH_MMAP_RND_COMPAT_BITS=8
CONFIG_HAVE_ARCH_COMPAT_MMAP_BASES=y
CONFIG_HAVE_COPY_THREAD_TLS=y
CONFIG_HAVE_STACK_VALIDATION=y
CONFIG_HAVE_RELIABLE_STACKTRACE=y
CONFIG_ISA_BUS_API=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y
CONFIG_COMPAT_32BIT_TIME=y
CONFIG_HAVE_ARCH_VMAP_STACK=y
# CONFIG_VMAP_STACK is not set
CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
CONFIG_STRICT_KERNEL_RWX=y
CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
CONFIG_STRICT_MODULE_RWX=y
CONFIG_ARCH_HAS_REFCOUNT=y
CONFIG_REFCOUNT_FULL=y
CONFIG_HAVE_ARCH_PREL32_RELOCATIONS=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
# CONFIG_GCOV_PROFILE_ALL is not set
CONFIG_GCOV_FORMAT_4_7=y
CONFIG_PLUGIN_HOSTCC="g++"
CONFIG_HAVE_GCC_PLUGINS=y
# CONFIG_GCC_PLUGINS is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
# CONFIG_MODULE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
# CONFIG_MODULE_SIG is not set
# CONFIG_MODULE_COMPRESS is not set
CONFIG_MODULES_TREE_LOOKUP=y
CONFIG_BLOCK=y
CONFIG_BLK_SCSI_REQUEST=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
# CONFIG_BLK_DEV_ZONED is not set
CONFIG_BLK_CMDLINE_PARSER=y
# CONFIG_BLK_WBT is not set
# CONFIG_BLK_DEBUG_FS is not set
# CONFIG_BLK_SED_OPAL is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
CONFIG_ACORN_PARTITION_CUMANA=y
# CONFIG_ACORN_PARTITION_EESOX is not set
# CONFIG_ACORN_PARTITION_ICS is not set
CONFIG_ACORN_PARTITION_ADFS=y
CONFIG_ACORN_PARTITION_POWERTEC=y
# CONFIG_ACORN_PARTITION_RISCIX is not set
CONFIG_AIX_PARTITION=y
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
CONFIG_ATARI_PARTITION=y
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
# CONFIG_UNIXWARE_DISKLABEL is not set
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
CONFIG_SYSV68_PARTITION=y
CONFIG_CMDLINE_PARTITION=y
CONFIG_BLOCK_COMPAT=y
CONFIG_BLK_MQ_PCI=y
CONFIG_BLK_MQ_VIRTIO=y
CONFIG_BLK_PM=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_MQ_IOSCHED_DEADLINE=y
CONFIG_MQ_IOSCHED_KYBER=m
# CONFIG_IOSCHED_BFQ is not set
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_RWSEM_SPIN_ON_OWNER=y
CONFIG_LOCK_SPIN_ON_OWNER=y
CONFIG_ARCH_USE_QUEUED_SPINLOCKS=y
CONFIG_QUEUED_SPINLOCKS=y
CONFIG_ARCH_USE_QUEUED_RWLOCKS=y
CONFIG_QUEUED_RWLOCKS=y
CONFIG_ARCH_HAS_SYNC_CORE_BEFORE_USERMODE=y
CONFIG_ARCH_HAS_SYSCALL_WRAPPER=y
CONFIG_FREEZER=y

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ELFCORE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_BINFMT_MISC is not set
CONFIG_COREDUMP=y

#
# Memory Management options
#
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
# CONFIG_BOUNCE is not set
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_ARCH_WANTS_THP_SWAP=y
CONFIG_THP_SWAP=y
CONFIG_TRANSPARENT_HUGE_PAGECACHE=y
CONFIG_CLEANCACHE=y
CONFIG_FRONTSWAP=y
# CONFIG_CMA is not set
# CONFIG_ZSWAP is not set
# CONFIG_ZPOOL is not set
# CONFIG_ZBUD is not set
CONFIG_ZSMALLOC=m
CONFIG_PGTABLE_MAPPING=y
# CONFIG_ZSMALLOC_STAT is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
# CONFIG_IDLE_PAGE_TRACKING is not set
CONFIG_ARCH_HAS_ZONE_DEVICE=y
CONFIG_ZONE_DEVICE=y
CONFIG_ARCH_HAS_HMM=y
CONFIG_MIGRATE_VMA_HELPER=y
CONFIG_HMM=y
CONFIG_HMM_MIRROR=y
# CONFIG_DEVICE_PRIVATE is not set
# CONFIG_DEVICE_PUBLIC is not set
CONFIG_ARCH_USES_HIGH_VMA_FLAGS=y
# CONFIG_PERCPU_STATS is not set
# CONFIG_GUP_BENCHMARK is not set
CONFIG_ARCH_HAS_PTE_SPECIAL=y
CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_TLS is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
# CONFIG_XFRM_USER is not set
# CONFIG_XFRM_INTERFACE is not set
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
# CONFIG_XFRM_STATISTICS is not set
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_NET_IP_TUNNEL=y
# CONFIG_SYN_COOKIES is not set
# CONFIG_NET_IPVTI is not set
# CONFIG_NET_FOU is not set
# CONFIG_NET_FOU_IP_TUNNELS is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_INET_UDP_DIAG is not set
# CONFIG_INET_RAW_DIAG is not set
# CONFIG_INET_DIAG_DESTROY is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
CONFIG_INET6_XFRM_MODE_BEET=y
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
# CONFIG_IPV6_VTI is not set
CONFIG_IPV6_SIT=y
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
# CONFIG_IPV6_SEG6_LWTUNNEL is not set
# CONFIG_IPV6_SEG6_HMAC is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_BPFILTER is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
CONFIG_ATM=m
# CONFIG_ATM_CLIP is not set
CONFIG_ATM_LANE=m
# CONFIG_ATM_MPOA is not set
# CONFIG_ATM_BR2684 is not set
# CONFIG_L2TP is not set
# CONFIG_BRIDGE is not set
CONFIG_HAVE_NET_DSA=y
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=m
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_ATALK=m
CONFIG_DEV_APPLETALK=m
CONFIG_IPDDP=m
CONFIG_IPDDP_ENCAP=y
CONFIG_X25=y
CONFIG_LAPB=m
CONFIG_PHONET=y
# CONFIG_6LOWPAN is not set
CONFIG_IEEE802154=m
CONFIG_IEEE802154_NL802154_EXPERIMENTAL=y
# CONFIG_IEEE802154_SOCKET is not set
CONFIG_MAC802154=m
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_VSOCKETS=y
# CONFIG_VSOCKETS_DIAG is not set
# CONFIG_VIRTIO_VSOCKETS is not set
CONFIG_NETLINK_DIAG=m
CONFIG_MPLS=y
CONFIG_NET_MPLS_GSO=y
# CONFIG_MPLS_ROUTING is not set
# CONFIG_NET_NSH is not set
CONFIG_HSR=y
# CONFIG_NET_SWITCHDEV is not set
# CONFIG_NET_L3_MASTER_DEV is not set
# CONFIG_NET_NCSI is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_CGROUP_NET_PRIO=y
# CONFIG_CGROUP_NET_CLASSID is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
# CONFIG_BPF_JIT is not set
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_DROP_MONITOR is not set
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=y
# CONFIG_AX25_DAMA_SLAVE is not set
# CONFIG_NETROM is not set
CONFIG_ROSE=y

#
# AX.25 network device drivers
#
CONFIG_MKISS=y
CONFIG_6PACK=m
# CONFIG_BPQETHER is not set
CONFIG_BAYCOM_SER_FDX=m
CONFIG_BAYCOM_SER_HDX=m
CONFIG_BAYCOM_PAR=m
# CONFIG_YAM is not set
CONFIG_CAN=m
# CONFIG_CAN_RAW is not set
# CONFIG_CAN_BCM is not set
CONFIG_CAN_GW=m

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
# CONFIG_CAN_VXCAN is not set
CONFIG_CAN_SLCAN=m
CONFIG_CAN_DEV=m
CONFIG_CAN_CALC_BITTIMING=y
# CONFIG_CAN_GRCAN is not set
CONFIG_CAN_C_CAN=m
# CONFIG_CAN_C_CAN_PLATFORM is not set
# CONFIG_CAN_C_CAN_PCI is not set
# CONFIG_CAN_CC770 is not set
CONFIG_CAN_IFI_CANFD=m
CONFIG_CAN_M_CAN=m
# CONFIG_CAN_PEAK_PCIEFD is not set
CONFIG_CAN_SJA1000=m
CONFIG_CAN_SJA1000_ISA=m
CONFIG_CAN_SJA1000_PLATFORM=m
# CONFIG_CAN_EMS_PCI is not set
# CONFIG_CAN_PEAK_PCI is not set
# CONFIG_CAN_KVASER_PCI is not set
# CONFIG_CAN_PLX_PCI is not set
# CONFIG_CAN_SOFTING is not set

#
# CAN SPI interfaces
#
CONFIG_CAN_HI311X=m
CONFIG_CAN_MCP251X=m

#
# CAN USB interfaces
#
CONFIG_CAN_8DEV_USB=m
CONFIG_CAN_EMS_USB=m
# CONFIG_CAN_ESD_USB2 is not set
CONFIG_CAN_GS_USB=m
CONFIG_CAN_KVASER_USB=m
# CONFIG_CAN_MCBA_USB is not set
# CONFIG_CAN_PEAK_USB is not set
CONFIG_CAN_UCAN=m
# CONFIG_CAN_DEBUG_DEVICES is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
# CONFIG_AF_KCM is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=m
CONFIG_NL80211_TESTMODE=y
CONFIG_CFG80211_DEVELOPER_WARNINGS=y
CONFIG_CFG80211_REQUIRE_SIGNED_REGDB=y
CONFIG_CFG80211_USE_KERNEL_REGDB_KEYS=y
CONFIG_CFG80211_DEFAULT_PS=y
CONFIG_CFG80211_DEBUGFS=y
CONFIG_CFG80211_CRDA_SUPPORT=y
# CONFIG_CFG80211_WEXT is not set
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
CONFIG_MAC80211_MESH=y
# CONFIG_MAC80211_LEDS is not set
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_MESSAGE_TRACING is not set
CONFIG_MAC80211_DEBUG_MENU=y
CONFIG_MAC80211_NOINLINE=y
# CONFIG_MAC80211_VERBOSE_DEBUG is not set
CONFIG_MAC80211_MLME_DEBUG=y
# CONFIG_MAC80211_STA_DEBUG is not set
# CONFIG_MAC80211_HT_DEBUG is not set
CONFIG_MAC80211_OCB_DEBUG=y
# CONFIG_MAC80211_IBSS_DEBUG is not set
CONFIG_MAC80211_PS_DEBUG=y
# CONFIG_MAC80211_MPL_DEBUG is not set
CONFIG_MAC80211_MPATH_DEBUG=y
# CONFIG_MAC80211_MHWMP_DEBUG is not set
CONFIG_MAC80211_MESH_SYNC_DEBUG=y
# CONFIG_MAC80211_MESH_CSA_DEBUG is not set
CONFIG_MAC80211_MESH_PS_DEBUG=y
# CONFIG_MAC80211_TDLS_DEBUG is not set
CONFIG_MAC80211_STA_HASH_MAX_SIZE=0
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_INPUT=y
# CONFIG_RFKILL_GPIO is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=m
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set
CONFIG_NFC=m
CONFIG_NFC_DIGITAL=m
CONFIG_NFC_NCI=m
# CONFIG_NFC_NCI_SPI is not set
CONFIG_NFC_NCI_UART=m
CONFIG_NFC_HCI=m
CONFIG_NFC_SHDLC=y

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_TRF7970A=m
CONFIG_NFC_SIM=m
CONFIG_NFC_PORT100=m
# CONFIG_NFC_FDP is not set
CONFIG_NFC_PN544=m
CONFIG_NFC_PN544_I2C=m
CONFIG_NFC_PN533=m
CONFIG_NFC_PN533_USB=m
# CONFIG_NFC_PN533_I2C is not set
# CONFIG_NFC_MICROREAD_I2C is not set
# CONFIG_NFC_MRVL_USB is not set
# CONFIG_NFC_MRVL_UART is not set
CONFIG_NFC_ST21NFCA=m
CONFIG_NFC_ST21NFCA_I2C=m
CONFIG_NFC_ST_NCI=m
CONFIG_NFC_ST_NCI_I2C=m
CONFIG_NFC_ST_NCI_SPI=m
CONFIG_NFC_NXP_NCI=m
CONFIG_NFC_NXP_NCI_I2C=m
# CONFIG_NFC_S3FWRN5_I2C is not set
CONFIG_NFC_ST95HF=m
CONFIG_PSAMPLE=m
CONFIG_NET_IFE=m
# CONFIG_LWTUNNEL is not set
CONFIG_DST_CACHE=y
CONFIG_GRO_CELLS=y
CONFIG_NET_DEVLINK=y
CONFIG_MAY_USE_DEVLINK=y
# CONFIG_FAILOVER is not set
CONFIG_HAVE_EBPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER=y
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set

#
# Firmware loader
#
CONFIG_FW_LOADER=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_FW_LOADER_USER_HELPER_FALLBACK is not set
CONFIG_WANT_DEV_COREDUMP=y
CONFIG_ALLOW_DEV_COREDUMP=y
CONFIG_DEV_COREDUMP=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_DEBUG_TEST_DRIVER_REMOVE is not set
# CONFIG_TEST_ASYNC_DRIVER_PROBE is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_GENERIC_CPU_VULNERABILITIES=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_REGMAP_SCCB=m

#
# Bus devices
#
CONFIG_SIMPLE_PM_BUS=y
CONFIG_CONNECTOR=m
# CONFIG_GNSS is not set
CONFIG_MTD=y
CONFIG_MTD_TESTS=m
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
CONFIG_MTD_CMDLINE_PARTS=y
# CONFIG_MTD_OF_PARTS is not set
CONFIG_MTD_AR7_PARTS=m

#
# Partition parsers
#

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
# CONFIG_MTD_BLOCK is not set
CONFIG_MTD_BLOCK_RO=y
CONFIG_FTL=y
CONFIG_NFTL=m
CONFIG_NFTL_RW=y
# CONFIG_INFTL is not set
# CONFIG_RFD_FTL is not set
CONFIG_SSFDC=m
# CONFIG_SM_FTL is not set
CONFIG_MTD_OOPS=m
CONFIG_MTD_SWAP=m
# CONFIG_MTD_PARTITIONED_MASTER is not set

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=m
CONFIG_MTD_JEDECPROBE=m
CONFIG_MTD_GEN_PROBE=m
CONFIG_MTD_CFI_ADV_OPTIONS=y
# CONFIG_MTD_CFI_NOSWAP is not set
# CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
CONFIG_MTD_CFI_LE_BYTE_SWAP=y
# CONFIG_MTD_CFI_GEOMETRY is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
CONFIG_MTD_OTP=y
# CONFIG_MTD_CFI_INTELEXT is not set
CONFIG_MTD_CFI_AMDSTD=m
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_RAM=y
# CONFIG_MTD_ROM is not set
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
CONFIG_MTD_PHYSMAP=m
# CONFIG_MTD_PHYSMAP_COMPAT is not set
# CONFIG_MTD_PHYSMAP_OF is not set
# CONFIG_MTD_AMD76XROM is not set
CONFIG_MTD_ICHXROM=m
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
CONFIG_MTD_NETtel=m
CONFIG_MTD_L440GX=m
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=y

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_DATAFLASH=m
# CONFIG_MTD_DATAFLASH_WRITE_VERIFY is not set
# CONFIG_MTD_DATAFLASH_OTP is not set
CONFIG_MTD_MCHP23K256=m
CONFIG_MTD_SST25L=y
# CONFIG_MTD_SLRAM is not set
CONFIG_MTD_PHRAM=y
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_CORE=m
CONFIG_MTD_ONENAND=y
# CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
# CONFIG_MTD_ONENAND_GENERIC is not set
CONFIG_MTD_ONENAND_OTP=y
CONFIG_MTD_ONENAND_2X_PROGRAM=y
CONFIG_MTD_NAND_ECC=m
CONFIG_MTD_NAND_ECC_SMC=y
CONFIG_MTD_NAND=m
CONFIG_MTD_NAND_BCH=m
CONFIG_MTD_NAND_ECC_BCH=y
# CONFIG_MTD_NAND_DENALI_PCI is not set
# CONFIG_MTD_NAND_DENALI_DT is not set
CONFIG_MTD_NAND_GPIO=m
# CONFIG_MTD_NAND_RICOH is not set
CONFIG_MTD_NAND_DISKONCHIP=m
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE=y
# CONFIG_MTD_NAND_CAFE is not set
# CONFIG_MTD_NAND_NANDSIM is not set
CONFIG_MTD_NAND_PLATFORM=m
CONFIG_MTD_SPI_NAND=m

#
# LPDDR & LPDDR2 PCM memory drivers
#
CONFIG_MTD_LPDDR=m
CONFIG_MTD_QINFO_PROBE=m
# CONFIG_MTD_SPI_NOR is not set
# CONFIG_MTD_UBI is not set
CONFIG_DTC=y
CONFIG_OF=y
CONFIG_OF_UNITTEST=y
CONFIG_OF_FLATTREE=y
CONFIG_OF_EARLY_FLATTREE=y
CONFIG_OF_KOBJ=y
# CONFIG_OF_DYNAMIC is not set
CONFIG_OF_ADDRESS=y
CONFIG_OF_IRQ=y
CONFIG_OF_NET=y
CONFIG_OF_RESOLVE=y
# CONFIG_OF_OVERLAY is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
# CONFIG_PARPORT_SERIAL is not set
CONFIG_PARPORT_PC_FIFO=y
CONFIG_PARPORT_PC_SUPERIO=y
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
# CONFIG_BLK_DEV_FD is not set
# CONFIG_PARIDE is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_ZRAM is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_LOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SKD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# NVME Support
#
CONFIG_NVME_CORE=m
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_NVME_MULTIPATH is not set
CONFIG_NVME_FABRICS=m
CONFIG_NVME_FC=m
# CONFIG_NVME_TARGET is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
# CONFIG_AD525X_DPOT_SPI is not set
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=m
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=m
# CONFIG_SENSORS_BH1770 is not set
CONFIG_SENSORS_APDS990X=m
# CONFIG_HMC6352 is not set
CONFIG_DS1682=y
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_LATTICE_ECP3_CONFIG is not set
CONFIG_SRAM=y
# CONFIG_PCI_ENDPOINT_TEST is not set
CONFIG_MISC_RTSX=m
CONFIG_C2PORT=m
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_AT25=y
CONFIG_EEPROM_LEGACY=y
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=y
# CONFIG_EEPROM_93XX46 is not set
# CONFIG_EEPROM_IDT_89HPESX is not set
# CONFIG_EEPROM_EE1004 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=m
CONFIG_SENSORS_LIS3_I2C=m
CONFIG_ALTERA_STAPL=y
# CONFIG_INTEL_MEI is not set
# CONFIG_INTEL_MEI_ME is not set
# CONFIG_INTEL_MEI_TXE is not set
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC & related support
#

#
# Intel MIC Bus Driver
#
# CONFIG_INTEL_MIC_BUS is not set

#
# SCIF Bus Driver
#
# CONFIG_SCIF_BUS is not set

#
# VOP Bus Driver
#
# CONFIG_VOP_BUS is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#

#
# SCIF Driver
#

#
# Intel MIC Coprocessor State Management (COSM) Drivers
#

#
# VOP Driver
#
# CONFIG_GENWQE is not set
CONFIG_ECHO=y
# CONFIG_MISC_RTSX_PCI is not set
CONFIG_MISC_RTSX_USB=m
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_MQ_DEFAULT=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_ENCLOSURE is not set
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=m
# CONFIG_SCSI_SAS_LIBSAS is not set
CONFIG_SCSI_SRP_ATTRS=m
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=m
# CONFIG_SCSI_DH_HP_SW is not set
# CONFIG_SCSI_DH_EMC is not set
CONFIG_SCSI_DH_ALUA=y
CONFIG_SCSI_OSD_INITIATOR=m
# CONFIG_SCSI_OSD_ULD is not set
CONFIG_SCSI_OSD_DPRINT_SENSE=1
# CONFIG_SCSI_OSD_DEBUG is not set
CONFIG_ATA=y
# CONFIG_ATA_VERBOSE_ERROR is not set
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
# CONFIG_SATA_AHCI_PLATFORM is not set
CONFIG_AHCI_CEVA=m
CONFIG_AHCI_QORIQ=y
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_ATA_BMDMA is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=m
# CONFIG_MD_LINEAR is not set
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
# CONFIG_MD_MULTIPATH is not set
# CONFIG_MD_FAULTY is not set
CONFIG_BCACHE=m
# CONFIG_BCACHE_DEBUG is not set
CONFIG_BCACHE_CLOSURES_DEBUG=y
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=m
# CONFIG_DM_DEBUG is not set
CONFIG_DM_BUFIO=m
# CONFIG_DM_DEBUG_BLOCK_MANAGER_LOCKING is not set
CONFIG_DM_BIO_PRISON=m
CONFIG_DM_PERSISTENT_DATA=m
CONFIG_DM_UNSTRIPED=m
CONFIG_DM_CRYPT=m
# CONFIG_DM_SNAPSHOT is not set
CONFIG_DM_THIN_PROVISIONING=m
CONFIG_DM_CACHE=m
# CONFIG_DM_CACHE_SMQ is not set
CONFIG_DM_WRITECACHE=m
CONFIG_DM_ERA=m
CONFIG_DM_MIRROR=m
# CONFIG_DM_LOG_USERSPACE is not set
CONFIG_DM_RAID=m
# CONFIG_DM_ZERO is not set
# CONFIG_DM_MULTIPATH is not set
CONFIG_DM_DELAY=m
CONFIG_DM_UEVENT=y
CONFIG_DM_FLAKEY=m
CONFIG_DM_VERITY=m
# CONFIG_DM_VERITY_FEC is not set
CONFIG_DM_SWITCH=m
# CONFIG_DM_LOG_WRITES is not set
# CONFIG_DM_INTEGRITY is not set
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
# CONFIG_FIREWIRE_OHCI is not set
CONFIG_FIREWIRE_SBP2=m
# CONFIG_FIREWIRE_NET is not set
# CONFIG_FIREWIRE_NOSY is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
# CONFIG_DUMMY is not set
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
# CONFIG_VXLAN is not set
# CONFIG_MACSEC is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_TUN is not set
# CONFIG_TUN_VNET_CROSS_LE is not set
# CONFIG_VETH is not set
# CONFIG_VIRTIO_NET is not set
# CONFIG_NLMON is not set
# CONFIG_ARCNET is not set
CONFIG_ATM_DRIVERS=y
# CONFIG_ATM_DUMMY is not set
# CONFIG_ATM_TCP is not set
# CONFIG_ATM_LANAI is not set
# CONFIG_ATM_ENI is not set
# CONFIG_ATM_FIRESTREAM is not set
# CONFIG_ATM_ZATM is not set
# CONFIG_ATM_NICSTAR is not set
# CONFIG_ATM_IDT77252 is not set
# CONFIG_ATM_AMBASSADOR is not set
# CONFIG_ATM_HORIZON is not set
# CONFIG_ATM_IA is not set
# CONFIG_ATM_FORE200E is not set
# CONFIG_ATM_HE is not set
# CONFIG_ATM_SOLOS is not set

#
# CAIF transport drivers
#

#
# Distributed Switch Architecture drivers
#
CONFIG_ETHERNET=y
CONFIG_MDIO=m
CONFIG_NET_VENDOR_3COM=y
# CONFIG_VORTEX is not set
# CONFIG_TYPHOON is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_AGERE=y
# CONFIG_ET131X is not set
CONFIG_NET_VENDOR_ALACRITECH=y
# CONFIG_SLICOSS is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
# CONFIG_ALTERA_TSE is not set
CONFIG_NET_VENDOR_AMAZON=y
CONFIG_NET_VENDOR_AMD=y
# CONFIG_AMD8111_ETH is not set
# CONFIG_PCNET32 is not set
# CONFIG_AMD_XGBE is not set
CONFIG_NET_VENDOR_AQUANTIA=y
# CONFIG_AQTION is not set
CONFIG_NET_VENDOR_ARC=y
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_ALX is not set
CONFIG_NET_VENDOR_AURORA=y
# CONFIG_AURORA_NB8800 is not set
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
# CONFIG_BCMGENET is not set
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2X is not set
# CONFIG_SYSTEMPORT is not set
# CONFIG_BNXT is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
CONFIG_NET_VENDOR_CADENCE=y
# CONFIG_MACB is not set
CONFIG_NET_VENDOR_CAVIUM=y
# CONFIG_THUNDER_NIC_PF is not set
# CONFIG_THUNDER_NIC_VF is not set
# CONFIG_THUNDER_NIC_BGX is not set
# CONFIG_THUNDER_NIC_RGX is not set
CONFIG_CAVIUM_PTP=y
# CONFIG_LIQUIDIO is not set
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
CONFIG_NET_VENDOR_CORTINA=y
# CONFIG_GEMINI_ETHERNET is not set
# CONFIG_CX_ECAT is not set
# CONFIG_DNET is not set
CONFIG_NET_VENDOR_DEC=y
# CONFIG_NET_TULIP is not set
CONFIG_NET_VENDOR_DLINK=y
# CONFIG_DL2K is not set
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
# CONFIG_BE2NET is not set
CONFIG_NET_VENDOR_EZCHIP=y
# CONFIG_EZCHIP_NPS_MANAGEMENT_ENET is not set
CONFIG_NET_VENDOR_HP=y
# CONFIG_HP100 is not set
CONFIG_NET_VENDOR_HUAWEI=y
CONFIG_NET_VENDOR_I825XX=y
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
CONFIG_E1000=y
CONFIG_E1000E=m
CONFIG_E1000E_HWTS=y
CONFIG_IGB=m
CONFIG_IGB_HWMON=y
# CONFIG_IGBVF is not set
# CONFIG_IXGB is not set
CONFIG_IXGBE=m
CONFIG_IXGBE_HWMON=y
# CONFIG_IXGBE_DCB is not set
# CONFIG_I40E is not set
# CONFIG_IGC is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX5_CORE is not set
# CONFIG_MLXSW_CORE is not set
# CONFIG_MLXFW is not set
CONFIG_NET_VENDOR_MICREL=y
# CONFIG_KS8842 is not set
# CONFIG_KS8851 is not set
# CONFIG_KS8851_MLL is not set
# CONFIG_KSZ884X_PCI is not set
CONFIG_NET_VENDOR_MICROCHIP=y
# CONFIG_ENC28J60 is not set
# CONFIG_ENCX24J600 is not set
# CONFIG_LAN743X is not set
CONFIG_NET_VENDOR_MICROSEMI=y
CONFIG_NET_VENDOR_MYRI=y
# CONFIG_MYRI10GE is not set
# CONFIG_FEALNX is not set
CONFIG_NET_VENDOR_NATSEMI=y
# CONFIG_NATSEMI is not set
# CONFIG_NS83820 is not set
CONFIG_NET_VENDOR_NETERION=y
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
CONFIG_NET_VENDOR_NETRONOME=y
CONFIG_NET_VENDOR_NI=y
# CONFIG_NI_XGE_MANAGEMENT_ENET is not set
CONFIG_NET_VENDOR_8390=y
# CONFIG_NE2K_PCI is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
CONFIG_NET_VENDOR_OKI=y
# CONFIG_ETHOC is not set
CONFIG_NET_VENDOR_PACKET_ENGINES=y
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
# CONFIG_QLCNIC is not set
# CONFIG_QLGE is not set
# CONFIG_NETXEN_NIC is not set
# CONFIG_QED is not set
CONFIG_NET_VENDOR_QUALCOMM=y
# CONFIG_QCA7000_SPI is not set
# CONFIG_QCOM_EMAC is not set
# CONFIG_RMNET is not set
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_ATP is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
# CONFIG_R8169 is not set
CONFIG_NET_VENDOR_RENESAS=y
CONFIG_NET_VENDOR_ROCKER=y
CONFIG_NET_VENDOR_SAMSUNG=y
# CONFIG_SXGBE_ETH is not set
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_NET_VENDOR_SOLARFLARE=y
# CONFIG_SFC is not set
# CONFIG_SFC_FALCON is not set
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
CONFIG_NET_VENDOR_SIS=y
# CONFIG_SIS900 is not set
# CONFIG_SIS190 is not set
CONFIG_NET_VENDOR_SMSC=y
# CONFIG_EPIC100 is not set
# CONFIG_SMSC911X is not set
# CONFIG_SMSC9420 is not set
CONFIG_NET_VENDOR_SOCIONEXT=y
CONFIG_NET_VENDOR_STMICRO=y
# CONFIG_STMMAC_ETH is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NIU is not set
CONFIG_NET_VENDOR_SYNOPSYS=y
# CONFIG_DWC_XLGMAC is not set
CONFIG_NET_VENDOR_TEHUTI=y
# CONFIG_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
# CONFIG_TI_CPSW_ALE is not set
# CONFIG_TLAN is not set
CONFIG_NET_VENDOR_VIA=y
# CONFIG_VIA_RHINE is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_NET_VENDOR_WIZNET=y
# CONFIG_WIZNET_W5100 is not set
# CONFIG_WIZNET_W5300 is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_MDIO_DEVICE is not set
# CONFIG_PHYLIB is not set
# CONFIG_MICREL_KS8995MA is not set
# CONFIG_PLIP is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
CONFIG_USB_NET_DRIVERS=y
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_RTL8152 is not set
# CONFIG_USB_LAN78XX is not set
# CONFIG_USB_USBNET is not set
# CONFIG_USB_HSO is not set
# CONFIG_USB_IPHETH is not set
CONFIG_WLAN=y
CONFIG_WLAN_VENDOR_ADMTEK=y
# CONFIG_ADM8211 is not set
CONFIG_WLAN_VENDOR_ATH=y
# CONFIG_ATH_DEBUG is not set
# CONFIG_ATH5K is not set
# CONFIG_ATH5K_PCI is not set
# CONFIG_ATH9K is not set
# CONFIG_ATH9K_HTC is not set
# CONFIG_CARL9170 is not set
# CONFIG_ATH6KL is not set
# CONFIG_AR5523 is not set
# CONFIG_WIL6210 is not set
# CONFIG_ATH10K is not set
# CONFIG_WCN36XX is not set
CONFIG_WLAN_VENDOR_ATMEL=y
# CONFIG_ATMEL is not set
# CONFIG_AT76C50X_USB is not set
CONFIG_WLAN_VENDOR_BROADCOM=y
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_BRCMSMAC is not set
# CONFIG_BRCMFMAC is not set
CONFIG_WLAN_VENDOR_CISCO=y
# CONFIG_AIRO is not set
CONFIG_WLAN_VENDOR_INTEL=y
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
# CONFIG_IWLWIFI is not set
CONFIG_WLAN_VENDOR_INTERSIL=y
# CONFIG_HOSTAP is not set
# CONFIG_HERMES is not set
# CONFIG_P54_COMMON is not set
# CONFIG_PRISM54 is not set
CONFIG_WLAN_VENDOR_MARVELL=y
# CONFIG_LIBERTAS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_MWIFIEX is not set
# CONFIG_MWL8K is not set
CONFIG_WLAN_VENDOR_MEDIATEK=y
# CONFIG_MT7601U is not set
# CONFIG_MT76x0U is not set
# CONFIG_MT76x0E is not set
# CONFIG_MT76x2E is not set
# CONFIG_MT76x2U is not set
CONFIG_WLAN_VENDOR_RALINK=y
# CONFIG_RT2X00 is not set
CONFIG_WLAN_VENDOR_REALTEK=y
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
CONFIG_RTL_CARDS=m
# CONFIG_RTL8192CE is not set
# CONFIG_RTL8192SE is not set
# CONFIG_RTL8192DE is not set
# CONFIG_RTL8723AE is not set
# CONFIG_RTL8723BE is not set
# CONFIG_RTL8188EE is not set
# CONFIG_RTL8192EE is not set
# CONFIG_RTL8821AE is not set
# CONFIG_RTL8192CU is not set
# CONFIG_RTL8XXXU is not set
CONFIG_WLAN_VENDOR_RSI=y
# CONFIG_RSI_91X is not set
CONFIG_WLAN_VENDOR_ST=y
# CONFIG_CW1200 is not set
CONFIG_WLAN_VENDOR_TI=y
# CONFIG_WL1251 is not set
# CONFIG_WL12XX is not set
# CONFIG_WL18XX is not set
# CONFIG_WLCORE is not set
CONFIG_WLAN_VENDOR_ZYDAS=y
# CONFIG_USB_ZD1201 is not set
# CONFIG_ZD1211RW is not set
CONFIG_WLAN_VENDOR_QUANTENNA=y
# CONFIG_QTNFMAC_PEARL_PCIE is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set

#
# WiMAX Wireless Broadband devices
#
# CONFIG_WIMAX_I2400M_USB is not set
# CONFIG_WAN is not set
CONFIG_IEEE802154_DRIVERS=m
# CONFIG_IEEE802154_FAKELB is not set
# CONFIG_IEEE802154_AT86RF230 is not set
# CONFIG_IEEE802154_MRF24J40 is not set
# CONFIG_IEEE802154_CC2520 is not set
# CONFIG_IEEE802154_ATUSB is not set
# CONFIG_IEEE802154_ADF7242 is not set
# CONFIG_IEEE802154_CA8210 is not set
# CONFIG_IEEE802154_MCR20A is not set
# CONFIG_IEEE802154_HWSIM is not set
# CONFIG_VMXNET3 is not set
# CONFIG_FUJITSU_ES is not set
# CONFIG_NETDEVSIM is not set
# CONFIG_NET_FAILOVER is not set
# CONFIG_ISDN is not set
CONFIG_NVM=y
# CONFIG_NVM_PBLK is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_LEDS=m
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=m
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=m
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADC is not set
# CONFIG_KEYBOARD_ADP5520 is not set
# CONFIG_KEYBOARD_ADP5588 is not set
CONFIG_KEYBOARD_ADP5589=m
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT1070=m
CONFIG_KEYBOARD_QT2160=m
CONFIG_KEYBOARD_DLINK_DIR685=m
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
CONFIG_KEYBOARD_GPIO_POLLED=y
CONFIG_KEYBOARD_TCA6416=m
CONFIG_KEYBOARD_TCA8418=y
CONFIG_KEYBOARD_MATRIX=m
CONFIG_KEYBOARD_LM8323=y
# CONFIG_KEYBOARD_LM8333 is not set
CONFIG_KEYBOARD_MAX7359=m
CONFIG_KEYBOARD_MCS=y
CONFIG_KEYBOARD_MPR121=y
# CONFIG_KEYBOARD_NEWTON is not set
CONFIG_KEYBOARD_OPENCORES=y
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_GOLDFISH_EVENTS is not set
CONFIG_KEYBOARD_STOWAWAY=y
CONFIG_KEYBOARD_SUNKBD=m
# CONFIG_KEYBOARD_STMPE is not set
CONFIG_KEYBOARD_OMAP4=m
CONFIG_KEYBOARD_TM2_TOUCHKEY=y
CONFIG_KEYBOARD_XTKBD=y
# CONFIG_KEYBOARD_CROS_EC is not set
CONFIG_KEYBOARD_CAP11XX=m
# CONFIG_KEYBOARD_BCM is not set
# CONFIG_KEYBOARD_MTK_PMIC is not set
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
CONFIG_MOUSE_SERIAL=y
CONFIG_MOUSE_APPLETOUCH=y
CONFIG_MOUSE_BCM5974=y
# CONFIG_MOUSE_CYAPA is not set
CONFIG_MOUSE_ELAN_I2C=m
CONFIG_MOUSE_ELAN_I2C_I2C=y
CONFIG_MOUSE_ELAN_I2C_SMBUS=y
CONFIG_MOUSE_VSXXXAA=m
CONFIG_MOUSE_GPIO=m
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
CONFIG_MOUSE_SYNAPTICS_USB=y
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
CONFIG_TABLET_USB_GTCO=y
# CONFIG_TABLET_USB_HANWANG is not set
CONFIG_TABLET_USB_KBTAB=y
# CONFIG_TABLET_USB_PEGASUS is not set
CONFIG_TABLET_SERIAL_WACOM4=m
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_88PM860X_ONKEY=y
CONFIG_INPUT_88PM80X_ONKEY=m
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_ATMEL_CAPTOUCH is not set
CONFIG_INPUT_BMA150=m
CONFIG_INPUT_E3X0_BUTTON=y
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_MAX77693_HAPTIC is not set
CONFIG_INPUT_MAX8925_ONKEY=y
CONFIG_INPUT_MC13783_PWRBUTTON=y
CONFIG_INPUT_MMA8450=y
# CONFIG_INPUT_APANEL is not set
CONFIG_INPUT_GP2A=m
# CONFIG_INPUT_GPIO_BEEPER is not set
CONFIG_INPUT_GPIO_DECODER=m
# CONFIG_INPUT_CPCAP_PWRBUTTON is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
CONFIG_INPUT_ATI_REMOTE2=m
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
CONFIG_INPUT_KXTJ9=y
CONFIG_INPUT_KXTJ9_POLLED_MODE=y
CONFIG_INPUT_POWERMATE=m
CONFIG_INPUT_YEALINK=m
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_REGULATOR_HAPTIC=y
# CONFIG_INPUT_RETU_PWRBUTTON is not set
CONFIG_INPUT_TPS65218_PWRBUTTON=y
CONFIG_INPUT_TWL6040_VIBRA=y
CONFIG_INPUT_UINPUT=m
CONFIG_INPUT_PCF50633_PMU=m
# CONFIG_INPUT_PCF8574 is not set
CONFIG_INPUT_PWM_BEEPER=m
CONFIG_INPUT_PWM_VIBRA=m
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
CONFIG_INPUT_DA9052_ONKEY=m
# CONFIG_INPUT_DA9055_ONKEY is not set
CONFIG_INPUT_DA9063_ONKEY=m
CONFIG_INPUT_WM831X_ON=y
# CONFIG_INPUT_ADXL34X is not set
CONFIG_INPUT_IMS_PCU=y
CONFIG_INPUT_CMA3000=m
CONFIG_INPUT_CMA3000_I2C=m
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set
# CONFIG_INPUT_DRV260X_HAPTICS is not set
# CONFIG_INPUT_DRV2665_HAPTICS is not set
CONFIG_INPUT_DRV2667_HAPTICS=y
CONFIG_RMI4_CORE=y
# CONFIG_RMI4_I2C is not set
CONFIG_RMI4_SPI=y
CONFIG_RMI4_SMB=y
CONFIG_RMI4_F03=y
CONFIG_RMI4_F03_SERIO=y
CONFIG_RMI4_2D_SENSOR=y
CONFIG_RMI4_F11=y
CONFIG_RMI4_F12=y
CONFIG_RMI4_F30=y
CONFIG_RMI4_F34=y
# CONFIG_RMI4_F55 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=m
CONFIG_SERIO_PS2MULT=y
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_SERIO_APBPS2=y
# CONFIG_SERIO_GPIO_PS2 is not set
# CONFIG_USERIO is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_NOZOMI is not set
# CONFIG_ISI is not set
CONFIG_N_HDLC=m
CONFIG_N_GSM=m
CONFIG_TRACE_ROUTER=m
CONFIG_TRACE_SINK=y
CONFIG_GOLDFISH_TTY=m
# CONFIG_DEVMEM is not set
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_FINTEK is not set
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_EXAR=y
CONFIG_SERIAL_8250_MEN_MCB=m
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_ASPEED_VUART is not set
CONFIG_SERIAL_8250_DW=m
# CONFIG_SERIAL_8250_RT288X is not set
CONFIG_SERIAL_8250_LPSS=y
CONFIG_SERIAL_8250_MID=y
# CONFIG_SERIAL_8250_MOXA is not set
# CONFIG_SERIAL_OF_PLATFORM is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
CONFIG_SERIAL_MAX310X=y
CONFIG_SERIAL_UARTLITE=y
# CONFIG_SERIAL_UARTLITE_CONSOLE is not set
CONFIG_SERIAL_UARTLITE_NR_UARTS=1
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_SCCNXP=m
CONFIG_SERIAL_SC16IS7XX_CORE=m
CONFIG_SERIAL_SC16IS7XX=m
# CONFIG_SERIAL_SC16IS7XX_I2C is not set
CONFIG_SERIAL_SC16IS7XX_SPI=y
CONFIG_SERIAL_ALTERA_JTAGUART=m
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_SERIAL_IFX6X60=m
CONFIG_SERIAL_XILINX_PS_UART=y
CONFIG_SERIAL_XILINX_PS_UART_CONSOLE=y
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
CONFIG_SERIAL_FSL_LPUART=y
# CONFIG_SERIAL_FSL_LPUART_CONSOLE is not set
CONFIG_SERIAL_CONEXANT_DIGICOLOR=y
# CONFIG_SERIAL_CONEXANT_DIGICOLOR_CONSOLE is not set
CONFIG_SERIAL_MEN_Z135=y
# CONFIG_SERIAL_DEV_BUS is not set
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=m
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=m
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_DMI_DECODE=y
CONFIG_IPMI_PANIC_EVENT=y
# CONFIG_IPMI_PANIC_STRING is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
CONFIG_IPMI_SSIF=y
CONFIG_IPMI_WATCHDOG=m
# CONFIG_IPMI_POWEROFF is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
# CONFIG_HW_RANDOM_VIA is not set
# CONFIG_HW_RANDOM_VIRTIO is not set
# CONFIG_NVRAM is not set
CONFIG_R3964=m
# CONFIG_APPLICOM is not set
CONFIG_MWAVE=m
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
# CONFIG_TCG_TPM is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_XILLYBUS=m
CONFIG_XILLYBUS_OF=m
CONFIG_RANDOM_TRUST_CPU=y

#
# I2C support
#
CONFIG_I2C=y
CONFIG_ACPI_I2C_OPREGION=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_ARB_GPIO_CHALLENGE is not set
CONFIG_I2C_MUX_GPIO=m
CONFIG_I2C_MUX_GPMUX=m
# CONFIG_I2C_MUX_LTC4306 is not set
CONFIG_I2C_MUX_PCA9541=m
CONFIG_I2C_MUX_PCA954x=m
CONFIG_I2C_MUX_PINCTRL=m
CONFIG_I2C_MUX_REG=m
# CONFIG_I2C_DEMUX_PINCTRL is not set
CONFIG_I2C_MUX_MLXCPLD=m
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_ISMT is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_NVIDIA_GPU is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=y
# CONFIG_I2C_DESIGNWARE_PLATFORM is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EMEV2 is not set
CONFIG_I2C_GPIO=m
CONFIG_I2C_GPIO_FAULT_INJECTOR=y
CONFIG_I2C_KEMPLD=y
CONFIG_I2C_OCORES=m
CONFIG_I2C_PCA_PLATFORM=m
# CONFIG_I2C_RK3X is not set
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=m

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=y
# CONFIG_I2C_PARPORT is not set
CONFIG_I2C_PARPORT_LIGHT=y
CONFIG_I2C_ROBOTFUZZ_OSIF=m
CONFIG_I2C_TAOS_EVM=m
CONFIG_I2C_TINY_USB=y
CONFIG_I2C_VIPERBOARD=m

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_MLXCPLD is not set
CONFIG_I2C_CROS_EC_TUNNEL=y
# CONFIG_I2C_FSI is not set
CONFIG_I2C_STUB=m
CONFIG_I2C_SLAVE=y
CONFIG_I2C_SLAVE_EEPROM=y
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y
CONFIG_SPI_MEM=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=y
CONFIG_SPI_AXI_SPI_ENGINE=m
CONFIG_SPI_BITBANG=y
CONFIG_SPI_BUTTERFLY=m
CONFIG_SPI_CADENCE=y
# CONFIG_SPI_DESIGNWARE is not set
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_LM70_LLP is not set
# CONFIG_SPI_FSL_SPI is not set
CONFIG_SPI_OC_TINY=m
# CONFIG_SPI_PXA2XX is not set
CONFIG_SPI_ROCKCHIP=m
CONFIG_SPI_SC18IS602=m
# CONFIG_SPI_XCOMM is not set
CONFIG_SPI_XILINX=m
# CONFIG_SPI_ZYNQMP_GQSPI is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=y
CONFIG_SPI_LOOPBACK_TEST=m
# CONFIG_SPI_TLE62X0 is not set
# CONFIG_SPI_SLAVE is not set
# CONFIG_SPMI is not set
CONFIG_HSI=m
CONFIG_HSI_BOARDINFO=y

#
# HSI controllers
#

#
# HSI clients
#
CONFIG_HSI_CHAR=m
# CONFIG_PPS is not set

#
# PTP clock support
#
# CONFIG_PTP_1588_CLOCK is not set

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_PINCTRL=y
CONFIG_PINMUX=y
CONFIG_PINCONF=y
CONFIG_GENERIC_PINCONF=y
CONFIG_DEBUG_PINCTRL=y
# CONFIG_PINCTRL_AMD is not set
# CONFIG_PINCTRL_MCP23S08 is not set
# CONFIG_PINCTRL_SINGLE is not set
CONFIG_PINCTRL_SX150X=y
CONFIG_PINCTRL_MAX77620=y
# CONFIG_PINCTRL_BAYTRAIL is not set
# CONFIG_PINCTRL_CHERRYVIEW is not set
# CONFIG_PINCTRL_BROXTON is not set
# CONFIG_PINCTRL_CANNONLAKE is not set
# CONFIG_PINCTRL_CEDARFORK is not set
# CONFIG_PINCTRL_DENVERTON is not set
# CONFIG_PINCTRL_GEMINILAKE is not set
# CONFIG_PINCTRL_ICELAKE is not set
# CONFIG_PINCTRL_LEWISBURG is not set
# CONFIG_PINCTRL_SUNRISEPOINT is not set
CONFIG_PINCTRL_MADERA=y
CONFIG_PINCTRL_CS47L35=y
CONFIG_GPIOLIB=y
CONFIG_GPIOLIB_FASTPATH_LIMIT=512
CONFIG_OF_GPIO=y
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_MAX730X=m

#
# Memory mapped GPIO drivers
#
CONFIG_GPIO_74XX_MMIO=y
CONFIG_GPIO_ALTERA=y
# CONFIG_GPIO_AMDPT is not set
# CONFIG_GPIO_DWAPB is not set
# CONFIG_GPIO_EXAR is not set
CONFIG_GPIO_FTGPIO010=y
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_GRGPIO=y
# CONFIG_GPIO_HLWD is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_LYNXPOINT is not set
CONFIG_GPIO_MB86S7X=y
# CONFIG_GPIO_MENZ127 is not set
# CONFIG_GPIO_MOCKUP is not set
CONFIG_GPIO_SIOX=m
CONFIG_GPIO_SYSCON=m
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_XILINX is not set

#
# Port-mapped I/O GPIO drivers
#
CONFIG_GPIO_F7188X=y
CONFIG_GPIO_IT87=m
# CONFIG_GPIO_SCH is not set
CONFIG_GPIO_SCH311X=y
CONFIG_GPIO_WINBOND=m
# CONFIG_GPIO_WS16C48 is not set

#
# I2C GPIO expanders
#
# CONFIG_GPIO_ADP5588 is not set
CONFIG_GPIO_ADNP=m
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCA953X_IRQ=y
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_TPIC2810 is not set

#
# MFD GPIO expanders
#
CONFIG_GPIO_ADP5520=y
CONFIG_GPIO_ARIZONA=m
# CONFIG_GPIO_DA9052 is not set
CONFIG_GPIO_DA9055=y
CONFIG_GPIO_KEMPLD=m
CONFIG_GPIO_LP873X=m
CONFIG_GPIO_MADERA=m
# CONFIG_GPIO_MAX77620 is not set
CONFIG_GPIO_STMPE=y
# CONFIG_GPIO_TPS65086 is not set
CONFIG_GPIO_TPS65912=m
CONFIG_GPIO_TWL6040=m
CONFIG_GPIO_WM831X=y
CONFIG_GPIO_WM8350=y

#
# PCI GPIO expanders
#
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_PCI_IDIO_16 is not set
# CONFIG_GPIO_PCIE_IDIO_24 is not set
# CONFIG_GPIO_RDC321X is not set
# CONFIG_GPIO_SODAVILLE is not set

#
# SPI GPIO expanders
#
CONFIG_GPIO_74X164=y
# CONFIG_GPIO_MAX3191X is not set
CONFIG_GPIO_MAX7301=m
CONFIG_GPIO_MC33880=y
CONFIG_GPIO_PISOSR=m
CONFIG_GPIO_XRA1403=y

#
# USB GPIO expanders
#
CONFIG_GPIO_VIPERBOARD=m
CONFIG_W1=m
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=m
CONFIG_W1_MASTER_DS2482=m
# CONFIG_W1_MASTER_DS1WM is not set
CONFIG_W1_MASTER_GPIO=m

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2405=m
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2413=m
CONFIG_W1_SLAVE_DS2406=m
CONFIG_W1_SLAVE_DS2423=m
# CONFIG_W1_SLAVE_DS2805 is not set
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=m
CONFIG_W1_SLAVE_DS2433_CRC=y
# CONFIG_W1_SLAVE_DS2438 is not set
CONFIG_W1_SLAVE_DS2780=m
CONFIG_W1_SLAVE_DS2781=m
# CONFIG_W1_SLAVE_DS28E04 is not set
CONFIG_W1_SLAVE_DS28E17=m
# CONFIG_POWER_AVS is not set
CONFIG_POWER_RESET=y
# CONFIG_POWER_RESET_GPIO is not set
CONFIG_POWER_RESET_GPIO_RESTART=y
CONFIG_POWER_RESET_LTC2952=y
# CONFIG_POWER_RESET_RESTART is not set
CONFIG_POWER_RESET_SYSCON=y
# CONFIG_POWER_RESET_SYSCON_POWEROFF is not set
CONFIG_REBOOT_MODE=y
CONFIG_SYSCON_REBOOT_MODE=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=m
CONFIG_GENERIC_ADC_BATTERY=y
CONFIG_MAX8925_POWER=y
CONFIG_WM831X_BACKUP=y
CONFIG_WM831X_POWER=m
# CONFIG_WM8350_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_88PM860X is not set
# CONFIG_CHARGER_ADP5061 is not set
CONFIG_BATTERY_CPCAP=m
CONFIG_BATTERY_DS2760=m
CONFIG_BATTERY_DS2780=m
CONFIG_BATTERY_DS2781=m
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_LEGO_EV3=y
# CONFIG_BATTERY_SBS is not set
CONFIG_CHARGER_SBS=m
CONFIG_MANAGER_SBS=m
CONFIG_BATTERY_BQ27XXX=y
CONFIG_BATTERY_BQ27XXX_I2C=m
CONFIG_BATTERY_BQ27XXX_HDQ=m
# CONFIG_BATTERY_BQ27XXX_DT_UPDATES_NVM is not set
CONFIG_BATTERY_DA9052=m
CONFIG_BATTERY_DA9150=y
CONFIG_BATTERY_MAX17040=m
CONFIG_BATTERY_MAX17042=m
# CONFIG_BATTERY_MAX1721X is not set
CONFIG_CHARGER_PCF50633=m
# CONFIG_CHARGER_ISP1704 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
CONFIG_CHARGER_MANAGER=y
CONFIG_CHARGER_LTC3651=m
CONFIG_CHARGER_DETECTOR_MAX14656=y
CONFIG_CHARGER_MAX77693=y
CONFIG_CHARGER_BQ2415X=m
CONFIG_CHARGER_BQ24190=y
# CONFIG_CHARGER_BQ24257 is not set
CONFIG_CHARGER_BQ24735=m
CONFIG_CHARGER_BQ25890=m
# CONFIG_CHARGER_SMB347 is not set
CONFIG_CHARGER_TPS65090=y
# CONFIG_CHARGER_TPS65217 is not set
CONFIG_BATTERY_GAUGE_LTC2941=y
# CONFIG_BATTERY_GOLDFISH is not set
# CONFIG_BATTERY_RT5033 is not set
# CONFIG_CHARGER_RT9455 is not set
CONFIG_CHARGER_CROS_USBPD=m
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
# CONFIG_SENSORS_ABITUGURU3 is not set
CONFIG_SENSORS_AD7314=m
CONFIG_SENSORS_AD7414=y
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=m
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7310=m
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=m
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_APPLESMC=m
# CONFIG_SENSORS_ASB100 is not set
CONFIG_SENSORS_ASPEED=m
# CONFIG_SENSORS_ATXP1 is not set
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_DELL_SMM=y
CONFIG_SENSORS_DA9052_ADC=y
# CONFIG_SENSORS_DA9055 is not set
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=y
# CONFIG_SENSORS_MC13783_ADC is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_G762=y
# CONFIG_SENSORS_GPIO_FAN is not set
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_IBMAEM=y
CONFIG_SENSORS_IBMPEX=y
CONFIG_SENSORS_IIO_HWMON=m
# CONFIG_SENSORS_I5500 is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_POWR1220=m
CONFIG_SENSORS_LINEAGE=y
# CONFIG_SENSORS_LTC2945 is not set
CONFIG_SENSORS_LTC2990=y
# CONFIG_SENSORS_LTC4151 is not set
CONFIG_SENSORS_LTC4215=y
# CONFIG_SENSORS_LTC4222 is not set
# CONFIG_SENSORS_LTC4245 is not set
CONFIG_SENSORS_LTC4260=m
CONFIG_SENSORS_LTC4261=y
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=m
CONFIG_SENSORS_MAX197=m
CONFIG_SENSORS_MAX31722=m
# CONFIG_SENSORS_MAX6621 is not set
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=m
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
CONFIG_SENSORS_MAX31790=y
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_MLXREG_FAN=m
CONFIG_SENSORS_TC654=y
# CONFIG_SENSORS_MENF21BMC_HWMON is not set
CONFIG_SENSORS_ADCXX=m
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM70=m
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=m
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=y
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LM95234 is not set
CONFIG_SENSORS_LM95241=y
# CONFIG_SENSORS_LM95245 is not set
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_NTC_THERMISTOR=m
# CONFIG_SENSORS_NCT6683 is not set
CONFIG_SENSORS_NCT6775=m
CONFIG_SENSORS_NCT7802=y
CONFIG_SENSORS_NCT7904=y
# CONFIG_SENSORS_NPCM7XX is not set
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=m
# CONFIG_SENSORS_PMBUS is not set
# CONFIG_SENSORS_ADM1275 is not set
CONFIG_SENSORS_IBM_CFFPS=m
CONFIG_SENSORS_IR35221=m
CONFIG_SENSORS_LM25066=m
# CONFIG_SENSORS_LTC2978 is not set
CONFIG_SENSORS_LTC3815=m
CONFIG_SENSORS_MAX16064=m
CONFIG_SENSORS_MAX20751=m
CONFIG_SENSORS_MAX31785=m
CONFIG_SENSORS_MAX34440=m
# CONFIG_SENSORS_MAX8688 is not set
CONFIG_SENSORS_TPS40422=m
CONFIG_SENSORS_TPS53679=m
CONFIG_SENSORS_UCD9000=m
CONFIG_SENSORS_UCD9200=m
# CONFIG_SENSORS_ZL6100 is not set
CONFIG_SENSORS_PWM_FAN=m
CONFIG_SENSORS_SHT15=m
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SHT3x=m
CONFIG_SENSORS_SHTC1=y
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=m
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=m
# CONFIG_SENSORS_SMSC47B397 is not set
CONFIG_SENSORS_STTS751=y
CONFIG_SENSORS_SMM665=m
# CONFIG_SENSORS_ADC128D818 is not set
CONFIG_SENSORS_ADS1015=m
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_ADS7871=y
CONFIG_SENSORS_AMC6821=y
# CONFIG_SENSORS_INA209 is not set
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_INA3221=y
CONFIG_SENSORS_TC74=m
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP103=y
CONFIG_SENSORS_TMP108=y
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=m
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83773G=m
CONFIG_SENSORS_W83781D=y
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=m
# CONFIG_SENSORS_W83795_FANCTRL is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=m
CONFIG_SENSORS_WM8350=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_STATISTICS=y
CONFIG_THERMAL_EMERGENCY_POWEROFF_DELAY_MS=0
# CONFIG_THERMAL_HWMON is not set
CONFIG_THERMAL_OF=y
# CONFIG_THERMAL_WRITABLE_TRIPS is not set
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
# CONFIG_THERMAL_DEFAULT_GOV_POWER_ALLOCATOR is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_BANG_BANG=y
CONFIG_THERMAL_GOV_USER_SPACE=y
CONFIG_THERMAL_GOV_POWER_ALLOCATOR=y
# CONFIG_CPU_THERMAL is not set
CONFIG_THERMAL_EMULATION=y
# CONFIG_MAX77620_THERMAL is not set
CONFIG_QORIQ_THERMAL=m
CONFIG_DA9062_THERMAL=m
CONFIG_INTEL_POWERCLAMP=m
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# ACPI INT340X thermal drivers
#
# CONFIG_INT340X_THERMAL is not set
# CONFIG_INTEL_PCH_THERMAL is not set
CONFIG_GENERIC_ADC_THERMAL=m
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
# CONFIG_SSB_DRIVER_GPIO is not set
CONFIG_BCMA_POSSIBLE=y
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_PCI=y
CONFIG_BCMA_DRIVER_GMAC_CMN=y
# CONFIG_BCMA_DRIVER_GPIO is not set
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_ACT8945A is not set
CONFIG_MFD_AS3711=y
# CONFIG_MFD_AS3722 is not set
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_AAT2870_CORE=y
# CONFIG_MFD_AT91_USART is not set
# CONFIG_MFD_ATMEL_FLEXCOM is not set
CONFIG_MFD_ATMEL_HLCDC=y
# CONFIG_MFD_BCM590XX is not set
# CONFIG_MFD_BD9571MWV is not set
# CONFIG_MFD_AXP20X_I2C is not set
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_CHARDEV=y
CONFIG_MFD_MADERA=y
# CONFIG_MFD_MADERA_I2C is not set
CONFIG_MFD_MADERA_SPI=y
CONFIG_MFD_CS47L35=y
# CONFIG_MFD_CS47L85 is not set
# CONFIG_MFD_CS47L90 is not set
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
# CONFIG_MFD_DA9052_SPI is not set
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
CONFIG_MFD_DA9062=m
CONFIG_MFD_DA9063=m
CONFIG_MFD_DA9150=y
# CONFIG_MFD_DLN2 is not set
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=m
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_MFD_HI6421_PMIC=m
CONFIG_HTC_PASIC3=m
CONFIG_HTC_I2CPLD=y
# CONFIG_MFD_INTEL_QUARK_I2C_GPIO is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_INTEL_SOC_PMIC is not set
# CONFIG_INTEL_SOC_PMIC_CHTWC is not set
# CONFIG_INTEL_SOC_PMIC_CHTDC_TI is not set
# CONFIG_MFD_INTEL_LPSS_ACPI is not set
# CONFIG_MFD_INTEL_LPSS_PCI is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_88PM800=y
# CONFIG_MFD_88PM805 is not set
CONFIG_MFD_88PM860X=y
# CONFIG_MFD_MAX14577 is not set
CONFIG_MFD_MAX77620=y
CONFIG_MFD_MAX77686=m
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX77843=y
# CONFIG_MFD_MAX8907 is not set
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
CONFIG_MFD_MT6397=y
CONFIG_MFD_MENF21BMC=y
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_CPCAP=m
CONFIG_MFD_VIPERBOARD=m
CONFIG_MFD_RETU=m
CONFIG_MFD_PCF50633=y
# CONFIG_PCF50633_ADC is not set
# CONFIG_PCF50633_GPIO is not set
# CONFIG_MFD_RDC321X is not set
CONFIG_MFD_RT5033=y
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_RK808 is not set
# CONFIG_MFD_RN5T618 is not set
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=y
# CONFIG_MFD_SM501 is not set
CONFIG_MFD_SKY81452=y
CONFIG_MFD_SMSC=y
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
# CONFIG_STMPE_I2C is not set
# CONFIG_STMPE_SPI is not set
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
# CONFIG_MFD_LP3943 is not set
CONFIG_MFD_LP8788=y
CONFIG_MFD_TI_LMU=m
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=m
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
CONFIG_MFD_TPS65086=m
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TPS65217=y
# CONFIG_MFD_TPS68470 is not set
CONFIG_MFD_TI_LP873X=y
# CONFIG_MFD_TI_LP87565 is not set
# CONFIG_MFD_TPS65218 is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=m
# CONFIG_MFD_TPS65912_I2C is not set
CONFIG_MFD_TPS65912_SPI=m
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_MFD_ARIZONA_SPI=m
# CONFIG_MFD_CS47L24 is not set
CONFIG_MFD_WM5102=y
# CONFIG_MFD_WM5110 is not set
# CONFIG_MFD_WM8997 is not set
# CONFIG_MFD_WM8998 is not set
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
# CONFIG_MFD_WM831X_I2C is not set
CONFIG_MFD_WM831X_SPI=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
# CONFIG_MFD_WM8994 is not set
CONFIG_MFD_ROHM_BD718XX=m
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=m
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
CONFIG_REGULATOR_88PG86X=y
CONFIG_REGULATOR_88PM800=y
CONFIG_REGULATOR_88PM8607=m
CONFIG_REGULATOR_ACT8865=m
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_ANATOP=y
# CONFIG_REGULATOR_AAT2870 is not set
# CONFIG_REGULATOR_AS3711 is not set
CONFIG_REGULATOR_BD718XX=m
# CONFIG_REGULATOR_CPCAP is not set
CONFIG_REGULATOR_DA9052=m
# CONFIG_REGULATOR_DA9055 is not set
CONFIG_REGULATOR_DA9062=m
CONFIG_REGULATOR_DA9063=m
CONFIG_REGULATOR_DA9210=m
CONFIG_REGULATOR_DA9211=y
CONFIG_REGULATOR_FAN53555=y
CONFIG_REGULATOR_GPIO=m
CONFIG_REGULATOR_HI6421=m
# CONFIG_REGULATOR_HI6421V530 is not set
CONFIG_REGULATOR_ISL9305=y
# CONFIG_REGULATOR_ISL6271A is not set
CONFIG_REGULATOR_LM363X=m
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=m
# CONFIG_REGULATOR_LP872X is not set
# CONFIG_REGULATOR_LP873X is not set
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_LP8788=y
CONFIG_REGULATOR_LTC3589=m
# CONFIG_REGULATOR_LTC3676 is not set
CONFIG_REGULATOR_MAX1586=m
# CONFIG_REGULATOR_MAX77620 is not set
CONFIG_REGULATOR_MAX8649=y
# CONFIG_REGULATOR_MAX8660 is not set
# CONFIG_REGULATOR_MAX8925 is not set
# CONFIG_REGULATOR_MAX8952 is not set
CONFIG_REGULATOR_MAX8973=m
# CONFIG_REGULATOR_MAX8998 is not set
CONFIG_REGULATOR_MAX77686=m
CONFIG_REGULATOR_MAX77693=y
CONFIG_REGULATOR_MAX77802=m
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
# CONFIG_REGULATOR_MC13892 is not set
# CONFIG_REGULATOR_MT6311 is not set
# CONFIG_REGULATOR_MT6323 is not set
# CONFIG_REGULATOR_MT6397 is not set
# CONFIG_REGULATOR_PCF50633 is not set
# CONFIG_REGULATOR_PFUZE100 is not set
CONFIG_REGULATOR_PV88060=m
CONFIG_REGULATOR_PV88080=y
CONFIG_REGULATOR_PV88090=m
CONFIG_REGULATOR_PWM=m
CONFIG_REGULATOR_RT5033=m
CONFIG_REGULATOR_S2MPA01=y
CONFIG_REGULATOR_S2MPS11=y
CONFIG_REGULATOR_S5M8767=m
# CONFIG_REGULATOR_SKY81452 is not set
CONFIG_REGULATOR_SY8106A=y
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS6105X=m
CONFIG_REGULATOR_TPS62360=m
CONFIG_REGULATOR_TPS65023=m
CONFIG_REGULATOR_TPS6507X=y
# CONFIG_REGULATOR_TPS65086 is not set
CONFIG_REGULATOR_TPS65090=m
# CONFIG_REGULATOR_TPS65132 is not set
# CONFIG_REGULATOR_TPS65217 is not set
CONFIG_REGULATOR_TPS6524X=y
# CONFIG_REGULATOR_TPS65912 is not set
CONFIG_REGULATOR_VCTRL=y
CONFIG_REGULATOR_WM831X=y
CONFIG_REGULATOR_WM8350=y
CONFIG_CEC_CORE=y
CONFIG_CEC_NOTIFIER=y
CONFIG_RC_CORE=y
CONFIG_RC_MAP=m
# CONFIG_LIRC is not set
# CONFIG_RC_DECODERS is not set
# CONFIG_RC_DEVICES is not set
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_SDR_SUPPORT is not set
CONFIG_MEDIA_CEC_SUPPORT=y
# CONFIG_MEDIA_CEC_RC is not set
CONFIG_MEDIA_CONTROLLER=y
CONFIG_MEDIA_CONTROLLER_DVB=y
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_SUBDEV_API=y
CONFIG_VIDEO_V4L2=m
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_V4L2_FLASH_LED_CLASS=m
CONFIG_V4L2_FWNODE=m
CONFIG_DVB_CORE=m
# CONFIG_DVB_MMAP is not set
CONFIG_DVB_NET=y
CONFIG_DVB_MAX_ADAPTERS=16
# CONFIG_DVB_DYNAMIC_MINORS is not set
CONFIG_DVB_DEMUX_SECTION_LOSS_LOG=y
CONFIG_DVB_ULE_DEBUG=y

#
# Media drivers
#
# CONFIG_MEDIA_USB_SUPPORT is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set
# CONFIG_V4L_PLATFORM_DRIVERS is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_V4L_TEST_DRIVERS is not set
# CONFIG_DVB_PLATFORM_DRIVERS is not set
CONFIG_CEC_PLATFORM_DRIVERS=y
CONFIG_VIDEO_CROS_EC_CEC=m

#
# Supported MMC/SDIO adapters
#
# CONFIG_SMS_SDIO_DRV is not set

#
# Supported FireWire (IEEE 1394) Adapters
#
# CONFIG_DVB_FIREDTV is not set
# CONFIG_CYPRESS_FIRMWARE is not set

#
# Media ancillary drivers (tuners, sensors, i2c, spi, frontends)
#
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set
CONFIG_MEDIA_ATTACH=y
CONFIG_VIDEO_IR_I2C=m

#
# I2C Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#
# CONFIG_VIDEO_TVAUDIO is not set
CONFIG_VIDEO_TDA7432=m
CONFIG_VIDEO_TDA9840=m
# CONFIG_VIDEO_TEA6415C is not set
CONFIG_VIDEO_TEA6420=m
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_CS3308=m
# CONFIG_VIDEO_CS5345 is not set
# CONFIG_VIDEO_CS53L32A is not set
CONFIG_VIDEO_TLV320AIC23B=m
CONFIG_VIDEO_UDA1342=m
CONFIG_VIDEO_WM8775=m
# CONFIG_VIDEO_WM8739 is not set
CONFIG_VIDEO_VP27SMPX=m
# CONFIG_VIDEO_SONY_BTF_MPX is not set

#
# RDS decoders
#
# CONFIG_VIDEO_SAA6588 is not set

#
# Video decoders
#
# CONFIG_VIDEO_ADV7180 is not set
# CONFIG_VIDEO_ADV7183 is not set
CONFIG_VIDEO_ADV748X=m
CONFIG_VIDEO_ADV7604=m
CONFIG_VIDEO_ADV7604_CEC=y
CONFIG_VIDEO_ADV7842=m
# CONFIG_VIDEO_ADV7842_CEC is not set
CONFIG_VIDEO_BT819=m
CONFIG_VIDEO_BT856=m
CONFIG_VIDEO_BT866=m
CONFIG_VIDEO_KS0127=m
CONFIG_VIDEO_ML86V7667=m
# CONFIG_VIDEO_AD5820 is not set
# CONFIG_VIDEO_AK7375 is not set
CONFIG_VIDEO_DW9714=m
CONFIG_VIDEO_DW9807_VCM=m
CONFIG_VIDEO_SAA7110=m
CONFIG_VIDEO_SAA711X=m
# CONFIG_VIDEO_TC358743 is not set
# CONFIG_VIDEO_TVP514X is not set
# CONFIG_VIDEO_TVP5150 is not set
CONFIG_VIDEO_TVP7002=m
# CONFIG_VIDEO_TW2804 is not set
CONFIG_VIDEO_TW9903=m
# CONFIG_VIDEO_TW9906 is not set
# CONFIG_VIDEO_TW9910 is not set
# CONFIG_VIDEO_VPX3220 is not set

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=m
CONFIG_VIDEO_CX25840=m

#
# Video encoders
#
# CONFIG_VIDEO_SAA7127 is not set
# CONFIG_VIDEO_SAA7185 is not set
CONFIG_VIDEO_ADV7170=m
CONFIG_VIDEO_ADV7175=m
CONFIG_VIDEO_ADV7343=m
# CONFIG_VIDEO_ADV7393 is not set
CONFIG_VIDEO_ADV7511=m
# CONFIG_VIDEO_ADV7511_CEC is not set
CONFIG_VIDEO_AD9389B=m
CONFIG_VIDEO_AK881X=m
CONFIG_VIDEO_THS8200=m

#
# Camera sensor devices
#
CONFIG_VIDEO_APTINA_PLL=m
CONFIG_VIDEO_IMX258=m
# CONFIG_VIDEO_IMX274 is not set
CONFIG_VIDEO_IMX319=m
# CONFIG_VIDEO_IMX355 is not set
CONFIG_VIDEO_OV2640=m
CONFIG_VIDEO_OV2659=m
CONFIG_VIDEO_OV2680=m
CONFIG_VIDEO_OV2685=m
CONFIG_VIDEO_OV5640=m
# CONFIG_VIDEO_OV5645 is not set
CONFIG_VIDEO_OV5647=m
CONFIG_VIDEO_OV6650=m
CONFIG_VIDEO_OV5670=m
CONFIG_VIDEO_OV5695=m
# CONFIG_VIDEO_OV7251 is not set
CONFIG_VIDEO_OV772X=m
CONFIG_VIDEO_OV7640=m
CONFIG_VIDEO_OV7670=m
CONFIG_VIDEO_OV7740=m
CONFIG_VIDEO_OV9650=m
# CONFIG_VIDEO_OV13858 is not set
# CONFIG_VIDEO_VS6624 is not set
CONFIG_VIDEO_MT9M032=m
CONFIG_VIDEO_MT9M111=m
CONFIG_VIDEO_MT9P031=m
# CONFIG_VIDEO_MT9T001 is not set
CONFIG_VIDEO_MT9T112=m
CONFIG_VIDEO_MT9V011=m
# CONFIG_VIDEO_MT9V032 is not set
CONFIG_VIDEO_MT9V111=m
# CONFIG_VIDEO_SR030PC30 is not set
CONFIG_VIDEO_NOON010PC30=m
CONFIG_VIDEO_M5MOLS=m
CONFIG_VIDEO_RJ54N1=m
CONFIG_VIDEO_S5K6AA=m
CONFIG_VIDEO_S5K6A3=m
CONFIG_VIDEO_S5K4ECGX=m
CONFIG_VIDEO_S5K5BAF=m
# CONFIG_VIDEO_SMIAPP is not set
CONFIG_VIDEO_ET8EK8=m
# CONFIG_VIDEO_S5C73M3 is not set

#
# Flash devices
#
# CONFIG_VIDEO_ADP1653 is not set
CONFIG_VIDEO_LM3560=m
# CONFIG_VIDEO_LM3646 is not set

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=m
CONFIG_VIDEO_UPD64083=m

#
# Audio/Video compression chips
#
CONFIG_VIDEO_SAA6752HS=m

#
# SDR tuner chips
#

#
# Miscellaneous helper chips
#
CONFIG_VIDEO_THS7303=m
# CONFIG_VIDEO_M52790 is not set
# CONFIG_VIDEO_I2C is not set

#
# Sensors used on soc_camera driver
#

#
# SPI helper chips
#
CONFIG_VIDEO_GS1662=m

#
# Media SPI Adapters
#
CONFIG_CXD2880_SPI_DRV=m
CONFIG_MEDIA_TUNER=m

#
# Customize TV tuners
#
# CONFIG_MEDIA_TUNER_SIMPLE is not set
# CONFIG_MEDIA_TUNER_TDA18250 is not set
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
# CONFIG_MEDIA_TUNER_TEA5761 is not set
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MSI001=m
CONFIG_MEDIA_TUNER_MT20XX=m
# CONFIG_MEDIA_TUNER_MT2060 is not set
CONFIG_MEDIA_TUNER_MT2063=m
# CONFIG_MEDIA_TUNER_MT2266 is not set
CONFIG_MEDIA_TUNER_MT2131=m
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_XC4000=m
# CONFIG_MEDIA_TUNER_MXL5005S is not set
CONFIG_MEDIA_TUNER_MXL5007T=m
CONFIG_MEDIA_TUNER_MC44S803=m
# CONFIG_MEDIA_TUNER_MAX2165 is not set
CONFIG_MEDIA_TUNER_TDA18218=m
CONFIG_MEDIA_TUNER_FC0011=m
CONFIG_MEDIA_TUNER_FC0012=m
CONFIG_MEDIA_TUNER_FC0013=m
CONFIG_MEDIA_TUNER_TDA18212=m
# CONFIG_MEDIA_TUNER_E4000 is not set
# CONFIG_MEDIA_TUNER_FC2580 is not set
CONFIG_MEDIA_TUNER_M88RS6000T=m
CONFIG_MEDIA_TUNER_TUA9001=m
CONFIG_MEDIA_TUNER_SI2157=m
# CONFIG_MEDIA_TUNER_IT913X is not set
CONFIG_MEDIA_TUNER_R820T=m
CONFIG_MEDIA_TUNER_MXL301RF=m
CONFIG_MEDIA_TUNER_QM1D1C0042=m
CONFIG_MEDIA_TUNER_QM1D1B0004=m

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=m
# CONFIG_DVB_STB6100 is not set
# CONFIG_DVB_STV090x is not set
# CONFIG_DVB_STV0910 is not set
# CONFIG_DVB_STV6110x is not set
# CONFIG_DVB_STV6111 is not set
# CONFIG_DVB_MXL5XX is not set
CONFIG_DVB_M88DS3103=m

#
# Multistandard (cable + terrestrial) frontends
#
# CONFIG_DVB_DRXK is not set
CONFIG_DVB_TDA18271C2DD=m
CONFIG_DVB_SI2165=m
CONFIG_DVB_MN88472=m
CONFIG_DVB_MN88473=m

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=m
CONFIG_DVB_CX24123=m
# CONFIG_DVB_MT312 is not set
CONFIG_DVB_ZL10036=m
# CONFIG_DVB_ZL10039 is not set
# CONFIG_DVB_S5H1420 is not set
CONFIG_DVB_STV0288=m
CONFIG_DVB_STB6000=m
CONFIG_DVB_STV0299=m
# CONFIG_DVB_STV6110 is not set
CONFIG_DVB_STV0900=m
CONFIG_DVB_TDA8083=m
CONFIG_DVB_TDA10086=m
CONFIG_DVB_TDA8261=m
# CONFIG_DVB_VES1X93 is not set
# CONFIG_DVB_TUNER_ITD1000 is not set
CONFIG_DVB_TUNER_CX24113=m
CONFIG_DVB_TDA826X=m
CONFIG_DVB_TUA6100=m
CONFIG_DVB_CX24116=m
CONFIG_DVB_CX24117=m
# CONFIG_DVB_CX24120 is not set
# CONFIG_DVB_SI21XX is not set
CONFIG_DVB_TS2020=m
# CONFIG_DVB_DS3000 is not set
# CONFIG_DVB_MB86A16 is not set
# CONFIG_DVB_TDA10071 is not set

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=m
CONFIG_DVB_SP887X=m
CONFIG_DVB_CX22700=m
CONFIG_DVB_CX22702=m
CONFIG_DVB_S5H1432=m
CONFIG_DVB_DRXD=m
CONFIG_DVB_L64781=m
CONFIG_DVB_TDA1004X=m
# CONFIG_DVB_NXT6000 is not set
CONFIG_DVB_MT352=m
# CONFIG_DVB_ZL10353 is not set
# CONFIG_DVB_DIB3000MB is not set
# CONFIG_DVB_DIB3000MC is not set
CONFIG_DVB_DIB7000M=m
# CONFIG_DVB_DIB7000P is not set
CONFIG_DVB_DIB9000=m
# CONFIG_DVB_TDA10048 is not set
CONFIG_DVB_AF9013=m
CONFIG_DVB_EC100=m
CONFIG_DVB_STV0367=m
CONFIG_DVB_CXD2820R=m
CONFIG_DVB_CXD2841ER=m
CONFIG_DVB_RTL2830=m
CONFIG_DVB_RTL2832=m
CONFIG_DVB_SI2168=m
CONFIG_DVB_ZD1301_DEMOD=m
CONFIG_DVB_CXD2880=m

#
# DVB-C (cable) frontends
#
# CONFIG_DVB_VES1820 is not set
CONFIG_DVB_TDA10021=m
# CONFIG_DVB_TDA10023 is not set
# CONFIG_DVB_STV0297 is not set

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
# CONFIG_DVB_NXT200X is not set
# CONFIG_DVB_OR51211 is not set
# CONFIG_DVB_OR51132 is not set
CONFIG_DVB_BCM3510=m
CONFIG_DVB_LGDT330X=m
# CONFIG_DVB_LGDT3305 is not set
CONFIG_DVB_LGDT3306A=m
# CONFIG_DVB_LG2160 is not set
# CONFIG_DVB_S5H1409 is not set
CONFIG_DVB_AU8522=m
CONFIG_DVB_AU8522_DTV=m
# CONFIG_DVB_AU8522_V4L is not set
CONFIG_DVB_S5H1411=m

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=m
CONFIG_DVB_DIB8000=m
CONFIG_DVB_MB86A20S=m

#
# ISDB-S (satellite) & ISDB-T (terrestrial) frontends
#
# CONFIG_DVB_TC90522 is not set
# CONFIG_DVB_MN88443X is not set

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=m
CONFIG_DVB_TUNER_DIB0070=m
# CONFIG_DVB_TUNER_DIB0090 is not set

#
# SEC control devices for DVB-S
#
CONFIG_DVB_DRX39XYJ=m
CONFIG_DVB_LNBH25=m
CONFIG_DVB_LNBH29=m
CONFIG_DVB_LNBP21=m
# CONFIG_DVB_LNBP22 is not set
CONFIG_DVB_ISL6405=m
# CONFIG_DVB_ISL6421 is not set
# CONFIG_DVB_ISL6423 is not set
# CONFIG_DVB_A8293 is not set
# CONFIG_DVB_LGS8GL5 is not set
CONFIG_DVB_LGS8GXX=m
# CONFIG_DVB_ATBM8830 is not set
# CONFIG_DVB_TDA665x is not set
CONFIG_DVB_IX2505V=m
CONFIG_DVB_M88RS2000=m
CONFIG_DVB_AF9033=m
CONFIG_DVB_HORUS3A=m
CONFIG_DVB_ASCOT2E=m
# CONFIG_DVB_HELENE is not set

#
# Common Interface (EN50221) controller drivers
#
# CONFIG_DVB_CXD2099 is not set
CONFIG_DVB_SP2=m

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
# CONFIG_DRM is not set
CONFIG_DRM_DP_CEC=y

#
# ACP (Audio CoProcessor) Configuration
#

#
# AMD Library routines
#

#
# Frame buffer Devices
#
CONFIG_FB_CMDLINE=y
CONFIG_FB_NOTIFY=y
CONFIG_FB=m
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
CONFIG_FB_FOREIGN_ENDIAN=y
CONFIG_FB_BOTH_ENDIAN=y
# CONFIG_FB_BIG_ENDIAN is not set
# CONFIG_FB_LITTLE_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=m
# CONFIG_FB_N411 is not set
CONFIG_FB_HGA=m
CONFIG_FB_OPENCORES=m
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
CONFIG_FB_SMSCUFX=m
# CONFIG_FB_UDL is not set
CONFIG_FB_IBM_GXT4500=m
CONFIG_FB_GOLDFISH=m
CONFIG_FB_VIRTUAL=m
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
CONFIG_FB_SSD1307=m
# CONFIG_FB_SM712 is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_LCD_L4F00242T03=m
CONFIG_LCD_LMS283GF05=m
CONFIG_LCD_LTV350QV=m
# CONFIG_LCD_ILI922X is not set
CONFIG_LCD_ILI9320=m
CONFIG_LCD_TDO24M=m
# CONFIG_LCD_VGG2432A4 is not set
CONFIG_LCD_PLATFORM=m
CONFIG_LCD_AMS369FG06=m
CONFIG_LCD_LMS501KF03=m
CONFIG_LCD_HX8357=m
CONFIG_LCD_OTM3225A=m
CONFIG_BACKLIGHT_CLASS_DEVICE=m
CONFIG_BACKLIGHT_GENERIC=m
CONFIG_BACKLIGHT_LM3533=m
CONFIG_BACKLIGHT_PWM=m
CONFIG_BACKLIGHT_DA9052=m
CONFIG_BACKLIGHT_MAX8925=m
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_PM8941_WLED=m
# CONFIG_BACKLIGHT_SAHARA is not set
CONFIG_BACKLIGHT_WM831X=m
CONFIG_BACKLIGHT_ADP5520=m
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
CONFIG_BACKLIGHT_88PM860X=m
CONFIG_BACKLIGHT_PCF50633=m
CONFIG_BACKLIGHT_AAT2870=m
CONFIG_BACKLIGHT_LM3630A=m
CONFIG_BACKLIGHT_LM3639=m
CONFIG_BACKLIGHT_LP855X=m
# CONFIG_BACKLIGHT_LP8788 is not set
CONFIG_BACKLIGHT_SKY81452=m
CONFIG_BACKLIGHT_TPS65217=m
# CONFIG_BACKLIGHT_AS3711 is not set
# CONFIG_BACKLIGHT_GPIO is not set
CONFIG_BACKLIGHT_LV5207LP=m
# CONFIG_BACKLIGHT_BD6107 is not set
CONFIG_BACKLIGHT_ARCXCNN=m
CONFIG_HDMI=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_DUMMY_CONSOLE_COLUMNS=80
CONFIG_DUMMY_CONSOLE_ROWS=25
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
CONFIG_LOGO_LINUX_VGA16=y
# CONFIG_LOGO_LINUX_CLUT224 is not set
CONFIG_SOUND=y
# CONFIG_SND is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
# CONFIG_HIDRAW is not set
CONFIG_UHID=m
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
# CONFIG_HID_ACCUTOUCH is not set
CONFIG_HID_ACRUX=m
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=y
# CONFIG_HID_APPLEIR is not set
CONFIG_HID_ASUS=y
# CONFIG_HID_AUREAL is not set
# CONFIG_HID_BELKIN is not set
CONFIG_HID_BETOP_FF=m
CONFIG_HID_BIGBEN_FF=y
CONFIG_HID_CHERRY=y
# CONFIG_HID_CHICONY is not set
CONFIG_HID_CORSAIR=m
CONFIG_HID_COUGAR=y
CONFIG_HID_CMEDIA=m
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
CONFIG_HID_EMS_FF=y
# CONFIG_HID_ELAN is not set
CONFIG_HID_ELECOM=m
CONFIG_HID_ELO=m
CONFIG_HID_EZKEY=m
CONFIG_HID_GEMBIRD=m
CONFIG_HID_GFRM=y
CONFIG_HID_HOLTEK=y
# CONFIG_HOLTEK_FF is not set
# CONFIG_HID_GOOGLE_HAMMER is not set
CONFIG_HID_GT683R=y
CONFIG_HID_KEYTOUCH=y
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=y
CONFIG_HID_WALTOP=m
CONFIG_HID_GYRATION=y
CONFIG_HID_ICADE=m
# CONFIG_HID_ITE is not set
# CONFIG_HID_JABRA is not set
CONFIG_HID_TWINHAN=y
# CONFIG_HID_KENSINGTON is not set
# CONFIG_HID_LCPOWER is not set
CONFIG_HID_LED=y
CONFIG_HID_LENOVO=y
# CONFIG_HID_LOGITECH is not set
# CONFIG_HID_MAGICMOUSE is not set
# CONFIG_HID_MAYFLASH is not set
CONFIG_HID_REDRAGON=y
CONFIG_HID_MICROSOFT=m
# CONFIG_HID_MONTEREY is not set
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_NTI=m
# CONFIG_HID_NTRIG is not set
CONFIG_HID_ORTEK=y
# CONFIG_HID_PANTHERLORD is not set
CONFIG_HID_PENMOUNT=y
CONFIG_HID_PETALYNX=m
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PICOLCD_CIR=y
# CONFIG_HID_PLANTRONICS is not set
CONFIG_HID_PRIMAX=m
CONFIG_HID_RETRODE=m
CONFIG_HID_ROCCAT=y
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=m
CONFIG_HID_SONY=m
# CONFIG_SONY_FF is not set
CONFIG_HID_SPEEDLINK=y
# CONFIG_HID_STEAM is not set
CONFIG_HID_STEELSERIES=y
CONFIG_HID_SUNPLUS=m
CONFIG_HID_RMI=y
CONFIG_HID_GREENASIA=m
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=y
CONFIG_SMARTJOYPLUS_FF=y
CONFIG_HID_TIVO=m
CONFIG_HID_TOPSEED=y
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=y
CONFIG_THRUSTMASTER_FF=y
# CONFIG_HID_UDRAW_PS3 is not set
# CONFIG_HID_WACOM is not set
CONFIG_HID_WIIMOTE=m
CONFIG_HID_XINMO=y
CONFIG_HID_ZEROPLUS=m
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=y
CONFIG_HID_SENSOR_HUB=m
CONFIG_HID_SENSOR_CUSTOM_SENSOR=m
CONFIG_HID_ALPS=m

#
# USB HID support
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set

#
# I2C HID support
#
# CONFIG_I2C_HID is not set

#
# Intel ISH HID support
#
# CONFIG_INTEL_ISH_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_PCI=y
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
# CONFIG_USB_DEFAULT_PERSIST is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_OTG=y
CONFIG_USB_OTG_WHITELIST=y
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_OTG_FSM=m
CONFIG_USB_MON=m
# CONFIG_USB_WUSB is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=m
# CONFIG_USB_XHCI_HCD is not set
# CONFIG_USB_EHCI_HCD is not set
CONFIG_USB_OXU210HP_HCD=m
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_FOTG210_HCD is not set
CONFIG_USB_MAX3421_HCD=m
# CONFIG_USB_OHCI_HCD is not set
# CONFIG_USB_UHCI_HCD is not set
CONFIG_USB_U132_HCD=y
CONFIG_USB_SL811_HCD=m
CONFIG_USB_SL811_HCD_ISO=y
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set
CONFIG_USB_HCD_BCMA=m
# CONFIG_USB_HCD_SSB is not set
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=y
CONFIG_USB_WDM=m
CONFIG_USB_TMC=y

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
CONFIG_USB_STORAGE_DEBUG=y
CONFIG_USB_STORAGE_REALTEK=m
# CONFIG_REALTEK_AUTOPM is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
CONFIG_USB_STORAGE_FREECOM=m
# CONFIG_USB_STORAGE_ISD200 is not set
CONFIG_USB_STORAGE_USBAT=m
CONFIG_USB_STORAGE_SDDR09=m
CONFIG_USB_STORAGE_SDDR55=m
CONFIG_USB_STORAGE_JUMPSHOT=m
CONFIG_USB_STORAGE_ALAUDA=m
CONFIG_USB_STORAGE_ONETOUCH=m
CONFIG_USB_STORAGE_KARMA=m
CONFIG_USB_STORAGE_CYPRESS_ATACB=m
# CONFIG_USB_STORAGE_ENE_UB6250 is not set
CONFIG_USB_UAS=m

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
CONFIG_USB_MICROTEK=m
CONFIG_USBIP_CORE=m
CONFIG_USBIP_VHCI_HCD=m
CONFIG_USBIP_VHCI_HC_PORTS=8
CONFIG_USBIP_VHCI_NR_HCS=1
CONFIG_USBIP_HOST=m
CONFIG_USBIP_VUDC=m
CONFIG_USBIP_DEBUG=y
CONFIG_USB_MUSB_HDRC=y
# CONFIG_USB_MUSB_HOST is not set
# CONFIG_USB_MUSB_GADGET is not set
CONFIG_USB_MUSB_DUAL_ROLE=y

#
# Platform Glue Layer
#

#
# MUSB DMA mode
#
CONFIG_MUSB_PIO_ONLY=y
CONFIG_USB_DWC3=y
# CONFIG_USB_DWC3_ULPI is not set
# CONFIG_USB_DWC3_HOST is not set
# CONFIG_USB_DWC3_GADGET is not set
CONFIG_USB_DWC3_DUAL_ROLE=y

#
# Platform Glue Driver Support
#
CONFIG_USB_DWC3_PCI=y
CONFIG_USB_DWC3_HAPS=y
CONFIG_USB_DWC3_OF_SIMPLE=y
# CONFIG_USB_DWC2 is not set
# CONFIG_USB_CHIPIDEA is not set
# CONFIG_USB_ISP1760 is not set

#
# USB port drivers
#
CONFIG_USB_USS720=m
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
# CONFIG_USB_EMI26 is not set
CONFIG_USB_ADUTUX=m
CONFIG_USB_SEVSEG=m
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
CONFIG_USB_LCD=m
CONFIG_USB_CYPRESS_CY7C63=m
CONFIG_USB_CYTHERM=y
CONFIG_USB_IDMOUSE=m
CONFIG_USB_FTDI_ELAN=y
CONFIG_USB_APPLEDISPLAY=m
CONFIG_USB_SISUSBVGA=y
CONFIG_USB_SISUSBVGA_CON=y
CONFIG_USB_LD=m
CONFIG_USB_TRANCEVIBRATOR=m
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
CONFIG_USB_EHSET_TEST_FIXTURE=y
CONFIG_USB_ISIGHTFW=m
# CONFIG_USB_YUREX is not set
CONFIG_USB_EZUSB_FX2=m
CONFIG_USB_HUB_USB251XB=y
CONFIG_USB_HSIC_USB3503=m
CONFIG_USB_HSIC_USB4604=y
CONFIG_USB_LINK_LAYER_TEST=y
CONFIG_USB_CHAOSKEY=m
CONFIG_USB_ATM=m
CONFIG_USB_SPEEDTOUCH=m
# CONFIG_USB_CXACRU is not set
CONFIG_USB_UEAGLEATM=m
# CONFIG_USB_XUSBATM is not set

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
CONFIG_USB_GPIO_VBUS=m
CONFIG_TAHVO_USB=m
CONFIG_TAHVO_USB_HOST_BY_DEFAULT=y
# CONFIG_USB_ISP1301 is not set
CONFIG_USB_GADGET=y
# CONFIG_USB_GADGET_DEBUG is not set
# CONFIG_USB_GADGET_DEBUG_FILES is not set
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
CONFIG_USB_FOTG210_UDC=m
CONFIG_USB_GR_UDC=m
# CONFIG_USB_R8A66597 is not set
# CONFIG_USB_PXA27X is not set
CONFIG_USB_MV_UDC=y
# CONFIG_USB_MV_U3D is not set
# CONFIG_USB_SNP_UDC_PLAT is not set
CONFIG_USB_M66592=y
CONFIG_USB_BDC_UDC=y

#
# Platform Support
#
CONFIG_USB_BDC_PCI=y
# CONFIG_USB_AMD5536UDC is not set
CONFIG_USB_NET2272=m
# CONFIG_USB_NET2272_DMA is not set
# CONFIG_USB_NET2280 is not set
# CONFIG_USB_GOKU is not set
# CONFIG_USB_EG20T is not set
CONFIG_USB_GADGET_XILINX=m
CONFIG_USB_DUMMY_HCD=y
# CONFIG_USB_CONFIGFS is not set
CONFIG_TYPEC=m
# CONFIG_TYPEC_TCPM is not set
CONFIG_TYPEC_UCSI=m
# CONFIG_UCSI_CCG is not set
# CONFIG_UCSI_ACPI is not set
CONFIG_TYPEC_TPS6598X=m

#
# USB Type-C Multiplexer/DeMultiplexer Switch support
#
# CONFIG_TYPEC_MUX_PI3USB30532 is not set

#
# USB Type-C Alternate Mode drivers
#
CONFIG_TYPEC_DP_ALTMODE=m
CONFIG_USB_ULPI_BUS=y
CONFIG_UWB=y
CONFIG_UWB_HWA=y
# CONFIG_UWB_WHCI is not set
# CONFIG_UWB_I1480U is not set
CONFIG_MMC=m
CONFIG_PWRSEQ_EMMC=m
CONFIG_PWRSEQ_SIMPLE=m
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
# CONFIG_SDIO_UART is not set
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_SDHCI is not set
CONFIG_MMC_WBSD=m
# CONFIG_MMC_TIFM_SD is not set
CONFIG_MMC_GOLDFISH=m
CONFIG_MMC_SPI=m
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MMC_VUB300=m
# CONFIG_MMC_USHC is not set
CONFIG_MMC_USDHI6ROL0=m
# CONFIG_MMC_REALTEK_USB is not set
CONFIG_MMC_CQHCI=m
# CONFIG_MMC_TOSHIBA_PCI is not set
CONFIG_MMC_MTK=m
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y
CONFIG_LEDS_CLASS_FLASH=y
CONFIG_LEDS_BRIGHTNESS_HW_CHANGED=y

#
# LED drivers
#
# CONFIG_LEDS_88PM860X is not set
CONFIG_LEDS_AAT1290=m
CONFIG_LEDS_AN30259A=y
# CONFIG_LEDS_APU is not set
# CONFIG_LEDS_AS3645A is not set
CONFIG_LEDS_BCM6328=m
CONFIG_LEDS_BCM6358=m
CONFIG_LEDS_CPCAP=m
CONFIG_LEDS_CR0014114=m
CONFIG_LEDS_LM3530=m
CONFIG_LEDS_LM3533=y
CONFIG_LEDS_LM3642=m
CONFIG_LEDS_LM3692X=m
CONFIG_LEDS_LM3601X=m
# CONFIG_LEDS_MT6323 is not set
CONFIG_LEDS_PCA9532=m
# CONFIG_LEDS_PCA9532_GPIO is not set
CONFIG_LEDS_GPIO=m
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP3952=m
CONFIG_LEDS_LP55XX_COMMON=m
# CONFIG_LEDS_LP5521 is not set
CONFIG_LEDS_LP5523=m
# CONFIG_LEDS_LP5562 is not set
CONFIG_LEDS_LP8501=m
CONFIG_LEDS_LP8788=y
CONFIG_LEDS_LP8860=y
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_PCA963X=m
CONFIG_LEDS_WM831X_STATUS=m
CONFIG_LEDS_WM8350=y
CONFIG_LEDS_DA9052=y
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_PWM is not set
CONFIG_LEDS_REGULATOR=y
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_LT3593=m
# CONFIG_LEDS_ADP5520 is not set
# CONFIG_LEDS_MC13783 is not set
CONFIG_LEDS_TCA6507=m
CONFIG_LEDS_TLC591XX=y
CONFIG_LEDS_MAX77693=m
CONFIG_LEDS_LM355x=y
CONFIG_LEDS_MENF21BMC=m
CONFIG_LEDS_KTD2692=y
CONFIG_LEDS_IS31FL319X=y
# CONFIG_LEDS_IS31FL32XX is not set

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
# CONFIG_LEDS_BLINKM is not set
CONFIG_LEDS_SYSCON=y
CONFIG_LEDS_MLXCPLD=m
# CONFIG_LEDS_MLXREG is not set
CONFIG_LEDS_USER=y
# CONFIG_LEDS_NIC78BX is not set

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
CONFIG_ACCESSIBILITY=y
CONFIG_A11Y_BRAILLE_CONSOLE=y
# CONFIG_INFINIBAND is not set
CONFIG_EDAC_ATOMIC_SCRUB=y
CONFIG_EDAC_SUPPORT=y
CONFIG_RTC_LIB=y
CONFIG_RTC_MC146818_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_SYSTOHC_DEVICE="rtc0"
CONFIG_RTC_DEBUG=y
# CONFIG_RTC_NVMEM is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
# CONFIG_RTC_INTF_PROC is not set
# CONFIG_RTC_INTF_DEV is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_88PM860X=y
CONFIG_RTC_DRV_88PM80X=m
CONFIG_RTC_DRV_ABB5ZES3=y
CONFIG_RTC_DRV_ABX80X=m
CONFIG_RTC_DRV_DS1307=y
CONFIG_RTC_DRV_DS1307_CENTURY=y
CONFIG_RTC_DRV_DS1374=m
# CONFIG_RTC_DRV_DS1374_WDT is not set
# CONFIG_RTC_DRV_DS1672 is not set
CONFIG_RTC_DRV_HYM8563=m
CONFIG_RTC_DRV_LP8788=m
CONFIG_RTC_DRV_MAX6900=y
# CONFIG_RTC_DRV_MAX8925 is not set
# CONFIG_RTC_DRV_MAX8998 is not set
# CONFIG_RTC_DRV_MAX77686 is not set
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=y
CONFIG_RTC_DRV_ISL12022=m
# CONFIG_RTC_DRV_ISL12026 is not set
CONFIG_RTC_DRV_X1205=y
# CONFIG_RTC_DRV_PCF8523 is not set
# CONFIG_RTC_DRV_PCF85063 is not set
# CONFIG_RTC_DRV_PCF85363 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
CONFIG_RTC_DRV_M41T80=y
# CONFIG_RTC_DRV_M41T80_WDT is not set
CONFIG_RTC_DRV_BQ32K=m
CONFIG_RTC_DRV_S35390A=m
CONFIG_RTC_DRV_FM3130=y
# CONFIG_RTC_DRV_RX8010 is not set
# CONFIG_RTC_DRV_RX8581 is not set
CONFIG_RTC_DRV_RX8025=y
CONFIG_RTC_DRV_EM3027=y
CONFIG_RTC_DRV_RV8803=m
CONFIG_RTC_DRV_S5M=y

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T93=y
# CONFIG_RTC_DRV_M41T94 is not set
# CONFIG_RTC_DRV_DS1302 is not set
CONFIG_RTC_DRV_DS1305=y
CONFIG_RTC_DRV_DS1343=m
# CONFIG_RTC_DRV_DS1347 is not set
CONFIG_RTC_DRV_DS1390=m
CONFIG_RTC_DRV_MAX6916=m
# CONFIG_RTC_DRV_R9701 is not set
CONFIG_RTC_DRV_RX4581=y
CONFIG_RTC_DRV_RX6110=m
# CONFIG_RTC_DRV_RS5C348 is not set
CONFIG_RTC_DRV_MAX6902=y
# CONFIG_RTC_DRV_PCF2123 is not set
# CONFIG_RTC_DRV_MCP795 is not set
CONFIG_RTC_I2C_AND_SPI=y

#
# SPI and I2C RTC drivers
#
# CONFIG_RTC_DRV_DS3232 is not set
CONFIG_RTC_DRV_PCF2127=m
CONFIG_RTC_DRV_RV3029C2=y
CONFIG_RTC_DRV_RV3029_HWMON=y

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
CONFIG_RTC_DRV_DS1685_FAMILY=m
CONFIG_RTC_DRV_DS1685=y
# CONFIG_RTC_DRV_DS1689 is not set
# CONFIG_RTC_DRV_DS17285 is not set
# CONFIG_RTC_DRV_DS17485 is not set
# CONFIG_RTC_DRV_DS17885 is not set
# CONFIG_RTC_DRV_DS1742 is not set
CONFIG_RTC_DRV_DS2404=y
CONFIG_RTC_DRV_DA9052=y
CONFIG_RTC_DRV_DA9055=m
CONFIG_RTC_DRV_DA9063=m
CONFIG_RTC_DRV_STK17TA8=y
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=y
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
CONFIG_RTC_DRV_RP5C01=y
CONFIG_RTC_DRV_V3020=y
# CONFIG_RTC_DRV_WM831X is not set
CONFIG_RTC_DRV_WM8350=m
CONFIG_RTC_DRV_PCF50633=m
# CONFIG_RTC_DRV_ZYNQMP is not set
CONFIG_RTC_DRV_CROS_EC=m

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_FTRTC010 is not set
CONFIG_RTC_DRV_MC13XXX=m
# CONFIG_RTC_DRV_SNVS is not set
CONFIG_RTC_DRV_MT6397=y
# CONFIG_RTC_DRV_R7301 is not set
# CONFIG_RTC_DRV_CPCAP is not set

#
# HID Sensor RTC drivers
#
CONFIG_RTC_DRV_HID_SENSOR_TIME=m
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
CONFIG_DMADEVICES_VDEBUG=y

#
# DMA Devices
#
CONFIG_DMA_ENGINE=y
CONFIG_DMA_VIRTUAL_CHANNELS=y
CONFIG_DMA_ACPI=y
CONFIG_DMA_OF=y
CONFIG_ALTERA_MSGDMA=m
CONFIG_DW_AXI_DMAC=y
# CONFIG_FSL_EDMA is not set
# CONFIG_INTEL_IDMA64 is not set
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_QCOM_HIDMA_MGMT is not set
CONFIG_QCOM_HIDMA=m
CONFIG_DW_DMAC_CORE=y
# CONFIG_DW_DMAC is not set
# CONFIG_DW_DMAC_PCI is not set
CONFIG_HSU_DMA=y

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=m
CONFIG_DMA_ENGINE_RAID=y

#
# DMABUF options
#
# CONFIG_SYNC_FILE is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_PANEL is not set
# CONFIG_UIO is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=m
# CONFIG_VIRTIO_MENU is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_PRISM2_USB is not set
CONFIG_COMEDI=m
# CONFIG_COMEDI_DEBUG is not set
CONFIG_COMEDI_DEFAULT_BUF_SIZE_KB=2048
CONFIG_COMEDI_DEFAULT_BUF_MAXSIZE_KB=20480
# CONFIG_COMEDI_MISC_DRIVERS is not set
# CONFIG_COMEDI_ISA_DRIVERS is not set
# CONFIG_COMEDI_PCI_DRIVERS is not set
CONFIG_COMEDI_USB_DRIVERS=m
CONFIG_COMEDI_DT9812=m
CONFIG_COMEDI_NI_USB6501=m
# CONFIG_COMEDI_USBDUX is not set
# CONFIG_COMEDI_USBDUXFAST is not set
# CONFIG_COMEDI_USBDUXSIGMA is not set
# CONFIG_COMEDI_VMK80XX is not set
CONFIG_COMEDI_8255=m
CONFIG_COMEDI_8255_SA=m
CONFIG_COMEDI_KCOMEDILIB=m
# CONFIG_RTL8192U is not set
# CONFIG_RTLLIB is not set
# CONFIG_RTL8723BS is not set
# CONFIG_R8712U is not set
# CONFIG_R8188EU is not set
# CONFIG_R8822BE is not set
# CONFIG_RTS5208 is not set
# CONFIG_VT6655 is not set
# CONFIG_VT6656 is not set

#
# IIO staging drivers
#

#
# Accelerometers
#
CONFIG_ADIS16203=m
# CONFIG_ADIS16240 is not set

#
# Analog to digital converters
#
CONFIG_AD7606=m
CONFIG_AD7606_IFACE_PARALLEL=m
CONFIG_AD7606_IFACE_SPI=m
# CONFIG_AD7780 is not set
CONFIG_AD7816=y
CONFIG_AD7192=y
# CONFIG_AD7280 is not set

#
# Analog digital bi-direction converters
#
# CONFIG_ADT7316 is not set

#
# Capacitance to digital converters
#
CONFIG_AD7150=y
CONFIG_AD7152=m
# CONFIG_AD7746 is not set

#
# Direct Digital Synthesis
#
# CONFIG_AD9832 is not set
CONFIG_AD9834=m

#
# Network Analyzer, Impedance Converters
#
CONFIG_AD5933=y

#
# Active energy metering IC
#
# CONFIG_ADE7854 is not set

#
# Resolver to digital converters
#
CONFIG_AD2S90=m
CONFIG_AD2S1210=m
# CONFIG_FB_SM750 is not set
# CONFIG_FB_XGI is not set

#
# Speakup console speech
#
# CONFIG_SPEAKUP is not set
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_STAGING_BOARD is not set
CONFIG_LTE_GDM724X=m
CONFIG_FIREWIRE_SERIAL=m
CONFIG_FWTTY_MAX_TOTAL_PORTS=64
CONFIG_FWTTY_MAX_CARD_PORTS=32
CONFIG_GOLDFISH_AUDIO=m
# CONFIG_MTD_SPINAND_MT29F is not set
CONFIG_GS_FPGABOOT=m
CONFIG_UNISYSSPAR=y
# CONFIG_COMMON_CLK_XLNX_CLKWZRD is not set
CONFIG_FB_TFT=m
# CONFIG_FB_TFT_AGM1264K_FL is not set
CONFIG_FB_TFT_BD663474=m
CONFIG_FB_TFT_HX8340BN=m
# CONFIG_FB_TFT_HX8347D is not set
# CONFIG_FB_TFT_HX8353D is not set
CONFIG_FB_TFT_HX8357D=m
# CONFIG_FB_TFT_ILI9163 is not set
CONFIG_FB_TFT_ILI9320=m
CONFIG_FB_TFT_ILI9325=m
CONFIG_FB_TFT_ILI9340=m
CONFIG_FB_TFT_ILI9341=m
CONFIG_FB_TFT_ILI9481=m
CONFIG_FB_TFT_ILI9486=m
# CONFIG_FB_TFT_PCD8544 is not set
CONFIG_FB_TFT_RA8875=m
# CONFIG_FB_TFT_S6D02A1 is not set
# CONFIG_FB_TFT_S6D1121 is not set
# CONFIG_FB_TFT_SH1106 is not set
# CONFIG_FB_TFT_SSD1289 is not set
CONFIG_FB_TFT_SSD1305=m
# CONFIG_FB_TFT_SSD1306 is not set
# CONFIG_FB_TFT_SSD1331 is not set
CONFIG_FB_TFT_SSD1351=m
CONFIG_FB_TFT_ST7735R=m
CONFIG_FB_TFT_ST7789V=m
CONFIG_FB_TFT_TINYLCD=m
CONFIG_FB_TFT_TLS8204=m
CONFIG_FB_TFT_UC1611=m
# CONFIG_FB_TFT_UC1701 is not set
CONFIG_FB_TFT_UPD161704=m
CONFIG_FB_TFT_WATTEROTT=m
CONFIG_FB_FLEX=m
CONFIG_FB_TFT_FBTFT_DEVICE=m
# CONFIG_WILC1000_SDIO is not set
# CONFIG_WILC1000_SPI is not set
CONFIG_MOST=m
CONFIG_MOST_CDEV=m
# CONFIG_MOST_NET is not set
CONFIG_MOST_VIDEO=m
# CONFIG_MOST_DIM2 is not set
CONFIG_MOST_I2C=m
CONFIG_MOST_USB=m
CONFIG_KS7010=m
CONFIG_GREYBUS=m
CONFIG_GREYBUS_ES2=m
CONFIG_GREYBUS_AUDIO=m
# CONFIG_GREYBUS_BOOTROM is not set
CONFIG_GREYBUS_FIRMWARE=m
CONFIG_GREYBUS_HID=m
# CONFIG_GREYBUS_LIGHT is not set
# CONFIG_GREYBUS_LOG is not set
CONFIG_GREYBUS_LOOPBACK=m
# CONFIG_GREYBUS_POWER is not set
CONFIG_GREYBUS_RAW=m
CONFIG_GREYBUS_VIBRATOR=m
CONFIG_GREYBUS_BRIDGED_PHY=m
CONFIG_GREYBUS_GPIO=m
CONFIG_GREYBUS_I2C=m
CONFIG_GREYBUS_PWM=m
CONFIG_GREYBUS_SDIO=m
CONFIG_GREYBUS_SPI=m
# CONFIG_GREYBUS_UART is not set
CONFIG_GREYBUS_USB=m
CONFIG_PI433=y
CONFIG_MTK_MMC=m
CONFIG_MTK_AEE_KDUMP=y
# CONFIG_MTK_MMC_CD_POLL is not set

#
# Gasket devices
#
# CONFIG_STAGING_GASKET_FRAMEWORK is not set
# CONFIG_XIL_AXIS_FIFO is not set
CONFIG_EROFS_FS=y
# CONFIG_EROFS_FS_DEBUG is not set
CONFIG_EROFS_FS_XATTR=y
# CONFIG_EROFS_FS_POSIX_ACL is not set
# CONFIG_EROFS_FS_SECURITY is not set
CONFIG_EROFS_FS_USE_VM_MAP_RAM=y
# CONFIG_EROFS_FAULT_INJECTION is not set
CONFIG_EROFS_FS_IO_MAX_RETRIES=5
# CONFIG_EROFS_FS_ZIP is not set
# CONFIG_X86_PLATFORM_DEVICES is not set
CONFIG_PMC_ATOM=y
CONFIG_GOLDFISH_PIPE=m
CONFIG_CHROME_PLATFORMS=y
# CONFIG_CHROMEOS_LAPTOP is not set
CONFIG_CHROMEOS_PSTORE=y
# CONFIG_CHROMEOS_TBMC is not set
CONFIG_CROS_EC_CTL=y
CONFIG_CROS_EC_I2C=y
CONFIG_CROS_EC_SPI=y
# CONFIG_CROS_EC_LPC is not set
CONFIG_CROS_EC_PROTO=y
# CONFIG_CROS_KBD_LED_BACKLIGHT is not set
CONFIG_MELLANOX_PLATFORM=y
CONFIG_MLXREG_HOTPLUG=m
CONFIG_MLXREG_IO=m
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
# CONFIG_COMMON_CLK_WM831X is not set
# CONFIG_CLK_HSDK is not set
# CONFIG_COMMON_CLK_MAX77686 is not set
# CONFIG_COMMON_CLK_MAX9485 is not set
# CONFIG_COMMON_CLK_SI5351 is not set
# CONFIG_COMMON_CLK_SI514 is not set
# CONFIG_COMMON_CLK_SI544 is not set
# CONFIG_COMMON_CLK_SI570 is not set
# CONFIG_COMMON_CLK_CDCE706 is not set
# CONFIG_COMMON_CLK_CDCE925 is not set
# CONFIG_COMMON_CLK_CS2000_CP is not set
# CONFIG_COMMON_CLK_S2MPS11 is not set
# CONFIG_CLK_TWL6040 is not set
# CONFIG_COMMON_CLK_PWM is not set
# CONFIG_COMMON_CLK_VC5 is not set
CONFIG_HWSPINLOCK=y

#
# Clock Source drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_MAILBOX=y
CONFIG_PLATFORM_MHU=y
# CONFIG_PCC is not set
CONFIG_ALTERA_MBOX=m
# CONFIG_MAILBOX_TEST is not set
CONFIG_IOMMU_SUPPORT=y

#
# Generic IOMMU Pagetable Support
#
CONFIG_IOMMU_DEBUGFS=y
# CONFIG_AMD_IOMMU is not set

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=m

#
# Rpmsg drivers
#
CONFIG_RPMSG=m
# CONFIG_RPMSG_CHAR is not set
CONFIG_RPMSG_QCOM_GLINK_NATIVE=m
CONFIG_RPMSG_QCOM_GLINK_RPM=m
# CONFIG_RPMSG_VIRTIO is not set
CONFIG_SOUNDWIRE=y

#
# SoundWire Devices
#

#
# SOC (System On Chip) specific Drivers
#

#
# Amlogic SoC drivers
#

#
# Broadcom SoC drivers
#

#
# NXP/Freescale QorIQ SoC drivers
#

#
# i.MX SoC drivers
#

#
# Qualcomm SoC drivers
#
# CONFIG_SOC_TI is not set

#
# Xilinx SoC drivers
#
# CONFIG_XILINX_VCU is not set
# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_ADC_JACK=y
CONFIG_EXTCON_GPIO=m
# CONFIG_EXTCON_INTEL_INT3496 is not set
CONFIG_EXTCON_MAX3355=m
CONFIG_EXTCON_MAX77693=m
CONFIG_EXTCON_MAX77843=m
CONFIG_EXTCON_RT8973A=y
CONFIG_EXTCON_SM5502=m
CONFIG_EXTCON_USB_GPIO=y
# CONFIG_EXTCON_USBC_CROS_EC is not set
CONFIG_MEMORY=y
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=m
CONFIG_IIO_BUFFER_HW_CONSUMER=m
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGERED_BUFFER=y
CONFIG_IIO_CONFIGFS=m
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2
CONFIG_IIO_SW_DEVICE=m
# CONFIG_IIO_SW_TRIGGER is not set
CONFIG_IIO_TRIGGERED_EVENT=m

#
# Accelerometers
#
CONFIG_ADIS16201=m
# CONFIG_ADIS16209 is not set
CONFIG_ADXL345=m
CONFIG_ADXL345_I2C=m
# CONFIG_ADXL345_SPI is not set
CONFIG_ADXL372=m
# CONFIG_ADXL372_SPI is not set
CONFIG_ADXL372_I2C=m
CONFIG_BMA180=y
CONFIG_BMA220=m
CONFIG_BMC150_ACCEL=m
CONFIG_BMC150_ACCEL_I2C=m
CONFIG_BMC150_ACCEL_SPI=m
# CONFIG_DA280 is not set
CONFIG_DA311=m
# CONFIG_DMARD06 is not set
# CONFIG_DMARD09 is not set
CONFIG_DMARD10=y
CONFIG_HID_SENSOR_ACCEL_3D=m
CONFIG_IIO_CROS_EC_ACCEL_LEGACY=m
# CONFIG_IIO_ST_ACCEL_3AXIS is not set
CONFIG_KXSD9=m
CONFIG_KXSD9_SPI=m
CONFIG_KXSD9_I2C=m
CONFIG_KXCJK1013=y
# CONFIG_MC3230 is not set
CONFIG_MMA7455=y
CONFIG_MMA7455_I2C=y
# CONFIG_MMA7455_SPI is not set
CONFIG_MMA7660=m
CONFIG_MMA8452=y
CONFIG_MMA9551_CORE=y
CONFIG_MMA9551=y
CONFIG_MMA9553=y
CONFIG_MXC4005=y
# CONFIG_MXC6255 is not set
# CONFIG_SCA3000 is not set
CONFIG_STK8312=m
CONFIG_STK8BA50=m

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=y
CONFIG_AD7266=m
# CONFIG_AD7291 is not set
# CONFIG_AD7298 is not set
# CONFIG_AD7476 is not set
CONFIG_AD7766=m
CONFIG_AD7791=m
CONFIG_AD7793=y
CONFIG_AD7887=m
CONFIG_AD7923=y
# CONFIG_AD799X is not set
# CONFIG_CC10001_ADC is not set
# CONFIG_CPCAP_ADC is not set
# CONFIG_DA9150_GPADC is not set
CONFIG_ENVELOPE_DETECTOR=m
CONFIG_HI8435=m
CONFIG_HX711=m
# CONFIG_LP8788_ADC is not set
CONFIG_LTC2471=m
CONFIG_LTC2485=y
# CONFIG_LTC2497 is not set
CONFIG_MAX1027=m
CONFIG_MAX11100=m
CONFIG_MAX1118=m
# CONFIG_MAX1363 is not set
CONFIG_MAX9611=y
CONFIG_MCP320X=m
# CONFIG_MCP3422 is not set
CONFIG_MCP3911=y
CONFIG_MEN_Z188_ADC=y
# CONFIG_NAU7802 is not set
# CONFIG_SD_ADC_MODULATOR is not set
CONFIG_TI_ADC081C=m
# CONFIG_TI_ADC0832 is not set
CONFIG_TI_ADC084S021=y
CONFIG_TI_ADC12138=m
CONFIG_TI_ADC108S102=m
# CONFIG_TI_ADC128S052 is not set
CONFIG_TI_ADC161S626=y
CONFIG_TI_ADS1015=m
CONFIG_TI_ADS7950=m
# CONFIG_TI_ADS8688 is not set
CONFIG_TI_AM335X_ADC=m
CONFIG_TI_TLC4541=m
CONFIG_VF610_ADC=m
CONFIG_VIPERBOARD_ADC=m

#
# Analog Front Ends
#
CONFIG_IIO_RESCALE=y

#
# Amplifiers
#
CONFIG_AD8366=y

#
# Chemical Sensors
#
CONFIG_ATLAS_PH_SENSOR=m
CONFIG_BME680=m
CONFIG_BME680_I2C=m
CONFIG_BME680_SPI=m
CONFIG_CCS811=y
# CONFIG_IAQCORE is not set
CONFIG_VZ89X=y
CONFIG_IIO_CROS_EC_SENSORS_CORE=y
CONFIG_IIO_CROS_EC_SENSORS=m

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=m
CONFIG_HID_SENSOR_IIO_TRIGGER=m
CONFIG_IIO_MS_SENSORS_I2C=y

#
# SSP Sensor Common
#
# CONFIG_IIO_SSP_SENSORHUB is not set
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_SPI=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Counters
#

#
# Digital to analog converters
#
CONFIG_AD5064=y
CONFIG_AD5360=y
CONFIG_AD5380=y
CONFIG_AD5421=m
CONFIG_AD5446=m
CONFIG_AD5449=y
CONFIG_AD5592R_BASE=y
CONFIG_AD5592R=y
# CONFIG_AD5593R is not set
CONFIG_AD5504=y
CONFIG_AD5624R_SPI=y
CONFIG_LTC1660=m
# CONFIG_LTC2632 is not set
CONFIG_AD5686=y
CONFIG_AD5686_SPI=y
CONFIG_AD5696_I2C=y
CONFIG_AD5755=y
CONFIG_AD5758=y
CONFIG_AD5761=y
CONFIG_AD5764=m
CONFIG_AD5791=y
CONFIG_AD7303=y
# CONFIG_AD8801 is not set
CONFIG_DPOT_DAC=m
CONFIG_DS4424=m
CONFIG_M62332=m
# CONFIG_MAX517 is not set
# CONFIG_MAX5821 is not set
CONFIG_MCP4725=m
CONFIG_MCP4922=y
CONFIG_TI_DAC082S085=y
CONFIG_TI_DAC5571=m
# CONFIG_VF610_DAC is not set

#
# IIO dummy driver
#
# CONFIG_IIO_SIMPLE_DUMMY is not set

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
CONFIG_AD9523=y

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
CONFIG_ADF4350=y

#
# Digital gyroscope sensors
#
# CONFIG_ADIS16080 is not set
CONFIG_ADIS16130=m
CONFIG_ADIS16136=y
CONFIG_ADIS16260=y
# CONFIG_ADXRS450 is not set
# CONFIG_BMG160 is not set
CONFIG_HID_SENSOR_GYRO_3D=m
CONFIG_MPU3050=m
CONFIG_MPU3050_I2C=m
CONFIG_IIO_ST_GYRO_3AXIS=m
CONFIG_IIO_ST_GYRO_I2C_3AXIS=m
CONFIG_IIO_ST_GYRO_SPI_3AXIS=m
CONFIG_ITG3200=m

#
# Health Sensors
#

#
# Heart Rate Monitors
#
CONFIG_AFE4403=m
CONFIG_AFE4404=m
CONFIG_MAX30100=y
# CONFIG_MAX30102 is not set

#
# Humidity sensors
#
CONFIG_AM2315=m
CONFIG_DHT11=y
CONFIG_HDC100X=y
# CONFIG_HID_SENSOR_HUMIDITY is not set
CONFIG_HTS221=m
CONFIG_HTS221_I2C=m
CONFIG_HTS221_SPI=m
CONFIG_HTU21=m
CONFIG_SI7005=m
CONFIG_SI7020=m

#
# Inertial measurement units
#
# CONFIG_ADIS16400 is not set
CONFIG_ADIS16480=y
CONFIG_BMI160=m
# CONFIG_BMI160_I2C is not set
CONFIG_BMI160_SPI=m
CONFIG_KMX61=m
CONFIG_INV_MPU6050_IIO=y
CONFIG_INV_MPU6050_I2C=m
CONFIG_INV_MPU6050_SPI=y
# CONFIG_IIO_ST_LSM6DSX is not set
CONFIG_IIO_ADIS_LIB=y
CONFIG_IIO_ADIS_LIB_BUFFER=y

#
# Light sensors
#
# CONFIG_ACPI_ALS is not set
# CONFIG_ADJD_S311 is not set
CONFIG_AL3320A=y
CONFIG_APDS9300=y
CONFIG_APDS9960=y
CONFIG_BH1750=y
CONFIG_BH1780=m
# CONFIG_CM32181 is not set
CONFIG_CM3232=m
# CONFIG_CM3323 is not set
# CONFIG_CM3605 is not set
# CONFIG_CM36651 is not set
CONFIG_IIO_CROS_EC_LIGHT_PROX=y
# CONFIG_GP2AP020A00F is not set
CONFIG_SENSORS_ISL29018=m
# CONFIG_SENSORS_ISL29028 is not set
CONFIG_ISL29125=m
CONFIG_HID_SENSOR_ALS=m
CONFIG_HID_SENSOR_PROX=m
CONFIG_JSA1212=y
CONFIG_RPR0521=y
# CONFIG_SENSORS_LM3533 is not set
CONFIG_LTR501=y
CONFIG_LV0104CS=y
CONFIG_MAX44000=y
CONFIG_OPT3001=y
# CONFIG_PA12203001 is not set
CONFIG_SI1133=y
# CONFIG_SI1145 is not set
CONFIG_STK3310=y
# CONFIG_ST_UVIS25 is not set
# CONFIG_TCS3414 is not set
CONFIG_TCS3472=y
# CONFIG_SENSORS_TSL2563 is not set
# CONFIG_TSL2583 is not set
CONFIG_TSL2772=m
CONFIG_TSL4531=y
# CONFIG_US5182D is not set
# CONFIG_VCNL4000 is not set
CONFIG_VEML6070=m
CONFIG_VL6180=y
CONFIG_ZOPT2201=m

#
# Magnetometer sensors
#
# CONFIG_AK8974 is not set
CONFIG_AK8975=m
CONFIG_AK09911=m
CONFIG_BMC150_MAGN=y
CONFIG_BMC150_MAGN_I2C=y
# CONFIG_BMC150_MAGN_SPI is not set
CONFIG_MAG3110=y
CONFIG_HID_SENSOR_MAGNETOMETER_3D=m
CONFIG_MMC35240=y
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y
CONFIG_IIO_ST_MAGN_SPI_3AXIS=y
# CONFIG_SENSORS_HMC5843_I2C is not set
# CONFIG_SENSORS_HMC5843_SPI is not set

#
# Multiplexers
#
# CONFIG_IIO_MUX is not set

#
# Inclinometer sensors
#
CONFIG_HID_SENSOR_INCLINOMETER_3D=m
# CONFIG_HID_SENSOR_DEVICE_ROTATION is not set

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=y
CONFIG_IIO_SYSFS_TRIGGER=m

#
# Digital potentiometers
#
CONFIG_AD5272=m
# CONFIG_DS1803 is not set
CONFIG_MAX5481=m
CONFIG_MAX5487=m
CONFIG_MCP4018=m
# CONFIG_MCP4131 is not set
# CONFIG_MCP4531 is not set
CONFIG_TPL0102=y

#
# Digital potentiostats
#
CONFIG_LMP91000=m

#
# Pressure sensors
#
# CONFIG_ABP060MG is not set
CONFIG_BMP280=y
CONFIG_BMP280_I2C=y
CONFIG_BMP280_SPI=y
# CONFIG_IIO_CROS_EC_BARO is not set
CONFIG_HID_SENSOR_PRESS=m
CONFIG_HP03=y
CONFIG_MPL115=y
# CONFIG_MPL115_I2C is not set
CONFIG_MPL115_SPI=y
CONFIG_MPL3115=y
CONFIG_MS5611=y
CONFIG_MS5611_I2C=y
# CONFIG_MS5611_SPI is not set
CONFIG_MS5637=m
# CONFIG_IIO_ST_PRESS is not set
CONFIG_T5403=y
CONFIG_HP206C=m
CONFIG_ZPA2326=y
CONFIG_ZPA2326_I2C=y
CONFIG_ZPA2326_SPI=y

#
# Lightning sensors
#
CONFIG_AS3935=m

#
# Proximity and distance sensors
#
CONFIG_ISL29501=y
CONFIG_LIDAR_LITE_V2=y
CONFIG_RFD77402=m
CONFIG_SRF04=y
CONFIG_SX9500=m
CONFIG_SRF08=m
CONFIG_VL53L0X_I2C=m

#
# Resolver to digital converters
#
# CONFIG_AD2S1200 is not set

#
# Temperature sensors
#
# CONFIG_MAXIM_THERMOCOUPLE is not set
CONFIG_HID_SENSOR_TEMP=m
# CONFIG_MLX90614 is not set
CONFIG_MLX90632=y
CONFIG_TMP006=y
CONFIG_TMP007=m
# CONFIG_TSYS01 is not set
CONFIG_TSYS02D=y
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
# CONFIG_PWM_ATMEL_HLCDC_PWM is not set
CONFIG_PWM_CROS_EC=m
# CONFIG_PWM_FSL_FTM is not set
# CONFIG_PWM_LPSS_PCI is not set
# CONFIG_PWM_LPSS_PLATFORM is not set
CONFIG_PWM_PCA9685=m
# CONFIG_PWM_STMPE is not set

#
# IRQ chip support
#
CONFIG_IRQCHIP=y
CONFIG_ARM_GIC_MAX_NR=1
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
CONFIG_SERIAL_IPOCTAL=m
CONFIG_RESET_CONTROLLER=y
CONFIG_RESET_TI_SYSCON=y
CONFIG_FMC=m
CONFIG_FMC_FAKEDEV=m
CONFIG_FMC_TRIVIAL=m
CONFIG_FMC_WRITE_EEPROM=m
CONFIG_FMC_CHARDEV=m

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
# CONFIG_BCM_KONA_USB2_PHY is not set
CONFIG_PHY_CADENCE_DP=y
CONFIG_PHY_PXA_28NM_HSIC=m
CONFIG_PHY_PXA_28NM_USB2=m
# CONFIG_PHY_CPCAP_USB is not set
CONFIG_PHY_MAPPHONE_MDM6600=y
CONFIG_PHY_OCELOT_SERDES=y
CONFIG_PHY_QCOM_USB_HS=m
# CONFIG_PHY_QCOM_USB_HSIC is not set
CONFIG_PHY_TUSB1210=y
CONFIG_POWERCAP=y
# CONFIG_IDLE_INJECT is not set
CONFIG_MCB=y
# CONFIG_MCB_PCI is not set
# CONFIG_MCB_LPC is not set

#
# Performance monitor support
#
# CONFIG_RAS is not set
# CONFIG_THUNDERBOLT is not set

#
# Android
#
# CONFIG_ANDROID is not set
# CONFIG_LIBNVDIMM is not set
CONFIG_DAX=m
CONFIG_DEV_DAX=m
CONFIG_NVMEM=y

#
# HW tracing support
#
CONFIG_STM=m
CONFIG_STM_PROTO_BASIC=m
CONFIG_STM_PROTO_SYS_T=m
CONFIG_STM_DUMMY=m
CONFIG_STM_SOURCE_CONSOLE=m
CONFIG_STM_SOURCE_HEARTBEAT=m
CONFIG_INTEL_TH=m
# CONFIG_INTEL_TH_PCI is not set
# CONFIG_INTEL_TH_ACPI is not set
CONFIG_INTEL_TH_GTH=m
# CONFIG_INTEL_TH_STH is not set
CONFIG_INTEL_TH_MSU=m
# CONFIG_INTEL_TH_PTI is not set
CONFIG_INTEL_TH_DEBUG=y
CONFIG_FPGA=y
CONFIG_ALTERA_PR_IP_CORE=m
CONFIG_ALTERA_PR_IP_CORE_PLAT=m
CONFIG_FPGA_MGR_ALTERA_PS_SPI=m
# CONFIG_FPGA_MGR_ALTERA_CVP is not set
CONFIG_FPGA_MGR_XILINX_SPI=y
CONFIG_FPGA_MGR_ICE40_SPI=m
CONFIG_FPGA_MGR_MACHXO2_SPI=y
CONFIG_FPGA_BRIDGE=y
CONFIG_XILINX_PR_DECOUPLER=m
CONFIG_FPGA_REGION=y
CONFIG_OF_FPGA_REGION=y
CONFIG_FPGA_DFL=y
CONFIG_FPGA_DFL_FME=y
CONFIG_FPGA_DFL_FME_MGR=y
# CONFIG_FPGA_DFL_FME_BRIDGE is not set
# CONFIG_FPGA_DFL_FME_REGION is not set
# CONFIG_FPGA_DFL_AFU is not set
# CONFIG_FPGA_DFL_PCI is not set
CONFIG_FSI=m
# CONFIG_FSI_NEW_DEV_NODE is not set
# CONFIG_FSI_MASTER_GPIO is not set
CONFIG_FSI_MASTER_HUB=m
CONFIG_FSI_SCOM=m
CONFIG_FSI_SBEFIFO=m
CONFIG_MULTIPLEXER=m

#
# Multiplexer drivers
#
CONFIG_MUX_ADG792A=m
# CONFIG_MUX_ADGS1408 is not set
CONFIG_MUX_GPIO=m
CONFIG_MUX_MMIO=m
# CONFIG_UNISYS_VISORBUS is not set
CONFIG_SIOX=m
# CONFIG_SIOX_BUS_GPIO is not set
CONFIG_SLIMBUS=y
CONFIG_SLIM_QCOM_CTRL=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_FS_IOMAP=y
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_FS_POSIX_ACL is not set
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
# CONFIG_EXT4_USE_FOR_EXT2 is not set
# CONFIG_EXT4_FS_POSIX_ACL is not set
CONFIG_EXT4_FS_SECURITY=y
CONFIG_EXT4_ENCRYPTION=y
CONFIG_EXT4_FS_ENCRYPTION=y
# CONFIG_EXT4_FS_VERITY is not set
CONFIG_EXT4_DEBUG=y
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=m
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
# CONFIG_XFS_ONLINE_SCRUB is not set
CONFIG_XFS_DEBUG=y
# CONFIG_XFS_ASSERT_FATAL is not set
CONFIG_GFS2_FS=m
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
# CONFIG_OCFS2_FS_STATS is not set
CONFIG_OCFS2_DEBUG_MASKLOG=y
CONFIG_OCFS2_DEBUG_FS=y
CONFIG_BTRFS_FS=m
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
CONFIG_BTRFS_ASSERT=y
CONFIG_BTRFS_FS_REF_VERIFY=y
CONFIG_NILFS2_FS=y
CONFIG_F2FS_FS=y
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
CONFIG_F2FS_FS_POSIX_ACL=y
CONFIG_F2FS_FS_SECURITY=y
# CONFIG_F2FS_CHECK_FS is not set
# CONFIG_F2FS_FS_ENCRYPTION is not set
# CONFIG_F2FS_FAULT_INJECTION is not set
# CONFIG_FS_DAX is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
# CONFIG_EXPORTFS_BLOCK_OPS is not set
CONFIG_FILE_LOCKING=y
CONFIG_MANDATORY_FILE_LOCKING=y
CONFIG_FS_ENCRYPTION=y
# CONFIG_FS_VERITY is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
# CONFIG_AUTOFS4_FS is not set
# CONFIG_AUTOFS_FS is not set
# CONFIG_FUSE_FS is not set
CONFIG_OVERLAY_FS=y
CONFIG_OVERLAY_FS_REDIRECT_DIR=y
# CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW is not set
# CONFIG_OVERLAY_FS_INDEX is not set
# CONFIG_OVERLAY_FS_XINO_AUTO is not set
# CONFIG_OVERLAY_FS_METACOPY is not set

#
# Caches
#
CONFIG_FSCACHE=m
CONFIG_FSCACHE_STATS=y
CONFIG_FSCACHE_HISTOGRAM=y
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
# CONFIG_CACHEFILES is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
# CONFIG_VFAT_FS is not set
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_NTFS_FS=y
CONFIG_NTFS_DEBUG=y
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_VMCORE_DEVICE_DUMP=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_PROC_CHILDREN=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
# CONFIG_HUGETLBFS is not set
CONFIG_MEMFD_CREATE=y
CONFIG_ARCH_HAS_GIGANTIC_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ORANGEFS_FS is not set
CONFIG_ADFS_FS=m
CONFIG_ADFS_FS_RW=y
# CONFIG_AFFS_FS is not set
CONFIG_ECRYPT_FS=m
# CONFIG_ECRYPT_FS_MESSAGING is not set
CONFIG_HFS_FS=y
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
CONFIG_EFS_FS=y
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
# CONFIG_JFFS2_FS_WRITEBUFFER is not set
# CONFIG_JFFS2_SUMMARY is not set
CONFIG_JFFS2_FS_XATTR=y
CONFIG_JFFS2_FS_POSIX_ACL=y
CONFIG_JFFS2_FS_SECURITY=y
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
CONFIG_JFFS2_ZLIB=y
CONFIG_JFFS2_LZO=y
# CONFIG_JFFS2_RTIME is not set
# CONFIG_JFFS2_RUBIN is not set
CONFIG_JFFS2_CMODE_NONE=y
# CONFIG_JFFS2_CMODE_PRIORITY is not set
# CONFIG_JFFS2_CMODE_SIZE is not set
# CONFIG_JFFS2_CMODE_FAVOURLZO is not set
CONFIG_UBIFS_FS_AUTHENTICATION=y
CONFIG_CRAMFS=y
CONFIG_CRAMFS_BLOCKDEV=y
CONFIG_CRAMFS_MTD=y
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=m
CONFIG_OMFS_FS=m
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
CONFIG_QNX6FS_FS=y
# CONFIG_QNX6FS_DEBUG is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=m
CONFIG_PSTORE_DEFLATE_COMPRESS=m
CONFIG_PSTORE_LZO_COMPRESS=m
CONFIG_PSTORE_LZ4_COMPRESS=m
# CONFIG_PSTORE_LZ4HC_COMPRESS is not set
# CONFIG_PSTORE_842_COMPRESS is not set
# CONFIG_PSTORE_ZSTD_COMPRESS is not set
CONFIG_PSTORE_COMPRESS=y
# CONFIG_PSTORE_DEFLATE_COMPRESS_DEFAULT is not set
# CONFIG_PSTORE_LZO_COMPRESS_DEFAULT is not set
CONFIG_PSTORE_LZ4_COMPRESS_DEFAULT=y
CONFIG_PSTORE_COMPRESS_DEFAULT="lz4"
CONFIG_PSTORE_CONSOLE=y
CONFIG_PSTORE_PMSG=y
CONFIG_PSTORE_RAM=m
CONFIG_SYSV_FS=y
CONFIG_UFS_FS=y
CONFIG_UFS_FS_WRITE=y
CONFIG_UFS_DEBUG=y
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V2=y
CONFIG_NFS_V3=y
# CONFIG_NFS_V3_ACL is not set
CONFIG_NFS_V4=m
# CONFIG_NFS_SWAP is not set
# CONFIG_NFS_V4_1 is not set
# CONFIG_ROOT_NFS is not set
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
# CONFIG_NFSD is not set
CONFIG_GRACE_PERIOD=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=m
CONFIG_RPCSEC_GSS_KRB5=m
# CONFIG_SUNRPC_DEBUG is not set
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=m
# CONFIG_CIFS_STATS2 is not set
CONFIG_CIFS_ALLOW_INSECURE_LEGACY=y
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_UPCALL is not set
# CONFIG_CIFS_XATTR is not set
CONFIG_CIFS_DEBUG=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DEBUG_DUMP_KEYS is not set
# CONFIG_CIFS_DFS_UPCALL is not set
# CONFIG_CIFS_FSCACHE is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
# CONFIG_9P_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=m
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=y
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=m
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=m
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=m
CONFIG_NLS_MAC_ROMANIAN=m
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=m
# CONFIG_DLM is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_COMPAT=y
CONFIG_PERSISTENT_KEYRINGS=y
# CONFIG_BIG_KEYS is not set
CONFIG_ENCRYPTED_KEYS=m
CONFIG_KEY_DH_OPERATIONS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_PAGE_TABLE_ISOLATION=y
CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR=y
# CONFIG_HARDENED_USERCOPY is not set
CONFIG_FORTIFY_SOURCE=y
CONFIG_STATIC_USERMODEHELPER=y
CONFIG_STATIC_USERMODEHELPER_PATH="/sbin/usermode-helper"
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
CONFIG_ASYNC_RAID6_RECOV=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_RNG_DEFAULT=y
CONFIG_CRYPTO_AKCIPHER2=y
CONFIG_CRYPTO_AKCIPHER=y
CONFIG_CRYPTO_KPP2=y
CONFIG_CRYPTO_KPP=y
CONFIG_CRYPTO_ACOMP2=y
CONFIG_CRYPTO_RSA=y
CONFIG_CRYPTO_DH=y
CONFIG_CRYPTO_ECDH=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=y
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_NULL2=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_SIMD=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y
CONFIG_CRYPTO_ENGINE=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_CHACHA20POLY1305=m
CONFIG_CRYPTO_AEGIS128=m
CONFIG_CRYPTO_AEGIS128L=m
CONFIG_CRYPTO_AEGIS256=m
CONFIG_CRYPTO_AEGIS128_AESNI_SSE2=m
# CONFIG_CRYPTO_AEGIS128L_AESNI_SSE2 is not set
CONFIG_CRYPTO_AEGIS256_AESNI_SSE2=y
# CONFIG_CRYPTO_MORUS640 is not set
CONFIG_CRYPTO_MORUS640_GLUE=m
CONFIG_CRYPTO_MORUS640_SSE2=m
CONFIG_CRYPTO_MORUS1280=y
CONFIG_CRYPTO_MORUS1280_GLUE=m
CONFIG_CRYPTO_MORUS1280_SSE2=m
# CONFIG_CRYPTO_MORUS1280_AVX2 is not set
CONFIG_CRYPTO_SEQIV=y
# CONFIG_CRYPTO_ECHAINIV is not set

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CFB=m
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_OFB=m
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y
CONFIG_CRYPTO_KEYWRAP=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=m
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_POLY1305=m
# CONFIG_CRYPTO_POLY1305_X86_64 is not set
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=m
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
# CONFIG_CRYPTO_SHA256_SSSE3 is not set
CONFIG_CRYPTO_SHA512_SSSE3=m
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=m
# CONFIG_CRYPTO_SHA3 is not set
# CONFIG_CRYPTO_SM3 is not set
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_TI is not set
CONFIG_CRYPTO_AES_X86_64=m
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=m
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_DES3_EDE_X86_64 is not set
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_CHACHA20=y
CONFIG_CRYPTO_CHACHA20_X86_64=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
CONFIG_CRYPTO_SERPENT_AVX_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=m
CONFIG_CRYPTO_SM4=m
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=m
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_LZO=m
CONFIG_CRYPTO_842=y
CONFIG_CRYPTO_LZ4=y
CONFIG_CRYPTO_LZ4HC=m
CONFIG_CRYPTO_ZSTD=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_DRBG_MENU=y
CONFIG_CRYPTO_DRBG_HMAC=y
CONFIG_CRYPTO_DRBG_HASH=y
# CONFIG_CRYPTO_DRBG_CTR is not set
CONFIG_CRYPTO_DRBG=y
CONFIG_CRYPTO_JITTERENTROPY=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=m
CONFIG_CRYPTO_USER_API_SKCIPHER=m
CONFIG_CRYPTO_USER_API_RNG=y
CONFIG_CRYPTO_USER_API_AEAD=m
# CONFIG_CRYPTO_STATS is not set
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
CONFIG_CRYPTO_DEV_PADLOCK_AES=y
# CONFIG_CRYPTO_DEV_PADLOCK_SHA is not set
# CONFIG_CRYPTO_DEV_CCP is not set
# CONFIG_CRYPTO_DEV_QAT_DH895xCC is not set
# CONFIG_CRYPTO_DEV_QAT_C3XXX is not set
# CONFIG_CRYPTO_DEV_QAT_C62X is not set
# CONFIG_CRYPTO_DEV_QAT_DH895xCCVF is not set
# CONFIG_CRYPTO_DEV_QAT_C3XXXVF is not set
# CONFIG_CRYPTO_DEV_QAT_C62XVF is not set
CONFIG_CRYPTO_DEV_VIRTIO=m
# CONFIG_CRYPTO_DEV_CCREE is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_PKCS8_PRIVATE_KEY_PARSER=m
CONFIG_PKCS7_MESSAGE_PARSER=y
CONFIG_PKCS7_TEST_KEY=y
# CONFIG_SIGNED_PE_FILE_VERIFICATION is not set

#
# Certificates for signature checking
#
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_SYSTEM_TRUSTED_KEYS=""
CONFIG_SYSTEM_EXTRA_CERTIFICATE=y
CONFIG_SYSTEM_EXTRA_CERTIFICATE_SIZE=4096
# CONFIG_SECONDARY_TRUSTED_KEYRING is not set
# CONFIG_SYSTEM_BLACKLIST_KEYRING is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=m
CONFIG_BITREVERSE=y
CONFIG_RATIONAL=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=m
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC64=m
CONFIG_CRC4=m
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=m
CONFIG_XXHASH=y
CONFIG_RANDOM32_SELFTEST=y
CONFIG_842_COMPRESS=y
CONFIG_842_DECOMPRESS=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4HC_COMPRESS=m
CONFIG_LZ4_DECOMPRESS=y
CONFIG_ZSTD_COMPRESS=y
CONFIG_ZSTD_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_XARRAY_MULTI=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DMA_DIRECT_OPS=y
CONFIG_SWIOTLB=y
CONFIG_SGL_ALLOC=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_GLOB=y
CONFIG_GLOB_SELFTEST=y
CONFIG_NLATTR=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=m
CONFIG_DDR=y
CONFIG_IRQ_POLL=y
CONFIG_MPILIB=y
CONFIG_LIBFDT=y
CONFIG_OID_REGISTRY=y
CONFIG_FONT_SUPPORT=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_SG_POOL=y
CONFIG_ARCH_HAS_SG_CHAIN=y
CONFIG_ARCH_HAS_PMEM_API=y
CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE=y
CONFIG_ARCH_HAS_UACCESS_MCSAFE=y
CONFIG_STACKDEPOT=y
CONFIG_SBITMAP=y
CONFIG_STRING_SELFTEST=y

#
# Kernel hacking
#

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_CONSOLE_LOGLEVEL_DEFAULT=7
CONFIG_CONSOLE_LOGLEVEL_QUIET=4
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_INFO_REDUCED=y
# CONFIG_DEBUG_INFO_SPLIT is not set
# CONFIG_DEBUG_INFO_DWARF4 is not set
# CONFIG_GDB_SCRIPTS is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
CONFIG_READABLE_ASM=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_PAGE_OWNER=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
# CONFIG_SECTION_MISMATCH_WARN_ONLY is not set
CONFIG_STACK_VALIDATION=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
# CONFIG_MAGIC_SYSRQ_SERIAL is not set
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_PAGE_EXTENSION=y
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_DEBUG_PAGEALLOC_ENABLE_DEFAULT=y
# CONFIG_PAGE_POISONING is not set
CONFIG_DEBUG_PAGE_REF=y
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
# CONFIG_DEBUG_OBJECTS_WORK is not set
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_SLUB_DEBUG_ON is not set
CONFIG_SLUB_STATS=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_VMACACHE is not set
# CONFIG_DEBUG_VM_RB is not set
CONFIG_DEBUG_VM_PGFLAGS=y
CONFIG_ARCH_HAS_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=y
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KASAN=y
# CONFIG_KASAN is not set
CONFIG_ARCH_HAS_KCOV=y
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_SOFTLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
CONFIG_HARDLOCKUP_CHECK_TIMESTAMP=y
# CONFIG_HARDLOCKUP_DETECTOR is not set
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_WQ_WATCHDOG=y
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
# CONFIG_SCHED_STACK_END_CHECK is not set
CONFIG_DEBUG_TIMEKEEPING=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_LOCK_DEBUGGING_SUPPORT=y
CONFIG_PROVE_LOCKING=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_RWSEMS=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_LOCKDEP=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_LOCK_TORTURE_TEST=m
# CONFIG_WW_MUTEX_SELFTEST is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_WARN_ALL_UNSEEDED_RANDOM is not set
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_KOBJECT_RELEASE is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
CONFIG_TORTURE_TEST=m
CONFIG_RCU_PERF_TEST=m
CONFIG_RCU_TORTURE_TEST=m
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_TRACE=y
# CONFIG_RCU_EQS_DEBUG is not set
# CONFIG_DEBUG_WQ_FORCE_RR_CPU is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_CPU_HOTPLUG_STATE_CONTROL is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
CONFIG_NETDEV_NOTIFIER_ERROR_INJECT=m
CONFIG_FUNCTION_ERROR_INJECTION=y
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_PREEMPTIRQ_TRACEPOINTS=y
CONFIG_TRACING=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_RUNTIME_TESTING_MENU is not set
# CONFIG_MEMTEST is not set
# CONFIG_BUG_ON_DATA_CORRUPTION is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
CONFIG_UBSAN=y
# CONFIG_UBSAN_SANITIZE_ALL is not set
# CONFIG_UBSAN_ALIGNMENT is not set
# CONFIG_TEST_UBSAN is not set
CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_EARLY_PRINTK_USB_XDBC is not set
CONFIG_X86_PTDUMP_CORE=y
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_WX=y
CONFIG_DOUBLEFAULT=y
CONFIG_DEBUG_TLBFLUSH=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=1
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
CONFIG_DEBUG_ENTRY=y
CONFIG_DEBUG_NMI_SELFTEST=y
# CONFIG_X86_DEBUG_FPU is not set
# CONFIG_PUNIT_ATOM_DEBUG is not set
CONFIG_UNWINDER_ORC=y
# CONFIG_UNWINDER_FRAME_POINTER is not set

--3IyuMspwcGTbYISR--
