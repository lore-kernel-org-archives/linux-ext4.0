From: CAI Qian <caiqian@redhat.com>
Subject: 3.10 GA: ext4 crash on power7
Date: Tue, 2 Jul 2013 02:42:00 -0400 (EDT)
Message-ID: <1598633085.7744466.1372747320569.JavaMail.root@redhat.com>
References: <2044908741.7743522.1372746883931.JavaMail.root@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:37109 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442Ab3GBGmC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Jul 2013 02:42:02 -0400
Received: from zmail14.collab.prod.int.phx2.redhat.com (zmail14.collab.prod.int.phx2.redhat.com [10.5.83.16])
	by mx4-phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r626g1Z3015985
	for <linux-ext4@vger.kernel.org>; Tue, 2 Jul 2013 02:42:01 -0400
In-Reply-To: <2044908741.7743522.1372746883931.JavaMail.root@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This has never been seen during either 3.10-rc7 or the last year's ext4
devel tree testing. Maybe because I have recently upgraded the distro
of the Fedora to the latest. This has happened using the fs_mark test and
reproduced on all power7 systems.

[ 2803.493590] EXT4-fs (ram0): mounted filesystem with ordered data mode. Opts: (null) 
[ 2806.684208] list_add corruption. next->prev should be prev (c00000002e7a2920), but was ffffffffffffffff. (next=c00000002291f6a8). 
[ 2806.684238] ------------[ cut here ]------------ 
[ 2806.684242] WARNING: at lib/list_debug.c:29 
[ 2806.684245] Modules linked in: vfat fat brd nfsv3 nfs_acl rpcsec_gss_krb5 auth_rpcgss nfsv4 nfs lockd sunrpc fscache nfnetlink_queue nfnetlink_log nfnetlink bluetooth rfkill arc4 md4 nls_utf8 cifs dns_resolver nf_tproxy_core nls_koi8_u nls_cp932 ts_kmp fuse nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6table_nat nf_nat_ipv6 ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat_ipv4 nf_nat iptable_mangle ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables sg xfs libcrc32c ehea sd_mod crc_t10dif ibmvscsi scsi_transport_srp scsi_tgt dm_mirror dm_region_hash dm_log dm_mod [last unloaded: zlib] 
[ 2806.684339] CPU: 1 PID: 21270 Comm: fs_mark Not tainted 3.10.0 #1 
[ 2806.684344] task: c000000038ce0e10 ti: c0000000375c0000 task.ti: c0000000375c0000 
[ 2806.684348] NIP: c0000000003dcd00 LR: c0000000003dccfc CTR: 0000000001766760 
[ 2806.684352] REGS: c0000000375c31f0 TRAP: 0700   Not tainted  (3.10.0) 
[ 2806.684356] MSR: 8000000000029032 <SF,EE,ME,IR,DR,RI>  CR: 28002424  XER: 00000006 
[ 2806.684368] SOFTE: 1 
[ 2806.684370] CFAR: c00000000073c7e0 
[ 2806.684372]  
GPR00: c0000000003dccfc c0000000375c3470 c000000001107c10 0000000000000075  
GPR04: 0000000000000000 0000000000000000 c000000000af2ef8 c000000001522448  
GPR08: c000000000ae7c10 0000000000000000 0000000000000000 0000000000003fef  
GPR12: 0000000028002422 c00000000eda0400 0000000000000000 0000000000000000  
GPR16: 0000000000000000 0000000000000001 00007fffffffffff 0000000000000000  
GPR20: 0000000000000000 0000000000000001 0000000000000000 0000000000000010  
GPR24: 0000000000000000 0000000000000000 c0000000225d0028 c00000004a4f54f8  
GPR28: c000000049d99c00 c00000002291f6a8 c00000002e7a2920 c00000004a4f54f8  
[ 2806.684429] NIP [c0000000003dcd00] .__list_add+0x100/0x110 
[ 2806.684433] LR [c0000000003dccfc] .__list_add+0xfc/0x110 
[ 2806.684436] Call Trace: 
[ 2806.684440] [c0000000375c3470] [c0000000003dccfc] .__list_add+0xfc/0x110 (unreliable) 
[ 2806.684447] [c0000000375c3500] [c0000000002f395c] .ext4_mb_new_group_pa+0x22c/0x340 
[ 2806.684453] [c0000000375c35a0] [c0000000002fad34] .ext4_mb_new_blocks+0x634/0x690 
[ 2806.684458] [c0000000375c3670] [c0000000002ee3fc] .ext4_ext_map_blocks+0x6fc/0x1720 
[ 2806.684464] [c0000000375c37a0] [c0000000002bcfd4] .ext4_map_blocks+0x324/0x560 
[ 2806.684470] [c0000000375c3880] [c0000000002c03f0] .mpage_da_map_and_submit+0xb0/0x470 
[ 2806.684476] [c0000000375c3940] [c0000000002c0fbc] .ext4_da_writepages+0x32c/0x660 
[ 2806.684482] [c0000000375c3ad0] [c0000000001a27ac] .do_writepages+0x3c/0x70 
[ 2806.684487] [c0000000375c3b40] [c0000000001950b8] .__filemap_fdatawrite_range+0x68/0x80 
[ 2806.684493] [c0000000375c3be0] [c0000000001951fc] .filemap_write_and_wait_range+0x3c/0xb0 
[ 2806.684499] [c0000000375c3c70] [c0000000002b68f4] .ext4_sync_file+0x74/0x460 
[ 2806.684504] [c0000000375c3d20] [c00000000024d678] .do_fsync+0x78/0xd0 
[ 2806.684509] [c0000000375c3dc0] [c00000000024da78] .SyS_fsync+0x18/0x30 
[ 2806.684514] [c0000000375c3e30] [c000000000009e54] syscall_exit+0x0/0x98 
[ 2806.684518] Instruction dump: 
[ 2806.684521] 7fa4eb78 38634190 7fc6f378 4835fa89 60000000 0fe00000 4bffff54 3c62ff8b  
[ 2806.684530] 7fa6eb78 38634128 4835fa6d 60000000 <0fe00000> 4bffff2c 60000000 60000000  
[ 2806.684540] ---[ end trace a56068f561c7dbb3 ]--- 
[ 2806.741754] list_add corruption. next->prev should be prev (c00000002e7a29a0), but was ffffffffffffffff. (next=c00000002ec2fdf8). 
[ 2806.741782] ------------[ cut here ]------------ 
[ 2806.741786] WARNING: at lib/list_debug.c:29 
[ 2806.741788] Modules linked in: vfat fat brd nfsv3 nfs_acl rpcsec_gss_krb5 auth_rpcgss nfsv4 nfs lockd sunrpc fscache nfnetlink_queue nfnetlink_log nfnetlink bluetooth rfkill arc4 md4 nls_utf8 cifs dns_resolver nf_tproxy_core nls_koi8_u nls_cp932 ts_kmp fuse nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6table_nat nf_nat_ipv6 ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat_ipv4 nf_nat iptable_mangle ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables sg xfs libcrc32c ehea sd_mod crc_t10dif ibmvscsi scsi_transport_srp scsi_tgt dm_mirror dm_region_hash dm_log dm_mod [last unloaded: zlib] 
[ 2806.741874] CPU: 0 PID: 21270 Comm: fs_mark Tainted: G        W    3.10.0 #1 
[ 2806.741879] task: c000000038ce0e10 ti: c0000000375c0000 task.ti: c0000000375c0000 
[ 2806.741883] NIP: c0000000003dcd00 LR: c0000000003dccfc CTR: 0000000001766760 
[ 2806.741887] REGS: c0000000375c31f0 TRAP: 0700   Tainted: G        W     (3.10.0) 
[ 2806.741890] MSR: 8000000000029032 <SF,EE,ME,IR,DR,RI>  CR: 28002424  XER: 00000006 
[ 2806.741901] SOFTE: 1 
[ 2806.741903] CFAR: c00000000073c7e0 
[ 2806.741906]  
GPR00: c0000000003dccfc c0000000375c3470 c000000001107c10 0000000000000075  
GPR04: 0000000000000000 0000000000000000 c000000000af2ef8 c000000001502448  
GPR08: c000000000ae7c10 0000000000000000 0000000000000000 0000000000003fef  
GPR12: 0000000028002422 c00000000eda0000 0000000000000000 0000000000000000  
GPR16: 0000000000000000 0000000000000001 00007fffffffffff 0000000000000000  
GPR20: 0000000000000000 0000000000000001 0000000000000000 0000000000000010  
GPR24: 0000000000000000 0000000000000000 c00000002647f7d0 c00000001b7b46c0  
GPR28: c000000049d99c00 c00000002ec2fdf8 c00000002e7a29a0 c00000001b7b46c0  
[ 2806.741957] NIP [c0000000003dcd00] .__list_add+0x100/0x110 
[ 2806.741961] LR [c0000000003dccfc] .__list_add+0xfc/0x110 
[ 2806.741964] Call Trace: 
[ 2806.741967] [c0000000375c3470] [c0000000003dccfc] .__list_add+0xfc/0x110 (unreliable) 
[ 2806.741974] [c0000000375c3500] [c0000000002f395c] .ext4_mb_new_group_pa+0x22c/0x340 
[ 2806.741980] [c0000000375c35a0] [c0000000002fad34] .ext4_mb_new_blocks+0x634/0x690 
[ 2806.741985] [c0000000375c3670] [c0000000002ee3fc] .ext4_ext_map_blocks+0x6fc/0x1720 
[ 2806.741991] [c0000000375c37a0] [c0000000002bcfd4] .ext4_map_blocks+0x324/0x560 
[ 2806.741996] [c0000000375c3880] [c0000000002c03f0] .mpage_da_map_and_submit+0xb0/0x470 
[ 2806.742001] [c0000000375c3940] [c0000000002c0fbc] .ext4_da_writepages+0x32c/0x660 
[ 2806.742007] [c0000000375c3ad0] [c0000000001a27ac] .do_writepages+0x3c/0x70 
[ 2806.742012] [c0000000375c3b40] [c0000000001950b8] .__filemap_fdatawrite_range+0x68/0x80 
[ 2806.742018] [c0000000375c3be0] [c0000000001951fc] .filemap_write_and_wait_range+0x3c/0xb0 
[ 2806.742023] [c0000000375c3c70] [c0000000002b68f4] .ext4_sync_file+0x74/0x460 
[ 2806.742027] [c0000000375c3d20] [c00000000024d678] .do_fsync+0x78/0xd0 
[ 2806.742032] [c0000000375c3dc0] [c00000000024da78] .SyS_fsync+0x18/0x30 
[ 2806.742038] [c0000000375c3e30] [c000000000009e54] syscall_exit+0x0/0x98 
[ 2806.742041] Instruction dump: 
[ 2806.742044] 7fa4eb78 38634190 7fc6f378 4835fa89 60000000 0fe00000 4bffff54 3c62ff8b  
[ 2806.742052] 7fa6eb78 38634128 4835fa6d 60000000 <0fe00000> 4bffff2c 60000000 60000000  
[ 2806.742061] ---[ end trace a56068f561c7dbb4 ]--- 
[ 2809.496203] list_add corruption. next->prev should be prev (c00000002e7a29a0), but was ffffffffffffffff. (next=c00000002ec2fdf8). 
[ 2809.496242] ------------[ cut here ]------------ 
[ 2809.496252] WARNING: at lib/list_debug.c:29 
[ 2809.496259] Modules linked in: vfat fat brd nfsv3 nfs_acl rpcsec_gss_krb5 auth_rpcgss nfsv4 nfs lockd sunrpc fscache nfnetlink_queue nfnetlink_log nfnetlink bluetooth rfkill arc4 md4 nls_utf8 cifs dns_resolver nf_tproxy_core nls_koi8_u nls_cp932 ts_kmp fuse nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6table_nat nf_nat_ipv6 ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat_ipv4 nf_nat iptable_mangle ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables sg xfs libcrc32c ehea sd_mod crc_t10dif ibmvscsi scsi_transport_srp scsi_tgt dm_mirror dm_region_hash dm_log dm_mod [last unloaded: zlib] 
[ 2809.496367] CPU: 14 PID: 21348 Comm: fs_mark Tainted: G        W    3.10.0 #1 
[ 2809.496373] task: c000000038cdd6b0 ti: c0000000375b4000 task.ti: c0000000375b4000 
[ 2809.496378] NIP: c0000000003dcd00 LR: c0000000003dccfc CTR: 0000000001766760 
[ 2809.496383] REGS: c0000000375b71f0 TRAP: 0700   Tainted: G        W     (3.10.0) 
[ 2809.496388] MSR: 8000000000029032 <SF,EE,ME,IR,DR,RI>  CR: 28002424  XER: 00000006 
[ 2809.496401] SOFTE: 1 
[ 2809.496404] CFAR: c00000000073c7e0 
[ 2809.496407]  
GPR00: c0000000003dccfc c0000000375b7470 c000000001107c10 0000000000000075  
GPR04: 0000000000000000 0000000000000000 c000000000af2ef8 c0000000016c2448  
GPR08: c000000000ae7c10 0000000000000000 0000000000000000 0000000000003fef  
GPR12: 0000000028002422 c00000000eda3800 0000000000000000 0000000000000000  
GPR16: 0000000000000000 0000000000000001 00007fffffffffff 0000000000000000  
GPR20: 0000000000000000 0000000000000001 0000000000000000 0000000000000010  
GPR24: 0000000000000000 0000000000000000 c0000000227c0028 c00000004ae3a770  
GPR28: c000000049d99c00 c00000002ec2fdf8 c00000002e7a29a0 c00000004ae3a770  
[ 2809.496473] NIP [c0000000003dcd00] .__list_add+0x100/0x110 
[ 2809.496478] LR [c0000000003dccfc] .__list_add+0xfc/0x110 
[ 2809.496482] Call Trace: 
[ 2809.496486] [c0000000375b7470] [c0000000003dccfc] .__list_add+0xfc/0x110 (unreliable) 
[ 2809.496494] [c0000000375b7500] [c0000000002f395c] .ext4_mb_new_group_pa+0x22c/0x340 
[ 2809.496501] [c0000000375b75a0] [c0000000002fad34] .ext4_mb_new_blocks+0x634/0x690 
[ 2809.496507] [c0000000375b7670] [c0000000002ee3fc] .ext4_ext_map_blocks+0x6fc/0x1720 
[ 2809.496514] [c0000000375b77a0] [c0000000002bcfd4] .ext4_map_blocks+0x324/0x560 
[ 2809.496521] [c0000000375b7880] [c0000000002c03f0] .mpage_da_map_and_submit+0xb0/0x470 
[ 2809.496527] [c0000000375b7940] [c0000000002c0fbc] .ext4_da_writepages+0x32c/0x660 
[ 2809.496534] [c0000000375b7ad0] [c0000000001a27ac] .do_writepages+0x3c/0x70 
[ 2809.496541] [c0000000375b7b40] [c0000000001950b8] .__filemap_fdatawrite_range+0x68/0x80 
[ 2809.496547] [c0000000375b7be0] [c0000000001951fc] .filemap_write_and_wait_range+0x3c/0xb0 
[ 2809.496554] [c0000000375b7c70] [c0000000002b68f4] .ext4_sync_file+0x74/0x460 
[ 2809.496560] [c0000000375b7d20] [c00000000024d678] .do_fsync+0x78/0xd0 
[ 2809.496565] [c0000000375b7dc0] [c00000000024da78] .SyS_fsync+0x18/0x30 
[ 2809.496573] [c0000000375b7e30] [c000000000009e54] syscall_exit+0x0/0x98 
[ 2809.496577] Instruction dump: 
[ 2809.496581] 7fa4eb78 38634190 7fc6f378 4835fa89 60000000 0fe00000 4bffff54 3c62ff8b  
[ 2809.496591] 7fa6eb78 38634128 4835fa6d 60000000 <0fe00000> 4bffff2c 60000000 60000000  
[ 2809.496603] ---[ end trace a56068f561c7dbb5 ]--- 
2013-07-01 03:08:01,350 backend check_offset: INFO Rewriting file 1e7781a0-1329-4868-870f-3c066a988d49. 
[ 2814.504456] list_del corruption. next->prev should be c0000000305079f0, but was ffffffffffffffff 
[ 2814.504482] ------------[ cut here ]------------ 
[ 2814.504486] WARNING: at lib/list_debug.c:62 
[ 2814.504489] Modules linked in: vfat fat brd nfsv3 nfs_acl rpcsec_gss_krb5 auth_rpcgss nfsv4 nfs lockd sunrpc fscache nfnetlink_queue nfnetlink_log nfnetlink bluetooth rfkill arc4 md4 nls_utf8 cifs dns_resolver nf_tproxy_core nls_koi8_u nls_cp932 ts_kmp fuse nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6table_nat nf_nat_ipv6 ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat_ipv4 nf_nat iptable_mangle ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables sg xfs libcrc32c ehea sd_mod crc_t10dif ibmvscsi scsi_transport_srp scsi_tgt dm_mirror dm_region_hash dm_log dm_mod [last unloaded: zlib] 
[ 2814.504584] CPU: 9 PID: 21470 Comm: umount Tainted: G        W    3.10.0 #1 
[ 2814.504589] task: c000000046367cd0 ti: c0000000469f0000 task.ti: c0000000469f0000 
[ 2814.504593] NIP: c0000000003dcda4 LR: c0000000003dcda0 CTR: 0000000001766760 
[ 2814.504598] REGS: c0000000469f3620 TRAP: 0700   Tainted: G        W     (3.10.0) 
[ 2814.504602] MSR: 8000000000029032 <SF,EE,ME,IR,DR,RI>  CR: 28000424  XER: 00000005 
[ 2814.504613] SOFTE: 1 
[ 2814.504616] CFAR: c00000000073c7e0 
[ 2814.504618]  
GPR00: c0000000003dcda0 c0000000469f38a0 c000000001107c10 0000000000000054  
GPR04: 0000000000000000 0000000000000000 c000000000af2ef8 c000000001622448  
GPR08: c000000000ae7c10 0000000000000000 0000000000000000 0000000000003fef  
GPR12: 0000000028000422 c00000000eda2400 0000000000000000 0000000000000000  
GPR16: 0000000000000000 0000000000000001 0000000000000008 ffffffffffffffff  
GPR20: c000000073eeea00 0000000000000020 0000000000000000 c00000000659b000  
GPR24: 0000000000000900 c00000002e7a2900 c000000049d99c00 0000000000000012  
GPR28: c000000001460840 c00000002e7a2920 c0000000305079e0 c0000000305079f0  
[ 2814.504675] NIP [c0000000003dcda4] .__list_del_entry+0x94/0xd0 
[ 2814.504680] LR [c0000000003dcda0] .__list_del_entry+0x90/0xd0 
[ 2814.504683] Call Trace: 
[ 2814.504686] [c0000000469f38a0] [c0000000003dcda0] .__list_del_entry+0x90/0xd0 (unreliable) 
[ 2814.504693] [c0000000469f3910] [c0000000003dcdf8] .list_del+0x18/0x50 
[ 2814.504699] [c0000000469f3990] [c0000000002f9f00] .ext4_mb_release+0x170/0x3e0 
[ 2814.504704] [c0000000469f3a80] [c0000000002de5f0] .ext4_put_super+0xb0/0x3d0 
[ 2814.504710] [c0000000469f3b20] [c000000000213320] .generic_shutdown_super+0x90/0x150 
[ 2814.504716] [c0000000469f3bb0] [c0000000002137a8] .kill_block_super+0x28/0x90 
[ 2814.504721] [c0000000469f3c30] [c000000000213c94] .deactivate_locked_super+0x94/0xd0 
[ 2814.504727] [c0000000469f3cb0] [c000000000239150] .mntput_no_expire+0x160/0x1d0 
[ 2814.504733] [c0000000469f3d50] [c00000000023a8ac] .SyS_umount+0xfc/0x4d0 
[ 2814.504738] [c0000000469f3e30] [c000000000009e54] syscall_exit+0x0/0x98 
[ 2814.504742] Instruction dump: 
[ 2814.504745] 4e800020 3c62ff8b 7d455378 38634210 4835f9e1 60000000 0fe00000 4bffffd8  
[ 2814.504755] 3c62ff8b 386342c0 4835f9c9 60000000 <0fe00000> 4bffffc0 3c62ff8b 38634280  
[ 2814.504764] ---[ end trace a56068f561c7dbb6 ]--- 
[ 2814.504777] Unable to handle kernel paging request for data at address 0xffffffffffffffff 
[ 2814.504781] Faulting instruction address: 0xc0000000003dcd48 
[ 2814.504786] Oops: Kernel access of bad area, sig: 11 [#1] 
[ 2814.504788] SMP NR_CPUS=1024 NUMA pSeries 
[ 2814.504793] Modules linked in: vfat fat brd nfsv3 nfs_acl rpcsec_gss_krb5 auth_rpcgss nfsv4 nfs lockd sunrpc fscache nfnetlink_queue nfnetlink_log nfnetlink bluetooth rfkill arc4 md4 nls_utf8 cifs dns_resolver nf_tproxy_core nls_koi8_u nls_cp932 ts_kmp fuse nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6table_nat nf_nat_ipv6 ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat_ipv4 nf_nat iptable_mangle ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables sg xfs libcrc32c ehea sd_mod crc_t10dif ibmvscsi scsi_transport_srp scsi_tgt dm_mirror dm_region_hash dm_log dm_mod [last unloaded: zlib] 
[ 2814.504863] CPU: 9 PID: 21470 Comm: umount Tainted: G        W    3.10.0 #1 
[ 2814.504867] task: c000000046367cd0 ti: c0000000469f0000 task.ti: c0000000469f0000 
[ 2814.504871] NIP: c0000000003dcd48 LR: c0000000003dcdf8 CTR: 0000000001766760 
[ 2814.504876] REGS: c0000000469f3620 TRAP: 0300   Tainted: G        W     (3.10.0) 
[ 2814.504879] MSR: 8000000000009032 <SF,EE,ME,IR,DR,RI>  CR: 28000428  XER: 00000005 
[ 2814.504890] SOFTE: 1 
[ 2814.504892] CFAR: c00000000000908c 
[ 2814.504895] DAR: ffffffffffffffff, DSISR: 40000000 
[ 2814.504898]  
GPR00: c0000000003dcdf8 c0000000469f38a0 c000000001107c10 c00000002291f6a8  
GPR04: c00000002291f6a8 c0000000016362d0 0000000000000000 000000000009d606  
GPR08: 0000000000200200 ffffffffffffffff c0000000af3332c0 0000000000003fef  
GPR12: 0000000028000428 c00000000eda2400 0000000000000000 0000000000000000  
GPR16: 0000000000000000 0000000000000001 0000000000000008 ffffffffffffffff  
GPR20: c000000073eeea00 0000000000000020 0000000000000000 c00000000659b000  
GPR24: 0000000000000900 c00000002e7a2900 c000000049d99c00 0000000000000012  
GPR28: c000000001460840 c00000002e7a2920 c00000002291f698 c00000002291f6a8  
[ 2814.504953] NIP [c0000000003dcd48] .__list_del_entry+0x38/0xd0 
[ 2814.504957] LR [c0000000003dcdf8] .list_del+0x18/0x50 
[ 2814.504960] Call Trace: 
[ 2814.504964] [c0000000469f38a0] [0000000000000900] 0x900 (unreliable) 
[ 2814.504970] [c0000000469f3910] [c0000000003dcdf8] .list_del+0x18/0x50 
[ 2814.504975] [c0000000469f3990] [c0000000002f9f00] .ext4_mb_release+0x170/0x3e0 
[ 2814.504980] [c0000000469f3a80] [c0000000002de5f0] .ext4_put_super+0xb0/0x3d0 
[ 2814.504985] [c0000000469f3b20] [c000000000213320] .generic_shutdown_super+0x90/0x150 
[ 2814.504991] [c0000000469f3bb0] [c0000000002137a8] .kill_block_super+0x28/0x90 
[ 2814.504996] [c0000000469f3c30] [c000000000213c94] .deactivate_locked_super+0x94/0xd0 
[ 2814.505001] [c0000000469f3cb0] [c000000000239150] .mntput_no_expire+0x160/0x1d0 
[ 2814.505007] [c0000000469f3d50] [c00000000023a8ac] .SyS_umount+0xfc/0x4d0 
[ 2814.505012] [c0000000469f3e30] [c000000000009e54] syscall_exit+0x0/0x98 
[ 2814.505016] Instruction dump: 
[ 2814.505019] 61290100 7c641b78 f8010010 f821ff91 e9430000 7faa4800 e9230008 41de0044  
[ 2814.505028] 3d000020 61080200 7fa94000 41de0080 <e8a90000> 7fa32840 40de005c e8aa0008  
[ 2814.505040] ---[ end trace a56068f561c7dbb7 ]--- 
[ 2814.506104]  

Another system had trace like this,

[ 3037.222659] Unable to handle kernel paging request for data at address 0xffffffffffffffff 
[ 3037.222678] Faulting instruction address: 0xc0000000003dcd48 
[ 3037.222685] Oops: Kernel access of bad area, sig: 11 [#1] 
[ 3037.222690] SMP NR_CPUS=1024 NUMA pSeries 
[ 3037.222697] Modules linked in: vfat fat brd nfsv3 nfs_acl rpcsec_gss_krb5 auth_rpcgss nfsv4 nfs lockd sunrpc fscache nfnetlink_queue nfnetlink_log nfnetlink bluetooth rfkill arc4 md4 nls_utf8 cifs dns_resolver nf_tproxy_core nls_koi8_u nls_cp932 ts_kmp fuse nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6table_nat nf_nat_ipv6 ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat_ipv4 nf_nat iptable_mangle ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables sg xfs libcrc32c ehea ses enclosure sd_mod crc_t10dif ipr libata dm_mirror dm_region_hash dm_log dm_mod [last unloaded: zlib] 
[ 3037.222800] CPU: 5 PID: 18889 Comm: umount Not tainted 3.10.0 #1 
[ 3037.222806] task: c0000003c7453090 ti: c0000003c74d4000 task.ti: c0000003c74d4000 
[ 3037.222813] NIP: c0000000003dcd48 LR: c0000000003dcdf8 CTR: 0000000000000000 
[ 3037.222819] REGS: c0000003c74d7620 TRAP: 0300   Not tainted  (3.10.0) 
[ 3037.222824] MSR: 8000000000009032 <SF,EE,ME,IR,DR,RI>  CR: 24000428  XER: 00000000 
[ 3037.222840] SOFTE: 1 
[ 3037.222844] CFAR: c00000000000908c 
[ 3037.222848] DAR: ffffffffffffffff, DSISR: 40000000 
[ 3037.222852]  
GPR00: c0000000003dcdf8 c0000003c74d78a0 c000000001107c10 c0000003376232d8  
GPR04: c0000003376232d8 c000000354d91e00 c0000000002f9f50 0000000000000020  
GPR08: 0000000000200200 ffffffffffffffff c0000000062c28e8 0000000000000001  
GPR12: 0000000024000428 c00000000f241400 0000000000000000 0000000000000000  
GPR16: 0000000000000000 0000000000000001 0000000000000008 ffffffffffffffff  
GPR20: c00000035b0cbd00 0000000000000020 0000000000000000 c000000007162000  
GPR24: 0000000000000e80 c000000354d91e80 c0000003afb5a800 000000000000001d  
GPR28: c000000001460840 c000000354d91ea0 c0000003376232c8 c0000003376232d8  
[ 3037.222932] NIP [c0000000003dcd48] .__list_del_entry+0x38/0xd0 
[ 3037.222939] LR [c0000000003dcdf8] .list_del+0x18/0x50 
[ 3037.222943] Call Trace: 
[ 3037.222950] [c0000003c74d78a0] [0000000000000e00] 0xe00 (unreliable) 
[ 3037.222958] [c0000003c74d7910] [c0000000003dcdf8] .list_del+0x18/0x50 
[ 3037.222967] [c0000003c74d7990] [c0000000002f9f00] .ext4_mb_release+0x170/0x3e0 
[ 3037.222975] [c0000003c74d7a80] [c0000000002de5f0] .ext4_put_super+0xb0/0x3d0 
[ 3037.222983] [c0000003c74d7b20] [c000000000213320] .generic_shutdown_super+0x90/0x150 
[ 3037.222991] [c0000003c74d7bb0] [c0000000002137a8] .kill_block_super+0x28/0x90 
[ 3037.222999] [c0000003c74d7c30] [c000000000213c94] .deactivate_locked_super+0x94/0xd0 
[ 3037.223008] [c0000003c74d7cb0] [c000000000239150] .mntput_no_expire+0x160/0x1d0 
[ 3037.223016] [c0000003c74d7d50] [c00000000023a8ac] .SyS_umount+0xfc/0x4d0 
[ 3037.223025] [c0000003c74d7e30] [c000000000009e54] syscall_exit+0x0/0x98 
[ 3037.223030] Instruction dump: 
[ 3037.223035] 61290100 7c641b78 f8010010 f821ff91 e9430000 7faa4800 e9230008 41de0044  
[ 3037.223048] 3d000020 61080200 7fa94000 41de0080 <e8a90000> 7fa32840 40de005c e8aa0008  
[ 3037.223066] ---[ end trace b3d9173b8e607cb0 ]--- 
[ 3037.224148]  

Log indicated that crash happened while running this sub-test,
Running fs_mark test: ext4/4
***** Start of Random_MultiDir 2013.07.01 02:53:28 *****
./fs_mark -d /mnt/brd/testarea/testdir1 -d /mnt/brd/testarea/testdir2 -s 16384 -n 4096 -l /mnt/testarea/fs_4.log -r 32 -D 128

#  ./fs_mark  -d  /mnt/brd/testarea/testdir1  -d  /mnt/brd/testarea/testdir2  -s  16384  -n  4096  -l  /mnt/testarea/fs_4.log  -r  32  -D  128 
#	Version Version 3.2, 2 thread(s) starting at Mon Jul  1 02:53:28 2013
#	Sync method: INBAND FSYNC: fsync() per file in write loop.
#	Directories:  Time based hash between directories across 128 subdirectories with 180 seconds per subdirectory.
#	File names: 40 bytes long, (8 initial bytes of time stamp with 32 random bytes at end of name)
#	Files info: size 16384 bytes, written with an IO size of 16384 bytes per write
#	App overhead is time in microseconds spent in the inner file writing loop not doing file writing related system calls.

FSUse%        Count         Size    Files/sec     App Overhead
     8         8192        16384      10155.7            82026
Random_MultiDir Passed: 
 
***** End of Random_MultiDir 2013.07.01 02:53:30 *****
 
*******************************************************************************



                     Number of $FSMARK_S_PARAM bytes Files/Sec

  10260 ++-----+-------+------+-------+------+-------+------+-------+-----++
  10250 ++     +       +      +       +      +      Two Directories + A   ++
  10230 ++                                                                ++
  10220 ++                                                                ++
  10210 ++                                                                ++
  10200 ++                                                                ++
  10180 ++                                                                ++
  10170 ++                                                                ++
  10160 ++                                A                               ++
  10150 ++                                                                ++
  10140 ++                                                                ++
  10120 ++                                                                ++
  10110 ++                                                                ++
  10100 ++                                                                ++
  10090 ++                                                                ++
  10070 ++                                                                ++
  10060 ++     +       +      +       +      +       +      +       +     ++
  10050 ++-----+-------+------+-------+------+-------+------+-------+-----++
       8100   8120    8140   8160    8180   8200    8220   8240    8260   8280
                                  Number of Files

*******************************************************************************

CAI Qian
