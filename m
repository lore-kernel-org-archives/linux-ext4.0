From: Li Wang <liwang@redhat.com>
Subject: [BUG] Unable to handle kernel paging request for unaligned access at
 address 0xc0000001c52c53df
Date: Tue, 6 Jun 2017 18:00:34 +0800
Message-ID: <CAEemH2fq0ciRxhpi2m7Rv1HTyzB1z=jFkEUOvan5jtSkw-tDSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-kernel@vger.kernel.org, ltp@lists.linux.it,
        linux-ext4@vger.kernel.org, Chunyu Hu <chuhu@redhat.com>
To: ebiggers@google.com, jack@suse.cz, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ua0-f170.google.com ([209.85.217.170]:36387 "EHLO
        mail-ua0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751329AbdFFKAf (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Jun 2017 06:00:35 -0400
Received: by mail-ua0-f170.google.com with SMTP id h39so36016660uaa.3
        for <linux-ext4@vger.kernel.org>; Tue, 06 Jun 2017 03:00:35 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

ltp/access04 always panic the latest mainstream kernel-4.12-rc4 on
ppc64le. From the calltrace
I guess the reason is probably that the tests mount ext2 file system
using ext4 driver.

A simple way to reproduce:

# dd of=wangli if=/dev/zero count=1024 bs=1024
# mkfs -t ext2 wangli
# mount -t ext4 wangli /mnt/


Are there any new changes in ext4 (on kernel-4.12-rc4) recently?


[  318.557844] EXT4-fs (loop0): mounting ext2 file system using the
ext4 subsystem
[  318.558104] Unable to handle kernel paging request for unaligned
access at address 0xc0000001c52c53df
[  318.558109] Faulting instruction address: 0xc000000000918b28
[  318.558114] Oops: Kernel access of bad area, sig: 7 [#1]
[  318.558117] SMP NR_CPUS=2048
[  318.558117] NUMA
[  318.558120] pSeries
[  318.558124] Modules linked in: ext4 jbd2 mbcache loop
rpcsec_gss_krb5 nfsv4 dns_resolver nfs fscache sg pseries_rng nfsd
auth_rpcgss nfs_acl lockd ghash_generic gf128mul xts vmx_crypto grace
sunrpc ip_tables xfs libcrc32c sd_mod ibmvscsi ibmveth
scsi_transport_srp dm_mirror dm_region_hash dm_log dm_mod
[  318.558152] CPU: 2 PID: 40748 Comm: access04 Not tainted 4.12.0-rc4 #1
[  318.558155] task: c0000003889fb200 task.stack: c0000003ac134000
[  318.558158] NIP: c000000000918b28 LR: c00000000011c5d4 CTR: c000000000130900
[  318.558162] REGS: c0000003ac137420 TRAP: 0600   Not tainted  (4.12.0-rc4)
[  318.558164] MSR: 800000010280b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE,TM[E]>
[  318.558171]   CR: 28028842  XER: 00000000
[  318.558174] CFAR: c00000000011c5d0 DAR: c0000001c52c53df DSISR:
00000000 SOFTE: 0
[  318.558174] GPR00: c00000000011c5d4 c0000003ac1376a0
c000000001049000 c0000001c52c53df
[  318.558174] GPR04: c0000004788657f0 0000000000000000
0000000000000000 0000000000000001
[  318.558174] GPR08: 0000000477be0000 0000000000000000
0000000080000002 0000000000000000
[  318.558174] GPR12: c000000000130900 c00000000fac1500
0000000000000000 c0000004648b6800
[  318.558174] GPR16: 0000000000000000 c000000408ad0400
0000000000000000 0000000000040001
[  318.558174] GPR20: 0000000000000001 0000000000000000
0000000000004000 c000000000cc5780
[  318.558174] GPR24: 00000001c45ffc5f 0000000000000000
c000000000cc5780 c0000001c52c53df
[  318.558174] GPR28: c000000009d06034 0000000000000004
0000000000000800 c0000001c52c53df
[  318.558222] NIP [c000000000918b28] _raw_spin_lock+0x28/0xc0
[  318.558226] LR [c00000000011c5d4] try_to_wake_up+0x1f4/0x5b0
[  318.558229] Call Trace:
[  318.558231] [c0000003ac1376a0] [c000000009d06034]
0xc000000009d06034 (unreliable)
[  318.558236] [c0000003ac1376d0] [c00000000011c5d4] try_to_wake_up+0x1f4/0x5b0
[  318.558241] [c0000003ac137750] [c000000000102828] create_worker+0x148/0x250
[  318.558245] [c0000003ac1377f0] [c0000000001059dc]
alloc_unbound_pwq+0x3bc/0x4c0
[  318.558249] [c0000003ac137850] [c00000000010601c]
apply_wqattrs_prepare+0x2ac/0x320
[  318.558253] [c0000003ac1378c0] [c0000000001060cc]
apply_workqueue_attrs_locked+0x3c/0xa0
[  318.558257] [c0000003ac1378f0] [c00000000010662c]
apply_workqueue_attrs+0x4c/0x80
[  318.558261] [c0000003ac137930] [c0000000001081cc]
__alloc_workqueue_key+0x16c/0x4e0
[  318.558280] [c0000003ac1379f0] [d000000008455ca0]
ext4_fill_super+0x1c70/0x3390 [ext4]
[  318.558286] [c0000003ac137b30] [c000000000316bdc] mount_bdev+0x21c/0x250
[  318.558298] [c0000003ac137bd0] [d00000000844db20] ext4_mount+0x20/0x40 [ext4]
[  318.558303] [c0000003ac137bf0] [c000000000318184] mount_fs+0x74/0x210
[  318.558307] [c0000003ac137ca0] [c00000000033fd18] vfs_kern_mount+0x68/0x1d0
[  318.558310] [c0000003ac137d10] [c000000000344a28] do_mount+0x278/0xef0
[  318.558314] [c0000003ac137de0] [c000000000345ac4] SyS_mount+0x94/0x100
[  318.558319] [c0000003ac137e30] [c00000000000af84] system_call+0x38/0xe0
[  318.558322] Instruction dump:
[  318.558324] 990d02bc 4bffffc8 3c4c0073 38420500 7c0802a6 fbe1fff8
7c7f1b78 f8010010
[  318.558329] f821ffd1 39400000 994d02bc 814d0008 <7d201829> 2c090000
40c20010 7d40192d
[  318.558336] ---[ end trace a2b72248c6bfebea ]---




More info of test environment
------------------------------------------
# uname -rm
4.12.0-rc4 ppc64le

# lscpu
Architecture:          ppc64le
Byte Order:            Little Endian
CPU(s):                16
On-line CPU(s) list:   0-15
Thread(s) per core:    8
Core(s) per socket:    1
Socket(s):             2
NUMA node(s):          2
Model:                 2.1 (pvr 004b 0201)
Model name:            POWER8 (architected), altivec supported
Hypervisor vendor:     pHyp
Virtualization type:   para
L1d cache:             64K
L1i cache:             32K
NUMA node0 CPU(s):     0-15
NUMA node1 CPU(s):


-- 
Li Wang
liwang@redhat.com
