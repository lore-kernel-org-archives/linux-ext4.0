From: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Subject: ext4: BUG: scheduling while atomic
Date: Wed, 01 Apr 2009 00:09:26 +0200
Message-ID: <49D29496.4060108@ph.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hamlet.e18.physik.tu-muenchen.de ([129.187.154.223]:34714 "EHLO
	hamlet.e18.physik.tu-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763669AbZCaWJf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 Mar 2009 18:09:35 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dear Ted,

I came across "scheduling while atomic" during tests with intentionally 
corrupted ext4 images.  It seems that ext4_error() is called while 
holding a spinlock.  The resulting superblock flush then causes a sleep. 
  I have no idea how bad this is (if at all).

The issue can be reproduced with yesterday's version of your ext4 tree 
when calling "mkdir" inside this fs:
http://e18.physik.tu-muenchen.de/~tnagel/misc/issue11.image.ext4.bz2

Kind regards,

Thiemo

[  201.286550] EXT4-fs: barriers enabled
[  201.301352] kjournald2 starting: pid 4073, dev loop0:8, commit 
interval 5 seconds
[  201.301501] EXT4 FS on loop0, internal journal on loop0:8
[  201.301508] EXT4-fs: delayed allocation enabled
[  201.301531] EXT4-fs: file extents enabled
[  201.301718] EXT4-fs: mballoc enabled
[  201.301813] EXT4-fs: mounted filesystem loop0 with ordered data mode
[  207.890044] EXT4-fs error (device loop0): ext4_mb_generate_buddy: 
EXT4-fs: group 1: 381 blocks in bitmap, 383 in gd
[  207.890169] EXT4-fs error (device loop0): ext4_add_entry: bad entry 
in directory #2: directory entry across blocks - offset=0, inode=2, 
rec_len=18444, name_len=1
[  207.890386] EXT4-fs error (device loop0): ext4_init_block_bitmap: 
Checksum bad for group 0
[  207.890425] BUG: scheduling while atomic: mkdir/4088/0x00000002
[  207.890448] INFO: lockdep is turned off.
[  207.890453] Modules linked in: ext4 jbd2 crc16 cpufreq_ondemand 
cpufreq_userspace cpufreq_powersave acpi_cpufreq freq_table 
speedstep_lib michael_mic arc4 ecb lib80211_crypt_tkip nls_iso8859_1 
nls_cp437 vfat fat nls_base toshiba loop snd_intel8x0 snd_ac97_codec 
ac97_bus ipw2200 libipw snd_pcm snd_timer lib80211 psmouse snd soundcore 
snd_page_alloc toshiba_acpi rfkill backlight input_polldev battery 
button ac evdev ext3 jbd mbcache usbhid sd_mod ata_generic usb_storage 
ata_piix libata ehci_hcd uhci_hcd e100 mii scsi_mod usbcore thermal 
processor fan thermal_sys
[  207.890825] Pid: 4088, comm: mkdir Not tainted 2.6.29-ext4 #1
[  207.890831] Call Trace:
[  207.890864]  [<c01227b7>] __schedule_bug+0x77/0x81
[  207.890894]  [<c0316021>] schedule+0x8f/0x847
[  207.890923]  [<c01189d6>] ? read_hpet+0xd/0x14
[  207.890951]  [<c0140fb2>] ? ktime_get_ts+0x48/0x4c
[  207.890961]  [<c0316820>] io_schedule+0x47/0x79
[  207.890989]  [<c01c0839>] sync_buffer+0x36/0x3e
[  207.891015]  [<c0316c4f>] __wait_on_bit+0x39/0x61
[  207.891086]  [<c01c0803>] ? sync_buffer+0x0/0x3e
[  207.891113]  [<c01c0803>] ? sync_buffer+0x0/0x3e
[  207.891122]  [<c0316ce4>] out_of_line_wait_on_bit+0x6d/0x89
[  207.891152]  [<c013e3ee>] ? wake_bit_function+0x0/0x55
[  207.891178]  [<c01c0801>] __wait_on_buffer+0x21/0x23
[  207.891205]  [<c01c24c6>] sync_dirty_buffer+0x94/0xd1
[  207.891216]  [<c0239077>] ? __percpu_counter_sum+0x54/0x6d
[  207.891306]  [<e044b35c>] ext4_commit_super+0x133/0x175 [ext4]
[  207.891374]  [<e044bcc7>] ext4_handle_error+0x83/0xac [ext4]
[  207.891402]  [<c012bb76>] ? printk+0x1b/0x1d
[  207.891495]  [<e044c1a5>] ext4_error+0x52/0x58 [ext4]
[  207.891564]  [<e043a56b>] ext4_init_block_bitmap+0x64/0x418 [ext4]
[  207.891595]  [<c0318496>] ? _spin_lock+0x4a/0x50
[  207.891657]  [<e043ac2f>] ext4_read_block_bitmap+0xdf/0x2ae [ext4]
[  207.891744]  [<e045b4a9>] ext4_mb_free_blocks+0x133/0x6f6 [ext4]
[  207.891753]  [<c0318d6d>] ? _spin_unlock+0x27/0x3c
[  207.891809]  [<e008ebd0>] ? insert_revoke_hash+0xe5/0xf2 [jbd2]
[  207.891847]  [<e008b3d6>] ? jbd2_journal_forget+0x17e/0x220 [jbd2]
[  207.891941]  [<e0455c0c>] ? __ext4_journal_revoke+0x4a/0x5f [ext4]
[  207.892003]  [<e043a3c4>] ext4_free_blocks+0x8c/0x106 [ext4]
[  207.892128]  [<e045399e>] ext4_ext_truncate+0x413/0x82c [ext4]
[  207.892195]  [<e04446bc>] ext4_truncate+0x73/0x4f0 [ext4]
[  207.892251]  [<e008acc2>] ? jbd2_journal_get_write_access+0x2f/0x3c 
[jbd2]
[  207.892339]  [<e043fd6d>] ? ext4_mark_iloc_dirty+0x4cf/0x542 [ext4]
[  207.892405]  [<e0440a2f>] ? ext4_mark_inode_dirty+0x172/0x1a2 [ext4]
[  207.892473]  [<e0455b51>] ? __ext4_handle_dirty_metadata+0xb1/0xca [ext4]
[  207.892538]  [<e0444b39>] ? ext4_delete_inode+0x0/0x227 [ext4]
[  207.892603]  [<e0444c65>] ext4_delete_inode+0x12c/0x227 [ext4]
[  207.892636]  [<c02386a7>] ? _raw_spin_unlock+0x7f/0x8b
[  207.892723]  [<e0444b39>] ? ext4_delete_inode+0x0/0x227 [ext4]
[  207.892751]  [<c01b4b86>] generic_delete_inode+0xdc/0x171
[  207.892761]  [<c01b4c37>] generic_drop_inode+0x1c/0x1b9
[  207.892790]  [<c022e096>] ? _atomic_dec_and_lock+0x3a/0x64
[  207.892816]  [<c01b41c6>] iput+0x4b/0x4e
[  207.892880]  [<e04484ba>] ext4_mkdir+0x250/0x2c3 [ext4]
[  207.892914]  [<c01ad315>] vfs_mkdir+0xdd/0x182
[  207.892940]  [<c01ad43d>] sys_mkdirat+0x83/0xbd
[  207.892968]  [<c01ad497>] sys_mkdir+0x20/0x22
[  207.892978]  [<c01031fb>] sysenter_do_call+0x12/0x3f
