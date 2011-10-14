From: Justin Gottula <justin@jgottula.com>
Subject: Re: 3.1-rc8 OOPS in jbd2_journal_file_inode (fs/jbd2/transaction.c
 line 2142)
Date: Thu, 13 Oct 2011 22:02:05 -0700
Message-ID: <CAKuMfTVDxo7kiKepYewfNAuHHE7y5KPqxpMYHBqdjxjcLctWcA@mail.gmail.com>
References: <loom.20111003T032009-943@post.gmane.org> <20111013190914.GD6018@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53075 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab1JNFCq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Oct 2011 01:02:46 -0400
Received: by wwf22 with SMTP id 22so2862370wwf.1
        for <linux-ext4@vger.kernel.org>; Thu, 13 Oct 2011 22:02:45 -0700 (PDT)
In-Reply-To: <20111013190914.GD6018@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On Thu, Oct 13, 2011 at 12:09 PM, Jan Kara <jack@suse.cz> wrote:
> =A0Hello,
>
> On Mon 03-10-11 01:44:11, Justin Gottula wrote:
>> Please tell me if this is the right place to report this; it appears=
 to
>> be an ext4-specific issue.
> =A0Yes, it is the right place. Thanks for your report.
>
>> I had a kernel panic occur today during some particularly heavy hard
>> drive activity on an ext4 filesystem, running a bleeding edge kernel
>> (3.1-rc8). =A0Unfortunately it's not an easily reproducible bug, it =
was
>> pretty much a random occurrence.
> =A0Have you seen the bug since the report?

Perhaps fortunately, the bug hasn't cropped up since I first reported i=
t.

>
>> Here's the excerpt from dmesg (these were the only pertinent lines):
>>
>> [ 5922.546229] BUG: unable to handle kernel NULL pointer dereference=
 at
