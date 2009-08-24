From: Brian Rogers <brian@xyzw.org>
Subject: e4defrag and chattr +e warnings
Date: Mon, 24 Aug 2009 15:39:24 -0700
Message-ID: <4A93169C.7070106@xyzw.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:44744 "EHLO
	QMTA05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753689AbZHXWjX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Aug 2009 18:39:23 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all.

The first time since boot that I run e4defrag on a directory of 
significant size, I get this warning in dmesg:

[  199.076871]
[  199.076876] =============================================
[  199.076884] [ INFO: possible recursive locking detected ]
[  199.076891] 2.6.31-rc7-red-debug #4
[  199.076896] ---------------------------------------------
[  199.076902] e4defrag/4399 is trying to acquire lock:
[  199.076908]  (&ei->i_data_sem){++++..}, at: [<ffffffffa0043839>] 
ext4_move_extents+0x10e/0xa19 [ext4]
[  199.076957]
[  199.076958] but task is already holding lock:
[  199.076964]  (&ei->i_data_sem){++++..}, at: [<ffffffffa0043830>] 
ext4_move_extents+0x105/0xa19 [ext4]
[  199.077006]
[  199.077007] other info that might help us debug this:
[  199.077015] 3 locks held by e4defrag/4399:
[  199.077019]  #0:  (&sb->s_type->i_mutex_key#7/1){+.+.+.}, at: 
[<ffffffffa00437f3>] ext4_move_extents+0xc8/0xa19 [ext4]
[  199.077069]  #1:  (&sb->s_type->i_mutex_key#7/2){+.+...}, at: 
[<ffffffffa0043800>] ext4_move_extents+0xd5/0xa19 [ext4]
[  199.077117]  #2:  (&ei->i_data_sem){++++..}, at: [<ffffffffa0043830>] 
ext4_move_extents+0x105/0xa19 [ext4]
[  199.077161]
[  199.077162] stack backtrace:
[  199.077170] Pid: 4399, comm: e4defrag Not tainted 2.6.31-rc7-red-debug #4
[  199.077176] Call Trace:
[  199.077188]  [<ffffffff8105bcc4>] __lock_acquire+0x1467/0x14f5
[  199.077200]  [<ffffffff81059990>] ? mark_held_locks+0x52/0x70
[  199.077212]  [<ffffffff812a699a>] ? _spin_unlock_irq+0x2b/0x57
[  199.077223]  [<ffffffff8105bda7>] lock_acquire+0x55/0x71
[  199.077261]  [<ffffffffa0043839>] ? ext4_move_extents+0x10e/0xa19 [ext4]
[  199.077275]  [<ffffffff812a5b10>] down_read+0x40/0x4f
[  199.077313]  [<ffffffffa0043839>] ? ext4_move_extents+0x10e/0xa19 [ext4]
[  199.077341]  [<ffffffffa0043839>] ext4_move_extents+0x10e/0xa19 [ext4]
[  199.077341]  [<ffffffff8105af3b>] ? __lock_acquire+0x6de/0x14f5
[  199.077341]  [<ffffffffa002b44d>] ext4_ioctl+0x595/0x756 [ext4]
[  199.077341]  [<ffffffff810b1a91>] vfs_ioctl+0x1d/0x82
[  199.077341]  [<ffffffff812a6a00>] ? _spin_unlock_irqrestore+0x3a/0x67
[  199.077341]  [<ffffffff810b1ff0>] do_vfs_ioctl+0x483/0x4c9
[  199.077341]  [<ffffffff81059c30>] ? trace_hardirqs_on+0xd/0xf
[  199.077341]  [<ffffffff8113fa6f>] ? __up_write+0x115/0x124
[  199.077341]  [<ffffffff8100ba9c>] ? sysret_check+0x27/0x62
[  199.077341]  [<ffffffff810b2087>] sys_ioctl+0x51/0x74
[  199.077341]  [<ffffffff8113f97a>] ? __up_write+0x20/0x124
[  199.077341]  [<ffffffff8113f97a>] ? __up_write+0x20/0x124
[  199.077341]  [<ffffffff8100ba6b>] system_call_fastpath+0x16/0x1b

This might be happening when it hits files that don't use extents, but I 
haven't tried e4defrag on a single non-extents file to verify that 
theory. I've just so far only seen this happen when I defrag a directory 
where I get the "operation not supported" message.

If I use chattr +e to migrate a file to use extents, I get this:

[  470.400044] ------------[ cut here ]------------
[  470.400065] WARNING: at fs/inode.c:1210 generic_delete_inode+0x65/0x16a()
[  470.400072] Hardware name: N/A
[  470.400078] Modules linked in: hidp hid ecryptfs cpufreq_ondemand 
binfmt_misc af_packet ipt_MASQUERADE iptable_nat nf_nat 
nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT 
xt_tcpudp iptable_filter ip_tables x_tables rfcomm bridge stp llc bnep 
sco l2cap kvm_intel kvm ipv6 container sbs sbshc microcode acpi_cpufreq 
freq_table uinput sbp2 snd_hda_codec_si3054 snd_hda_codec_realtek 
snd_hda_intel arc4 snd_hda_codec ecb snd_hwdep iwl3945 snd_pcm iwlcore 
snd_seq_midi snd_rawmidi snd_seq_midi_event mac80211 snd_seq led_class 
btusb joydev snd_timer sr_mod bluetooth snd_seq_device cdrom cfg80211 
snd ata_generic tg3 soundcore pata_acpi ohci1394 uhci_hcd ehci_hcd 
psmouse libphy snd_page_alloc ata_piix processor rfkill ieee1394 button 
usbcore battery evdev serio_raw wmi ac sg sd_mod thermal fan fuse 
dm_mirror dm_region_hash dm_log dm_mod ahci libata scsi_mod ext4 mbcache 
jbd2 crc16
[  470.400353] Pid: 4451, comm: chattr Not tainted 2.6.31-rc7-red-debug #4
[  470.400359] Call Trace:
[  470.400372]  [<ffffffff81037771>] warn_slowpath_common+0x77/0x8f
[  470.400385]  [<ffffffff81037798>] warn_slowpath_null+0xf/0x11
[  470.400395]  [<ffffffff810b7f28>] generic_delete_inode+0x65/0x16a
[  470.400405]  [<ffffffff810b8044>] generic_drop_inode+0x17/0x1bd
[  470.400413]  [<ffffffff810b7083>] iput+0x61/0x65
[  470.400455]  [<ffffffffa003b229>] ext4_ext_migrate+0x5eb/0x66a [ext4]
[  470.400492]  [<ffffffffa002b1f8>] ext4_ioctl+0x340/0x756 [ext4]
[  470.400507]  [<ffffffff810b1a91>] vfs_ioctl+0x1d/0x82
[  470.400517]  [<ffffffff810b1ff0>] do_vfs_ioctl+0x483/0x4c9
[  470.400527]  [<ffffffff81059c30>] ? trace_hardirqs_on+0xd/0xf
[  470.400537]  [<ffffffff810b2087>] sys_ioctl+0x51/0x74
[  470.400549]  [<ffffffff8100ba6b>] system_call_fastpath+0x16/0x1b
[  470.400557] ---[ end trace ab85723542352dac ]---

Aside from these messages, the system continues normally and I haven't 
seen any data loss. After the chattr +e, I am able to defrag with 
e4defrag just fine. This is with the latest kernel code today and with 
the current ext4 next tree merged in. Same result also in both ordered 
and writeback modes. I hope this info helps.

Brian

