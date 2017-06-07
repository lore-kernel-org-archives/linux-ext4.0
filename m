From: Eryu Guan <eguan@redhat.com>
Subject: Re: [LTP] [BUG] Unable to handle kernel paging request for unaligned
 access at address 0xc0000001c52c53df
Date: Wed, 7 Jun 2017 11:27:32 +0800
Message-ID: <20170607032732.GV19952@eguan.usersys.redhat.com>
References: <CAEemH2fq0ciRxhpi2m7Rv1HTyzB1z=jFkEUOvan5jtSkw-tDSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ebiggers@google.com, jack@suse.cz, tytso@mit.edu,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        ltp@lists.linux.it
To: Li Wang <liwang@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53158 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751481AbdFGD1j (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 6 Jun 2017 23:27:39 -0400
Content-Disposition: inline
In-Reply-To: <CAEemH2fq0ciRxhpi2m7Rv1HTyzB1z=jFkEUOvan5jtSkw-tDSw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 06, 2017 at 06:00:34PM +0800, Li Wang wrote:
> Hi,
> 
> ltp/access04 always panic the latest mainstream kernel-4.12-rc4 on
> ppc64le. From the calltrace
> I guess the reason is probably that the tests mount ext2 file system
> using ext4 driver.
> 
> A simple way to reproduce:
> 
> # dd of=wangli if=/dev/zero count=1024 bs=1024
> # mkfs -t ext2 wangli
> # mount -t ext4 wangli /mnt/

I can't reproduce this crash either by your reproducer nor by ltp
access04 test on ppc64le host.

> 
> 
> Are there any new changes in ext4 (on kernel-4.12-rc4) recently?

I don't think it's an ext4 bug, I've seen similar crashes twice in
4.12-rc4 kernel testings, once testing XFS running fstests, and once
running ltp on ext3. But it seems not related to filesystem code.

[  828.119270] run fstests generic/034 at 2017-06-06 19:16:10 
[  828.720341] XFS (sda5): Unmounting Filesystem 
[  828.814003] device-mapper: uevent: version 1.0.3 
[  828.814096] Unable to handle kernel paging request for unaligned access at address 0xc0000001c52c5e7f 
[  828.814103] Faulting instruction address: 0xc0000000004d214c 
[  828.814109] Oops: Kernel access of bad area, sig: 7 [#1] 
[  828.814113] SMP NR_CPUS=2048  
[  828.814114] NUMA  
[  828.814117] pSeries 
[  828.814122] Modules linked in: dm_mod(+) sg pseries_rng ghash_generic gf128mul xts vmx_crypto nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c sd_mod ibmvscsi ibmveth scsi_transport_srp 
[  828.814150] CPU: 10 PID: 137772 Comm: modprobe Not tainted 4.12.0-rc4 #1 
[  828.814155] task: c0000003fe13c800 task.stack: c00000046ec68000 
[  828.814163] NIP: c0000000004d214c LR: c00000000011c884 CTR: c000000000130900 
[  828.814168] REGS: c00000046ec6b3d0 TRAP: 0600   Not tainted  (4.12.0-rc4) 
[  828.814173] MSR: 800000010280b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE,TM[E]> 
[  828.814184]   CR: 28228244  XER: 00000005 
[  828.814191] CFAR: c00000000011c880 DAR: c0000001c52c5e7f DSISR: 00000000 SOFTE: 0  
[  828.814191] GPR00: c00000000011c848 c00000046ec6b650 c000000001049100 c0000003f3b77020  
[  828.814191] GPR04: c0000003f3b77020 c0000001c52c5e7f 0000000000000000 0000000000000001  
[  828.814191] GPR08: 0008f92d89943c42 00000024000048b7 0000000000000008 0000000000000000  
[  828.814191] GPR12: c000000000130900 c00000000fac6900 d000000007dd3908 d000000007dd3908  
[  828.814191] GPR16: c00000046ec6bdec c00000046ec6bda0 000000000000ff20 0000000000000000  
[  828.814191] GPR20: 00000000000052f8 0000000000000000 0000000000004000 c000000000cc5780  
[  828.814191] GPR24: 00000001c45ffc5f 0000000000000000 00000001c45ffc5f c00000000107dd00  
[  828.814191] GPR28: c0000003f3b77834 0000000000000004 0000000000000800 c0000003f3b77000  
[  828.814257] NIP [c0000000004d214c] llist_add_batch+0xc/0x40 
[  828.814263] LR [c00000000011c884] try_to_wake_up+0x4a4/0x5b0 
[  828.814268] Call Trace: 
[  828.814273] [c00000046ec6b650] [c00000000011c848] try_to_wake_up+0x468/0x5b0 (unreliable) 
[  828.814282] [c00000046ec6b6d0] [c000000000102828] create_worker+0x148/0x250 
[  828.814290] [c00000046ec6b770] [c0000000001059dc] alloc_unbound_pwq+0x3bc/0x4c0 
[  828.814296] [c00000046ec6b7d0] [c00000000010601c] apply_wqattrs_prepare+0x2ac/0x320 
[  828.814304] [c00000046ec6b840] [c0000000001060cc] apply_workqueue_attrs_locked+0x3c/0xa0 
[  828.814313] [c00000046ec6b870] [c00000000010662c] apply_workqueue_attrs+0x4c/0x80 
[  828.814322] [c00000046ec6b8b0] [c0000000001081cc] __alloc_workqueue_key+0x16c/0x4e0 
[  828.814343] [c00000046ec6b970] [d000000007e04748] local_init+0xdc/0x1a4 [dm_mod] 
[  828.814362] [c00000046ec6b9f0] [d000000007e04854] dm_init+0x44/0xc4 [dm_mod] 
[  828.814375] [c00000046ec6ba30] [c00000000000ccf0] do_one_initcall+0x60/0x1c0 
[  828.814390] [c00000046ec6baf0] [c00000000091e748] do_init_module+0x8c/0x244 
[  828.814405] [c00000046ec6bb80] [c000000000197e08] load_module+0x12f8/0x1600 
[  828.814414] [c00000046ec6bd30] [c000000000198388] SyS_finit_module+0xa8/0x110 
[  828.814424] [c00000046ec6be30] [c00000000000af84] system_call+0x38/0xe0 
[  828.814429] Instruction dump: 
[  828.814436] 60420000 38600000 4e800020 60000000 60420000 7c832378 4e800020 60000000  
[  828.814448] 60000000 e9250000 f9240000 7c0004ac <7d4028a8> 7c2a4800 40c20010 7c6029ad  
[  828.814466] ---[ end trace 87ec4ff1fa8e1a3d ]--- 

I suspect it's a regression introduced in 4.12-rc4 kernel, I didn't see
such crashes when testing 4.12-rc3 kernel. I'll do bisect once I worked
out a reliable reproducer (unless you can reliably reproduce it with
your reproducer :).

Thanks,
Eryu