>> =A0 (null)
>> [ 5922.546272] IP: [<ffffffffa00ccac8>] jbd2_journal_file_inode+0x38=
/0xf0 [jbd2]
>> [ 5922.546308] PGD 195b3f067 PUD 1c1a70067 PMD 0
>> [ 5922.546339] Oops: 0000 [#1] PREEMPT SMP
>> [ 5922.546361] CPU 1
>> [ 5922.546370] Modules linked in: it87 hwmon_vid coretemp ipv6 vboxn=
etflt
>> vboxnetadp vboxdrv fuse loop uvcvideo joydev videodev snd_usb_audio =
usbhid
>> usb_storage media hid xpad v4l2_compat_ioctl32 ff_memless snd_usbmid=
i_lib uas
>> evdev ppdev radeon sg snd_hda_codec_hdmi parport_pc snd_hda_codec_re=
altek
>> i2c_i801 psmouse parport serio_raw iTCO_wdt ttm floppy iTCO_vendor_s=
upport
>> drm_kms_helper drm snd_oxygen snd_hda_intel snd_oxygen_lib i2c_algo_=
bit
>> processor intel_agp snd_hda_codec intel_gtt i2c_core snd_hwdep butto=
n
>> snd_mpu401_uart snd_rawmidi snd_seq_dummy snd_seq_oss snd_seq_midi_e=
vent snd_seq
>> snd_seq_device snd_pcm_oss snd_pcm snd_timer snd_page_alloc snd_mixe=
r_oss snd
>> soundcore pcspkr r8169 mii xhci_hcd btrfs lzo zlib_deflate libcrc32c=
 crc32c ext4
>> mbcache jbd2 crc16 uhci_hcd ehci_hcd usbcore sr_mod cdrom ahci libah=
ci sd_mod
>> pata_jmicron libata scsi_mod
>> [ 5922.546911]
>> [ 5922.546919] Pid: 951, comm: flush-8:16 Not tainted 3.1.0-rc8-main=
line #1
>> Gigabyte Technology Co., Ltd. EP35-DS3R/EP35-DS3R
>> [ 5922.546963] RIP: 0010:[<ffffffffa00ccac8>] =A0[<ffffffffa00ccac8>=
]
>> jbd2_journal_file_inode+0x38/0xf0 [jbd2]
>> [ 5922.546999] RSP: 0000:ffff88020fda5960 =A0EFLAGS: 00010246
>> [ 5922.547019] RAX: 00000000fffffffb RBX: ffff8801293f5500 RCX: 0000=
000000000001
>> [ 5922.547043] RDX: ffff88020e5c7c00 RSI: 0000000000000000 RDI: ffff=
880202ada750
>> [ 5922.547067] RBP: ffff88020fda5980 R08: 00000000182c0e00 R09: 0000=
000000000001
>> [ 5922.547091] R10: 0000000000000000 R11: 0000000000000000 R12: 0000=
000000000000
>> [ 5922.547115] R13: ffff88020fdb0800 R14: ffff880202ada750 R15: ffff=
88004f00e890
>> [ 5922.547139] FS: =A00000000000000000(0000) GS:ffff88021fc80000(000=
0)
>> knlGS:0000000000000000
>> [ 5922.547166] CS: =A00010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> [ 5922.547185] CR2: 0000000000000000 CR3: 000000014411a000 CR4: 0000=
0000000406e0
>> [ 5922.547209] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000=
000000000000
>> [ 5922.547233] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000=
000000000400
>> [ 5922.547256] Process flush-8:16 (pid: 951, threadinfo ffff88020fda=
4000, task
>> ffff88021012b250)
>> [ 5922.547284] Stack:
>> [ 5922.547296] =A0ffff88020fda5a80 000000000000bada 0000000000000001
>> ffff880202ada750
>> [ 5922.547334] =A0ffff88020fda5a00 ffffffffa00ef35c ffffea00046022c0
>> ffffffffa00efd3b
>> [ 5922.547369] =A0ffffea00081e0840 0000000000000000 ffffffffa0125630
>> 00000000072e62da
>> [ 5922.547403] Call Trace:
>> [ 5922.547419] =A0[<ffffffffa00ef35c>] mpage_da_map_and_submit+0x2bc=
/0x400 [ext4]
>> [ 5922.547449] =A0[<ffffffffa00efd3b>] ? ext4_da_writepages+0x35b/0x=
6b0 [ext4]
>> [ 5922.547476] =A0[<ffffffffa00efd86>] ext4_da_writepages+0x3a6/0x6b=
0 [ext4]
>> [ 5922.547503] =A0[<ffffffff81108534>] do_writepages+0x24/0x40
>> [ 5922.547523] =A0[<ffffffff811848a3>] writeback_single_inode+0x183/=
0x490
>> [ 5922.547546] =A0[<ffffffff81184faa>] writeback_sb_inodes+0x1aa/0x2=
70
>> [ 5922.547567] =A0[<ffffffff8118510e>] __writeback_inodes_wb+0x9e/0x=
d0
>> [ 5922.547589] =A0[<ffffffff811854db>] wb_writeback+0x39b/0x3d0
>> [ 5922.547610] =A0[<ffffffff811855a8>] wb_check_old_data_flush+0x98/=
0xa0
>> [ 5922.547632] =A0[<ffffffff811865fc>] wb_do_writeback+0x1ac/0x250
>> [ 5922.547653] =A0[<ffffffff81071770>] ? init_timer_deferrable_key+0=
x30/0x30
>> [ 5922.547676] =A0[<ffffffff8118672c>] bdi_writeback_thread+0x8c/0x3=
40
>> [ 5922.547698] =A0[<ffffffff811866a0>] ? wb_do_writeback+0x250/0x250
>> [ 5922.547720] =A0[<ffffffff810846fc>] kthread+0x8c/0xa0
>> [ 5922.547738] =A0[<ffffffff81408734>] kernel_thread_helper+0x4/0x10
>> [ 5922.547759] =A0[<ffffffff81084670>] ? kthread_worker_fn+0x190/0x1=
90
>> [ 5922.547780] =A0[<ffffffff81408730>] ? gs_change+0x13/0x13
>> [ 5922.547797] Code: 89 65 e8 4c 89 6d f0 4c 89 75 f8 66 66 66 66 90=
 b8 fb ff ff
>> =A0ff 48 8b 1f 49 89 f4 f6 47 14 04 4c 8b 2b 75 72 41 f6 45 00 02 75=
 6b
>> [ 5922.548006] RIP =A0[<ffffffffa00ccac8>] jbd2_journal_file_inode+0=
x38/0xf0
>> [jbd2]
>> [ 5922.548036] =A0RSP <ffff88020fda5960>
>> [ 5922.548048] CR2: 0000000000000000
>> [ 5922.607946] ---[ end trace 6f21f07839837a01 ]---
>>
>> I learned how to make gdb give me the offending lines from the call =
stack. Let
>> me know if this is sufficient information or if there's a better way=
 to do this:
>>
>> [<ffffffffa00ccac8>] jbd2_journal_file_inode+0x38/0xf0 [jbd2]
>> Line 2142 of "fs/jbd2/transaction.c"
>> [<ffffffffa00ef35c>] mpage_da_map_and_submit+0x2bc/0x400 [ext4]
>> Line 1478 of "fs/ext4/inode.c"
>> [<ffffffffa00efd3b>] ? ext4_da_writepages+0x35b/0x6b0 [ext4]
>> Line 2140 of "fs/ext4/inode.c"
>> [<ffffffffa00efd86>] ext4_da_writepages+0x3a6/0x6b0 [ext4]
>> Line 2160 of "fs/ext4/inode.c"
>> [<ffffffff81108534>] do_writepages+0x24/0x40
>> Line 1264 of "mm/page-writeback.c"
>> [ 5922.547523] =A0[<ffffffff811848a3>] writeback_single_inode+0x183/=
0x490
>> Line 405 of "fs/fs-writeback.c"
>>
>> If you need my kernel config or other relevant details, I can provid=
e them. I
>> still have the source tree, config, and other bits and pieces that I=
 used to
>> build the kernel so I'm in a good position to help diagnose the prob=
lem.
> =A0Thanks for those details. So the problem was that jinode was NULL =
(i.e.
> inode written back by ext4_da_writepages() didn't have
> EXT4(inode)->i_jinode allocated). Allocation of jinode happens when a=
 file is
> opened for writing. So the question is, how an inode could get dirty =
data
> without being opened for writing. Did you do something unusual when t=
he bug
> triggered? Something like defragmentation, inode migration, or other
> things?

I wasn't doing anything out of the ordinary, including defragging or
any other sort of FS maintenance. I had, however, started an rsync
operation which wrote to the ext4 filesystem in question just before
the kernel seized up. I do keep a VirtualBox instance running in the
background a majority of the time, and its hard drive file is on the
same filesystem, so it might possibly have had something to do with
it; however, based on the timing of the panic I would wager it had
more to do with rsync.

>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>


Justin
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
