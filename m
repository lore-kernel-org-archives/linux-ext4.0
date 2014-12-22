From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: inlinedata crash on ppc64
Date: Mon, 22 Dec 2014 11:27:02 -0800
Message-ID: <20141222192702.GM5368@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27305 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153AbaLVT1F (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Dec 2014 14:27:05 -0500
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id sBMJR4rJ005808
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 22 Dec 2014 19:27:05 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet22.oracle.com (8.14.5+Sun/8.14.5) with ESMTP id sBMJR3ZU014799
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-ext4@vger.kernel.org>; Mon, 22 Dec 2014 19:27:04 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id sBMJR3et016930
	for <linux-ext4@vger.kernel.org>; Mon, 22 Dec 2014 19:27:03 GMT
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi everyone,

I'm running e2fuzz on a powerpc64 system and saw this crash.  Looks like we
were trying to clear the inlinedata but the MAY_INLINE_DATA ext4 inode flag was
set.

--D

[288946.670855] ------------[ cut here ]------------
[288946.671160] kernel BUG at /raid/home/djwong/cdev/work/linux-mcsum/fs/ext4/inode.c:2344!
[288946.671732] Oops: Exception in kernel mode, sig: 5 [#1]
[288946.671894] PREEMPT SMP NR_CPUS=4 pSeries
[288946.672650] Modules linked in: ext4 jbd2 mbcache loop sch_fq_codel virtio_balloon fuse nfsd auth_rpcgss sd_mod raid10 raid456 async_memcpy async_raid6_recov async_pq async_xor async_tx xor ibmvscsi scsi_transport_srp raid6_pq raid1 raid0 multipath linear ohci_pci virtio_pci virtio_ring virtio ohci_hcd
[288946.765334] CPU: 0 PID: 1774 Comm: kworker/u2:2 Tainted: G             L 3.18.0-pcsum #4
[288946.833087] Workqueue: writeback .bdi_writeback_workfn (flush-7:0)
[288946.833416] task: c000000009d7c800 ti: c000000009d5c000 task.ti: c000000009d5c000
[288946.833506] NIP: d00000000229f5ac LR: d00000000229f590 CTR: c0000000006a82e0
[288946.833600] REGS: c000000009d5f270 TRAP: 0700   Tainted: G             L  (3.18.0-pcsum)
[288946.833695] MSR: 8000000000029032 <SF,EE,ME,IR,DR,RI>  CR: 24002048  XER: 20000000
[288946.834225] CFAR: d0000000022d67ec SOFTE: 1 
GPR00: d00000000229f590 c000000009d5f4f0 d00000000232af68 c0000000070a0000 
GPR04: c0000000070a0000 0000000000000050 0000000000000008 0000000000000001 
GPR08: 0000000000100000 0000000000000001 0000000000009220 d0000000020220b0 
GPR12: 0000000084002042 c00000000fff0000 c0000000000a2360 0000000000000003 
GPR16: 7fffffffffffffff c000000000ee3824 c0000000133cf3a8 c000000006d01800 
GPR20: 00000001044d1982 c000000009d5f830 c000000009d5c000 c000000009d2b9f8 
GPR24: 0000000000000000 c0000000133cf3a8 c000000006d0a800 c000000009d2b9d8 
GPR28: 0000000000000040 c0000000070a0000 c0000000133cf258 c000000009d5f830 
[288946.836431] NIP [d00000000229f5ac] .ext4_writepages+0x35c/0xde0 [ext4]
[288946.836890] LR [d00000000229f590] .ext4_writepages+0x340/0xde0 [ext4]
[288946.837016] Call Trace:
[288946.837539] [c000000009d5f4f0] [d00000000229f590] .ext4_writepages+0x340/0xde0 [ext4] (unreliable)
[288946.837767] [c000000009d5f690] [c0000000001c97dc] .do_writepages+0x5c/0xc0
[288946.837868] [c000000009d5f710] [c00000000027c9b4] .__writeback_single_inode+0x64/0x450
[288946.837966] [c000000009d5f7c0] [c00000000027d100] .writeback_sb_inodes+0x290/0x480
[288946.838065] [c000000009d5f8d0] [c00000000027d3d4] .__writeback_inodes_wb+0xe4/0x150
[288946.838164] [c000000009d5f980] [c00000000027e15c] .wb_writeback+0x32c/0x410
[288946.838260] [c000000009d5fa60] [c00000000027ee04] .bdi_writeback_workfn+0x314/0x5e0
[288946.838856] [c000000009d5fba0] [c00000000009b3e0] .process_one_work+0x1a0/0x4e0
[288946.838980] [c000000009d5fc50] [c00000000009bbb0] .worker_thread+0x180/0x540
[288946.839075] [c000000009d5fd30] [c0000000000a2470] .kthread+0x110/0x130
[288946.841960] [c000000009d5fe30] [c000000000009364] .ret_from_kernel_thread+0x58/0x74
[288946.842105] Instruction dump:
[288946.842580] 38800922 38a00001 38c00001 38e00000 480371a5 60000000 3920f000 7fa34840 
[288946.842827] 7c7d1b78 419d0a30 e93eff80 7929bfe0 <0b090000> 7fc4f378 7fa3eb78 480539b9 
[288946.859936] ---[ end trace c411c57b37ecaca2 ]---
[288947.043597] 
[288947.053346] ------------[ cut here ]------------
[288947.053527] WARNING: at /raid/home/djwong/cdev/work/linux-mcsum/kernel/smp.c:293
[288947.053598] Modules linked in: ext4 jbd2 mbcache loop sch_fq_codel virtio_balloon fuse nfsd auth_rpcgss sd_mod raid10 raid456 async_memcpy async_raid6_recov async_pq async_xor async_tx xor ibmvscsi scsi_transport_srp raid6_pq raid1 raid0 multipath linear ohci_pci virtio_pci virtio_ring virtio ohci_hcd
[288947.054307] CPU: 0 PID: 1774 Comm: kworker/u2:2 Tainted: G      D      L 3.18.0-pcsum #4
[288947.055928] task: c000000009d7c800 ti: c000000009d5c000 task.ti: c000000009d5c000
[288947.056011] NIP: c000000000111b00 LR: c000000000111a34 CTR: c0000000001a4f50
[288947.056072] REGS: c000000009d5e9f0 TRAP: 0700   Tainted: G      D      L  (3.18.0-pcsum)
[288947.056125] MSR: 8000000002021032 <SF,VEC,ME,IR,DR,RI>  CR: 48004022  XER: 00000000
[288947.056333] CFAR: c000000000111a78 SOFTE: 0 
GPR00: c000000000111a34 c000000009d5ec70 c000000000ff1f18 0000000000000000 
GPR04: c0000000008b47b0 c000000009d5ed70 0000000000000001 c000000000f279c8 
GPR08: 0000000000000000 0000000000000001 c000000000f01f18 c000000000899918 
GPR12: 0000000048004028 c00000000fff0000 c0000000000a2360 0000000000000003 
GPR16: 7fffffffffffffff c000000000ee3824 c0000000133cf3a8 c000000006d01800 
GPR20: c000000009d7c800 c000000009d5f830 c000000009d7d3b8 c000000009d2b9f8 
GPR24: c000000009d5eeb0 c0000000133cf3a8 0000000000000000 c000000000f2b2b8 
GPR28: 0000000000000001 c000000009d5ed70 c000000000f8af98 0000000000000000 
[288947.057811] NIP [c000000000111b00] .smp_call_function_single+0x110/0x150
[288947.057891] LR [c000000000111a34] .smp_call_function_single+0x44/0x150
[288947.057945] Call Trace:
[288947.058005] [c000000009d5ec70] [c000000000111a34] .smp_call_function_single+0x44/0x150 (unreliable)
[288947.058120] [c000000009d5ed00] [c0000000001a11f4] .task_function_call+0x54/0x70
[288947.058213] [c000000009d5eda0] [c000000000129bc0] .cgroup_exit+0xf0/0x170
[288947.071004] [c000000009d5ee40] [c00000000007d278] .do_exit+0x358/0xb00
[288947.071155] [c000000009d5ef30] [c00000000001e2a4] .die+0x304/0x450
[288947.071243] [c000000009d5efd0] [c00000000001e604] ._exception+0x1a4/0x1d0
[288947.080560] [c000000009d5f170] [c0000000006aa0c8] .program_check_exception+0x2c8/0x390
[288947.080710] [c000000009d5f200] [c000000000006208] program_check_common+0x108/0x180
[288947.081555] --- interrupt: 700 at .ext4_writepages+0x35c/0xde0 [ext4]
[288947.081555]     LR = .ext4_writepages+0x340/0xde0 [ext4]
[288947.081669] [c000000009d5f690] [c0000000001c97dc] .do_writepages+0x5c/0xc0
[288947.081764] [c000000009d5f710] [c00000000027c9b4] .__writeback_single_inode+0x64/0x450
[288947.081858] [c000000009d5f7c0] [c00000000027d100] .writeback_sb_inodes+0x290/0x480
[288947.081953] [c000000009d5f8d0] [c00000000027d3d4] .__writeback_inodes_wb+0xe4/0x150
[288947.082045] [c000000009d5f980] [c00000000027e15c] .wb_writeback+0x32c/0x410
[288947.082137] [c000000009d5fa60] [c00000000027ee04] .bdi_writeback_workfn+0x314/0x5e0
[288947.082230] [c000000009d5fba0] [c00000000009b3e0] .process_one_work+0x1a0/0x4e0
[288947.082326] [c000000009d5fc50] [c00000000009bbb0] .worker_thread+0x180/0x540
[288947.082412] [c000000009d5fd30] [c0000000000a2470] .kthread+0x110/0x130
[288947.082537] [c000000009d5fe30] [c000000000009364] .ret_from_kernel_thread+0x58/0x74
[288947.082649] Instruction dump:
[288947.082738] 4e800020 60000000 60000000 60000000 3d420018 392a2960 81290000 2f890000 
[288947.083041] 409eff88 3d42fff1 892a7082 69290001 <0b090000> 2fa90000 419eff70 39200001 
[288947.083384] ---[ end trace c411c57b37ecaca3 ]---
[288947.675231] Unable to handle kernel paging request for data at address 0xffffffffffffffd8
[288947.675353] Faulting instruction address: 0xc0000000000a2de0
[288947.675482] Oops: Kernel access of bad area, sig: 11 [#2]
[288947.675533] PREEMPT SMP NR_CPUS=4 pSeries
[288947.675628] Modules linked in: ext4 jbd2 mbcache loop sch_fq_codel virtio_balloon fuse nfsd auth_rpcgss sd_mod raid10 raid456 async_memcpy async_raid6_recov async_pq async_xor async_tx xor ibmvscsi scsi_transport_srp raid6_pq raid1 raid0 multipath linear ohci_pci virtio_pci virtio_ring virtio ohci_hcd
[288947.676182] CPU: 0 PID: 1774 Comm: kworker/u2:2 Tainted: G      D W    L 3.18.0-pcsum #4
[288947.676688] task: c000000009d7c800 ti: c000000009d5c000 task.ti: c000000009d5c000
[288947.676763] NIP: c0000000000a2de0 LR: c00000000009c038 CTR: c0000000000bee70
[288947.676819] REGS: c000000009d5e850 TRAP: 0300   Tainted: G      D W    L  (3.18.0-pcsum)
[288947.676872] MSR: 8000000000009032 <SF,EE,ME,IR,DR,RI>  CR: 48004028  XER: 00000000
[288947.677050] CFAR: c0000000000083b0 DAR: ffffffffffffffd8 DSISR: 40000000 SOFTE: 0 
GPR00: c00000000009c038 c000000009d5ead0 c000000000ff1f18 c000000009d7c800 
GPR04: 0000000000000000 00000000000003ff 0000000000000000 000000000000000f 
GPR08: 0000000000000000 0000000000000000 0000000000000001 000000000ef05d0e 
GPR12: 0000000048004048 c00000000fff0000 c000000009d7cd38 0000000000000001 
GPR16: c000000000a08580 c00000000007d5dc 0000000000000000 c000000006d01800 
GPR20: c000000000a08580 0000000000000001 0000000000000000 c000000000f29e20 
GPR24: 0000000000000004 c000000000a08580 c000000001038aa8 c000000009d5c000 
GPR28: c000000000a08580 0000000000000000 c000000009d7c800 c000000009d7c800 
[288947.677945] NIP [c0000000000a2de0] .kthread_data+0x20/0x40
[288947.678007] LR [c00000000009c038] .wq_worker_sleeping+0x28/0x100
[288947.678054] Call Trace:
[288947.678112] [c000000009d5ead0] [c0000000000adbd4] .update_rq_clock.part.64+0x24/0x60 (unreliable)
[288947.678205] [c000000009d5eb50] [c00000000009c038] .wq_worker_sleeping+0x28/0x100
[288947.678281] [c000000009d5ebe0] [c0000000006a35ac] .__schedule+0x6bc/0x8f0
[288947.678354] [c000000009d5ee40] [c00000000007d5dc] .do_exit+0x6bc/0xb00
[288947.678423] [c000000009d5ef30] [c00000000001e2a4] .die+0x304/0x450
[288947.678545] [c000000009d5efd0] [c00000000001e604] ._exception+0x1a4/0x1d0
[288947.678629] [c000000009d5f170] [c0000000006aa0c8] .program_check_exception+0x2c8/0x390
[288947.678708] [c000000009d5f200] [c000000000006208] program_check_common+0x108/0x180
[288947.679517] --- interrupt: 700 at .ext4_writepages+0x35c/0xde0 [ext4]
[288947.679517]     LR = .ext4_writepages+0x340/0xde0 [ext4]
[288947.679610] [c000000009d5f690] [c0000000001c97dc] .do_writepages+0x5c/0xc0
[288947.679687] [c000000009d5f710] [c00000000027c9b4] .__writeback_single_inode+0x64/0x450
[288947.679765] [c000000009d5f7c0] [c00000000027d100] .writeback_sb_inodes+0x290/0x480
[288947.679842] [c000000009d5f8d0] [c00000000027d3d4] .__writeback_inodes_wb+0xe4/0x150
[288947.679919] [c000000009d5f980] [c00000000027e15c] .wb_writeback+0x32c/0x410
[288947.679993] [c000000009d5fa60] [c00000000027ee04] .bdi_writeback_workfn+0x314/0x5e0
[288947.680070] [c000000009d5fba0] [c00000000009b3e0] .process_one_work+0x1a0/0x4e0
[288947.680148] [c000000009d5fc50] [c00000000009bbb0] .worker_thread+0x180/0x540
[288947.680221] [c000000009d5fd30] [c0000000000a2470] .kthread+0x110/0x130
[288947.680298] [c000000009d5fe30] [c000000000009364] .ret_from_kernel_thread+0x58/0x74
[288947.680384] Instruction dump:
[288947.680445] 4e800020 60000000 60000000 60000000 7c0802a6 fbe1fff8 f8010010 f821ff81 
[288947.680620] 7c7f1b78 60000000 60000000 e93f04c0 <e869ffd8> 38210080 e8010010 ebe1fff8 
[288947.680854] ---[ end trace c411c57b37ecaca4 ]---
[288947.714125] 
[288947.714449] Fixing recursive fault but reboot is needed!
[288947.715008] BUG: scheduling while atomic: kworker/u2:2/1774/0x00000004
[288947.715201] Modules linked in: ext4 jbd2 mbcache loop sch_fq_codel virtio_balloon fuse nfsd auth_rpcgss sd_mod raid10 raid456 async_memcpy async_raid6_recov async_pq async_xor async_tx xor ibmvscsi scsi_transport_srp raid6_pq raid1 raid0 multipath linear ohci_pci virtio_pci virtio_ring virtio ohci_hcd
[288947.716807] Preemption disabled at:[<          (null)>]           (null)
[288947.717162] 
[288947.717621] CPU: 0 PID: 1774 Comm: kworker/u2:2 Tainted: G      D W    L 3.18.0-pcsum #4
[288947.718734] Call Trace:
[288947.719687] [c000000009d5e270] [c0000000006b37d8] .dump_stack+0x9c/0x104 (unreliable)
[288947.719937] [c000000009d5e2f0] [c0000000006afee4] .__schedule_bug+0xb4/0xdc
[288947.720063] [c000000009d5e370] [c0000000006a3718] .__schedule+0x828/0x8f0
[288947.720192] [c000000009d5e5d0] [c00000000007d9b0] .do_exit+0xa90/0xb00
[288947.720314] [c000000009d5e6c0] [c00000000001e2a4] .die+0x304/0x450
[288947.720464] [c000000009d5e760] [c000000000042a8c] .bad_page_fault+0xcc/0x120
[288947.720592] [c000000009d5e7e0] [c00000000000857c] handle_page_fault+0x2c/0x30
[288947.720762] --- interrupt: 300 at .kthread_data+0x20/0x40
[288947.720762]     LR = .wq_worker_sleeping+0x28/0x100
[288947.720944] [c000000009d5ead0] [c0000000000adbd4] .update_rq_clock.part.64+0x24/0x60 (unreliable)
[288947.721103] [c000000009d5eb50] [c00000000009c038] .wq_worker_sleeping+0x28/0x100
[288947.721230] [c000000009d5ebe0] [c0000000006a35ac] .__schedule+0x6bc/0x8f0
[288947.721359] [c000000009d5ee40] [c00000000007d5dc] .do_exit+0x6bc/0xb00
[288947.721481] [c000000009d5ef30] [c00000000001e2a4] .die+0x304/0x450
[288947.721605] [c000000009d5efd0] [c00000000001e604] ._exception+0x1a4/0x1d0
[288947.721736] [c000000009d5f170] [c0000000006aa0c8] .program_check_exception+0x2c8/0x390
[288947.721869] [c000000009d5f200] [c000000000006208] program_check_common+0x108/0x180
[288947.723188] --- interrupt: 700 at .ext4_writepages+0x35c/0xde0 [ext4]
[288947.723188]     LR = .ext4_writepages+0x340/0xde0 [ext4]
[288947.723356] [c000000009d5f690] [c0000000001c97dc] .do_writepages+0x5c/0xc0
[288947.723491] [c000000009d5f710] [c00000000027c9b4] .__writeback_single_inode+0x64/0x450
[288947.723626] [c000000009d5f7c0] [c00000000027d100] .writeback_sb_inodes+0x290/0x480
[288947.723760] [c000000009d5f8d0] [c00000000027d3d4] .__writeback_inodes_wb+0xe4/0x150
[288947.723892] [c000000009d5f980] [c00000000027e15c] .wb_writeback+0x32c/0x410
[288947.724021] [c000000009d5fa60] [c00000000027ee04] .bdi_writeback_workfn+0x314/0x5e0
[288947.724156] [c000000009d5fba0] [c00000000009b3e0] .process_one_work+0x1a0/0x4e0
[288947.724290] [c000000009d5fc50] [c00000000009bbb0] .worker_thread+0x180/0x540
[288947.724424] [c000000009d5fd30] [c0000000000a2470] .kthread+0x110/0x130
[288947.724693] [c000000009d5fe30] [c000000000009364] .ret_from_kernel_thread+0x58/0x74
