From: Nick Dokos <nicholas.dokos@hp.com>
Subject: Re: Some 64-bit tests
Date: Mon, 08 Jun 2009 23:13:48 -0400
Message-ID: <14597.1244517228@gamaville.dokosmarshall.org>
References: <18887.1244469441@gamaville.dokosmarshall.org>  <20090608201037.GB23723@skywalker>
Reply-To: nicholas.dokos@hp.com
Cc: Nick Dokos <nicholas.dokos@hp.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Valerie Aurora <vaurora@redhat.com>, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from qmta08.westchester.pa.mail.comcast.net ([76.96.62.80]:50410
	"EHLO QMTA08.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751635AbZFIDNV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Jun 2009 23:13:21 -0400
In-Reply-To: Message from "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
   of "Tue, 09 Jun 2009 01:40:37 +0530." <20090608201037.GB23723@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com> wrote:

> Can you try this patch ?
> 
> commit 6a910bd1d28be09ba3a0e073bae78285ce057a5f
> Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Date:   Tue Jun 9 01:38:53 2009 +0530
> 
>     ext4: Use different normalization method for allocation size.
>     
>     Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index ed8482e..7f2423b 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -633,7 +633,7 @@ static void ext4_mb_mark_free_simple(struct super_block *sb,
>  
>  	BUG_ON(len > EXT4_BLOCKS_PER_GROUP(sb));
>  
> -	border = 2 << sb->s_blocksize_bits;
> +	border = 1 << (sb->s_blocksize_bits + 1);
>  
>  	while (len > 0) {
>  		/* find how many blocks can be covered since this position */
> @@ -3063,8 +3063,10 @@ static void ext4_mb_normalize_group_request(struct ext4_allocation_context *ac)
>  ext4_mb_normalize_request(struct ext4_allocation_context *ac,
>  				struct ext4_allocation_request *ar)
>  {
> -	int bsbits, max;
> +	int bsbits, i;
> +	loff_t max;
>  	ext4_lblk_t end;
> +	unsigned int s_mb_stream_request;
>  	loff_t size, orig_size, start_off;
>  	ext4_lblk_t start, orig_start;
>  	struct ext4_inode_info *ei = EXT4_I(ac->ac_inode);
> @@ -3090,54 +3092,52 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
>  	}
>  
>  	bsbits = ac->ac_sb->s_blocksize_bits;
> +	s_mb_stream_request = EXT4_SB(ac->ac_sb)->s_mb_stream_request;
> +	/* make sure this is power of 2 */
> +	s_mb_stream_request =
> +		roundup_pow_of_two((unsigned long)s_mb_stream_request);
>  
>  	/* first, let's learn actual file size
>  	 * given current request is allocated */
>  	size = ac->ac_o_ex.fe_logical + ac->ac_o_ex.fe_len;
> -	size = size << bsbits;
> -	if (size < i_size_read(ac->ac_inode))
> -		size = i_size_read(ac->ac_inode);
> -
> -	/* max size of free chunks */
> -	max = 2 << bsbits;
> +	if (size < (i_size_read(ac->ac_inode) >> bsbits))
> +		size = i_size_read(ac->ac_inode) >> bsbits;
> +	/*
> +	 * max free chunk blocks. 
> +	 * (max buddy cache order is (bsbits + 1).
> +	 */
> +	max = 1 << (bsbits + 1);
>  
>  #define NRL_CHECK_SIZE(req, size, max, chunk_size)	\
> -		(req <= (size) || max <= (chunk_size))
> +	(((req <= (size)) && (req <= (chunk_size))) || max <= (chunk_size))
>  
>  	/* first, try to predict filesize */
>  	/* XXX: should this table be tunable? */
>  	start_off = 0;
> -	if (size <= 16 * 1024) {
> -		size = 16 * 1024;
> -	} else if (size <= 32 * 1024) {
> -		size = 32 * 1024;
> -	} else if (size <= 64 * 1024) {
> -		size = 64 * 1024;
> -	} else if (size <= 128 * 1024) {
> -		size = 128 * 1024;
> -	} else if (size <= 256 * 1024) {
> -		size = 256 * 1024;
> -	} else if (size <= 512 * 1024) {
> -		size = 512 * 1024;
> -	} else if (size <= 1024 * 1024) {
> -		size = 1024 * 1024;
> -	} else if (NRL_CHECK_SIZE(size, 4 * 1024 * 1024, max, 2 * 1024)) {
> -		start_off = ((loff_t)ac->ac_o_ex.fe_logical >>
> -						(21 - bsbits)) << 21;
> -		size = 2 * 1024 * 1024;
> -	} else if (NRL_CHECK_SIZE(size, 8 * 1024 * 1024, max, 4 * 1024)) {
> -		start_off = ((loff_t)ac->ac_o_ex.fe_logical >>
> -							(22 - bsbits)) << 22;
> -		size = 4 * 1024 * 1024;
> -	} else if (NRL_CHECK_SIZE(ac->ac_o_ex.fe_len,
> -					(8<<20)>>bsbits, max, 8 * 1024)) {
> -		start_off = ((loff_t)ac->ac_o_ex.fe_logical >>
> -							(23 - bsbits)) << 23;
> -		size = 8 * 1024 * 1024;
> -	} else {
> -		start_off = (loff_t)ac->ac_o_ex.fe_logical << bsbits;
> -		size	  = ac->ac_o_ex.fe_len << bsbits;
> +
> +	/*
> +	 * less than s_mb_stream_request is using locality group
> +	 * preallocation
> +	 */
> +	if (size <= s_mb_stream_request)
> +		size = s_mb_stream_request;
> +	i = 4;
> +	while (1) {
> +		/*
> +		 * if (size <= 4 * s_mb_stream ||
> +		 * max <= 2 * s_mb_stream ) size = 2 * s_mb_stream
> +		 */
> +		if (NRL_CHECK_SIZE(size, i * s_mb_stream_request,
> +					max, ((i * s_mb_stream_request) >> 1))) {
> +			/* number of blocks */
> +			size = (i * s_mb_stream_request) >> 1;
> +			size = size << bsbits;
> +			start_off = (loff_t)ac->ac_o_ex.fe_logical & ~(size - 1);
> +			break;
> +		}
> +		i = i << 1;
>  	}
> +
>  	orig_size = size = size >> bsbits;
>  	orig_start = start = start_off >> bsbits;
>  

Aneesh,

I tried this on top of 2.6.30-rc8 and I hit a couple of BUGs, one in pdflush
and the other in the Lustre teest program (liverfs):

Jun  8 22:49:13 shifter kernel: ------------[ cut here ]------------
Jun  8 22:49:13 shifter kernel: kernel BUG at fs/ext4/mballoc.c:3245!
Jun  8 22:49:13 shifter kernel: invalid opcode: 0000 [#1] SMP 
Jun  8 22:49:13 shifter kernel: last sysfs file: /sys/devices/system/cpu/cpu15/cache/index2/shared_cpu_map
Jun  8 22:49:13 shifter kernel: CPU 4 
Jun  8 22:49:13 shifter kernel: Modules linked in: ext4 jbd2 crc16 bridge stp bnep sco l2cap bluetooth sunrpc ipv6 dm_multipath uinput pcspkr serio_raw bnx2 qla2xxx scsi_transport_fc scsi_tgt ipmi_si ipmi_msghandler ata_generic pata_acpi hpwdt pata_amd shpchp cciss [last unloaded: freq_table]
Jun  8 22:49:13 shifter kernel: Pid: 594, comm: pdflush Not tainted 2.6.30-rc8+aneesh.64-bit.patch #8 ProLiant DL585 G5   
Jun  8 22:49:13 shifter kernel: RIP: 0010:[<ffffffffa01be684>]  [<ffffffffa01be684>] ext4_mb_normalize_request+0x29a/0x313 [ext4]
Jun  8 22:49:13 shifter kernel: RSP: 0018:ffff88087c0ff7c0  EFLAGS: 00010246
Jun  8 22:49:13 shifter kernel: RAX: 0000000000002000 RBX: 0000000000000000 RCX: 0000000000002000
Jun  8 22:49:13 shifter kernel: RDX: 0000000000002000 RSI: 0000000000002000 RDI: 0000000000100000
Jun  8 22:49:13 shifter kernel: RBP: ffff88087c0ff800 R08: 0000000000000010 R09: 0000000000002000
Jun  8 22:49:13 shifter kernel: R10: 0000000000002000 R11: ffff88105c1087b0 R12: 0000000000002000
Jun  8 22:49:13 shifter kernel: R13: 0000000000002000 R14: ffff88039e0cf000 R15: 0000000000002000
Jun  8 22:49:13 shifter kernel: FS:  00007f5922f9b6f0(0000) GS:ffffc20000054000(0000) knlGS:0000000000000000
Jun  8 22:49:13 shifter kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Jun  8 22:49:13 shifter kernel: CR2: 000000352fc33150 CR3: 00000008282a4000 CR4: 00000000000006e0
Jun  8 22:49:13 shifter kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jun  8 22:49:13 shifter kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jun  8 22:49:13 shifter kernel: Process pdflush (pid: 594, threadinfo ffff88087c0fe000, task ffff88087c100000)
Jun  8 22:49:13 shifter kernel: Stack:
Jun  8 22:49:13 shifter kernel: ffff88087c0ff800 ffff88087c0ff940 ffff88105c108a48 ffff88039e0cf000
Jun  8 22:49:13 shifter kernel: ffff88087c0ff940 0000000000000000 ffff88105c1087b0 ffff88105c1087b0
Jun  8 22:49:13 shifter kernel: ffff88087c0ff8a0 ffffffffa01c15c0 0000006000000008 ffff88105c108700
Jun  8 22:49:13 shifter kernel: Call Trace:
Jun  8 22:49:13 shifter kernel: [<ffffffffa01c15c0>] ext4_mb_new_blocks+0x1f8/0x4b0 [ext4]
Jun  8 22:49:13 shifter kernel: [<ffffffffa01b6d3d>] ? kzalloc+0xf/0x11 [ext4]
Jun  8 22:49:13 shifter kernel: [<ffffffffa01ba19f>] ext4_ext_get_blocks+0xc86/0xe93 [ext4]
Jun  8 22:49:13 shifter kernel: [<ffffffff81055b73>] ? up_read+0x9/0xb
Jun  8 22:49:13 shifter kernel: [<ffffffff8116852c>] ? generic_make_request+0x2b6/0x307
Jun  8 22:49:13 shifter kernel: [<ffffffffa01a8a4c>] ext4_get_blocks_wrap+0x109/0x253 [ext4]
Jun  8 22:49:13 shifter kernel: [<ffffffff8117b79e>] ? radix_tree_gang_lookup_tag_slot+0x85/0xaa
Jun  8 22:49:13 shifter kernel: [<ffffffffa01a8f08>] mpage_da_map_blocks+0xb0/0x5c2 [ext4]
Jun  8 22:49:13 shifter kernel: [<ffffffff8109cbbd>] ? __pagevec_release+0x21/0x2d
Jun  8 22:49:13 shifter kernel: [<ffffffff8109ac16>] ? write_cache_pages+0x311/0x39f
Jun  8 22:49:13 shifter kernel: [<ffffffffa01a99f1>] ? __mpage_da_writepage+0x0/0x135 [ext4]
Jun  8 22:49:13 shifter kernel: [<ffffffffa01a9750>] ext4_da_writepages+0x336/0x52c [ext4]
Jun  8 22:49:13 shifter kernel: [<ffffffff8109acf1>] do_writepages+0x28/0x38
Jun  8 22:49:13 shifter kernel: [<ffffffff810e001f>] __writeback_single_inode+0x194/0x325
Jun  8 22:49:13 shifter kernel: [<ffffffff810e058e>] generic_sync_sb_inodes+0x245/0x375
Jun  8 22:49:13 shifter kernel: [<ffffffff810e08a5>] writeback_inodes+0x9d/0xf0
Jun  8 22:49:13 shifter kernel: [<ffffffff8109b343>] background_writeout+0x92/0xcb
Jun  8 22:49:13 shifter kernel: [<ffffffff8109bb66>] pdflush+0x174/0x255
Jun  8 22:49:13 shifter kernel: [<ffffffff8109b2b1>] ? background_writeout+0x0/0xcb
Jun  8 22:49:13 shifter kernel: [<ffffffff8109b9f2>] ? pdflush+0x0/0x255
Jun  8 22:49:13 shifter kernel: [<ffffffff81052698>] kthread+0x56/0x83
Jun  8 22:49:13 shifter kernel: [<ffffffff8100cbea>] child_rip+0xa/0x20
Jun  8 22:49:13 shifter kernel: [<ffffffff8100c5e9>] ? restore_args+0x0/0x30
Jun  8 22:49:13 shifter kernel: [<ffffffff81052642>] ? kthread+0x0/0x83
Jun  8 22:49:13 shifter kernel: [<ffffffff8100cbe0>] ? child_rip+0x0/0x20
Jun  8 22:49:13 shifter kernel: Code: e1 41 8b 56 10 89 d0 49 39 c4 7f 09 41 39 d5 76 04 0f 0b eb fe 48 85 db 74 11 49 8b 7e 08 48 8b 87 a8 02 00 00 48 3b 58 10 76 04 <0f> 0b eb fe 48 8b 55 c8 45 89 6e 20 41 89 5e 2c 48 8b 72 30 48 
Jun  8 22:49:13 shifter kernel: RIP  [<ffffffffa01be684>] ext4_mb_normalize_request+0x29a/0x313 [ext4]
Jun  8 22:49:13 shifter kernel: RSP <ffff88087c0ff7c0>
Jun  8 22:49:13 shifter kernel: ---[ end trace a55a13c6b40b2ef7 ]---
Jun  8 22:49:26 shifter kernel: ------------[ cut here ]------------
Jun  8 22:49:26 shifter kernel: kernel BUG at fs/ext4/mballoc.c:3245!
Jun  8 22:49:26 shifter kernel: invalid opcode: 0000 [#2] SMP 
Jun  8 22:49:26 shifter kernel: last sysfs file: /sys/devices/system/cpu/cpu15/cache/index2/shared_cpu_map
Jun  8 22:49:26 shifter kernel: CPU 6 
Jun  8 22:49:26 shifter kernel: Modules linked in: ext4 jbd2 crc16 bridge stp bnep sco l2cap bluetooth sunrpc ipv6 dm_multipath uinput pcspkr serio_raw bnx2 qla2xxx scsi_transport_fc scsi_tgt ipmi_si ipmi_msghandler ata_generic pata_acpi hpwdt pata_amd shpchp cciss [last unloaded: freq_table]
Jun  8 22:49:26 shifter kernel: Pid: 4063, comm: liverfs Tainted: G      D    2.6.30-rc8+aneesh.64-bit.patch #8 ProLiant DL585 G5   
Jun  8 22:49:26 shifter kernel: RIP: 0010:[<ffffffffa01be684>]  [<ffffffffa01be684>] ext4_mb_normalize_request+0x29a/0x313 [ext4]
Jun  8 22:49:26 shifter kernel: RSP: 0018:ffff880820553488  EFLAGS: 00010246
Jun  8 22:49:26 shifter kernel: RAX: 0000000000002000 RBX: 0000000000000000 RCX: 0000000000002000
Jun  8 22:49:26 shifter kernel: RDX: 0000000000002000 RSI: 0000000000002000 RDI: 0000000000100000
Jun  8 22:49:26 shifter kernel: RBP: ffff8808205534c8 R08: 0000000000000010 R09: 0000000000002000
Jun  8 22:49:26 shifter kernel: R10: 0000000000002000 R11: ffff88105c108b30 R12: 0000000000002000
Jun  8 22:49:26 shifter kernel: R13: 0000000000002000 R14: ffff8816a4d1d000 R15: 0000000000002000
Jun  8 22:49:26 shifter kernel: FS:  00007fe0f59076f0(0000) GS:ffffc2000007e000(0000) knlGS:0000000000000000
Jun  8 22:49:26 shifter kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jun  8 22:49:26 shifter kernel: CR2: 00000000022d3060 CR3: 0000001d60b23000 CR4: 00000000000006e0
Jun  8 22:49:26 shifter kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jun  8 22:49:26 shifter kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jun  8 22:49:26 shifter kernel: Process liverfs (pid: 4063, threadinfo ffff880820552000, task ffff880874d5e3c0)
Jun  8 22:49:26 shifter kernel: Stack:
Jun  8 22:49:26 shifter kernel: ffff8808205534c8 ffff880820553608 ffff88105c108dc8 ffff8816a4d1d000
Jun  8 22:49:26 shifter kernel: ffff880820553608 0000000000000000 ffff88105c108b30 ffff88105c108b30
Jun  8 22:49:26 shifter kernel: ffff880820553568 ffffffffa01c15c0 0000006000010000 ffff88105c108a80
Jun  8 22:49:26 shifter kernel: Call Trace:
Jun  8 22:49:26 shifter kernel: [<ffffffffa01c15c0>] ext4_mb_new_blocks+0x1f8/0x4b0 [ext4]
Jun  8 22:49:26 shifter kernel: [<ffffffffa01b6d3d>] ? kzalloc+0xf/0x11 [ext4]
Jun  8 22:49:26 shifter kernel: [<ffffffffa01ba19f>] ext4_ext_get_blocks+0xc86/0xe93 [ext4]
Jun  8 22:49:26 shifter kernel: [<ffffffff81097bb5>] ? __rmqueue_smallest+0xff/0x142
Jun  8 22:49:26 shifter kernel: [<ffffffffa01a8a4c>] ext4_get_blocks_wrap+0x109/0x253 [ext4]
Jun  8 22:49:26 shifter kernel: [<ffffffff8117b79e>] ? radix_tree_gang_lookup_tag_slot+0x85/0xaa
Jun  8 22:49:26 shifter kernel: [<ffffffffa01a8f08>] mpage_da_map_blocks+0xb0/0x5c2 [ext4]
Jun  8 22:49:26 shifter kernel: [<ffffffff8109cbbd>] ? __pagevec_release+0x21/0x2d
Jun  8 22:49:26 shifter kernel: [<ffffffff8109ac16>] ? write_cache_pages+0x311/0x39f
Jun  8 22:49:26 shifter kernel: [<ffffffffa01a99f1>] ? __mpage_da_writepage+0x0/0x135 [ext4]
Jun  8 22:49:26 shifter kernel: [<ffffffffa01a9750>] ext4_da_writepages+0x336/0x52c [ext4]
Jun  8 22:49:26 shifter kernel: [<ffffffffa018d609>] ? do_get_write_access+0x43b/0x482 [jbd2]
Jun  8 22:49:26 shifter kernel: [<ffffffff8109acf1>] do_writepages+0x28/0x38
Jun  8 22:49:26 shifter kernel: [<ffffffff810e001f>] __writeback_single_inode+0x194/0x325
Jun  8 22:49:26 shifter kernel: [<ffffffff8117adbc>] ? prop_fraction_single+0x3c/0x5e
Jun  8 22:49:26 shifter kernel: [<ffffffff810e058e>] generic_sync_sb_inodes+0x245/0x375
Jun  8 22:49:26 shifter kernel: [<ffffffff810e08a5>] writeback_inodes+0x9d/0xf0
Jun  8 22:49:26 shifter kernel: [<ffffffff8109b562>] balance_dirty_pages_ratelimited_nr+0x152/0x27d
Jun  8 22:49:26 shifter kernel: [<ffffffffa01b4335>] ? __ext4_journal_stop+0x64/0x6a [ext4]
Jun  8 22:49:26 shifter kernel: [<ffffffff81094e36>] generic_file_buffered_write+0x1f4/0x2df
Jun  8 22:49:26 shifter kernel: [<ffffffff81095316>] __generic_file_aio_write_nolock+0x25e/0x292
Jun  8 22:49:26 shifter kernel: [<ffffffff81095340>] ? __generic_file_aio_write_nolock+0x288/0x292
Jun  8 22:49:26 shifter kernel: [<ffffffff81095b69>] generic_file_aio_write+0x67/0xc3
Jun  8 22:49:26 shifter kernel: [<ffffffffa01a29af>] ext4_file_write+0x9a/0x123 [ext4]
Jun  8 22:49:26 shifter kernel: [<ffffffff810c67de>] do_sync_write+0xe7/0x12d
Jun  8 22:49:26 shifter kernel: [<ffffffff81052d27>] ? remove_wait_queue+0x2f/0x38
Jun  8 22:49:26 shifter kernel: [<ffffffff81052a5c>] ? autoremove_wake_function+0x0/0x38
Jun  8 22:49:26 shifter kernel: [<ffffffff81146518>] ? security_file_permission+0x11/0x13
Jun  8 22:49:26 shifter kernel: [<ffffffff810c7204>] vfs_write+0xab/0x105
Jun  8 22:49:26 shifter kernel: [<ffffffff810c7322>] sys_write+0x47/0x6f
Jun  8 22:49:26 shifter kernel: [<ffffffff8100bbab>] system_call_fastpath+0x16/0x1b
Jun  8 22:49:26 shifter kernel: Code: e1 41 8b 56 10 89 d0 49 39 c4 7f 09 41 39 d5 76 04 0f 0b eb fe 48 85 db 74 11 49 8b 7e 08 48 8b 87 a8 02 00 00 48 3b 58 10 76 04 <0f> 0b eb fe 48 8b 55 c8 45 89 6e 20 41 89 5e 2c 48 8b 72 30 48 
Jun  8 22:49:26 shifter kernel: RIP  [<ffffffffa01be684>] ext4_mb_normalize_request+0x29a/0x313 [ext4]
Jun  8 22:49:26 shifter kernel: RSP <ffff880820553488>
Jun  8 22:49:26 shifter kernel: ---[ end trace a55a13c6b40b2ef8 ]---

Thanks,
Nick
