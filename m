From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 22212] New: Crash in ext4_init_io_end
Date: Sat, 6 Nov 2010 19:58:16 GMT
Message-ID: <bug-22212-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:52789 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab0KFT6R (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 6 Nov 2010 15:58:17 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id oA6JwG3u004205
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 6 Nov 2010 19:58:16 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=22212

           Summary: Crash in ext4_init_io_end
           Product: File System
           Version: 2.5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: sgh@sgh.dk
        Regression: No


Today I got this crash.

I was doing some web surfing, kde-compilation, and  a dd if=/dev/zero
of=/dev/sdb

[ 7746.726096] ------------[ cut here ]------------
[ 7746.726107] kernel BUG at /home/kernel-ppa/COD/linux/fs/ext4/page-io.c:146!
[ 7746.726112] invalid opcode: 0000 [#1] SMP 
[ 7746.726117] last sysfs file:
/sys/devices/LNXSYSTM:00/device:00/PNP0A03:00/PNP0C0A:00/power_supply/BAT0/energy_full
[ 7746.726121] Modules linked in: btrfs zlib_deflate crc32c libcrc32c ufs qnx4
hfsplus hfs minix ntfs vfat msdos fat jfs xfs exportfs reiserfs usb_storage
aes_i586 aes_generic binfmt_misc parport_pc ppdev snd_hda_codec_realtek
nvidia(P) snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_seq_midi arc4
snd_rawmidi snd_seq_midi_event ath5k ath joydev snd_seq mac80211 snd_timer
snd_seq_device cfg80211 snd tcp_veno asus_laptop usbhid sparse_keymap soundcore
snd_page_alloc k8temp led_class hid lp agpgart psmouse video output i2c_nforce2
serio_raw shpchp parport sata_nv pata_amd forcedeth
[ 7746.726183] 
[ 7746.726188] Pid: 19858, comm: c++ Tainted: P           
2.6.37-020637rc1-generic #201011020905 Easy Note_MX51/Easy Note_MX51
[ 7746.726194] EIP: 0060:[<c02af978>] EFLAGS: 00010246 CPU: 1
[ 7746.726202] EIP is at ext4_init_io_end+0x58/0x60
[ 7746.726206] EAX: 00000000 EBX: e9449b00 ECX: 00000000 EDX: 0000c1c1
[ 7746.726210] ESI: e8584ec8 EDI: ed3bf968 EBP: e8ef3bd4 ESP: e8ef3bcc
[ 7746.726214]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 7746.726218] Process c++ (pid: 19858, ti=e8ef2000 task=f701bf20
task.ti=e8ef2000)
[ 7746.726221] Stack:
[ 7746.726223]  00000080 00000000 e8ef3bf8 c02af9ba e8ef3e64 e8584ec8 e8ef3d00
f6aa15c0
[ 7746.726232]  e8ef3d00 00000000 ed3bf968 e8ef3c20 c02afbc5 ed3bf968 00000050
c02b0140
[ 7746.726241]  e8584ec8 e43ea828 ed3bf968 00000000 f6aa15c0 e8ef3c58 c02b01f7
e8ef3e64
[ 7746.726250] Call Trace:
[ 7746.726256]  [<c02af9ba>] ? io_submit_init+0x3a/0xf0
[ 7746.726262]  [<c02afbc5>] ? io_submit_add_bh+0x155/0x160
[ 7746.726266]  [<c02b0140>] ? ext4_bio_write_page+0x50/0x150
[ 7746.726271]  [<c02b01f7>] ? ext4_bio_write_page+0x107/0x150
[ 7746.726277]  [<c01ec247>] ? pagevec_lookup+0x27/0x40
[ 7746.726282]  [<c02abbf0>] ? mpage_da_submit_io+0x3f0/0x4d0
[ 7746.726288]  [<c02ae094>] ? mpage_da_map_and_submit+0x244/0x4a0
[ 7746.726294]  [<c02ae9fc>] ? ext4_da_writepages+0x27c/0x530
[ 7746.726300]  [<c0233b1f>] ? pollwake+0x2f/0x40
[ 7746.726307]  [<c0138b08>] ? __wake_up_common+0x48/0x70
[ 7746.726313]  [<c02ae780>] ? ext4_da_writepages+0x0/0x530
[ 7746.726318]  [<c01eb722>] ? do_writepages+0x22/0x40
[ 7746.726324]  [<c01e34eb>] ? __filemap_fdatawrite_range+0x6b/0x80
[ 7746.726330]  [<c01e378b>] ? filemap_fdatawrite_range+0x2b/0x40
[ 7746.726337]  [<c02e2346>] ? jbd2_journal_begin_ordered_truncate+0x86/0xa0
[ 7746.726342]  [<c02ad0eb>] ? ext4_evict_inode+0x1ab/0x2b0
[ 7746.726347]  [<c02382bf>] ? evict+0x1f/0xa0
[ 7746.726352]  [<c0238ed4>] ? iput_final+0x104/0x190
[ 7746.726356]  [<c0238f95>] ? iput+0x35/0x40
[ 7746.726361]  [<c0230c19>] ? do_unlinkat+0xc9/0x150
[ 7746.726367]  [<c01b8180>] ? cmd_attr_register_cpumask+0x10/0x40
[ 7746.726373]  [<c0230cb5>] ? sys_unlink+0x15/0x20
[ 7746.726378]  [<c0102d5f>] ? sysenter_do_call+0x12/0x28
[ 7746.726381] Code: f8 ff 85 c0 89 43 08 74 22 8d 43 24 c7 43 20 00 09 00 00
89 43 24 89 43 28 c7 43 2c 10 fd 2a c0 89 1b 89 5b 04 89 d8 5b 5e 5d c3 <0f> 0b
eb fe 8d 74 26 00 55 89 e5 57 56 53 83 ec 10 3e 8d 74 26 
[ 7746.726428] EIP: [<c02af978>] ext4_init_io_end+0x58/0x60 SS:ESP
0068:e8ef3bcc
[ 7746.726437] ---[ end trace adb78f0bf54f2690 ]-

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
