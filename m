From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: kernel BUG at fs/buffer.c:1234!
Date: Wed, 19 Jun 2013 14:55:37 -0400
Message-ID: <20130619185537.GB24587@thunk.org>
References: <51C1DF40.7030708@null-ptr.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dustin Lundquist <dustin@null-ptr.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59494 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934694Ab3FSSzm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Jun 2013 14:55:42 -0400
Content-Disposition: inline
In-Reply-To: <51C1DF40.7030708@null-ptr.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 19, 2013 at 09:41:36AM -0700, Dustin Lundquist wrote:
> I've run into the following oops several times with the 3.10-rc3
> through -rc6, and they have not occurred under 3.9. Originally they
> only occurred when running Google Chrome, but this is the first time
> it has happened in another application.

So this is very strange.  fs/buffer.c:1234 for 3.10-rc6 is this
BUG_ON:

static inline void check_irqs_on(void)
{
#ifdef irqs_disabled
	BUG_ON(irqs_disabled());
#endif
}

The only place where ext4 turns off irq's is very briefly in
fs/ext4/page-io.c, and it's pretty easy to visually inspect all of the
calls to spin_lock_irqsave() and spin_lock_irqrestore() and
lock_irq_save() and local_irq_restore() are properly bracketed --- and
the stack trace does not have any of the functions that are defined in
fs/ext4/page_io.c.

I notice from the dmesg file that one of the ext4 file systems is
mounted on a device mapper volume.  What kind of dm device is it?

	     	    	   	    - Ted



