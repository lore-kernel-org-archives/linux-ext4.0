From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 113041] New: mbcache NULL pointer dereference
Date: Wed, 24 Feb 2016 10:05:11 +0000
Message-ID: <bug-113041-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:38956 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753758AbcBXKFR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Feb 2016 05:05:17 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id EB89E20256
	for <linux-ext4@vger.kernel.org>; Wed, 24 Feb 2016 10:05:14 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 91C41202C8
	for <linux-ext4@vger.kernel.org>; Wed, 24 Feb 2016 10:05:12 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=113041

            Bug ID: 113041
           Summary: mbcache NULL pointer dereference
           Product: File System
           Version: 2.5
    Kernel Version: 4.2.2
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: johnny+bugzilla@appdata.biz
        Regression: No

Experienced a sudden restart without any noticeable load except high memory
usage.
Logged crash message below:

[1500169.920760] BUG: unable to handle kernel NULL pointer dereference at      
    (null)
[1500169.921056] IP: [<ffffffffa00f4fb9>] mb_cache_shrink+0x2c9/0x3a0 [mbcache]
[1500169.921056] PGD 78938f067 PUD 30aa81067 PMD 0 
[1500169.921056] Oops: 0000 [#1] SMP 
[1500169.921056] Modules linked in: xt_conntrack ipt_MASQUERADE
nf_nat_masquerade_ipv4 vxlan ip6_udp_tunnel udp_tunnel iptable_nat
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype iptable_filter
br_netfilter nf_nat nf_conntrack bridge stp llc xfs libcrc32c nls_ascii
nls_cp437 vfat fat xenfs xen_privcmd ext4 crc16 mbcache jbd2 crc32c_intel hmac
ata_piix drbg libata aesni_intel aes_x86_64 glue_helper lrw mousedev gf128mul
ablk_helper cryptd i2c_piix4 xen_blkfront microcode scsi_mod firmware_class
ixgbevf i2c_core psmouse evdev acpi_cpufreq button sch_fq_codel ip_tables
autofs4
[1500169.921056] CPU: 0 PID: 23022 Comm: java Not tainted 4.2.2-coreos-r2 #2
[1500169.921056] Hardware name: Xen HVM domU, BIOS 4.2.amazon 12/07/2015
[1500169.921056] task: ffff8800eba50000 ti: ffff8800270fc000 task.ti:
ffff8800270fc000
[1500169.921056] RIP: 0010:[<ffffffffa00f4fb9>]  [<ffffffffa00f4fb9>]
mb_cache_shrink+0x2c9/0x3a0 [mbcache]
[1500169.921056] RSP: 0018:ffff8800270ff358  EFLAGS: 00010213
[1500169.921056] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
0000000180270025
[1500169.921056] RDX: 0000000180270026 RSI: ffffea001ce5fcc0 RDI:
0000000000000000
[1500169.921056] RBP: ffff8800270ff388 R08: 00000000397f3e01 R09:
0000000180270025
[1500169.921056] R10: ffff8807b0e18f80 R11: ffff8807397f3e38 R12:
ffff8800270ff358
[1500169.921056] R13: 0000000000000036 R14: 0000000000000080 R15:
ffffffffa00f7000
[1500169.921056] FS:  00007f43d702d700(0000) GS:ffff8807b0e00000(0000)
knlGS:0000000000000000
[1500169.921056] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[1500169.921056] CR2: 0000000000000000 CR3: 00000002f1e43000 CR4:
00000000001406f0
[1500169.921056] Stack:
[1500169.921056]  ffff880584aebf70 ffff8803d200b208 0000000000000000
0000000000000098
[1500169.921056]  0000000000000080 000000000000004c ffff8800270ff468
ffffffff8115ef3d
[1500169.921056]  ffff880000000003 ffffffff8109cd00 ffff880000000001
ffff880788906340
[1500169.921056] Call Trace:
[1500169.921056]  [<ffffffff8115ef3d>] shrink_slab+0x1ed/0x370
[1500169.921056]  [<ffffffff8109cd00>] ? enqueue_entity+0x3e0/0xdc0
[1500169.921056]  [<ffffffff81163283>] shrink_zone+0x283/0x290
[1500169.921056]  [<ffffffff811633ec>] do_try_to_free_pages+0x15c/0x430
[1500169.921056]  [<ffffffff8116377a>] try_to_free_pages+0xba/0x130
[1500169.921056]  [<ffffffff8115658a>] __alloc_pages_nodemask+0x56a/0x970
[1500169.921056]  [<ffffffff81199221>] alloc_pages_current+0x91/0x100
[1500169.921056]  [<ffffffff811a3d9c>] new_slab+0x34c/0x440
[1500169.921056]  [<ffffffff810afc01>] ?
__raw_callee_save___pv_queued_spin_unlock+0x11/0x20
[1500169.921056]  [<ffffffff811a4239>] __slab_alloc+0x3a9/0x490
[1500169.921056]  [<ffffffffa01e5a6f>] ? ext4_orphan_del+0x47ff/0xda20 [ext4]
[1500169.921056]  [<ffffffff8126818c>] ? hashtab_search+0x5c/0x80
[1500169.921056]  [<ffffffff81274787>] ? mls_level_isvalid+0x57/0x60
[1500169.921056]  [<ffffffffa01e5a6f>] ? ext4_orphan_del+0x47ff/0xda20 [ext4]
[1500169.921056]  [<ffffffff811a44b1>] kmem_cache_alloc+0x191/0x1f0
[1500169.921056]  [<ffffffffa01e5a6f>] ext4_orphan_del+0x47ff/0xda20 [ext4]
[1500169.921056]  [<ffffffff811d7a9d>] alloc_inode+0x1d/0x90
[1500169.921056]  [<ffffffff811d98a1>] new_inode_pseudo+0x11/0x60
[1500169.921056]  [<ffffffff811d990b>] new_inode+0x1b/0x40
[1500169.921056]  [<ffffffffa01cec7f>] __ext4_new_inode+0x7f/0x1190 [ext4]
[1500169.921056]  [<ffffffffa01df63c>] ext4_insert_dentry+0x188c/0x1900 [ext4]
[1500169.921056]  [<ffffffff811c9e2a>] vfs_create+0xca/0x130
[1500169.921056]  [<ffffffff8123c748>] ovl_create_real+0xb8/0x230
[1500169.921056]  [<ffffffff8123d9ab>] ovl_create_or_link+0x10b/0x500
[1500169.921056]  [<ffffffff8123dddd>] ovl_create_object+0x3d/0x60
[1500169.921056]  [<ffffffff8125d533>] ? selinux_inode_create+0x13/0x20
[1500169.921056]  [<ffffffff8123deb1>] ovl_create+0x21/0x30
[1500169.921056]  [<ffffffff811c9e2a>] vfs_create+0xca/0x130
[1500169.921056]  [<ffffffff811cc3f1>] path_openat+0xab1/0x13e0
[1500169.921056]  [<ffffffff811cce9b>] ? putname+0x5b/0x60
[1500169.921056]  [<ffffffff81090f6f>] ? wake_up_q+0x2f/0x70
[1500169.921056]  [<ffffffff811a4499>] ? kmem_cache_alloc+0x179/0x1f0
[1500169.921056]  [<ffffffff811cdddb>] do_filp_open+0x7b/0xe0
[1500169.921056]  [<ffffffff811daeb9>] ? __alloc_fd+0x89/0x110
[1500169.921056]  [<ffffffff811bd27c>] do_sys_open+0x12c/0x210
[1500169.921056]  [<ffffffff81021b4f>] ? syscall_trace_enter_phase1+0xff/0x150
[1500169.921056]  [<ffffffff811bd37e>] SyS_open+0x1e/0x20
[1500169.921056]  [<ffffffff8152bbae>] entry_SYSCALL_64_fastpath+0x12/0x71
[1500169.921056] Code: 4c 89 ef ff 14 25 c8 b8 a2 81 48 8b 7d d0 45 31 ed 4c 39
e7 48 8b 1f 74 17 e8 04 f1 ff ff 48 89 d8 49 83 c5 01 48 89 df 4c 39 e0 <48> 8b
1b 75 e9 48 83 c4 18 4c 89 e8 5b 41 5c 41 5d 5d c3 f3 90 
[1500169.921056] RIP  [<ffffffffa00f4fb9>] mb_cache_shrink+0x2c9/0x3a0
[mbcache]
[1500169.921056]  RSP <ffff8800270ff358>
[1500169.921056] CR2: 0000000000000000
[1500170.273210] ---[ end trace 76bceb77fead570b ]---
[1500170.278279] Kernel panic - not syncing: Fatal exception
[1500170.282063] Kernel Offset: disabled


Additional information collected after reboot:

cat /proc/version
Linux version 4.2.2-coreos-r2 (buildbot@ip-10-204-3-57) (gcc version 4.9.3
(Gentoo Hardened 4.9.3 p1.2, pie-0.6.3) ) #2 SMP Tue Feb 2 13:27:19 UTC 2016

cat /proc/meminfo
MemTotal:       31419640 kB
MemFree:         1313584 kB
MemAvailable:   13120824 kB
Buffers:         1164008 kB
Cached:          9589260 kB
SwapCached:            0 kB
Active:         11727272 kB
Inactive:        7908784 kB
Active(anon):    8903468 kB
Inactive(anon):      344 kB
Active(file):    2823804 kB
Inactive(file):  7908440 kB
Unevictable:     8990544 kB
Mlocked:         8990544 kB
SwapTotal:             0 kB
SwapFree:              0 kB
Dirty:                96 kB
Writeback:             0 kB
AnonPages:      17873320 kB
Mapped:           373056 kB
Shmem:               696 kB
Slab:            1337196 kB
SReclaimable:    1158852 kB
SUnreclaim:       178344 kB
KernelStack:        8816 kB
PageTables:        41244 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    15709820 kB
Committed_AS:   24212340 kB
VmallocTotal:   34359738367 kB
VmallocUsed:       61388 kB
VmallocChunk:   34359668736 kB
HardwareCorrupted:     0 kB
AnonHugePages:  17457152 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:      180224 kB
DirectMap2M:    31950848 kB

processor    : 0
vendor_id    : GenuineIntel
cpu family    : 6
model        : 62
model name    : Intel(R) Xeon(R) CPU E5-2670 v2 @ 2.50GHz
stepping    : 4
microcode    : 0x428
cpu MHz        : 2494.012
cache size    : 25600 KB
physical id    : 0
siblings    : 4
core id        : 0
cpu cores    : 2
apicid        : 0
initial apicid    : 0
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm constant_tsc
rep_good nopl xtopology eagerfpu pni pclmulqdq ssse3 cx16 pcid sse4_1 sse4_2
x2apic popcnt tsc_deadline_timer aes xsave avx f16c rdrand hypervisor lahf_lm
fsgsbase smep erms xsaveopt
bugs        :
bogomips    : 4988.02
clflush size    : 64
cache_alignment    : 64
address sizes    : 46 bits physical, 48 bits virtual
power management:
....

Java application that triggered the crash: Cassandra 2.1.12

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
