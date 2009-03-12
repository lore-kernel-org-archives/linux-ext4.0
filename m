From: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Subject: BUG at fs/ext4/mballoc.c:3295
Date: Thu, 12 Mar 2009 17:54:28 +0100
Message-ID: <49B93E44.8070109@ph.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hamlet.e18.physik.tu-muenchen.de ([129.187.154.223]:56363 "EHLO
	hamlet.e18.physik.tu-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754436AbZCLQyr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Mar 2009 12:54:47 -0400
Received: from [129.187.154.161] (earlgrey.e18.physik.tu-muenchen.de [129.187.154.161])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by hamlet.e18.physik.tu-muenchen.de (Postfix) with ESMTP id BB1E24F0E1
	for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2009 17:54:44 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

the following can be observed reproducibly with 2.6.29-rc7 when filling 
up a very small (2MB) file system:

dd if=/dev/zero of=/file/inside/small/filesystem

hangs, dmesg output is:

[  602.831279] EXT4-fs: barriers enabled
[  602.862751] EXT4-fs warning: mounting fs with errors, running e2fsck 
is recommended
[  602.864165] kjournald2 starting: pid 5414, dev loop0:8, commit 
interval 5 seconds
[  602.864318] EXT4 FS on loop0, internal journal on loop0:8
[  602.864325] EXT4-fs: delayed allocation enabled
[  602.864348] EXT4-fs: file extents enabled
[  602.864669] EXT4-fs: mballoc enabled
[  602.864674] EXT4-fs: recovery complete.
[  602.869466] EXT4-fs: mounted filesystem loop0 with ordered data mode
[  623.000911] JBD: barrier-based sync failed on loop0:8 - disabling 
barriers
[  633.432299] ------------[ cut here ]------------
[  633.432329] kernel BUG at fs/ext4/mballoc.c:3295!
[  633.432353] invalid opcode: 0000 [#1] PREEMPT SMP
[  633.432382] last sysfs file: /sys/power/state
[  633.432388] Modules linked in: ext4 jbd2 crc16 cpufreq_ondemand 
cpufreq_userspace cpufreq_powersave acpi_cpufreq speedstep_lib 
freq_table toshiba loop snd_intel8x0 snd_ac97_codec ac97_bus ipw2200 
snd_pcm libipw snd_timer psmouse snd soundcore lib80211 snd_page_alloc 
toshiba_acpi rfkill backlight input_polldev ac battery button evdev ext3 
jbd mbcache usbhid sd_mod ata_generic ata_piix libata ehci_hcd uhci_hcd 
e100 mii scsi_mod usbcore thermal processor fan thermal_sys
[  633.432669]
[  633.432676] Pid: 5475, comm: dd Not tainted (2.6.29-rc7-dbg #1) TECRA A3X
[  633.432701] EIP: 0060:[<e04486bc>] EFLAGS: 00210202 CPU: 0
[  633.432772] EIP is at ext4_mb_normalize_request+0x712/0x7bd [ext4]
[  633.432796] EAX: 00000001 EBX: 00000200 ECX: 00000001 EDX: cf950738
[  633.432803] ESI: 00000000 EDI: cf94a3f0 EBP: cd07fa98 ESP: cd07fa38
[  633.432827]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  633.432852] Process dd (pid: 5475, ti=cd07e000 task=dd092d00 
task.ti=cd07e000)
[  633.432859] Stack:
[  633.432863]  00000002 00000001 00000000 e044853a 0005e800 00000000 
cd07fb6c cf950738
[  633.432918]  00000200 00000000 cf94a3f0 0000000a 00000200 00000000 
00000000 00000000
[  633.432958]  cf94a0ac cf94a184 cf94a184 000001da 00000002 00000000 
dcdf0c00 cf94a184
[  633.433016] Call Trace:
[  633.433021]  [<e044853a>] ? ext4_mb_normalize_request+0x590/0x7bd [ext4]
[  633.433047]  [<e044d5e8>] ? ext4_mb_new_blocks+0x1c3/0x480 [ext4]
[  633.433047]  [<e04455fa>] ? ext4_ext_get_blocks+0xc06/0xe7c [ext4]
[  633.433047]  [<c0315ccd>] ? _spin_unlock+0x27/0x3c
[  633.433047]  [<e007da49>] ? find_revoke_record+0x94/0xa3 [jbd2]
[  633.433047]  [<e007e10d>] ? jbd2_journal_cancel_revoke+0x11a/0x15c [jbd2]
[  633.433047]  [<c014f580>] ? __lock_acquire+0x475/0x5e0
[  633.433047]  [<e04343a2>] ? ext4_get_blocks_wrap+0xf0/0x214 [ext4]
[  633.433047]  [<e0434bb4>] ? ext4_get_block+0xba/0xf1 [ext4]
[  633.433047]  [<c01c1954>] ? __block_prepare_write+0x15b/0x352
[  633.433047]  [<c0179320>] ? find_lock_page+0x33/0x6b
[  633.433047]  [<c01c1ce7>] ? block_write_begin+0x7b/0xd7
[  633.433047]  [<e0434afa>] ? ext4_get_block+0x0/0xf1 [ext4]
[  633.433047]  [<e042f416>] ? ext4_write_begin+0xde/0x1dd [ext4]
[  633.433047]  [<e0434afa>] ? ext4_get_block+0x0/0xf1 [ext4]
[  633.433047]  [<e042faab>] ? ext4_da_write_begin+0x10f/0x227 [ext4]
[  633.433047]  [<c0178ac1>] ? generic_file_buffered_write+0xd9/0x27c
[  633.433047]  [<c017a503>] ? __generic_file_aio_write_nolock+0x4b3/0x507
[  633.433047]  [<c017a5b2>] ? generic_file_aio_write+0x5b/0xb9
[  633.433047]  [<c012ec77>] ? __do_softirq+0x68/0x163
[  633.433047]  [<c014d207>] ? validate_chain+0x12e/0x1044
[  633.433047]  [<e042cd05>] ? ext4_file_write+0xd0/0x152 [ext4]
[  633.433047]  [<c014fea2>] ? mark_held_locks+0x4f/0x66
[  633.433047]  [<c01a1eb5>] ? do_sync_write+0xc4/0x109
[  633.433047]  [<c013dadd>] ? autoremove_wake_function+0x0/0x41
[  633.433047]  [<c01fa634>] ? security_file_permission+0xf/0x11
[  633.433047]  [<c01a20b1>] ? rw_verify_area+0xb0/0xd3
[  633.433047]  [<c0315ccd>] ? _spin_unlock+0x27/0x3c
[  633.433047]  [<c01a216b>] ? vfs_write+0x97/0x14e
[  633.433047]  [<c0103237>] ? sysenter_exit+0xf/0x1a
[  633.433047]  [<c01a1df1>] ? do_sync_write+0x0/0x109
[  633.433047]  [<c01a2963>] ? sys_write+0x3d/0x61
[  633.433047]  [<c01031fb>] ? sysenter_do_call+0x12/0x3f
[  633.433047] Code: 26 8b 55 bc 8b 42 04 8b 80 7c 02 00 00 8b 40 08 b9 
01 00 00 00 83 fe 00 7f 0b 7c 04 39 c3 73 05 b9 00 00 00 00 89 c8 85 c0 
74 04 <0f> 0b eb fe 8b 7d dc 8b 4d bc 89 79 18 89 59 24 8b 45 b8 8b 50
[  633.433047] EIP: [<e04486bc>] ext4_mb_normalize_request+0x712/0x7bd 
[ext4] SS:ESP 0068:cd07fa38
[  633.443710] ---[ end trace 7b79a7a8035c66f0 ]---


IIRC the small filesystem was created like that:

dd if=/dev/zero of=image.ext4 bs=1M count=2
/sbin/mkfs.ext4 -v -F -b 1024 -m 0 -g 512 -G 4 -I 128 -N 1 -O 
large_file,dir_index,flex_bg,extent,sparse_super image.ext4

Kind regards,

Thiemo
