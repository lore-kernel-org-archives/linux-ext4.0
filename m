From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: ext3 SMP bug  ?  PANIC in __d_find_alias
Date: Wed, 12 Dec 2007 20:36:40 +0100
Message-ID: <200712122036.41270.rjw@sisk.pl>
References: <475FD03A.7080401@0Bits.COM>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Mitch <Mitch@0bits.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:58749 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754818AbXLLTRl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Dec 2007 14:17:41 -0500
In-Reply-To: <475FD03A.7080401@0Bits.COM>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[Added CC to linux-ext4@vger.kernel.org]

On Wednesday, 12 of December 2007, Mitch wrote:
> Can anyone help with this ? This seems to be a true SMP bug - the same 
> kernel on another UP machine is working fine (although different h/w). 
> Seems like stress (find for example) can easily trigger this. Does it 
> look like i have a bad filesystem ? Can anyone help me figure out which 
> one ? The fact that this is tainted (due to nvidia) is a red herring i 
> think because both my machines (the SMP and UP one) are using the same 
> nvidia module and the panic is in ext3 code.

Which kernel is this?

Did it happen with any previous kernel?


> Dec 10 03:02:43 home kernel: BUG: unable to handle kernel NULL pointer 
> dereference at virtual address 00000000
> Dec 10 03:02:43 home kernel:  printing eip:
> Dec 10 03:02:43 home kernel: c01761fc
> Dec 10 03:02:43 home kernel: *pdpt = 00000000198a6001
> Dec 10 03:02:43 home kernel: *pde = 0000000000000000
> Dec 10 03:02:43 home kernel: Oops: 0000 [#1]
> Dec 10 03:02:43 home kernel: PREEMPT SMP
> Dec 10 03:02:43 home kernel: Modules linked in: loop nls_iso8859_1 
> nls_cp437 vfat fat tun iptable_nat nvidia(P) appletalk psnap llc nfsd expo
> rtfs lockd sunrpc xt_limit xt_tcpudp iptable_mangle ipt_LOG 
> ipt_MASQUERADE nf_nat ipt_TOS ipt_REJECT nf_conntrack_irc 
> nf_conntrack_ftp nf_con
> ntrack_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables 
> ftdi_sio usbserial forcedeth snd_hda_intel snd_seq_oss snd_seq_midi_event
>   snd_seq snd_seq_device snd_pcm_oss snd_pcm snd_timer snd_page_alloc 
> snd_mixer_oss snd usb_storage ehci_hcd ohci_hcd it87 hwmon_vid i2c_dev i
> 2c_core
> Dec 10 03:02:43 home kernel: CPU:    1
> Dec 10 03:02:43 home kernel: EIP:    0060:[__d_find_alias+44/192] 
> Tainted: P        VLI
> Dec 10 03:02:43 home kernel: EFLAGS: 00010282   (2.6.23 #5)
> Dec 10 03:02:43 home kernel: EIP is at __d_find_alias+0x2c/0xc0
> Dec 10 03:02:43 home kernel: eax: 00000000   ebx: c03579bc   ecx: 
> 00000000   edx: 00004000
> Dec 10 03:02:44 home kernel: esi: f55d58bc   edi: 00000000   ebp: 
> 00000001   esp: d479dda4
> Dec 10 03:02:44 home kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033 
> ss: 0068
> Dec 10 03:02:44 home kernel: Process find (pid: 8233, ti=d479c000 
> task=f6d35ab0 task.ti=d479c000)
> Dec 10 03:02:44 home kernel: Stack: f55d58a4 ebf42f00 f6735800 ebf42f00 
> c017832f f55d58a4 ebf42f00 f6735800
> Dec 10 03:02:44 home kernel:        c01ad386 c0177755 ebf42f60 d479de38 
> ebf42f00 e85bf2fc c0357e80 ebf42f00
> Dec 10 03:02:44 home kernel:        d479df04 c016d242 d479de44 f7c04740 
> f1352a98 f1352b0c d479de38 00034c98
> Dec 10 03:02:44 home kernel: Call Trace:
> Dec 10 03:02:44 home kernel:  [d_splice_alias+95/208] 
> d_splice_alias+0x5f/0xd0
> Dec 10 03:02:44 home kernel:  [ext3_lookup+230/288] ext3_lookup+0xe6/0x120
> Dec 10 03:02:44 home kernel:  [d_alloc+309/416] d_alloc+0x135/0x1a0
> Dec 10 03:02:44 home kernel:  [do_lookup+290/416] do_lookup+0x122/0x1a0
> Dec 10 03:02:44 home kernel:  [__link_path_walk+1873/3408] 
> __link_path_walk+0x751/0xd50
> Dec 10 03:02:44 home kernel:  [link_path_walk+101/192] 
> link_path_walk+0x65/0xc0
> Dec 10 03:02:44 home kernel:  [link_path_walk+69/192] 
> link_path_walk+0x45/0xc0
> Dec 10 03:02:44 home kernel:  [nameidata_to_filp+53/64] 
> nameidata_to_filp+0x35/0x40
> Dec 10 03:02:44 home kernel:  [do_filp_open+75/96] do_filp_open+0x4b/0x60
> Dec 10 03:02:44 home kernel:  [do_path_lookup+120/448] 
> do_path_lookup+0x78/0x1c0
> Dec 10 03:02:44 home kernel:  [getname+160/192] getname+0xa0/0xc0
> Dec 10 03:02:44 home kernel:  [__user_walk_fd+59/96] 
> __user_walk_fd+0x3b/0x60
> Dec 10 03:02:44 home kernel:  [vfs_lstat_fd+31/80] vfs_lstat_fd+0x1f/0x50
> Dec 10 03:02:44 home kernel:  [nameidata_to_filp+53/64] 
> nameidata_to_filp+0x35/0x40
> Dec 10 03:02:44 home kernel:  [do_filp_open+75/96] do_filp_open+0x4b/0x60
> Dec 10 03:02:44 home kernel:  [sys_lstat64+15/48] sys_lstat64+0xf/0x30
> Dec 10 03:02:44 home kernel:  [__fput+257/352] __fput+0x101/0x160
> Dec 10 03:02:44 home kernel:  [mntput_no_expire+19/96] 
> mntput_no_expire+0x13/0x60
> Dec 10 03:02:44 home kernel:  [filp_close+71/128] filp_close+0x47/0x80
> Dec 10 03:02:44 home kernel:  [sys_close+102/208] sys_close+0x66/0xd0
> Dec 10 03:02:44 home kernel:  [sysenter_past_esp+95/133] 
> sysenter_past_esp+0x5f/0x85
> Dec 10 03:02:44 home kernel:  =======================
> Dec 10 03:02:44 home kernel: Code: 89 c1 89 d5 57 56 8d 70 18 53 8b 40 
> 18 31 db 39 c6 74 6c 0f b7 51 6a 31 ff 81 e2 00 f0 00 00 eb 0a 85 ed 7
> 4 6a 39 ce 74 2e 89 c8 <8b> 08 0f 18 01 90 81 fa 00 40 00 00 8d 58 bc 74 
> 06 f6 43 04 10
> Dec 10 03:02:44 home kernel: EIP: [__d_find_alias+44/192] 
> __d_find_alias+0x2c/0xc0 SS:ESP 0068:d479dda4
> Dec 10 03:02:44 home kernel: note: find[8233] exited with preempt_count 1
> Dec 10 03:02:44 home kernel: BUG: scheduling while atomic: 
> find/0x10000002/8233
> Dec 10 03:02:44 home kernel:  [schedule+1474/1728] 
> __sched_text_start+0x5c2/0x6c0
> Dec 10 03:02:44 home kernel:  [__cond_resched+24/48] 
> __cond_resched+0x18/0x30
> Dec 10 03:02:44 home kernel:  [cond_resched+42/64] cond_resched+0x2a/0x40
> Dec 10 03:02:44 home kernel:  [unmap_vmas+1502/1536] unmap_vmas+0x5de/0x600
> Dec 10 03:02:44 home kernel:  [exit_mmap+123/288] exit_mmap+0x7b/0x120
> Dec 10 03:02:44 home kernel:  [mmput+30/128] mmput+0x1e/0x80
> Dec 10 03:02:44 home kernel:  [do_exit+272/2048] do_exit+0x110/0x800
> Dec 10 03:02:44 home kernel:  [die+588/592] die+0x24c/0x250
> Dec 10 03:02:44 home kernel:  [do_page_fault+722/2016] 
> do_page_fault+0x2d2/0x7e0
> Dec 10 03:02:44 home kernel:  [do_page_fault+0/2016] do_page_fault+0x0/0x7e0
> Dec 10 03:02:44 home kernel:  [error_code+114/120] error_code+0x72/0x78
> Dec 10 03:02:44 home kernel:  [__d_find_alias+44/192] 
> __d_find_alias+0x2c/0xc0
> Dec 10 03:02:44 home kernel:  [d_splice_alias+95/208] 
> d_splice_alias+0x5f/0xd0
> Dec 10 03:02:44 home kernel:  [ext3_lookup+230/288] ext3_lookup+0xe6/0x120
> Dec 10 03:02:44 home kernel:  [d_alloc+309/416] d_alloc+0x135/0x1a0
> Dec 10 03:02:44 home kernel:  [do_lookup+290/416] do_lookup+0x122/0x1a0
> Dec 10 03:02:44 home kernel:  [__link_path_walk+1873/3408] 
> __link_path_walk+0x751/0xd50
> Dec 10 03:02:44 home kernel:  [link_path_walk+101/192] 
> link_path_walk+0x65/0xc0
> Dec 10 03:02:44 home kernel:  [link_path_walk+69/192] 
> link_path_walk+0x45/0xc0
> Dec 10 03:02:44 home kernel:  [nameidata_to_filp+53/64] 
> nameidata_to_filp+0x35/0x40
> Dec 10 03:02:44 home kernel:  [do_filp_open+75/96] do_filp_open+0x4b/0x60
> Dec 10 03:02:44 home kernel:  [do_path_lookup+120/448] 
> do_path_lookup+0x78/0x1c0
> Dec 10 03:02:44 home kernel:  [getname+160/192] getname+0xa0/0xc0
> Dec 10 03:02:44 home kernel:  [__user_walk_fd+59/96] 
> __user_walk_fd+0x3b/0x60
> Dec 10 03:02:44 home kernel:  [vfs_lstat_fd+31/80] vfs_lstat_fd+0x1f/0x50
> Dec 10 03:02:44 home kernel:  [nameidata_to_filp+53/64] 
> nameidata_to_filp+0x35/0x40
> Dec 10 03:02:44 home kernel:  [do_filp_open+75/96] do_filp_open+0x4b/0x60
> Dec 10 03:02:44 home kernel:  [sys_lstat64+15/48] sys_lstat64+0xf/0x30
> Dec 10 03:02:44 home kernel:  [__fput+257/352] __fput+0x101/0x160
> Dec 10 03:02:44 home kernel:  [mntput_no_expire+19/96] 
> mntput_no_expire+0x13/0x60
> Dec 10 03:02:44 home kernel:  [filp_close+71/128] filp_close+0x47/0x80
> Dec 10 03:02:44 home kernel:  [sys_close+102/208] sys_close+0x66/0xd0
> Dec 10 03:02:44 home kernel:  [sysenter_past_esp+95/133] 
> sysenter_past_esp+0x5f/0x85
> Dec 10 03:02:44 home kernel:  =======================
> Dec 10 03:02:44 home kernel: BUG: scheduling while atomic: 
> find/0x10000002/8233
> Dec 10 03:02:44 home kernel:  [schedule+1474/1728] 
> __sched_text_start+0x5c2/0x6c0
> Dec 10 03:02:44 home kernel:  [release_pages+295/336] 
> release_pages+0x127/0x150
> Dec 10 03:02:44 home kernel:  [reschedule_interrupt+40/48] 
> reschedule_interrupt+0x28/0x30
> Dec 10 03:02:44 home kernel:  [__cond_resched+24/48] 
> __cond_resched+0x18/0x30
> Dec 10 03:02:44 home kernel:  [cond_resched+42/64] cond_resched+0x2a/0x40
> Dec 10 03:02:44 home kernel:  [unmap_vmas+1502/1536] unmap_vmas+0x5de/0x600
> Dec 10 03:02:44 home kernel:  [exit_mmap+123/288] exit_mmap+0x7b/0x120
> Dec 10 03:02:44 home kernel:  [mmput+30/128] mmput+0x1e/0x80
> Dec 10 03:02:44 home kernel:  [do_exit+272/2048] do_exit+0x110/0x800
> Dec 10 03:02:44 home kernel:  [die+588/592] die+0x24c/0x250
> Dec 10 03:02:44 home kernel:  [do_page_fault+722/2016] 
> do_page_fault+0x2d2/0x7e0
> Dec 10 03:02:44 home kernel:  [do_page_fault+0/2016] do_page_fault+0x0/0x7e0
> Dec 10 03:02:44 home kernel:  [error_code+114/120] error_code+0x72/0x78
> Dec 10 03:02:44 home kernel:  [__d_find_alias+44/192] 
> __d_find_alias+0x2c/0xc0
> Dec 10 03:02:44 home kernel:  [d_splice_alias+95/208] 
> d_splice_alias+0x5f/0xd0
> Dec 10 03:02:44 home kernel:  [ext3_lookup+230/288] ext3_lookup+0xe6/0x120
> Dec 10 03:02:44 home kernel:  [d_alloc+309/416] d_alloc+0x135/0x1a0
> Dec 10 03:02:44 home kernel:  [do_lookup+290/416] do_lookup+0x122/0x1a0
> Dec 10 03:02:44 home kernel:  [__link_path_walk+1873/3408] 
> __link_path_walk+0x751/0xd50
> Dec 10 03:02:44 home kernel:  [link_path_walk+101/192] 
> link_path_walk+0x65/0xc0
> Dec 10 03:02:44 home kernel:  [link_path_walk+69/192] 
> link_path_walk+0x45/0xc0
> Dec 10 03:02:44 home kernel:  [nameidata_to_filp+53/64] 
> nameidata_to_filp+0x35/0x40
> Dec 10 03:02:44 home kernel:  [do_filp_open+75/96] do_filp_open+0x4b/0x60
> Dec 10 03:02:44 home kernel:  [do_path_lookup+120/448] 
> do_path_lookup+0x78/0x1c0
> Dec 10 03:02:44 home kernel:  [getname+160/192] getname+0xa0/0xc0
> Dec 10 03:02:44 home kernel:  [__user_walk_fd+59/96] 
> __user_walk_fd+0x3b/0x60
> Dec 10 03:02:44 home kernel:  [vfs_lstat_fd+31/80] vfs_lstat_fd+0x1f/0x50
> Dec 10 03:02:44 home kernel:  [nameidata_to_filp+53/64] 
> nameidata_to_filp+0x35/0x40
> Dec 10 03:02:44 home kernel:  [do_filp_open+75/96] do_filp_open+0x4b/0x60
> Dec 10 03:02:44 home kernel:  [sys_lstat64+15/48] sys_lstat64+0xf/0x30
> Dec 10 03:02:44 home kernel:  [__fput+257/352] __fput+0x101/0x160
> Dec 10 03:02:44 home kernel:  [mntput_no_expire+19/96] 
> mntput_no_expire+0x13/0x60
> Dec 10 03:02:44 home kernel:  [filp_close+71/128] filp_close+0x47/0x80
> Dec 10 03:02:44 home kernel:  [sys_close+102/208] sys_close+0x66/0xd0
> Dec 10 03:02:44 home kernel:  [sysenter_past_esp+95/133] 
> sysenter_past_esp+0x5f/0x85
> Dec 10 03:02:44 home kernel:  =======================
