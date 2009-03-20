From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Severe data corruption with ext4
Date: Fri, 20 Mar 2009 03:01:21 -0700
Message-ID: <20090320030121.1fa8e6d3.akpm@linux-foundation.org>
References: <b2080d80903200244u7fbcc150g6724a84c9b3b2054@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Richard <richard@r-selected.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56228 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760528AbZCTKH3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Mar 2009 06:07:29 -0400
In-Reply-To: <b2080d80903200244u7fbcc150g6724a84c9b3b2054@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

(cc the linux-ext4 list)

On Fri, 20 Mar 2009 10:44:02 +0100 Richard <richard@r-selected.de> wrote:

> Hello, I've already searched the web and the list archives, but
> couldn't find anything related, so I decided to post to the LKML.
> 
> I am running an up-to-date Arch Linux [1] installation with the stock
> kernel ("2.6.28-ARCH"), using ext4 on LUKS on LVM on RAID-1; LUKS was
> set up as described here [2], and RAID/LVM was set up following this
> howto [3].
> 
> [1] Arch Linux: http://www.archlinux.org/
> [2] LUKS setup: http://wiki.archlinux.org/index.php/LUKS
> [3] RAID/LVM setup:
> http://wiki.archlinux.org/index.php/Installing_with_Software_RAID_or_LVM
> 
> The system running several days without any problems, last morning I
> found some messages in /var/log/errors.log, stating:
> 
> ----------
> Mar 19 08:42:43 bakunin kernel: BUG: scheduling while atomic:
> install-info/27020/0x00000002
> Mar 19 08:42:48 bakunin kernel: BUG: scheduling while atomic:
> kjournald2/2451/0x00000002
> ----------
> 
> repeating the 2nd line 10 more times.
> 
> Looking into /var/log/kernel.log, I found the following message:
> 
> ----------
> Mar 19 08:42:43 bakunin kernel: EXT4-fs error (device dm-13):
> ext4_mb_generate_buddy: EXT4-fs: group 0: 16470 blocks in bitmap, 4354
> in gd
> Mar 19 08:42:43 bakunin kernel:
> Mar 19 08:42:43 bakunin kernel: BUG: scheduling while atomic:
> install-info/27020/0x00000002
> Mar 19 08:42:43 bakunin kernel: Modules linked in: it87 hwmon_vid
> isofs zlib_inflate ext3 jbd loop ipv6 arc4 ecb snd_seq_oss nvidia(P)
> ath5k snd_seq_midi_event snd_seq snd
> _seq_device agpgart mac80211 snd_hda_intel led_class snd_pcm_oss
> snd_mixer_oss i2c_core k8temp snd_hwdep pcspkr snd_pcm snd_timer snd
> snd_page_alloc cfg80211 shpchp pci_ho
> tplug r8169 mii sg soundcore wmi evdev thermal processor fan button
> battery ac rtc_cmos rtc_core rtc_lib ext4 mbcache jbd2 crc16 aes_i586
> aes_generic xts gf128mul dm_crypt
>  dm_mod raid1 md_mod sd_mod usbhid hid ahci pata_amd pata_acpi
> ata_generic libata scsi_mod ohci_hcd ehci_hcd usbcore [last unloaded:
> i2c_dev]
> Mar 19 08:42:43 bakunin kernel: Pid: 27020, comm: install-info
> Tainted: P           2.6.28-ARCH #1
> Mar 19 08:42:43 bakunin kernel: Call Trace:
> Mar 19 08:42:43 bakunin kernel: [<c0336dc7>] schedule+0x4a7/0x970
> Mar 19 08:42:43 bakunin kernel: [<f8bb844d>]
> dm_table_unplug_all+0x3d/0x90 [dm_mod]
> Mar 19 08:42:43 bakunin kernel: [<c03396d5>] _spin_unlock+0x5/0x20
> Mar 19 08:42:43 bakunin kernel: [<c02790df>] vt_console_print+0x23f/0x330
> Mar 19 08:42:43 bakunin kernel: [<c014cde1>] getnstimeofday+0x51/0x110
> Mar 19 08:42:43 bakunin kernel: [<c03372e1>] io_schedule+0x51/0x90
> Mar 19 08:42:43 bakunin kernel: [<c01be315>] sync_buffer+0x35/0x40
> Mar 19 08:42:43 bakunin kernel: [<c0337797>] __wait_on_bit+0x47/0x70
> Mar 19 08:42:43 bakunin kernel: [<c01be2e0>] sync_buffer+0x0/0x40
> Mar 19 08:42:43 bakunin kernel: [<c01be2e0>] sync_buffer+0x0/0x40
> Mar 19 08:42:43 bakunin kernel: [<c0337873>] out_of_line_wait_on_bit+0xb3/0xd0
> Mar 19 08:42:43 bakunin kernel: [<c0144dd0>] wake_bit_function+0x0/0x70
> Mar 19 08:42:43 bakunin kernel: [<c01be28e>] __wait_on_buffer+0x1e/0x30
> Mar 19 08:42:43 bakunin kernel: [<c01be8af>] sync_dirty_buffer+0x7f/0xc0
> Mar 19 08:42:43 bakunin kernel: [<f941e227>] ext4_commit_super+0x77/0xd0 [ext4]
> Mar 19 08:42:43 bakunin kernel: [<f9421fd7>] ext4_handle_error+0x47/0xb0 [ext4]
> Mar 19 08:42:43 bakunin kernel: [<c03365f2>] printk+0x17/0x1d
> Mar 19 08:42:43 bakunin kernel: [<f9422104>] ext4_error+0x54/0x60 [ext4]
> Mar 19 08:42:43 bakunin kernel: [<f942c8cb>]
> ext4_mb_init_cache+0x94b/0xb40 [ext4]
> Mar 19 08:42:43 bakunin kernel: [<c0173997>] find_or_create_page+0x57/0x90
> Mar 19 08:42:43 bakunin kernel: [<f942cd6d>]
> ext4_mb_load_buddy+0x2ad/0x2e0 [ext4]
> Mar 19 08:42:43 bakunin kernel: [<f942d0da>]
> ext4_mb_free_blocks+0x33a/0x760 [ext4]
> Mar 19 08:42:43 bakunin kernel: [<c0172b8c>] find_get_page+0x2c/0xd0
> Mar 19 08:42:43 bakunin kernel: [<f9412622>]
> ext4_mark_iloc_dirty+0x412/0x520 [ext4]
> Mar 19 08:42:43 bakunin kernel: [<f940e66b>] ext4_free_blocks+0x5b/0xf0 [ext4]
> Mar 19 08:42:43 bakunin kernel: [<f9426dc7>]
> ext4_ext_truncate+0x807/0x960 [ext4]
> Mar 19 08:42:43 bakunin kernel: [<f9418177>] ext4_truncate+0x147/0x690 [ext4]
> Mar 19 08:42:43 bakunin kernel: [<c017c7c1>]
> truncate_inode_pages_range+0x191/0x360
> Mar 19 08:42:43 bakunin kernel: [<c0183eda>] unmap_mapping_range+0xda/0x280
> Mar 19 08:42:43 bakunin kernel: [<c0184266>] vmtruncate+0xc6/0x190
> Mar 19 08:42:43 bakunin kernel: [<c01b0c53>] inode_setattr+0x53/0x180
> Mar 19 08:42:43 bakunin kernel: [<f9413961>] ext4_setattr+0x241/0x350 [ext4]
> Mar 19 08:42:43 bakunin kernel: [<c01a5453>] do_lookup+0x93/0x1e0
> Mar 19 08:42:43 bakunin kernel: [<c01b0ec9>] notify_change+0x149/0x340
> Mar 19 08:42:43 bakunin kernel: [<c0337e73>] __mutex_lock_slowpath+0x1d3/0x250
> Mar 19 08:42:43 bakunin kernel: [<c019c5cc>] do_truncate+0x6c/0x90
> Mar 19 08:42:43 bakunin kernel: [<c03396d5>] _spin_unlock+0x5/0x20
> Mar 19 08:42:43 bakunin kernel: [<c01aeaee>] __d_lookup+0x10e/0x150
> Mar 19 08:42:43 bakunin kernel: [<c01a6a1f>] may_open+0x1bf/0x250
> Mar 19 08:42:43 bakunin kernel: [<c01a8ec5>] do_filp_open+0x185/0x860
> Mar 19 08:42:43 bakunin kernel: [<c018ec1b>] free_pages_and_swap_cache+0x7b/0xa0
> Mar 19 08:42:43 bakunin kernel: [<c03396d5>] _spin_unlock+0x5/0x20
> Mar 19 08:42:43 bakunin kernel: [<c019b641>] do_sys_open+0x61/0xf0
> Mar 19 08:42:43 bakunin kernel: [<c019b74c>] sys_open+0x2c/0x40
> Mar 19 08:42:43 bakunin kernel: [<c0103f0f>] sysenter_do_call+0x12/0x2f
> ----------
> 
> followed by multiple instances of:
> 
> ----------
> Mar 19 08:42:48 bakunin kernel: EXT4-fs error (device dm-13):
> mb_free_blocks: double-free of inode 0's block 11457(bit 11457 in
> group 0)
> Mar 19 08:42:48 bakunin kernel:
> Mar 19 08:42:48 bakunin kernel: BUG: scheduling while atomic:
> kjournald2/2451/0x00000002
> Mar 19 08:42:48 bakunin kernel: Modules linked in: it87 hwmon_vid
> isofs zlib_inflate ext3 jbd loop ipv6 arc4 ecb snd_seq_oss nvidia(P)
> ath5k snd_seq_midi_event snd_seq snd_seq_device agpgart mac80211
> snd_hda_intel led_class snd_pcm_oss snd_mixer_oss i2c_core k8temp
> snd_hwdep pcspkr snd_pcm snd_timer snd snd_page_alloc cfg80211 shpchp
> pci_hotplug r8169 mii sg soundcore wmi evdev thermal processor fan
> button battery ac rtc_cmos rtc_core rtc_lib ext4 mbcache jbd2 crc16
> aes_i586 aes_generic xts gf128mul dm_crypt dm_mod raid1 md_mod sd_mod
> usbhid hid ahci pata_amd pata_acpi ata_generic libata scsi_mod
> ohci_hcd ehci_hcd usbcore [last unloaded: i2c_dev]
> Mar 19 08:42:48 bakunin kernel: Pid: 2451, comm: kjournald2 Tainted: P
>           2.6.28-ARCH #1
> Mar 19 08:42:48 bakunin kernel: Call Trace:
> Mar 19 08:42:48 bakunin kernel: [<c0336dc7>] schedule+0x4a7/0x970
> Mar 19 08:42:48 bakunin kernel: [<f8bb844d>]
> dm_table_unplug_all+0x3d/0x90 [dm_mod]
> Mar 19 08:42:48 bakunin kernel: [<c0144d9b>] autoremove_wake_function+0x1b/0x50
> Mar 19 08:42:48 bakunin kernel: [<c03396d5>] _spin_unlock+0x5/0x20
> Mar 19 08:42:48 bakunin kernel: [<c02790df>] vt_console_print+0x23f/0x330
> Mar 19 08:42:48 bakunin kernel: [<c014cde1>] getnstimeofday+0x51/0x110
> Mar 19 08:42:48 bakunin kernel: [<c03372e1>] io_schedule+0x51/0x90
> Mar 19 08:42:48 bakunin kernel: [<c01be315>] sync_buffer+0x35/0x40
> Mar 19 08:42:48 bakunin kernel: [<c0337797>] __wait_on_bit+0x47/0x70
> Mar 19 08:42:48 bakunin kernel: [<c01be2e0>] sync_buffer+0x0/0x40
> Mar 19 08:42:48 bakunin kernel: [<c01be2e0>] sync_buffer+0x0/0x40
> Mar 19 08:42:48 bakunin kernel: [<c0337873>] out_of_line_wait_on_bit+0xb3/0xd0
> Mar 19 08:42:48 bakunin kernel: [<c0144dd0>] wake_bit_function+0x0/0x70
> Mar 19 08:42:48 bakunin kernel: [<c01be28e>] __wait_on_buffer+0x1e/0x30
> Mar 19 08:42:48 bakunin kernel: [<c01be8af>] sync_dirty_buffer+0x7f/0xc0
> Mar 19 08:42:48 bakunin kernel: [<f941e227>] ext4_commit_super+0x77/0xd0 [ext4]
> Mar 19 08:42:48 bakunin kernel: [<f9421fd7>] ext4_handle_error+0x47/0xb0 [ext4]
> Mar 19 08:42:48 bakunin kernel: [<c03365f2>] printk+0x17/0x1d
> Mar 19 08:42:48 bakunin kernel: [<f9422104>] ext4_error+0x54/0x60 [ext4]
> Mar 19 08:42:48 bakunin kernel: [<f942b40c>] mb_free_blocks+0x1dc/0x440 [ext4]
> Mar 19 08:42:48 bakunin kernel: [<f943022e>]
> release_blocks_on_commit+0xde/0x250 [ext4]
> Mar 19 08:42:48 bakunin kernel: [<f93b038c>]
> jbd2_journal_commit_transaction+0xf3c/0x1180 [jbd2]
> Mar 19 08:42:48 bakunin kernel: [<f93b3dac>] kjournald2+0xac/0x1f0 [jbd2]
> Mar 19 08:42:48 bakunin kernel: [<c0144d80>] autoremove_wake_function+0x0/0x50
> Mar 19 08:42:48 bakunin kernel: [<f93b3d00>] kjournald2+0x0/0x1f0 [jbd2]
> Mar 19 08:42:48 bakunin kernel: [<c0144a89>] kthread+0x39/0x70
> Mar 19 08:42:48 bakunin kernel: [<c0144a50>] kthread+0x0/0x70
> Mar 19 08:42:48 bakunin kernel: [<c0104d9f>] kernel_thread_helper+0x7/0x18
> ----------
> 
> Using "dmsetup ls", I figured that dm-13 was /usr; so I fsck'd it.
> fsck revealed hundreds of errors, which I let "fsck -y" fix automatically.
> Now there's plenty (more than 250) of files and directories in /usr/lost+found.
> 
> [Annotation: When I now, after a reboot, use "dmsetup ls", /usr is
> associated minor number 14, while 13 (which is mentioned in
>  the error messages above) is associated with /var. I don't know
> whether I misread the number/volume in the first place, or if
>  the enumeration can change after a reboot. However, /var is hosting a
> clean filesystem.]
> 
> An extended SMART self-test of my hard drives spotted no error messages.
> 
> The evening before the errors occured, I ran lm_sensors'
> "sensors-detect" script which loaded a couple of modules and stuff.
> Don't know if there might be a connection.
> 
> Also, every night about 5 minutes past midnight, I get something like
> this in my logs:
> 
> ----------
> Mar 19 00:04:51 bakunin kernel: init_special_inode: bogus i_mode (336)
> ----------
> 
> I guess this is caused by some process run by crond, but have not yet
> figured out which one spawns/spawned this message.
> 
> Annotation:
> I remember while my RAID-1 sync'd, when running 3D apps (Quake 3,
> glxgears), the system would sometimes suddenly appear to have locked
> up, but was working again after some time (like, a minute or so). The
> logs showed something like:
> 
> ----------
> Mar 13 01:11:56 bakunin ata4.00: exception Emask 0x0 SAct 0xffff SErr
> 0x0 action 0x6 frozen
> Mar 13 01:11:56 bakunin ata4.00: cmd
> 61/80:00:92:31:42/02:00:21:00:00/40 tag 0 ncq 327680 out
> Mar 13 01:11:56 bakunin res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
> 0x4 (timeout)
> Mar 13 01:11:56 bakunin ata4.00: status: { DRDY }
> Mar 13 01:11:56 bakunin ata4.00: cmd
> 61/80:08:12:36:42/00:00:21:00:00/40 tag 1 ncq 65536 out
> Mar 13 01:11:56 bakunin res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
> 0x4 (timeout)
> Mar 13 01:11:56 bakunin ata4.00: status: { DRDY }
> Mar 13 01:11:56 bakunin ata4.00: cmd
> 61/00:10:92:3a:42/01:00:21:00:00/40 tag 2 ncq 131072 out
> Mar 13 01:11:56 bakunin res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
> 0x4 (timeout)
> Mar 13 01:11:56 bakunin ata4.00: status: { DRDY }
> ----------
> 
> Bad cabling, maybe..?
> This problem has never, ever occured again after the RAID
> synchronization was complete.
> 
> lspci output:
> 
> ----------
> 00:00.0 RAM memory: nVidia Corporation MCP78S [GeForce 8200] Memory
> Controller (rev a2)
> 00:01.0 ISA bridge: nVidia Corporation MCP78S [GeForce 8200] LPC Bridge (rev a2)
> 00:01.1 SMBus: nVidia Corporation MCP78S [GeForce 8200] SMBus (rev a1)
> 00:01.2 RAM memory: nVidia Corporation MCP78S [GeForce 8200] Memory
> Controller (rev a1)
> 00:01.3 Co-processor: nVidia Corporation MCP78S [GeForce 8200]
> Co-Processor (rev a2)
> 00:01.4 RAM memory: nVidia Corporation MCP78S [GeForce 8200] Memory
> Controller (rev a1)
> 00:02.0 USB Controller: nVidia Corporation MCP78S [GeForce 8200] OHCI
> USB 1.1 Controller (rev a1)
> 00:02.1 USB Controller: nVidia Corporation MCP78S [GeForce 8200] EHCI
> USB 2.0 Controller (rev a1)
> 00:04.0 USB Controller: nVidia Corporation MCP78S [GeForce 8200] OHCI
> USB 1.1 Controller (rev a1)
> 00:04.1 USB Controller: nVidia Corporation MCP78S [GeForce 8200] EHCI
> USB 2.0 Controller (rev a1)
> 00:06.0 IDE interface: nVidia Corporation MCP78S [GeForce 8200] IDE (rev a1)
> 00:07.0 Audio device: nVidia Corporation MCP78S [GeForce 8200] High
> Definition Audio (rev a1)
> 00:08.0 PCI bridge: nVidia Corporation MCP78S [GeForce 8200] PCI Bridge (rev a1)
> 00:09.0 IDE interface: nVidia Corporation MCP78S [GeForce 8200] SATA
> Controller (non-AHCI mode) (rev a2)
> 00:0b.0 PCI bridge: nVidia Corporation MCP78S [GeForce 8200] PCI
> Express Bridge (rev a1)
> 00:10.0 PCI bridge: nVidia Corporation MCP78S [GeForce 8200] PCI
> Express Bridge (rev a1)
> 00:12.0 PCI bridge: nVidia Corporation MCP78S [GeForce 8200] PCI
> Express Bridge (rev a1)
> 00:13.0 PCI bridge: nVidia Corporation MCP78S [GeForce 8200] PCI Bridge (rev a1)
> 00:14.0 PCI bridge: nVidia Corporation MCP78S [GeForce 8200] PCI Bridge (rev a1)
> 00:18.0 Host bridge: Advanced Micro Devices [AMD] K8
> [Athlon64/Opteron] HyperTransport Technology Configuration
> 00:18.1 Host bridge: Advanced Micro Devices [AMD] K8
> [Athlon64/Opteron] Address Map
> 00:18.2 Host bridge: Advanced Micro Devices [AMD] K8
> [Athlon64/Opteron] DRAM Controller
> 00:18.3 Host bridge: Advanced Micro Devices [AMD] K8
> [Athlon64/Opteron] Miscellaneous Control
> 01:06.0 Ethernet controller: Atheros Communications Inc. Atheros
> AR5001X+ Wireless Network Adapter (rev 01)
> 02:00.0 VGA compatible controller: nVidia Corporation GeForce 8100 /
> nForce 720a (rev a2)
> 05:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
> RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 02)

