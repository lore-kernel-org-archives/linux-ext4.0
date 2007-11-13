From: Jan Kara <jack@suse.cz>
Subject: Re: Oops 2.6.23.1 in ext3+jbd at journal_put_journal_head
Date: Tue, 13 Nov 2007 18:21:30 +0100
Message-ID: <20071113172130.GA13733@atrey.karlin.mff.cuni.cz>
References: <4738AC21.8070507@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>, sct@redhat.com,
	akpm@linux-foundation.org, adilger@clusterfs.com
To: Mark Lord <lkml@rtr.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:53121 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150AbXKMRVb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Nov 2007 12:21:31 -0500
Content-Disposition: inline
In-Reply-To: <4738AC21.8070507@rtr.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello,

> A one-time event thus far, happened under very heavy I/O,
> Dell i9400 Core2Duo notebook w/3GB ram, single SATA drive with ext3.
> Had to cycle power to get it back and see this Oops in the syslog:
> 
> : BUG: unable to handle kernel paging request at virtual address 430a7261
> :  printing eip:
> : c01a6605
> : *pde = 00000000
> : Oops: 0002 [#1]
> : PREEMPT SMP
> : Modules linked in: nls_iso8859_1 vfat fat usb_storage ide_core libusual 
> hci_usb ext2 loop nls_cp437 isofs zlib_inflate udf vmnet(P) vmblock(P) 
> vmmon(P) binfmt_misc rfcomm l2cap bluetooth nfs nfsd exportfs lockd nfs_acl 
> auth_rpcgss sunrpc acpi_cpufreq cpufreq_stats cpufreq_userspace 
> cpufreq_ondemand cpufreq_conservative freq_table cpufreq_powersave 
> container fan firmware_class af_packet pciehp usbhid hid pci_hotplug visor 
> usbserial fuse mousedev snd_hda_intel snd_pcm_oss snd_pcm snd_mixer_oss 
> snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event 
> serio_raw snd_seq snd_timer snd_seq_device sg thermal firewire_ohci snd 
> pcspkr sr_mod cdrom psmouse firewire_core sdhci mmc_core b44 mii crc_itu_t 
> ac uhci_hcd ehci_hcd intel_agp agpgart processor button soundcore 
> snd_page_alloc usbcore battery unix
> : CPU:    1
> : EIP:    0060:[journal_put_journal_head+64/209]    Tainted: P        VLI
> : EFLAGS: 00010202   (2.6.23.1-slab #15)
> : EIP is at journal_put_journal_head+0x40/0xd1
> : eax: c2bf7000   ebx: 430a7261   ecx: 00000000   edx: c24f4780
> : esi: f000fea5   edi: c24f4780   ebp: f000fea5   esp: c2bf7e38
> : ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
  Hmm, your pointer to buffer_head in journal_head has been overwritten
by some garbage - it actually looks like ASCII ("C\n ra"). I think your
journal_head pointer is stored in EAX (at least if I compile SMP kernel
for i386 it is) and that is 0xc2bd7000 - start of the page. So probably
some driver went wild and overwritten a piece of memory which did not
belong to it... I suggest turning on a few debugging options (like
DEBUG_SLAB) to catch the offender.

> : Process kswapd0 (pid: 243, ti=c2bf7000 task=c29ec030 task.ti=c2bf7000)
> : Stack: 00000000 d6216868 0000002a d4f52670 00000034 f000fea5 00000000 
> c01a34b6
> :        00000246 c003fe08 ef082d98 ef082d4c ef082d4c c29f00c0 c003fdb8 
> c0198a8f
> :        00000000 0002ad02 ef082d4c c0145b21 c24f4780 0000000b c014a5e0 
> 0000000e
> : Call Trace:
> :  [journal_try_to_free_buffers+299/383] 
> journal_try_to_free_buffers+0x12b/0x17f
> :  [ext3_releasepage+0/114] ext3_releasepage+0x0/0x72
> :  [try_to_release_page+48/66] try_to_release_page+0x30/0x42
> :  [__invalidate_mapping_pages+116/231] __invalidate_mapping_pages+0x74/0xe7
> :  [invalidate_mapping_pages+15/17] invalidate_mapping_pages+0xf/0x11
> :  [shrink_icache_memory+219/445] shrink_icache_memory+0xdb/0x1bd
> :  [shrink_slab+217/338] shrink_slab+0xd9/0x152
> :  [kswapd+729/1069] kswapd+0x2d9/0x42d
> :  [autoremove_wake_function+0/53] autoremove_wake_function+0x0/0x35
> :  [kswapd+0/1069] kswapd+0x0/0x42d
> :  [kthread+56/95] kthread+0x38/0x5f
> :  [kthread+0/95] kthread+0x0/0x5f
> :  [kernel_thread_helper+7/16] kernel_thread_helper+0x7/0x10
> :  =======================
> : Code: 89 e0 25 00 f0 ff ff ff 48 14 8b 40 08 a8 04 74 05 e8 a6 d6 0e 00 
> f3 90 89 e0 25 00 f0 ff ff ff 40 14 8b 03 a9 00 00 40 00 75 d5 <f0> 0f ba 
> 2b 16 19 c0 85 c0 75 ec 8b 46 04 85 c0 7f 30 c7 44 24
> : EIP: [journal_put_journal_head+64/209] journal_put_journal_head+0x40/0xd1 
> SS:ESP 0068:c2bf7e38
> : note: kswapd0[243] exited with preempt_count 2

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
