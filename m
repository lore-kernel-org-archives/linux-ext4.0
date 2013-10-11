From: Jan Kara <jack@suse.cz>
Subject: Re: A crash in ext3 on disk failure
Date: Fri, 11 Oct 2013 16:40:25 +0200
Message-ID: <20131011144025.GA27106@quack.suse.cz>
References: <alpine.LRH.2.02.1310110814280.17283@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40862 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932Ab3JKOk5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Oct 2013 10:40:57 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1310110814280.17283@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Fri 11-10-13 08:28:52, Mikulas Patocka wrote:
> I report this crash in the ext3 filesystem. The filesystem is mounted on 
> nbd, the nbd server was rebooted - so the nbd client returned errors on 
> all requests. Those errors caused kernel crash.
> 
> The kernel version is 3.4.62.
> 
> The crash happens in submit_bh when attempting to write the superblock, 
> the condition that caused the crash is BUG_ON(!buffer_mapped(bh));
  Hum, really !buffer_mapped(bh)? That would mean someone called
kill_bdev() on the device with mounted filesystem (that's about the only
way how I can imagine blkdev buffer we hold reference to can get
invalidated). If that really happened that would be the real culprit (I
don't think we want to harden all the places using buffers to verify
whether the buffers weren't invalidated under them). nbd seems to have some
ioctls which call set_blocksize() which would call kill_bdev(). And these
don't seem to check device isn't used by someone else. So maybe that's what
happened?

								Honza
> 
> Mikulas
> 
> block nbd3: Receive control failed (result -104)
> block nbd3: shutting down socket
> end_request: I/O error, dev nbd3, sector 187842584
> end_request: I/O error, dev nbd3, sector 205532832
> end_request: I/O error, dev nbd3, sector 205532584
> end_request: I/O error, dev nbd3, sector 205169504
> end_request: I/O error, dev nbd3, sector 205169256
> end_request: I/O error, dev nbd3, sector 203666336
> end_request: I/O error, dev nbd3, sector 203666088
> end_request: I/O error, dev nbd3, sector 207242104
> end_request: I/O error, dev nbd3, sector 207241856
> block nbd3: queue cleared
> block nbd3: Attempted send on closed socket
> end_request: I/O error, dev nbd3, sector 205532712
> block nbd3: Attempted send on closed socket
> end_request: I/O error, dev nbd3, sector 229789648
> block nbd3: Attempted send on closed socket
> end_request: I/O error, dev nbd3, sector 229789680
> block nbd3: Attempted send on closed socket
> end_request: I/O error, dev nbd3, sector 229789760
> block nbd3: Attempted send on closed socket
> end_request: I/O error, dev nbd3, sector 229789832
> block nbd3: Attempted send on closed socket
> end_request: I/O error, dev nbd3, sector 229789776
> block nbd3: Attempted send on closed socket
> end_request: I/O error, dev nbd3, sector 229785616
> block nbd3: Attempted send on closed socket
> end_request: I/O error, dev nbd3, sector 229785616
> block nbd3: Attempted send on closed socket
> end_request: I/O error, dev nbd3, sector 187842584
> EXT3-fs error (device nbd3): ext3_find_entry: reading directory #5865482 
> offset 0
> block nbd3: Attempted send on closed socket
> end_request: I/O error, dev nbd3, sector 0
> Buffer I/O error on device nbd3, logical block 0
> lost page write due to I/O error on nbd3
> EXT3-fs (nbd3): I/O error while writing superblock
> block nbd3: Attempted send on closed socket
> end_request: I/O error, dev nbd3, sector 187842584
> EXT3-fs error (device nbd3): ext3_find_entry: reading directory #5865482 
> offset 0
> block nbd3: Attempted send on closed socket
> end_request: I/O error, dev nbd3, sector 0
> Buffer I/O error on device nbd3, logical block 0
> lost page write due to I/O error on nbd3
> EXT3-fs (nbd3): I/O error while writing superblock
> block nbd3: Attempted send on closed socket
> end_request: I/O error, dev nbd3, sector 187842584
> EXT3-fs error (device nbd3): ext3_find_entry: reading directory #5865482 
> offset 0
> ------------[ cut here ]------------
> kernel BUG at fs/buffer.c:2880!
> invalid opcode: 0000 [#1] PREEMPT
> Modules linked in: speedstep_smi tun sha1_generic arc4 ecb ppp_mppe 
> ppp_async crc_ccitt ppp_generic slhc ext3 jbd mbcache sha256_generic krng 
> chainiv crypto_wq rng aes_generic cbc cryptomgr aead pcompress dm_crypt 
> crypto_hash crypto_blkcipher crypto_algapi crypto dm_mod loop nbd 
> xt_length xt_limit xt_ipfile xt_state ipt_REJECT xt_conntrack 
> iptable_filter ipt_MASQUERADE xt_tcpudp xt_multiport iptable_nat ip_tables 
> x_tables nf_nat_sip nf_conntrack_sip nf_nat_irc nf_conntrack_irc 
> nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_ftp 
> nf_conntrack af_packet cpufreq_stats cpufreq_powersave ipv6 freq_table 
> speedstep_lib parport_pc parport 8250 serial_core apm 8139too bitrev crc32 
> snd_maestro3 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm 
> uhci_hcd snd_timer microcode snd_page_alloc rtc_cmos ide_cd_mod psmouse 
> pcspkr usbcore snd i2c_piix4 yenta_socket cdrom 3c59x pcmcia_core 
> usb_common mii soundcore i2c_core pcmcia_rsrc intel_agp intel_gtt agpgart 
> unix
> 
> Pid: 26759, comm: bash Tainted: G        W    3.4.62 #3 Dell Computer 
> Corporation Latitude C600                   /Latitude C600
> EIP: 0060:[<c10c8295>] EFLAGS: 00010246 CPU: 0
> EIP is at submit_bh+0xe5/0xf0
> EAX: 00040005 EBX: c49ab6d8 ECX: 00000000 EDX: c49ab6d8
> ESI: 00000211 EDI: 00000211 EBP: 00000001 ESP: d6a5dccc
>  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> CR0: 8005003b CR2: 0901e008 CR3: 10b1c000 CR4: 000006d0
> DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> DR6: ffff0ff0 DR7: 00000400
> Process bash (pid: 26759, ti=d6a5c000 task=d79c8820 task.ti=d6a5c000)
> Stack:
>  c49ab6d8 00000211 c590c400 c10c8e04 d0953e00 c49ab6d8 d8da2cc1 00000001
>  00000046 00000000 0196b320 d0953e00 c590c400 00000001 d8da2dbd 00000001
>  00000001 c1209e99 d0953e00 00000000 d8da2fad d8dac804 d0953f4c d8dab3b8
> Call Trace:
>  [<c10c8e04>] ? __sync_dirty_buffer+0x34/0xa0
>  [<d8da2cc1>] ? ext3_commit_super.constprop.27+0x51/0xe0 [ext3]
>  [<d8da2dbd>] ? ext3_handle_error+0x6d/0xc0 [ext3]
>  [<c1209e99>] ? printk+0x17/0x1b
>  [<d8da2fad>] ? ext3_error+0x4d/0x60 [ext3]
>  [<d8d9ec9c>] ? ext3_find_entry+0x11c/0x590 [ext3]
>  [<c10b5fa5>] ? __d_lookup+0x125/0x1c0
>  [<c10b5fa5>] ? __d_lookup+0x125/0x1c0
>  [<d8d9f156>] ? ext3_lookup+0x46/0x100 [ext3]
>  [<c10a9843>] ? __lookup_hash+0x43/0xe0
>  [<c10ab8e4>] ? do_lookup+0x2c4/0x350
>  [<c10ace2c>] ? path_lookupat+0xfc/0x6c0
>  [<c10ad418>] ? do_path_lookup+0x28/0x80
>  [<c10c8e04>] ? __sync_dirty_buffer+0x34/0xa0
>  [<d8da2cc1>] ? ext3_commit_super.constprop.27+0x51/0xe0 [ext3]
>  [<d8da2dbd>] ? ext3_handle_error+0x6d/0xc0 [ext3]
>  [<c1209e99>] ? printk+0x17/0x1b
>  [<d8da2fad>] ? ext3_error+0x4d/0x60 [ext3]
>  [<d8d9ec9c>] ? ext3_find_entry+0x11c/0x590 [ext3]
>  [<c10b5fa5>] ? __d_lookup+0x125/0x1c0
>  [<c10b5fa5>] ? __d_lookup+0x125/0x1c0
>  [<d8d9f156>] ? ext3_lookup+0x46/0x100 [ext3]
>  [<c10a9843>] ? __lookup_hash+0x43/0xe0
>  [<c10ab8e4>] ? do_lookup+0x2c4/0x350
>  [<c10ace2c>] ? path_lookupat+0xfc/0x6c0
>  [<c10ad418>] ? do_path_lookup+0x28/0x80
>  [<c10adcf3>] ? user_path_at_empty+0x43/0x80
>  [<c10add46>] ? user_path_at+0x16/0x20
>  [<c10a44ab>] ? vfs_fstatat+0x4b/0x80
>  [<c10a4518>] ? vfs_stat+0x18/0x20
>  [<c10a492e>] ? sys_stat64+0xe/0x30
>  [<c12103d0>] ? sysenter_do_call+0x12/0x26
> Code: ff 46 30 89 f2 89 f8 e8 fa c6 04 00 8b 5e 10 89 f0 c1 e3 18 c1 fb 1f 
> e8 da 4c 00 00 83 e3 a1 89 d8 5b 5e 5f c3 0f 0b 0f 0b 0f 0b <0f> 0b 0f 0b 
> 8d b4 26 00 00 00 00 53 83 fa a1 89 c3 8b 48 3c 74
> EIP: [<c10c8295>] submit_bh+0xe5/0xf0 SS:ESP 0068:d6a5dccc
> ---[ end trace c62efc9e706b2739 ]---
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
