From: Guenter Roeck <linux@roeck-us.net>
Subject: WARNING: at fs/ext4/inode.c:230 ext4_evict_inode+0x41b/0x510
Date: Mon, 8 Jul 2013 11:38:29 -0700
Message-ID: <20130708183829.GA3205@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

seen this morning with a brand new top-of-tree kernel (as of last night) plus a
couple of patches I am working on.

Due to my changes, there is a slight chance that the problem is not due to an
upstream bug, but I think that is quite unlikely (my changes are unrelated
to file system code).

If there is anything I can help to track this down, please let me know.

Thanks,
Guenter

[13071.291013] ------------[ cut here ]------------
[13071.291021] WARNING: at fs/ext4/inode.c:230 ext4_evict_inode+0x41b/0x510()
[13071.291022] Modules linked in: ds1621 i2c_diolan_u2c(O) xt_multiport iptable_filter ip_tables x_tables snd_hda_codec_realtek spi_diolan_u2c(O) snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_page_alloc snd_seq_midi snd_seq_midi_event hid_generic snd_rawmidi diolan_u2c_core(O) snd_seq snd_seq_device parport_pc snd_timer psmouse bnep serio_raw rfcomm ppdev bluetooth snd usbhid hid lpc_ich i915 soundcore video drm_kms_helper drm mac_hid i2c_algo_bit coretemp hwmon i2c_dev lp parport e1000e ptp pps_core [last unloaded: i2c_diolan_u2c]
[13071.291051] CPU: 5 PID: 17981 Comm: git Tainted: G           O 3.10.0+ #1
[13071.291052] Hardware name:                  /DB65AL, BIOS ALB6510H.86A.0041.2011.0114.1553 01/14/2011
[13071.291053]  0000000000000009 ffff8803a992fca8 ffffffff81671d5c 0000000000000000
[13071.291055]  ffff8803a992fce0 ffffffff81043370 ffff88030e409cb0 ffff88030e409cb0
[13071.291056]  ffffffff8182b6c0 ffffffff8182b6c0 00000000ffffff9c ffff8803a992fcf0
[13071.291058] Call Trace:
[13071.291069]  [<ffffffff81671d5c>] dump_stack+0x45/0x56
[13071.291072]  [<ffffffff81043370>] warn_slowpath_common+0x70/0xa0
[13071.291074]  [<ffffffff810433ba>] warn_slowpath_null+0x1a/0x20
[13071.291075]  [<ffffffff8121145b>] ext4_evict_inode+0x41b/0x510
[13071.291078]  [<ffffffff8118b24c>] evict+0xac/0x1a0
[13071.291079]  [<ffffffff8118b9d5>] iput+0x105/0x190
[13071.291081]  [<ffffffff811875c8>] d_kill+0xf8/0x130
[13071.291083]  [<ffffffff81187cb7>] dput+0xe7/0x1c0
[13071.291085]  [<ffffffff8117fa49>] SYSC_renameat+0x3a9/0x450
[13071.291087]  [<ffffffff8118f629>] ? mntput_no_expire+0x49/0x160
[13071.291089]  [<ffffffff8118f766>] ? mntput+0x26/0x40
[13071.291091]  [<ffffffff8117358e>] ? ____fput+0xe/0x10
[13071.291094]  [<ffffffff810651cc>] ? task_work_run+0xac/0xe0
[13071.291096]  [<ffffffff8118241e>] SyS_renameat+0xe/0x10
[13071.291098]  [<ffffffff8118243b>] SyS_rename+0x1b/0x20
[13071.291100]  [<ffffffff81680f02>] system_call_fastpath+0x16/0x1b
[13071.291101] ---[ end trace 3c1a516fb2cf5d2f ]---
[15600.880124] ------------[ cut here ]------------
[15600.880134] WARNING: at fs/ext4/inode.c:230 ext4_evict_inode+0x41b/0x510()
[15600.880136] Modules linked in: ds1621 i2c_diolan_u2c(O) xt_multiport iptable_filter ip_tables x_tables snd_hda_codec_realtek spi_diolan_u2c(O) snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_page_alloc snd_seq_midi snd_seq_midi_event hid_generic snd_rawmidi diolan_u2c_core(O) snd_seq snd_seq_device parport_pc snd_timer psmouse bnep serio_raw rfcomm ppdev bluetooth snd usbhid hid lpc_ich i915 soundcore video drm_kms_helper drm mac_hid i2c_algo_bit coretemp hwmon i2c_dev lp parport e1000e ptp pps_core [last unloaded: i2c_diolan_u2c]
[15600.880176] CPU: 1 PID: 17263 Comm: collect2 Tainted: G        W  O 3.10.0+ #1
[15600.880178] Hardware name:                  /DB65AL, BIOS ALB6510H.86A.0041.2011.0114.1553 01/14/2011
[15600.880180]  0000000000000009 ffff8803cfbc7dd0 ffffffff81671d5c 0000000000000000
[15600.880185]  ffff8803cfbc7e08 ffffffff81043370 ffff8802e2cd38b0 ffff8802e2cd38b0
[15600.880188]  ffffffff8182b6c0 ffffffff8182b6c0 0000000000000000 ffff8803cfbc7e18
[15600.880192] Call Trace:
[15600.880199]  [<ffffffff81671d5c>] dump_stack+0x45/0x56
[15600.880205]  [<ffffffff81043370>] warn_slowpath_common+0x70/0xa0
[15600.880209]  [<ffffffff810433ba>] warn_slowpath_null+0x1a/0x20
[15600.880213]  [<ffffffff8121145b>] ext4_evict_inode+0x41b/0x510
[15600.880217]  [<ffffffff8118b24c>] evict+0xac/0x1a0
[15600.880221]  [<ffffffff8118b9d5>] iput+0x105/0x190
[15600.880225]  [<ffffffff8117ee8e>] do_unlinkat+0x1de/0x240
[15600.880229]  [<ffffffff81144239>] ? vm_munmap+0x59/0x70
[15600.880233]  [<ffffffff81182076>] SyS_unlink+0x16/0x20
[15600.880238]  [<ffffffff81680f02>] system_call_fastpath+0x16/0x1b
[15600.880241] ---[ end trace 3c1a516fb2cf5d30 ]---
