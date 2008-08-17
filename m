From: "Theodore Ts'o" <tytso@mit.edu>
Subject: ENOSPC error returned too late
Date: Sun, 17 Aug 2008 08:53:11 -0400
Message-ID: <E1KUhkt-0003yw-Sf@closure.thunk.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:40330 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752671AbYHQMxO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Aug 2008 08:53:14 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


While trying to track down kernel BZ #11341 (which is really an
e2fsprogs bug, not a 2.6.26 regression) I created a fresh ext4
filesystem which was 5GB in length, and then filled it to ENOSPC via:

dd if=/dev/zero of=/mnt/bigfile bs=1024 count=10485760

Unfortunately, it sent the ENOSPC few blocks too late, so the following
appeared in dmesg, and an attempt to umount the filesystem hung in D
wait.  :-(

						- Ted


[63518.930337] mpage_da_map_blocks block allocation failed for inode 12 at logical offset 1254547 with max blocks 2 with error -28
[63518.930337] This should not happen.!! Data will be lost
[63518.930337] ------------[ cut here ]------------
[63518.930337] kernel BUG at fs/buffer.c:1858!
[63518.930337] invalid opcode: 0000 [#1] SMP 
[63518.930337] Modules linked in: af_packet arc4 ecb iwlagn iwlcore mac80211 cfg80211 i915 drm nfsd auth_rpcgss exportfs kvm_intel kvm autofs4 pci_slot container wmi cpufreq_stats cpufreq_conservative cpufreq_userspace cpufreq_powersave nfs lockd sunrpc iptable_filter ip_tables x_tables deflate zlib_deflate ctr twofish twofish_common camellia serpent blowfish des_generic cbc aes_i586 aes_generic xcbc rmd160 sha256_generic sha1_generic crypto_null crypto_blkcipher af_key ext3 jbd uinput acpi_cpufreq loop snd_hda_intel snd_pcm_oss snd_mixer_oss serio_raw snd_pcm snd_page_alloc snd_hwdep psmouse battery snd_seq_dummy video output snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device button snd soundcore intel_agp thinkpad_acpi rfkill led_class nvram evdev id
 e_pci_generic piix ide_core sg sd_mod crc_t10dif ata_piix ata_generic ahci libata scsi_mod dock dm_mirror dm_log dm_snapshot dm_mod thermal processor fan fuse ext4dev mbcache jbd2 crc16
[63518.930337] 
[63518.930337] Pid: 15028, comm: sync Not tainted (2.6.27-rc3-00038-gd6f7b5a #56)
[63518.930337] EIP: 0060:[<c01b0fa9>] EFLAGS: 00010246 CPU: 0
[63518.930337] EIP is at __block_prepare_write+0x20/0x2b1
[63518.930337] EAX: 00000000 EBX: d3a04604 ECX: 00000000 EDX: 00000000
[63518.930337] ESI: c6070730 EDI: 00000000 EBP: e2d71cbc ESP: e2d71c7c
[63518.930337]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[63518.930337] Process sync (pid: 15028, ti=e2d71000 task=e81c8000 task.ti=e2d71000)
[63518.930337] Stack: c014653b d3a044d8 00000246 f74d8ba8 c01b123f e2d71cb4 c0168845 f74d8ba8 
[63518.930337]        00000246 00000000 00000246 00000000 00001000 d3a04604 c6070730 00000000 
[63518.930337]        e2d71cd4 c01b1258 00001000 f88b7035 00000000 00001000 e2d71cf8 f88b8086 
[63518.930337] Call Trace:
[63518.930337]  [<c014653b>] ? trace_hardirqs_on+0xb/0xd
[63518.930337]  [<c01b123f>] ? block_prepare_write+0x5/0x36
[63518.930337]  [<c0168845>] ? ftrace_record_ip+0x1b3/0x1cc
[63518.930337]  [<c01b1258>] ? block_prepare_write+0x1e/0x36
[63518.930337]  [<f88b7035>] ? ext4_normal_get_block_write+0x0/0x53 [ext4dev]
[63518.930337]  [<f88b8086>] ? ext4_da_writepage+0x89/0x138 [ext4dev]
[63518.930337]  [<f88b7035>] ? ext4_normal_get_block_write+0x0/0x53 [ext4dev]
[63518.930337]  [<f88b61cc>] ? mpage_da_submit_io+0x7a/0xab [ext4dev]
[63518.930337]  [<f88b62ca>] ? __mpage_da_writepage+0x3c/0x171 [ext4dev]
[63518.930337]  [<c01463fc>] ? mark_held_locks+0x45/0x5c
[63518.930337]  [<c014653b>] ? trace_hardirqs_on+0xb/0xd
[63518.930337]  [<c01464fb>] ? trace_hardirqs_on_caller+0xe8/0x11d
[63518.930337]  [<c014653b>] ? trace_hardirqs_on+0xb/0xd
[63518.930337]  [<c0173720>] ? write_cache_pages+0x155/0x261
[63518.930337]  [<f88b628e>] ? __mpage_da_writepage+0x0/0x171 [ext4dev]
[63518.930337]  [<f885d733>] ? jbd2_journal_start+0xce/0xf2 [jbd2]
[63518.930337]  [<f88b8773>] ? ext4_da_writepages+0x186/0x23f [ext4dev]
[63518.930337]  [<c01089e0>] ? native_sched_clock+0x97/0xb5
[63518.930337]  [<c0108768>] ? sched_clock+0xb/0x1c
[63518.930337]  [<c0144908>] ? lock_release_holdtime+0x43/0x48
[63518.930337]  [<f88b9260>] ? ext4_da_get_block_write+0x0/0x13e [ext4dev]
[63518.930337]  [<f88b85ed>] ? ext4_da_writepages+0x0/0x23f [ext4dev]
[63518.930337]  [<c0173880>] ? do_writepages+0x28/0x39
[63518.930337]  [<c01abcaf>] ? __writeback_single_inode+0x130/0x222
[63518.930337]  [<c01ac0b3>] ? generic_sync_sb_inodes+0x195/0x25f
[63518.930337]  [<c01ac18a>] ? sync_sb_inodes+0xd/0xf
[63518.930337]  [<c01ac204>] ? sync_inodes_sb+0x78/0x80
[63518.930337]  [<c01ac267>] ? __sync_inodes+0x5b/0xa1
[63518.930337]  [<c01ac2c6>] ? sync_inodes+0x19/0x31
[63518.930337]  [<c01ae847>] ? do_sync+0x19/0x5f
[63518.930337]  [<c01ae89f>] ? sys_sync+0x12/0x17
[63518.930337]  [<c0103a63>] ? sysenter_do_call+0x12/0x3f
[63518.930337]  =======================
[63518.930337] Code: ff 8d 65 f4 89 f0 5b 5e 5f 5d c3 55 89 e5 57 56 53 83 ec 34 0f 1f 44 00 00 89 45 c4 89 d0 89 d6 89 cf e8 21 dd ff ff 85 c0 75 04 <0f> 0b eb fe 81 ff 00 10 00 00 76 04 0f 0b eb fe 81 7d 08 00 10 
[63518.930337] EIP: [<c01b0fa9>] __block_prepare_write+0x20/0x2b1 SS:ESP 0068:e2d71c7c
[63518.931648] ---[ end trace fa5a90ec7832f4fc ]---
