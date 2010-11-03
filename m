From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: BUG in ext4 with 2.6.37-rc1
Date: Wed, 03 Nov 2010 14:14:21 -0400
Message-ID: <4CD1A67D.5060909@redhat.com>
References: <20101102202013.GA3861@elliptictech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756246Ab0KCSOR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Nov 2010 14:14:17 -0400
In-Reply-To: <20101102202013.GA3861@elliptictech.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/2/10 4:20 PM, Nick Bowler wrote:
> The following BUG occurred today while compiling gcc, with 2.6.37-rc1+.
> More precisely, commit 7fe19da4ca38 ("preempt: fix kernel build with
> !CONFIG_BKL") with http://permalink.gmane.org/gmane.linux.nfs/36521
> applied on top.  It basically took out the whole system.
> 
>   ------------[ cut here ]------------
>   kernel BUG at /scratch_space/linux-2.6/fs/ext4/page-io.c:146!

138 ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags)
139 {
140         ext4_io_end_t *io = NULL;
141
142         io = kmem_cache_alloc(io_end_cachep, flags);
143         if (io) {
144                 memset(io, 0, sizeof(*io));
145                 io->inode = igrab(inode);
146                 BUG_ON(!io->inode);

igrab can fail if it's being torn down:

                /*
                 * Handle the case where s_op->clear_inode is not been
                 * called yet, and somebody is calling igrab
                 * while the inode is getting freed.
                 */
                inode = NULL;

and boom.

-Eric

>   invalid opcode: 0000 [#1] PREEMPT SMP 
>   last sysfs file: /sys/devices/pci0000:00/0000:00:1d.7/usb8/8-3/8-3:1.0/uevent
>   CPU 0 
>   Modules linked in: nls_iso8859_1 nls_cp437 vfat fat nfs nfs_acl bridge stp llc autofs4 nfsd lockd sunrpc exportfs ipv6 iptable_filter iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer snd soundcore snd_page_alloc sg evdev usb_storage ext2 ehci_hcd sr_mod cdrom loop tun acpi_cpufreq mperf arc4 ecb crypto_blkcipher cryptomgr aead crypto_algapi rt2800pci rt2800lib crc_ccitt rt2x00pci rt2x00lib mac80211 cfg80211 eeprom_93cx6 e1000e
>   
>   Pid: 30058, comm: ranlib Not tainted 2.6.37-rc1-00004-g1c7d46a #60 WG43M/Aspire X3810
>   RIP: 0010:[<ffffffff81107409>]  [<ffffffff81107409>] ext4_init_io_end+0x3c/0x72
>   RSP: 0018:ffff880016a4b788  EFLAGS: 00010246
>   RAX: 0000000000000000 RBX: ffff880062e2abe0 RCX: 0000000000000000
>   RDX: ffffea0002398c88 RSI: ffff8800018c3948 RDI: ffff880016a4a000
>   RBP: ffff880016a4b798 R08: 0000000000000023 R09: 0000000000008000
>   R10: ffff88013beaace0 R11: ffff88013beaace0 R12: ffff8800018c3948
>   R13: ffff880016a4b918 R14: ffff880100cd5f30 R15: ffffea0002398c88
>   FS:  00002abaac327b20(0000) GS:ffff8800b7a00000(0000) knlGS:0000000000000000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: 00007f573b7a8000 CR3: 000000008d3ed000 CR4: 00000000000406f0
>   DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>   DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>   Process ranlib (pid: 30058, threadinfo ffff880016a4a000, task ffff880016b59640)
>   Stack:
>    ffff8800a59999c0 ffffea0002398c88 ffff880016a4b818 ffffffff811075b1
>    ffff88013e028000 ffff880016a4bc68 0000100016b59640 ffffea0002398c88
>    ffff8800a59999c0 ffff880062e2abe0 0000100000008000 0000000000000080
>   Call Trace:
>    [<ffffffff811075b1>] ext4_bio_write_page+0x172/0x307
>    [<ffffffff811033a7>] mpage_da_submit_io+0x2f9/0x37b
>    [<ffffffff811068d7>] mpage_da_map_and_submit+0x2cc/0x2e2
>    [<ffffffff811069b3>] mpage_add_bh_to_extent+0xc6/0xd5
>    [<ffffffff81106c66>] write_cache_pages_da+0x2a4/0x3ac
>    [<ffffffff81107044>] ext4_da_writepages+0x2d6/0x44d
>    [<ffffffff81087910>] do_writepages+0x1c/0x25
>    [<ffffffff810810a4>] __filemap_fdatawrite_range+0x4b/0x4d
>    [<ffffffff810815f5>] filemap_fdatawrite_range+0xe/0x10
>    [<ffffffff81122a2e>] jbd2_journal_begin_ordered_truncate+0x7b/0xa2
>    [<ffffffff8110615d>] ext4_evict_inode+0x57/0x24c
>    [<ffffffff810c14a3>] evict+0x22/0x92
>    [<ffffffff810c1a3d>] iput+0x212/0x249
>    [<ffffffff810bdf16>] dentry_iput+0xa1/0xb9
>    [<ffffffff810bdf6b>] d_kill+0x3d/0x5d
>    [<ffffffff810be613>] dput+0x13a/0x147
>    [<ffffffff810b990d>] sys_renameat+0x1b5/0x258
>    [<ffffffff81145f71>] ? _atomic_dec_and_lock+0x2d/0x4c
>    [<ffffffff810b2950>] ? cp_new_stat+0xde/0xea
>    [<ffffffff810b29c1>] ? sys_newlstat+0x2d/0x38
>    [<ffffffff810b99c6>] sys_rename+0x16/0x18
>    [<ffffffff81002a2b>] system_call_fastpath+0x16/0x1b
>   Code: e8 97 4c fa ff 49 89 c4 48 85 c0 74 4c 31 c0 b9 1a 01 00 00 4c 89 e7 f3 ab 48 89 df e8 1f 95 fb ff 49 89 44 24 10 48 85 c0 75 04 <0f> 0b eb fe 49 8d 44 24 40 49 c7 44 24 38 00 05 00 00 49 89 44 
>   RIP  [<ffffffff81107409>] ext4_init_io_end+0x3c/0x72
>    RSP <ffff880016a4b788>
>   ---[ end trace ddc79adad95a6879 ]---
> 

