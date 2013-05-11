From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: EXT4 regression caused 4eec7
Date: Sat, 11 May 2013 15:00:53 +0400
Message-ID: <87mws1eq6y.fsf@openvz.org>
References: <6719519.5821368147110937.JavaMail.weblogic@epml17> <20130510192747.GA11707@thunk.org> <87y5bm53z3.fsf@openvz.org> <87txm96fkd.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4\@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
To: Theodore Ts'o <tytso@mit.edu>,
	EUNBONG SONG <eunb.song@samsung.com>, Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:43080 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab3EKLA7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 11 May 2013 07:00:59 -0400
In-Reply-To: <87txm96fkd.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 11 May 2013 13:17:38 +0400, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
Non-text part: multipart/mixed
> On Sat, 11 May 2013 12:13:20 +0400, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> > On Fri, 10 May 2013 15:27:47 -0400, Theodore Ts'o <tytso@mit.edu> wrote:
> > > Hmm, since you seem to be able to reproduce the problem reliably, any
> > > chance you can try bisecting the problem?  I've looked at the commits
> > > that touch fs/jbd2 and nothing is jumping out at me.
> > > 
> > > Also, how many CPU's do you have your system, and what kind of storage
> > > device were you using when you were running iozone (5400rpm HDD,
> > > 7200RPM HDD, RAID array, SSD, etc.)?
> Ok, I've able to reproduce corruption on ext4
> So at this moment we have:
> Slub corruption on XFS testcase: xfstests/generic/013
> Slub corruption on EXT4 testcase: xfstests/generic/299
I've bisected ext4 related issue. It is appeared that it is pure ext4
specific. Regression caused by  following commit
commit 4eec708d263f0ee10861d69251708a225b64cac7
Author: Jan Kara <jack@suse.cz>
Date:   Thu Apr 11 23:56:53 2013 -0400
    ext4: use io_end for multiple bios

