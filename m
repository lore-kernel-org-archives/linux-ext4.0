From: Dave Jones <davej@redhat.com>
Subject: WARNING: at fs/ext4/inode.c:230 ext4_evict_inode+0x4b9/0x6d0()
Date: Fri, 12 Jul 2013 15:35:28 -0400
Message-ID: <20130712193528.GA15261@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Linux Kernel <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53620 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757521Ab3GLTfh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 12 Jul 2013 15:35:37 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Just hit a bunch of these..

WARNING: CPU: 0 PID: 995613 at fs/ext4/inode.c:230 ext4_evict_inode+0x4b9/0x6d0()
Modules linked in: 8021q garp mrp bridge stp rfcomm tun nfsd nfs_acl rpcsec_gss_krb5 auth_rpcgss oid_registry nfsv4 nfs lockd 
sunrpc fscache fuse l2tp_ppp l2tp_netlink l2tp_core bnep cmtp kernelcapi hidp scsi_transport_iscsi can_raw ipt_ULOG nfnetlink can_bcm llc2 irda af_802154 x25 can pppoe pppox p
pp_generic af_key slhc af_rxrpc atm rds bluetooth vmw_vsock_vmci_transport vmw_vmci phonet vsock netrom appletalk rose ipx p8023 ax25 psnap p8022 llc nfc rfkill caif_socket ca
if crc_ccitt btrfs xor snd_hda_codec_realtek snd_hda_intel snd_hda_codec raid6_pq libcrc32c snd_pcm zlib_deflate snd_page_alloc snd_timer pcspkr snd serio_raw edac_core soundc
ore r8169 mii sr_mod cdrom pata_atiixp radeon backlight drm_kms_helper ttm
CPU: 0 PID: 995613 Comm: trinity-child1 Not tainted 3.10.0+ #10
Hardware name: Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H, BIOS F12a 04/23/2010
 ffffffff81a1c2b3 ffff88010d537d18 ffffffff816bbb90 0000000000000000
 ffff88010d537d50 ffffffff81043f0c ffff88000c583970 ffff88000c583970
 ffffffff81825420 ffffffff81825420 ffff88011d4f9f90 ffff88010d537d60
Call Trace:
 [<ffffffff816bbb90>] dump_stack+0x4e/0x82
 [<ffffffff81043f0c>] warn_slowpath_common+0x8c/0xc0
 [<ffffffff81043ffa>] warn_slowpath_null+0x1a/0x20
 [<ffffffff81258079>] ext4_evict_inode+0x4b9/0x6d0
 [<ffffffff811da983>] evict+0xa3/0x1a0
 [<ffffffff811db335>] iput+0x105/0x190
 [<ffffffff811eccf4>] sync_inodes_sb+0x194/0x240
 [<ffffffff816c18df>] ? wait_for_completion+0xdf/0x110
 [<ffffffff811f2ad0>] ? generic_write_sync+0x70/0x70
 [<ffffffff811f2ae9>] sync_inodes_one_sb+0x19/0x20
 [<ffffffff811c2100>] iterate_supers+0xb0/0x110
 [<ffffffff811f2d65>] sys_sync+0x35/0x90
 [<ffffffff816cdd94>] tracesys+0xdd/0xe2
---[ end trace 1749b013664e80fc ]---

WARNING: CPU: 1 PID: 998688 at fs/ext4/inode.c:230 ext4_evict_inode+0x4b9/0x6d0()
Modules linked in: 8021q garp mrp bridge stp rfcomm tun nfsd nfs_acl rpcsec_gss_krb5 auth_rpcgss oid_registry nfsv4 nfs lockd sunrpc fscache fuse l2tp_ppp l2tp_netlink l2tp_core bnep cmtp kernelcapi hidp scsi_transport_iscsi can_raw ipt_ULOG nfnetlink can_bcm llc2 irda af_802154 x25 can pppoe pppox ppp_generic af_key slhc af_rxrpc atm rds bluetooth vmw_vsock_vmci_transport vmw_vmci phonet vsock netrom appletalk rose ipx p8023 ax25 psnap p8022 llc nfc rfkill caif_socket caif crc_ccitt btrfs xor snd_hda_codec_realtek snd_hda_intel snd_hda_codec raid6_pq libcrc32c snd_pcm zlib_deflate snd_page_alloc snd_timer pcspkr snd serio_raw edac_core soundcore r8169 mii sr_mod cdrom pata_atiixp radeon backlight drm_kms_helper ttm
CPU: 1 PID: 998688 Comm: gcc Tainted: G        W    3.10.0+ #10 
Hardware name: Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H, BIOS F12a 04/23/2010
 ffffffff81a1c2b3 ffff880126ce7cd0 ffffffff816bbb90 0000000000000000
 ffff880126ce7d08 ffffffff81043f0c ffff880007d88ae0 ffff880007d88ae0
 ffffffff81825420 ffffffff81825420 ffff88011afcd780 ffff880126ce7d18
Call Trace:
 [<ffffffff816bbb90>] dump_stack+0x4e/0x82
 [<ffffffff81043f0c>] warn_slowpath_common+0x8c/0xc0
 [<ffffffff81043ffa>] warn_slowpath_null+0x1a/0x20
 [<ffffffff81258079>] ext4_evict_inode+0x4b9/0x6d0
 [<ffffffff811da983>] evict+0xa3/0x1a0
 [<ffffffff811db335>] iput+0x105/0x190
 [<ffffffff811d6878>] dput+0x1f8/0x2d0
 [<ffffffff811cd73d>] SYSC_renameat+0x35d/0x3b0
 [<ffffffff810b993e>] ? put_lock_stats.isra.27+0xe/0x40
 [<ffffffff810b9f25>] ? lock_release_holdtime.part.28+0xe5/0x160
 [<ffffffff810bcb4d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff81010725>] ? syscall_trace_enter+0x25/0x290
 [<ffffffff811cfd7e>] SyS_renameat+0xe/0x10
 [<ffffffff811cfd9b>] SyS_rename+0x1b/0x20
 [<ffffffff816cdd94>] tracesys+0xdd/0xe2
---[ end trace 1749b013664e812a ]---


That's...

	WARN_ON(atomic_read(&EXT4_I(inode)->i_ioend_count));

