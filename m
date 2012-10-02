From: Jan Kara <jack@suse.cz>
Subject: Re: Repeatable ext4 oops with 3.6.0 (regression)
Date: Tue, 2 Oct 2012 15:36:42 +0200
Message-ID: <20121002133642.GD22777@quack.suse.cz>
References: <pan.2012.10.02.11.19.55.793436@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Holger Hoffstaette <holger.hoffstaette@googlemail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58184 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359Ab2JBNgo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Oct 2012 09:36:44 -0400
Content-Disposition: inline
In-Reply-To: <pan.2012.10.02.11.19.55.793436@googlemail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 02-10-12 13:19:57, Holger Hoffstaette wrote:
> 
> I can repeatably oops my T60 Thinkpad by starting GThumb (a photo gallery
> viewer) on Gentoo with vanilla 3.6.0:
  Thanks for report! Can you please attach here full dmesg after the oops
happens - the output from syslog seems to be partially filtered which makes
things unnecessarily hard... Thanks!

								Honza

> Oct  2 02:00:25 hho kernel: pool[9151]: segfault at 138 ip b6fa8ee0 sp a89fee2c error 4 in libgio-2.0.so.0.3200.4[b6f85000+156000]
> Oct  2 02:00:29 hho kernel: *pde = 00000000 
> Oct  2 02:00:29 hho kernel: Oops: 0000 [#1] SMP 
> Oct  2 02:00:29 hho kernel: Modules linked in: nfsv4 auth_rpcgss radeon drm_kms_helper ttm drm i2c_algo_bit nfs lockd sunrpc dm_mod snd_hda_codec_analog coretemp kvm_intel kvm i2c_i801 i2c_core ehci_hcd uhci_hcd sr_mod e1000e cdrom usbcore snd_hda_intel usb_common snd_hda_codec snd_pcm snd_page_alloc snd_timer thinkpad_acpi snd video
> Oct  2 02:00:29 hho kernel: Pid: 9153, comm: gthumb Not tainted 3.6.0 #1 LENOVO 20087JG/20087JG
> Oct  2 02:00:29 hho kernel: EIP: 0060:[<c01c0238>] EFLAGS: 00010206 CPU: 0
> Oct  2 02:00:29 hho kernel: EIP is at __kmalloc+0x88/0x150
> Oct  2 02:00:29 hho kernel: EAX: 00000000 EBX: 09000000 ECX: 000f21a4 EDX: 000f21a3
> Oct  2 02:00:29 hho kernel: ESI: f5802380 EDI: 09000000 EBP: f16cbe10 ESP: f16cbde4
> Oct  2 02:00:29 hho kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Oct  2 02:00:29 hho kernel: CR0: 80050033 CR2: 09000000 CR3: 315d3000 CR4: 000007d0
> Oct  2 02:00:29 hho kernel: DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> Oct  2 02:00:29 hho kernel: DR6: ffff0ff0 DR7: 00000400
> Oct  2 02:00:29 hho kernel:  00000018 09000000 000f21a3 c024e3e0 000f21a4 6f5f696d c0236ed9 000080d0
> Oct  2 02:00:29 hho kernel:  e3f3e134 f16cbeac e3f3e134 f16cbe30 c0236ed9 bc6c4748 c23b21b8 f14e8c20
> Oct  2 02:00:29 hho kernel:  e3f3e134 f16cbeac de5c9e00 f16cbe70 c0245c06 e3f3e134 e3f3e134 de5c9e00
> Oct  2 02:00:29 hho kernel:  [<c024e3e0>] ? ext4_follow_link+0x20/0x20
> Oct  2 02:00:29 hho kernel:  [<c0236ed9>] ? ext4_htree_store_dirent+0x29/0x110
> Oct  2 02:00:29 hho kernel:  [<c0236ed9>] ext4_htree_store_dirent+0x29/0x110
> Oct  2 02:00:29 hho kernel:  [<c0245c06>] htree_dirblock_to_tree+0x126/0x1b0
> Oct  2 02:00:29 hho kernel:  [<c0245cf8>] ext4_htree_fill_tree+0x68/0x1d0
> Oct  2 02:00:29 hho kernel:  [<c01bfd4d>] ? kmem_cache_alloc+0x9d/0xd0
> Oct  2 02:00:29 hho kernel:  [<c0236d6b>] ? ext4_readdir+0x71b/0x820
> Oct  2 02:00:29 hho kernel:  [<c0236bd3>] ext4_readdir+0x583/0x820
> Oct  2 02:00:29 hho kernel:  [<c01aaf13>] ? handle_mm_fault+0x133/0x1c0
> Oct  2 02:00:29 hho kernel:  [<c01d7120>] ? sys_ioctl+0x80/0x80
> Oct  2 02:00:29 hho kernel:  [<c02a182c>] ? security_file_permission+0x8c/0xa0
> Oct  2 02:00:29 hho kernel:  [<c01d7120>] ? sys_ioctl+0x80/0x80
> Oct  2 02:00:29 hho kernel:  [<c01d7435>] vfs_readdir+0xa5/0xd0
> Oct  2 02:00:29 hho kernel:  [<c01d75e0>] sys_getdents64+0x60/0xc0
> Oct  2 02:00:29 hho kernel:  [<c04a8bd0>] sysenter_do_call+0x12/0x26
> Oct  2 02:00:29 hho kernel: CR2: 0000000009000000
> Oct  2 02:00:29 hho kernel: ---[ end trace 671b8487c03aa154 ]---
> Oct  2 02:00:30 hho kernel: *pde = 00000000 
> Oct  2 02:00:30 hho kernel: Oops: 0000 [#2] SMP 
> Oct  2 02:00:30 hho kernel: Modules linked in: nfsv4 auth_rpcgss radeon drm_kms_helper ttm drm i2c_algo_bit nfs lockd sunrpc dm_mod snd_hda_codec_analog coretemp kvm_intel kvm i2c_i801 i2c_core ehci_hcd uhci_hcd sr_mod e1000e cdrom usbcore snd_hda_intel usb_common snd_hda_codec snd_pcm snd_page_alloc snd_timer thinkpad_acpi snd video
> Oct  2 02:00:30 hho kernel: Pid: 8552, comm: deluged Tainted: G      D      3.6.0 #1 LENOVO 20087JG/20087JG
> Oct  2 02:00:30 hho kernel: EIP: 0060:[<c01bfcfd>] EFLAGS: 00210206 CPU: 0
> Oct  2 02:00:30 hho kernel: EIP is at kmem_cache_alloc+0x4d/0xd0
> Oct  2 02:00:30Oct  2 02:01:34 hho syslogd 1.5.0: restart.
> 
> Observations:
> 
> - it's 100% repeatable on 3.6.0
> 
> - the stacktrace/oopsing call path is always the same
> 
> - it does *not* happen on 3.5.x (incl. -5-rc1), so the app/libs are not
> corrupted
> 
> - system is stable otherwise, so memory/overheating/bitrot gremlins seem
> very unlikely
> 
> - the fs is plain, clean, uncorrupted ext4 on an Intel SSD.
> 
> AFAICT it tries to traverse a symlink, which might be one into an
> existing/running/stable NFS automount. I have no idea why this would oops,
> as traversing those links in any other way (file manager, shell, ..) works
> just fine. The machine is completely stable otherwise; the problem seems
> to be confined to this particular application/library (libgio).
> 
> Suggestions? I am willing to apply patches over 3.6.0 but cannot bisect at
> the moment (machine too slow & needed for actual work).
> 
> thanks
> Holger
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