> 
> After this occurs I can not access any local files, but still able
> to use remote systems and executables which are already cached.
> 
> [36386.297932] ------------[ cut here ]------------
> [36386.297961] kernel BUG at fs/buffer.c:1234!
> [36386.297982] invalid opcode: 0000 [#1] SMP
> [36386.298004] Modules linked in: hidp ecb ip6table_filter
> ip6_tables ebtable_nat ebtables ipt_MASQUERADE iptable_nat
> nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
> nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp
> iptable_filter ip_tables x_tables bridge stp llc parport_pc ppdev lp
> parport cpufreq_conservative cpufreq_powersave cpufreq_stats
> cpufreq_userspace rfcomm bnep binfmt_misc uinput loop ecryptfs
> hid_generic usbhid hid snd_hda_codec_hdmi snd_hda_codec_realtek
> uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core videodev
> btusb bluetooth joydev coretemp kvm_intel kvm crc32c_intel
> ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper
> ablk_helper cryptd iTCO_wdt iTCO_vendor_support arc4 snd_hda_intel
> snd_hda_codec thinkpad_acpi iwldvm snd_hwdep snd_pcm snd_page_alloc
> mac80211 nvram snd_seq snd_timer snd_seq_device psmouse serio_raw
> i915 snd evdev iwlwifi drm_kms_helper microcode battery i2c_i801 drm
> ac lpc_ich mfd_core pcspkr i2c_algo_bit cfg80211 i2c_core video wmi
> ehci_pci rfkill soundcore ehci_hcd acpi_cpufreq mperf button
> processor ext4 crc16 jbd2 mbcache dm_mod sg sd_mod crc_t10dif ahci
> libahci thermal thermal_sys xhci_hcd libata usbcore usb_common
> e1000e ptp sdhci_pci pps_core sdhci scsi_mod mmc_core
> [36386.298747] CPU: 1 PID: 28664 Comm: debconf-communi Not tainted
> 3.10.0-rc6 #1
> [36386.298836] Hardware name: LENOVO 2306CTO/2306CTO, BIOS G2ET94WW
> (2.54 ) 04/30/2013
> [36386.298930] task: ffff88039f3d8040 ti: ffff8803653bc000 task.ti:
> ffff8803653bc000
> [36386.299021] RIP: 0010:[<ffffffff8112396e>]  [<ffffffff8112396e>]
> check_irqs_on+0x7/0xa
> [36386.299130] RSP: 0018:ffff8803653bd540  EFLAGS: 00010046
> [36386.299196] RAX: 0000000000000096 RBX: 0000000000001000 RCX:
> 0000000000000000
> [36386.299283] RDX: 0000000000001000 RSI: 0000000000a8207b RDI:
> ffff88041d788a80
> [36386.299370] RBP: ffff88041d788a80 R08: 0000000001400000 R09:
> 0000000000000010
> [36386.299457] R10: 0000000000000000 R11: 000000000000000e R12:
> 0000000000a8207b
> [36386.299543] R13: 0000000000000001 R14: 0000000000a8207b R15:
> 0000000000000000
> [36386.299638] FS:  00007f09ccc6d700(0000) GS:ffff88041e240000(0000)
> knlGS:0000000000000000
> [36386.299756] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [36386.299845] CR2: 0000000001852c38 CR3: 0000000352268000 CR4:
> 00000000001407e0
> [36386.299952] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [36386.300061] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
> [36386.300166] Stack:
> [36386.300200]  ffffffff81123bb5 0000000000000001 ffff8803fae99fb0
> ffff8803653bd5b0
> [36386.300329]  ffffffffa015010d ffff8803653bd6b4 ffff8803653bd630
> ffff8803653bd630
> [36386.300458]  ffff8803fae9a870 0000000000000000 ffff8803653bd6b4
> 0000000000001000
> [36386.300591] Call Trace:
> [36386.300641]  [<ffffffff81123bb5>] ? __find_get_block+0x17/0x162
> [36386.300770]  [<ffffffffa015010d>] ?
> __check_block_validity.constprop.53+0x27/0x65 [ext4]
> [36386.300898]  [<ffffffff811248f1>] ? __getblk+0x1b/0x275
> [36386.301004]  [<ffffffffa0151c55>] ? ext4_getblk+0x9b/0x15d [ext4]
> [36386.301118]  [<ffffffffa0151d24>] ? ext4_bread+0xd/0x61 [ext4]
> [36386.301234]  [<ffffffffa0157f2f>] ?
> __ext4_read_dirblock+0x35/0x251 [ext4]
> [36386.301361]  [<ffffffffa015836c>] ? dx_probe+0x38/0x308 [ext4]
> [36386.301469]  [<ffffffffa0157fae>] ?
> __ext4_read_dirblock+0xb4/0x251 [ext4]
> [36386.301593]  [<ffffffffa01590cc>] ? ext4_dx_find_entry+0x3d/0x152 [ext4]
> [36386.301698]  [<ffffffff810eef43>] ? ____cache_alloc+0x41/0x251
> [36386.301792]  [<ffffffff810eef43>] ? ____cache_alloc+0x41/0x251
> [36386.301890]  [<ffffffff81194244>] ? blkcipher_walk_done+0xb2/0x16f
> [36386.302008]  [<ffffffffa01592ee>] ? ext4_find_entry+0x10d/0x3be [ext4]
> [36386.302111]  [<ffffffff810efd03>] ? __kmalloc+0x13a/0x14c
> [36386.302196]  [<ffffffff81110e8c>] ? __d_alloc+0x3f/0x141
> [36386.302300]  [<ffffffffa01595d5>] ? ext4_lookup+0x36/0x10b [ext4]
> [36386.302398]  [<ffffffff8110f347>] ? spin_unlock+0x5/0x6
> [36386.306492]  [<ffffffff81107d05>] ? lookup_real+0x24/0x3f
> [36386.310214]  [<ffffffff8110814c>] ? __lookup_hash+0x2a/0x31
> [36386.313899]  [<ffffffff8110bda6>] ? lookup_one_len+0xd3/0xe5
> [36386.317355]  [<ffffffffa05e61e1>] ? ecryptfs_lookup+0xff/0x2d3 [ecryptfs]
> [36386.320621]  [<ffffffff81107d05>] ? lookup_real+0x24/0x3f
> [36386.323711]  [<ffffffff8110b491>] ? do_last+0x509/0xa16
> [36386.326638]  [<ffffffff8110923a>] ? __inode_permission+0x2f/0x95
> [36386.329532]  [<ffffffff8110ba62>] ? path_openat+0xc4/0x335
> [36386.332207]  [<ffffffff8110bf7e>] ? do_filp_open+0x2a/0x6e
> [36386.334746]  [<ffffffff8105b816>] ? load_balance+0xc7/0x5e0
> [36386.337225]  [<ffffffff811419e2>] ? cn_printf+0xda/0xea
> [36386.339602]  [<ffffffff810ffa1b>] ? file_open_name+0x27/0x2d
> [36386.341943]  [<ffffffff810ffa43>] ? filp_open+0x22/0x27
> [36386.344216]  [<ffffffff81142250>] ? do_coredump+0x85e/0xbe6
> [36386.346503]  [<ffffffff81053e11>] ? finish_task_switch+0x78/0x9a
> [36386.348717]  [<ffffffff8103f87a>] ? get_signal_to_deliver+0x46a/0x4a5
> [36386.351041]  [<ffffffff8100214a>] ? do_signal+0x3c/0x504
> [36386.352025]  [<ffffffff811007aa>] ? vfs_write+0xdc/0x103
> [36386.353904]  [<ffffffff81100864>] ? vfs_read+0x93/0xf5
> [36386.356074]  [<ffffffff81002637>] ? do_notify_resume+0x25/0x68
> [36386.358250]  [<ffffffff81370862>] ? int_signal+0x12/0x17
> [36386.360377] Code: db b6 6d 48 c1 fe 03 48 0f af f0 48 b8 00 00 00
> 00 00 88 ff ff 48 c1 e6 0c 48 01 c6 48 01 f2 48 89 57 28 c3 9c 58 f6
> c4 02 75 02 <0f> 0b c3 55 48 c7 c5 60 f3 00 00 83 c8 ff 53 31 db 41
> 52 65 c7
> [36386.365120] RIP  [<ffffffff8112396e>] check_irqs_on+0x7/0xa
> [36386.367479]  RSP <ffff8803653bd540>
> [36386.381228] ---[ end trace 3ddcbffc09c97c49 ]---
> 
> Full dmesg output and .config are here:
> https://gist.github.com/dlundquist/1d94dd938f03c5d06a2b
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
