From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14562] On umount warn in page_alloc.c:1751
 __alloc_pages_slowpath
Date: Tue, 17 Nov 2009 22:22:07 GMT
Message-ID: <200911172222.nAHMM7IX025014@demeter.kernel.org>
References: <bug-14562-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:35215 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756242AbZKQWWB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Nov 2009 17:22:01 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAHMM7hI025015
	for <linux-ext4@vger.kernel.org>; Tue, 17 Nov 2009 22:22:07 GMT
In-Reply-To: <bug-14562-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14562


Francis Russell <francis+lkbt@unchartedbackwaters.co.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |francis+lkbt@unchartedbackw
                   |                            |aters.co.uk




--- Comment #4 from Francis Russell <francis+lkbt@unchartedbackwaters.co.uk>  2009-11-17 22:22:01 ---
Hi there,

I also have this warning. It seems to occur only when mounting or remounting an
ext4 partition using the auto_da_alloc ext4 mount option. Without this option,
the warning doesn't occur. I'm using x86_64 Debian testing with a 2.6.31.6
kernel compiled from vanilla kernel.org sources running an a Samsung R560
laptop. This is what I see in the syslog:

Nov 17 22:03:41 callisto kernel: [   19.128673] WARNING: at
mm/page_alloc.c:1751 __alloc_pages_nodemask+0x174/0x592()
Nov 17 22:03:41 callisto kernel: [   19.152057] Hardware name: R560             
Nov 17 22:03:41 callisto kernel: [   19.175684] Modules linked in: ext4 jbd2
crc16 fuse coretemp loop btusb bluetooth arc4 ecb snd_hda_codec_nvhdmi
snd_hda_codec_realtek iwlagn iwlcore snd_hda_intel joydev snd_hda_codec
snd_hwdep snd_pcm_oss snd_mixer_oss led_class snd_pcm snd_seq_dummy snd_seq_oss
mac80211 snd_seq_midi snd_rawmidi sg snd_seq_midi_event snd_seq snd_timer
snd_seq_device cfg80211 snd i2c_i801 sr_mod soundcore uhci_hcd rfkill i2c_core
psmouse cdrom intel_agp snd_page_alloc ehci_hcd sky2 evdev serio_raw video
battery pcspkr output button ac aes_x86_64 aes_generic xts gf128mul dm_crypt
dm_mod sd_mod crc_t10dif fan ahci ext3 jbd mbcache
Nov 17 22:03:41 callisto kernel: [   19.255394] Pid: 1553, comm: mount Not
tainted 2.6.31.6 #1
Nov 17 22:03:41 callisto kernel: [   19.282323] Call Trace:
Nov 17 22:03:41 callisto kernel: [   19.308744]  [<ffffffff810a7e87>] ?
__alloc_pages_nodemask+0x174/0x592
Nov 17 22:03:41 callisto kernel: [   19.335479]  [<ffffffff810412da>]
warn_slowpath_common+0x77/0xa4
Nov 17 22:03:41 callisto kernel: [   19.361993]  [<ffffffff81041316>]
warn_slowpath_null+0xf/0x11
Nov 17 22:03:41 callisto kernel: [   19.388272]  [<ffffffff810a7e87>]
__alloc_pages_nodemask+0x174/0x592
Nov 17 22:03:41 callisto kernel: [   19.414627]  [<ffffffff8105de26>] ?
getnstimeofday+0x57/0xb3
Nov 17 22:03:41 callisto kernel: [   19.441186]  [<ffffffff810a830e>]
__get_free_pages+0x12/0x4f
Nov 17 22:03:41 callisto kernel: [   19.467454]  [<ffffffff810ccff2>]
__kmalloc+0x45/0x132
Nov 17 22:03:41 callisto kernel: [   19.493497]  [<ffffffff8117703e>]
match_number+0x35/0x98
Nov 17 22:03:41 callisto kernel: [   19.519417]  [<ffffffff811770cc>]
match_int+0xb/0xd
Nov 17 22:03:41 callisto kernel: [   19.545047]  [<ffffffffa0382a1b>]
parse_options+0x61b/0x73e [ext4]
Nov 17 22:03:41 callisto kernel: [   19.570632]  [<ffffffff810f30da>] ?
__wait_on_buffer+0x1f/0x21
Nov 17 22:03:41 callisto kernel: [   19.596161]  [<ffffffff810f3101>] ?
wait_on_buffer+0x25/0x29
Nov 17 22:03:41 callisto kernel: [   19.621468]  [<ffffffffa0383411>]
ext4_fill_super+0x368/0x20c2 [ext4]
Nov 17 22:03:41 callisto kernel: [   19.646600]  [<ffffffff81176135>] ?
snprintf+0x59/0x5b
Nov 17 22:03:41 callisto kernel: [   19.671431]  [<ffffffff8117063b>] ?
kobject_get+0x1a/0x22
Nov 17 22:03:41 callisto kernel: [   19.696013]  [<ffffffff810f7b54>] ?
__blkdev_get+0x2a7/0x35a
Nov 17 22:03:41 callisto kernel: [   19.720428]  [<ffffffff812ca16a>] ?
down_write+0x19/0x1d
Nov 17 22:03:41 callisto kernel: [   19.744514]  [<ffffffff810d5bc7>]
get_sb_bdev+0x119/0x162
Nov 17 22:03:41 callisto kernel: [   19.768211]  [<ffffffffa03830a9>] ?
ext4_fill_super+0x0/0x20c2 [ext4]
Nov 17 22:03:41 callisto kernel: [   19.791875]  [<ffffffffa0380df3>]
ext4_get_sb+0x13/0x15 [ext4]
Nov 17 22:03:41 callisto kernel: [   19.815571]  [<ffffffff810d57fa>]
vfs_kern_mount+0x99/0x11d
Nov 17 22:03:41 callisto kernel: [   19.839280]  [<ffffffff810d58db>]
do_kern_mount+0x47/0xe7
Nov 17 22:03:41 callisto kernel: [   19.862943]  [<ffffffff810ea17f>]
do_mount+0x74b/0x7b9
Nov 17 22:03:41 callisto kernel: [   19.886475]  [<ffffffff810a830e>] ?
__get_free_pages+0x12/0x4f
Nov 17 22:03:41 callisto kernel: [   19.910076]  [<ffffffff810ea26d>]
sys_mount+0x80/0xc3
Nov 17 22:03:41 callisto kernel: [   19.933491]  [<ffffffff8104c3d3>] ?
sys_rt_sigprocmask+0x54/0xcf
Nov 17 22:03:41 callisto kernel: [   19.956952]  [<ffffffff8100baeb>]
system_call_fastpath+0x16/0x1b
Nov 17 22:03:41 callisto kernel: [   19.980419] ---[ end trace 7a506926f0515111
]---
Nov 17 22:03:41 callisto kernel: [   20.060709] EXT4-fs (dm-3): barriers
enabled
Nov 17 22:03:41 callisto kernel: [   20.100150] kjournald2 starting: pid 1579,
dev dm-3:8, commit interval 5 seconds
Nov 17 22:03:41 callisto kernel: [   20.124074] EXT4-fs (dm-3): internal
journal on dm-3:8
Nov 17 22:03:41 callisto kernel: [   20.147399] EXT4-fs (dm-3): delayed
allocation enabled
Nov 17 22:03:41 callisto kernel: [   20.147616] EXT4-fs: file extents enabled
Nov 17 22:03:41 callisto kernel: [   20.148116] EXT4-fs: mballoc enabled
Nov 17 22:03:41 callisto kernel: [   20.148127] EXT4-fs (dm-3): mounted
filesystem with ordered data mode

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
