From: Nick Bowler <nbowler@elliptictech.com>
Subject: Re: [PATCH -BUGFIX] Re: BUG in ext4 with 2.6.37-rc1
Date: Wed, 3 Nov 2010 16:53:06 -0400
Message-ID: <20101103205306.GA3627@elliptictech.com>
References: <20101102202013.GA3861@elliptictech.com>
 <20101103181412.GH25614@thunk.org>
 <20101103182229.GA8766@elliptictech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ted Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:38204 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754088Ab0KCUxO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Nov 2010 16:53:14 -0400
Content-Disposition: inline
In-Reply-To: <20101103182229.GA8766@elliptictech.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-11-03 14:22 -0400, Nick Bowler wrote:
> On 2010-11-03 14:14 -0400, Ted Ts'o wrote:
> > How easily can you reproduce this bug?  I'm pretty sure I know what
> > caused it, but it's always good to get confirmation that a patch
> > addresses the reported bug.  If it happens to you fairly often, can
> > you try out this patch and let me know whether it fixes the bug for
> > you?
> 
> I only encountered it the one time, but I haven't tried compiling gcc
> since it blew up the first time (there seems to be no problem compiling
> linux, for instance).  I will try it again now with and without the
> patch.

OK, it's 100% reproducible: the kernel BUGs, without fail, every time I
do 'make install' in the gcc build tree.  After applying the patch, it
seems that the original BUG is gone, but now there's a new one:

  ------------[ cut here ]------------
  kernel BUG at /scratch_space/linux-2.6/fs/inode.c:1405!
  invalid opcode: 0000 [#1] PREEMPT SMP 
  last sysfs file: /sys/devices/virtual/vtconsole/vtcon1/uevent
  CPU 1 
  Modules linked in: netconsole nfs nfs_acl bridge stp llc autofs4 nfsd lockd sunrpc exportfs ipv6 iptable_filter iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer snd soundcore snd_page_alloc sg evdev usb_storage ext2 ehci_hcd sr_mod cdrom loop tun acpi_cpufreq mperf arc4 ecb crypto_blkcipher cryptomgr aead crypto_algapi rt2800pci rt2800lib crc_ccitt rt2x00pci rt2x00lib mac80211 cfg80211 eeprom_93cx6 e1000e
  
  Pid: 273, comm: kworker/1:1 Not tainted 2.6.37-rc1-00005-gdd0ce84 #77 WG43M/Aspire X3810
  RIP: 0010:[<ffffffff810c1847>]  [<ffffffff810c1847>] iput+0x1c/0x249
  RSP: 0018:ffff88013ff1fdc0  EFLAGS: 00010202
  RAX: 0000000000000000 RBX: ffff88012d3baf78 RCX: ffff88012d3bb220
  RDX: ffff880021f2ac10 RSI: 0000000000000296 RDI: ffff88012d3baf78
  RBP: ffff88013ff1fdd0 R08: 0000000000000000 R09: ffff88013ee95900
  R10: ffff8800b7a8de70 R11: ffff88013ff1fda0 R12: 0000000000000000
  R13: ffff88012d3bb230 R14: ffff880021f2bde8 R15: 0000000000000000
  FS:  0000000000000000(0000) GS:ffff8800b7a80000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
  CR2: 00002b121db17a20 CR3: 000000013972d000 CR4: 00000000000406e0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
  Process kworker/1:1 (pid: 273, threadinfo ffff88013ff1e000, task ffff88013feec2c0)
  Stack:
   ffff880021f2bdb0 0000000000000000 ffff88013ff1fe00 ffffffff8110783d
   ffff880021f2bdb0 ffff88012d3bb038 ffff88012d3bb230 ffff880021f2bde8
   ffff88013ff1fe30 ffffffff81107b9a ffff88013fce6700 ffff8800b7a8da80
  Call Trace:
   [<ffffffff8110783d>] ext4_free_io_end+0x84/0x9c
   [<ffffffff81107b9a>] ext4_end_io_work+0x81/0x8a
   [<ffffffff81107b19>] ? ext4_end_io_work+0x0/0x8a
   [<ffffffff8104970c>] process_one_work+0x1a8/0x286
   [<ffffffff8104b1f9>] worker_thread+0x136/0x255
   [<ffffffff8104b0c3>] ? worker_thread+0x0/0x255
   [<ffffffff8104e2be>] kthread+0x7d/0x85
   [<ffffffff81003754>] kernel_thread_helper+0x4/0x10
   [<ffffffff8104e241>] ? kthread+0x0/0x85
   [<ffffffff81003750>] ? kernel_thread_helper+0x0/0x10
  Code: 29 08 f9 ff 48 83 c4 18 5b 41 5c 41 5d c9 c3 55 48 85 ff 48 89 e5 41 54 53 48 89 fb 0f 84 31 02 00 00 f6 87 e0 01 00 00 40 74 04 <0f> 0b eb fe 48 8d 7f 58 48 c7 c6 50 22 73 81 e8 f1 46 08 00 85 
  RIP  [<ffffffff810c1847>] iput+0x1c/0x249
   RSP <ffff88013ff1fdc0>
  ---[ end trace 4ed7b09a97b06d55 ]---

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