TESTCASE: xfstests  generic/299
> 
> In fact both test cases (069'th and 299'th) are just stress tests.
> So this is likely a regression in mm layer. I try to bisect it now.
> 
> 
> #Testcase: xfstests  generic/299
> #DMESG
> ------------[ cut here ]------------
> WARNING: at fs/ext4/inode.c:3223 ext4_ext_direct_IO+0x2cb/0x3c0()
> Modules linked in: cpufreq_ondemand usb_storage acpi_cpufreq freq_table mperf coretemp kvm_intel kvm crc32c_intel ghash_clmulni_intel microcode sg xhci_hcd button sd_mod crc_t10dif aesni_intel ablk_helper cryptd lrw gf128mul glue_helper aes_x86_64 ahci libahci pata_acpi ata_generic dm_mirror dm_region_hash dm_log dm_mod
> CPU: 3 PID: 30537 Comm: fio Not tainted 3.9.0+ #14
> Hardware name:                  /DQ67SW, BIOS SWQ6710H.86A.0052.2011.0520.1802 05/20/2011
>  ffffffff81e44ed6 ffff8801259ffa28 ffffffff818b20ff ffff8801259ffa68
>  ffffffff81060a87 ffff8801259ffa58 ffff880205a921d0 ffff880233192740
>  ffff880176496400 0000000000000000 ffffffffffffffe4 ffff8801259ffa78
> Call Trace:
>  [<ffffffff818b20ff>] dump_stack+0x19/0x22
>  [<ffffffff81060a87>] warn_slowpath_common+0x87/0xb0
>  [<ffffffff81060aca>] warn_slowpath_null+0x1a/0x20
>  [<ffffffff813131eb>] ext4_ext_direct_IO+0x2cb/0x3c0
>  [<ffffffff813161c0>] ? ext4_get_block_write_nolock+0x20/0x20
>  [<ffffffff813132e0>] ? ext4_ext_direct_IO+0x3c0/0x3c0
>  [<ffffffff8131ac9f>] ext4_direct_IO+0x22f/0x3c0
>  [<ffffffff8118db75>] generic_file_direct_write+0x175/0x240
>  [<ffffffff81191bc6>] __generic_file_aio_write+0x556/0x770
>  [<ffffffff8130d2de>] ext4_file_dio_write+0x35e/0x4f0
>  [<ffffffff812929b3>] ? aio_rw_vect_retry+0xc3/0x250
>  [<ffffffff8130d5ae>] ext4_file_write+0x13e/0x190
>  [<ffffffff8130d470>] ? ext4_file_dio_write+0x4f0/0x4f0
>  [<ffffffff812929e3>] aio_rw_vect_retry+0xf3/0x250
>  [<ffffffff811c7f53>] ? might_fault+0x73/0xe0
>  [<ffffffff8130d470>] ? ext4_file_dio_write+0x4f0/0x4f0
>  [<ffffffff812949da>] aio_run_iocb+0x25a/0x3b0
>  [<ffffffff81294e26>] io_submit_one+0x2f6/0x3a0
>  [<ffffffff8129512e>] do_io_submit+0x25e/0x2f0
>  [<ffffffff812926b2>] ? lookup_ioctx+0xc2/0x100
>  [<ffffffff812951d0>] SyS_io_submit+0x10/0x20
>  [<ffffffff818c4ac2>] system_call_fastpath+0x16/0x1b
> ---[ end trace c96126e84d56efc2 ]---
> ------------[ cut here ]------------
> WARNING: at fs/ext4/inode.c:3223 ext4_ext_direct_IO+0x2cb/0x3c0()
> Modules linked in: cpufreq_ondemand usb_storage acpi_cpufreq freq_table mperf coretemp kvm_intel kvm crc32c_intel ghash_clmulni_intel microcode sg xhci_hcd button sd_mod crc_t10dif aesni_intel ablk_helper cryptd lrw gf128mul glue_helper aes_x86_64 ahci libahci pata_acpi ata_generic dm_mirror dm_region_hash dm_log dm_mod
> CPU: 1 PID: 30539 Comm: fio Tainted: G        W    3.9.0+ #14
> Hardware name:                  /DQ67SW, BIOS SWQ6710H.86A.0052.2011.0520.1802 05/20/2011
>  ffffffff81e44ed6 ffff880131209a28 ffffffff818b20ff ffff880131209a68
>  ffffffff81060a87 ffff880131209a58 ffff8801f5347990 ffff88022b9b7e00
>  ffff88023342c508 0000000000000000 ffffffffffffffe4 ffff880131209a78
> Call Trace:
>  [<ffffffff818b20ff>] dump_stack+0x19/0x22
>  [<ffffffff81060a87>] warn_slowpath_common+0x87/0xb0
>  [<ffffffff81060aca>] warn_slowpath_null+0x1a/0x20
>  [<ffffffff813131eb>] ext4_ext_direct_IO+0x2cb/0x3c0
>  [<ffffffff813161c0>] ? ext4_get_block_write_nolock+0x20/0x20
>  [<ffffffff813132e0>] ? ext4_ext_direct_IO+0x3c0/0x3c0
>  [<ffffffff8131ac9f>] ext4_direct_IO+0x22f/0x3c0
>  [<ffffffff8118db75>] generic_file_direct_write+0x175/0x240
>  [<ffffffff81191bc6>] __generic_file_aio_write+0x556/0x770
>  [<ffffffff8130d2de>] ext4_file_dio_write+0x35e/0x4f0
>  [<ffffffff812929b3>] ? aio_rw_vect_retry+0xc3/0x250
>  [<ffffffff8130d5ae>] ext4_file_write+0x13e/0x190
>  [<ffffffff8130d470>] ? ext4_file_dio_write+0x4f0/0x4f0
>  [<ffffffff812929e3>] aio_rw_vect_retry+0xf3/0x250
>  [<ffffffff811c7f53>] ? might_fault+0x73/0xe0
>  [<ffffffff8130d470>] ? ext4_file_dio_write+0x4f0/0x4f0
>  [<ffffffff812949da>] aio_run_iocb+0x25a/0x3b0
>  [<ffffffff81294e26>] io_submit_one+0x2f6/0x3a0
>  [<ffffffff8129512e>] do_io_submit+0x25e/0x2f0
>  [<ffffffff812926b2>] ? lookup_ioctx+0xc2/0x100
>  [<ffffffff812951d0>] SyS_io_submit+0x10/0x20
>  [<ffffffff818c4ac2>] system_call_fastpath+0x16/0x1b
> ---[ end trace c96126e84d56efc3 ]---
> Slab corruption (Tainted: G        W   ): ext4_io_end start=ffff88023342c508, len=64
> Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
> Last user: [<ffffffff8131fe9b>](ext4_release_io_end+0x12b/0x130)
> 030: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6a 6b 6b a5  kkkkkkkkkkkkjkk.
> Prev obj: start=ffff88023342c4b0, len=64
> Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
> Last user: [<ffffffff813200d3>](ext4_init_io_end+0x23/0x60)
> 000: 58 cf 42 33 02 88 ff ff c8 27 33 62 01 88 ff ff  X.B3.....'3b....
> 010: d0 51 a4 30 02 88 ff ff 05 00 00 00 00 00 00 00  .Q.0............
> Next obj: start=ffff88023342c560, len=64
> Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
> Last user: [<ffffffff813200d3>](ext4_init_io_end+0x23/0x60)
> 000: a8 d3 1e 27 02 88 ff ff a0 8d 47 2b 02 88 ff ff  ...'......G+....
> 010: d0 51 a4 30 02 88 ff ff 05 00 00 00 00 00 00 00  .Q.0............
> Slab corruption (Tainted: G        W   ): ext4_io_end start=ffff880176496400, len=64
> Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
> Last user: [<ffffffff8131fe9b>](ext4_release_io_end+0x12b/0x130)
> 030: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6a 6b 6b a5  kkkkkkkkkkkkjkk.
> Prev obj: start=ffff8801764963a8, len=64
> Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
> Last user: [<ffffffff813200d3>](ext4_init_io_end+0x23/0x60)
> 000: a8 63 49 76 01 88 ff ff a8 63 49 76 01 88 ff ff  .cIv.....cIv....
> 010: 90 b9 79 2b 02 88 ff ff 00 00 00 00 00 00 00 00  ..y+............
> Next obj: start=ffff880176496458, len=64
> Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
> Last user: [<ffffffff8131fe9b------------[ cut here ]------------
> 
> 
> > XFS TOO....
> > It it definitely just an ext3/4 related issue.
> > I've run xfstests on xfs and almost immediately have got slub corruption
> > I use following HEAD: 2dbd3cac87250a0d44e07acc86c4224a08522709
> > 
> > 2013-05-11 11:59:30 Slab corruption (Not tainted): xfs_efi_item
> > start=ffff8802335063f0, len=400^M
> > 2013-05-11 11:59:30 Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.^M
> > 2013-05-11 11:59:30 Last user:
> > [<ffffffffa03ba36f>](xfs_efi_item_free+0x3f/0x50 [xfs])^M
> > 2013-05-11 11:59:30 070: 6a 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> > jkkkkkkkkkkkkkkk^M
> > 2013-05-11 11:59:30 Single bit error detected. Probably bad RAM.^M
> > 2013-05-11 11:59:30 Run memtest86+ or a similar memory test tool.^M
> > 2013-05-11 11:59:30 Prev obj: start=ffff880233506248, len=400^M
> > 2013-05-11 11:59:30 Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.^M
> > 2013-05-11 11:59:30 Last user:
> > [<ffffffffa034d7bb>](kmem_zone_alloc+0xbb/0x190 [xfs])^M
> > 2013-05-11 11:59:30 000: 48 62 50 33 02 88 ff ff 48 62 50 33 02 88 ff ff
> > HbP3....HbP3....^M
> > 2013-05-11 11:59:30 010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > ................^M
> > 2013-05-11 11:59:30 Next obj: start=ffff880233506598, len=400^M
> > 2013-05-11 11:59:30 Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.^M
> > > 
> > > Thanks,
> > > 
> > > 						- Ted
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
