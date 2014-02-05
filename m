From: Lenz Weber <mail@lenzw.de>
Subject: ext4 stops responding, need help debugging (kernel oops 5 in utf8s_to_utf16s)
Date: Wed, 05 Feb 2014 12:44:26 +0100
Message-ID: <52F2241A.3010804@lenzw.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000106010807040307090800"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from umask.pw ([109.239.58.173]:50231 "EHLO
	j31018.servers.jiffybox.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751120AbaBELvP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Feb 2014 06:51:15 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by j31018.servers.jiffybox.net (Postfix) with ESMTP id 07BA31E96
	for <linux-ext4@vger.kernel.org>; Wed,  5 Feb 2014 12:44:31 +0100 (CET)
Received: from j31018.servers.jiffybox.net ([127.0.0.1])
	by localhost (j31018.servers.jiffybox.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1Kb3UNXlCcby for <linux-ext4@vger.kernel.org>;
	Wed,  5 Feb 2014 12:44:29 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000106010807040307090800
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Hello everyone,
I have a NAS with an ext4 filesystem that I access using NFSv4. From
time to time (about once in a month), the the ext4 driver crashes and I
can't access the file system in any way until I reboot.

As I have no further experience in filesystems, maybe you can help me.
The system is currently in "blocked" state, so I can do any experiments
you ask me to if you need more data.

For starters, I am attaching a dmesg output, maybe this already gives
you an idea on what might be wrong.

Mount flags are
"rw,usrjquota=aquota.user,jqfmt=vfsv0,user_xattr,data=ordered,delalloc,noacl"

Kernel is
Linux QNAPBackup 2.6.33.2 #1 Fri Jul 26 11:32:35 CST 2013 armv5tel unknown

I have already asked in the manufacturer's forum (
http://forum.qnap.com/viewtopic.php?f=25&t=88179&p=397077#p387790 ), but
got no reply there in over a month, so I'm counting on your help

Regards,
Lenz Weber

--------------000106010807040307090800
Content-Type: text/plain; charset=windows-1252;
 name="ext4-dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ext4-dmesg.txt"

[646315.290000] Unable to handle kernel paging request at virtual address d0000000
[646315.300000] pgd = cb2a4000
[646315.300000] [d0000000] *pgd=00000000
[646315.310000] Internal error: Oops: 5 [#1]
[646315.310000] last sysfs file: /sys/class/net/eth0/mtu
[646315.310000] Modules linked in: fbdisk iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi uvcvideo v4l2_common videodev v4l1_compat v4l2_int_device snd_usb_caiaq snd_usb_audio hid_logitech snd_usb_lib snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_oss snd_seq_midi snd_seq_midi_event snd_seq snd_rawmidi snd_page_alloc snd_seq_device snd_timer snd soundcore mac80211 cfg80211 lib80211 fnotify(P) smbfs etxhci_hcd cifs nfs udf isofs ufsd(P) ext4 jbd2 sysinfo usblp usbhid cryptodev mv_cesa sha512_generic sha256_generic sha1_generic aes_generic dm_crypt dm_mod raid456 async_raid6_recov async_pq async_xor async_memcpy async_tx raid6_pq xor nls_utf8 nls_iso8859_2 nls_cp850 nls_cp437 vfat fat appletalk psnap llc hal_netlink ehci_hcd hid ext3 jbd [last unloaded: fbdisk]
[646315.310000] CPU: 0 Tainted: P (2.6.33.2 #1)
[646315.310000] PC is at utf8s_to_utf16s+0x38/0xc0
[646315.310000] LR is at do_case_folding_transform+0x50/0xbc
[646315.310000] pc : [<c0161018>] lr : [<c00d12e4>] psr: 60000013
[646315.310000] sp : cb33dae0 ip : cb33db08 fp : cb33db04
[646315.310000] r10: cb33db49 r9 : 00001000 r8 : 000000ff
[646315.310000] r7 : c0430010 r6 : d0000000 r5 : 00000000 r4 : c0430020
[646315.310000] r3 : 00000047 r2 : c0430010 r1 : 00000008 r0 : cffffff8
[646315.310000] Flags: nZCv IRQs on FIQs on Mode SVC_32 ISA ARM Segment kernel
[646315.310000] Control: 0005397f Table: 0b2a4000 DAC: 00000017
[646315.310000] Process nfsd (pid: 29399, stack limit = 0xcb33c270)
[646315.310000] Stack: (0xcb33dae0 to 0xcb33e000)
[646315.310000] dae0: c0430010 00000008 c0430010 00000008 c041000c cffffff8 cb33db34 cb33db08
[646315.310000] db00: c00d12e4 c0160ff0 000000fe cb33db49 00000008 cb33db49 cffffff8 cffffff0
[646315.310000] db20: cffff000 cb33ddb4 cb33dca4 cb33db38 bf197b30 c00d12a4 cb33db64 cb33dcf0
[646315.310000] db40: c00c2230 c2bf8c88 33333400 504a2e31 cb000047 c649f160 cb33db8c cb33db68
[646315.310000] db60: bf16d240 bf16d020 cc924260 cb13e000 c649f160 bf1ae770 c649f160 cb33dd00
[646315.310000] db80: cb33dba4 cb33db90 bf16ef18 bf16d1c0 ca3d6368 c2bf8c88 cb33dbcc cb33dba8
[646315.310000] dba0: c2bf8c88 00000002 cb33dbcc cb33dbb8 c007abe4 c007ab94 ca3d6368 c49e1b88
[646315.310000] dbc0: cb33dbdc cb33dbd0 00000000 c49e1b88 cac20508 00000002 cb33dbfc cb33dbe8
[646315.310000] dbe0: cde0d078 c03e46c8 cb33dc1c cb33dbf8 c007f500 c005a358 c0ce601c cb0b00e0
[646315.310000] dc00: 00000017 cde0d040 c03e4698 c030de18 cb33dc34 cb33dc20 c007f590 c007f4bc
[646315.310000] dc20: 00000000 cb33dc30 cb33dc4c cb33dc38 c007f5b8 c007f584 cb0b00e0 00000000
[646315.310000] dc40: cb33dc7c cb33dc50 34333331 2e4a5047 08080808 08080808 08080808 08080808
[646315.310000] dc60: 08080808 08080808 f3504761 be91d773 79081140 97e5e7b0 c0061fa4 cffffff0
[646315.310000] dc80: c8f32000 cb33dcf0 cffffff0 cffff000 00001000 cb33ddb4 cb33dd34 cb33dca8
[646315.310000] dca0: bf18ec30 bf197a8c 08080808 cb33dd8c c649f160 ca3d6368 c8f32000 cffffff0
[646315.310000] dcc0: 00000008 c2bf8c88 cffffff0 c8f31950 cffff000 c8f31000 bf18da34 00000001
[646315.310000] dce0: 000000d6 d0000000 00000013 cac96ae0 be91d772 79081140 00000004 cdc78280
[646315.310000] dd00: 00000000 00000076 bf1a0804 00000075 cb33dd8c c649f160 ca3d6368 cebd2b18
[646315.310000] dd20: ffffffe4 c649f0d8 cb33ddf4 cb33dd38 bf18f818 bf18ea84 cb33dda4 cb33ddb8
[646315.310000] dd40: ced3d620 cb33dd8c cac96ae0 cb0f3000 00001000 c6971020 c0e6d0a0 ced3d620
[646315.310000] dd60: cb33dd8c cb33c000 ca3d6368 c69712d8 cb13e000 0000002b cac96ae0 bf176124
[646315.310000] dd80: cb33ddb4 cb33dd90 bf16e0bc cac20508 c6971020 c69712d8 c649f160 cebd2b18
[646315.310000] dda0: 0000002b bedddf82 23a65a57 00000004 cdc78280 c2adff48 ffffffe4 cb33ddfc
[646315.310000] ddc0: cb33ddf4 cb33ddd0 c0069f30 cac96ae0 ca3d6368 c649f160 cebd2b18 ca3d6368
[646315.310000] dde0: cac96ae0 cac96b5c cb33de2c cb33ddf8 bf19047c bf18f058 c00cf250 52aea58d
[646315.310000] de00: 247c981c 00000000 cebd2b18 00000000 cac96ae0 cebd2b18 c649f160 cebd2c98
[646315.310000] de20: cb33de5c cb33de30 c00d4e8c bf1903e8 00000008 cb1d10a0 cebd2c98 cca23408
[646315.310000] de40: 00000000 00000008 cb1d10a0 c649f160 cb33def4 cb33de60 c0138300 c00d4d9c
[646315.310000] de60: c005fccc c0061e44 00000000 60000013 cce20a60 cce0a000 cb33deb4 c1443398
[646315.310000] de80: cec5d000 cebd2b18 c0e82f20 c044a9cc 52aea5a5 c0e82f20 52aea52d fffffffe
[646315.310000] dea0: cec5dd7c 52aea5a5 c0e82f20 52aea52d 52aea5a5 c0e82f20 cb33def4 cb33dec8
[646315.310000] dec0: c02f7024 c0197dfc 00000002 cca23408 c0ca1000 cca23400 cca23520 c0ca1118
[646315.310000] dee0: cc935000 cec5d000 cb33df24 cb33def8 c013e600 c0138148 cca23520 cec5d000
[646315.310000] df00: cec5d000 c03eb3fc 0000001c c044de30 cc935018 cc935000 cb33df4c cb33df28
[646315.310000] df20: c0131050 c013e570 cec5d000 c03eb3fc c03eb1c8 c0130f90 cc830740 c044de28
[646315.310000] df40: cb33df9c cb33df50 c02ed86c c0130fa0 00057e40 cc830740 fffffff5 00000018
[646315.310000] df60: 0000021c cc935018 00100100 01000000 cb33df8c 000000a8 cec5d000 cb33c000
[646315.310000] df80: 00000000 c0432948 00000000 00000000 cb33dfc4 cb33dfa0 c0131590 c02ed33c
[646315.310000] dfa0: c0ea7de8 cec5d000 c01314d0 00000000 00000000 00000000 cb33dff4 cb33dfc8
[646315.310000] dfc0: c007a98c c01314e0 00000000 00000000 cb33dfd0 cb33dfd0 00000000 00000000
[646315.310000] dfe0: 00000000 00000000 00000000 cb33dff8 c0068604 c007a914 00000000 00000000
[646315.310000] Backtrace:
[646315.310000] [<c0160fe0>] (utf8s_to_utf16s+0x0/0xc0) from [<c00d12e4>] (do_case_folding_transform+0x50/0xbc)
[646315.310000] r7:cffffff8 r6:c041000c r5:00000008 r4:c0430010
[646315.310000] [<c00d1294>] (do_case_folding_transform+0x0/0xbc) from [<bf197b30>] (ext4fs_dirhash+0xb4/0x2fc [ext4])
[646315.310000] [<bf197a7c>] (ext4fs_dirhash+0x0/0x2fc [ext4]) from [<bf18ec30>] (do_split+0x1bc/0x5d4 [ext4])
[646315.310000] [<bf18ea74>] (do_split+0x0/0x5d4 [ext4]) from [<bf18f818>] (ext4_add_entry+0x7d0/0x8cc [ext4])
[646315.310000] [<bf18f048>] (ext4_add_entry+0x0/0x8cc [ext4]) from [<bf19047c>] (ext4_link+0xa4/0x1a8 [ext4])
[646315.310000] [<bf1903d8>] (ext4_link+0x0/0x1a8 [ext4]) from [<c00d4e8c>] (vfs_link_without_acl+0x100/0x1c0)
[646315.310000] r8:cebd2c98 r7:c649f160 r6:cebd2b18 r5:cac96ae0 r4:00000000
[646315.310000] [<c00d4d8c>] (vfs_link_without_acl+0x0/0x1c0) from [<c0138300>] (nfsd_link+0x1c8/0x304)
[646315.310000] [<c0138138>] (nfsd_link+0x0/0x304) from [<c013e600>] (nfsd3_proc_link+0xa0/0x120)
[646315.310000] [<c013e560>] (nfsd3_proc_link+0x0/0x120) from [<c0131050>] (nfsd_dispatch+0xc0/0x210)
[646315.310000] [<c0130f90>] (nfsd_dispatch+0x0/0x210) from [<c02ed86c>] (svc_process+0x540/0x858)
[646315.310000] [<c02ed32c>] (svc_process+0x0/0x858) from [<c0131590>] (nfsd+0xc0/0x168)
[646315.310000] [<c01314d0>] (nfsd+0x0/0x168) from [<c007a98c>] (kthread+0x88/0x90)
[646315.310000] r9:00000000 r8:00000000 r7:00000000 r6:c01314d0 r5:cec5d000
[646315.310000] r4:c0ea7de8
[646315.310000] [<c007a904>] (kthread+0x0/0x90) from [<c0068604>] (do_exit+0x0/0x69c)
[646315.310000] r6:00000000 r5:00000000 r4:00000000
[646315.310000] Code: 1a00000a e0c430b2 e2866001 e2455001 (e5d63000)
[646315.320000] ---[ end trace a3712c2317b802f3 ]---
--------------000106010807040307090800--
