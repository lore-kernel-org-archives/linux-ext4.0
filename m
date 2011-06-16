From: Norbert Preining <preining@logic.at>
Subject: Re: another ext3 kernel BUG
Date: Thu, 16 Jun 2011 17:28:48 +0900
Message-ID: <20110616082848.GA1458@gamma.logic.tuwien.ac.at>
References: <20110614024307.GA3039@gamma.logic.tuwien.ac.at> <20110614032111.GA5392@redhat.com> <4DF6D644.3010109@redhat.com> <20110611021732.GA18768@gamma.logic.tuwien.ac.at> <20110614011904.GA32521@gamma.logic.tuwien.ac.at> <4DF6C541.5050805@redhat.com> <20110616055125.GB23083@gamma.logic.tuwien.ac.at> <4DF9AAA1.5030002@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Dave Jones <davej@redhat.com>, Eric Sandeen <sandeen@redhat.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: =?iso-8859-15?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:34913 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab1FPI2x (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Jun 2011 04:28:53 -0400
Content-Disposition: inline
In-Reply-To: <4DF9AAA1.5030002@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Do, 16 Jun 2011, T=F6r=F6k Edwin wrote:
> e6bc45d65df8599fdbae73be9cec4ceed274db53
>=20
> See here for a patch:
> https://lkml.org/lkml/2011/6/15/341
>=20
> Does that help?

Well, at least that is gone, but I am not sure. I am hit by
yet another bug (probably crappy hardware?):=20

Thee external USB disk disconnects suddenly while saving big stuff
onto it (unison sync). Then the kernel hangs (that is something
that should NOT happen!), here is the log.

It is easy to see:-
- external disk plugged
- for some time working
- suddenly disconnected
- kernel goes into "I hang myself" mode


Jun 16 17:13:44 mithrandir kernel: [  171.640096] usb 2-3: new high spe=
ed USB device number 3 using ehci_hcd
Jun 16 17:13:44 mithrandir kernel: [  171.773558] usb 2-3: New USB devi=
ce found, idVendor=3D0411, idProduct=3D0108
Jun 16 17:13:44 mithrandir kernel: [  171.773568] usb 2-3: New USB devi=
ce strings: Mfr=3D1, Product=3D2, SerialNumber=3D3
Jun 16 17:13:44 mithrandir kernel: [  171.773575] usb 2-3: Product: USB=
-SATA Bridge
Jun 16 17:13:44 mithrandir kernel: [  171.773580] usb 2-3: Manufacturer=
: BUFFALO
Jun 16 17:13:44 mithrandir kernel: [  171.773586] usb 2-3: SerialNumber=
: 00000002022EAA7
Jun 16 17:13:44 mithrandir kernel: [  172.071498] Initializing USB Mass=
 Storage driver...
Jun 16 17:13:44 mithrandir kernel: [  172.071707] scsi6 : usb-storage 2=
-3:1.0
Jun 16 17:13:44 mithrandir kernel: [  172.071827] usbcore: registered n=
ew interface driver usb-storage
Jun 16 17:13:44 mithrandir kernel: [  172.071829] USB Mass Storage supp=
ort registered.
Jun 16 17:13:45 mithrandir kernel: [  173.068809] scsi 6:0:0:0: Direct-=
Access     BUFFALO  External HDD     0000 PQ: 0 ANSI: 3
Jun 16 17:13:45 mithrandir kernel: [  173.069248] sd 6:0:0:0: Attached =
scsi generic sg2 type 0
Jun 16 17:13:53 mithrandir kernel: [  180.691341] sd 6:0:0:0: [sdb] 293=
0277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
Jun 16 17:13:53 mithrandir kernel: [  180.692296] sd 6:0:0:0: [sdb] Wri=
te Protect is off
Jun 16 17:13:53 mithrandir kernel: [  180.692306] sd 6:0:0:0: [sdb] Mod=
e Sense: 3b 00 00 00
Jun 16 17:13:53 mithrandir kernel: [  180.693183] sd 6:0:0:0: [sdb] Wri=
te cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jun 16 17:13:53 mithrandir kernel: [  180.716119]  sdb: sdb1
Jun 16 17:13:53 mithrandir kernel: [  180.718780] sd 6:0:0:0: [sdb] Att=
ached SCSI disk
Jun 16 17:13:53 mithrandir ata_id[4035]: HDIO_GET_IDENTITY failed for '=
/dev/.tmp-block-8:16'
Jun 16 17:13:53 mithrandir kernel: [  181.011546] device fsid 70f41f7e-=
6f28-416e-a263-8c214138822a devid 1 transid 5690 /dev/sdb1
Jun 16 17:15:47 mithrandir kernel: [  295.086699] usb 2-3: USB disconne=
ct, device number 3
Jun 16 17:15:47 mithrandir kernel: [  295.090546] sd 6:0:0:0: [sdb] Unh=
andled error code
Jun 16 17:15:47 mithrandir kernel: [  295.090550] sd 6:0:0:0: [sdb]  Re=
sult: hostbyte=3D0x01 driverbyte=3D0x00
Jun 16 17:15:47 mithrandir kernel: [  295.090553] sd 6:0:0:0: [sdb] CDB=
: cdb[0]=3D0x28: 28 00 7d c5 eb 0f 00 00 f0 00
Jun 16 17:15:47 mithrandir kernel: [  295.090561] end_request: I/O erro=
r, dev sdb, sector 2110122767
Jun 16 17:15:47 mithrandir kernel: [  295.090644] sd 6:0:0:0: [sdb] Unh=
andled error code
Jun 16 17:15:47 mithrandir kernel: [  295.090646] sd 6:0:0:0: [sdb]  Re=
sult: hostbyte=3D0x01 driverbyte=3D0x00
Jun 16 17:15:47 mithrandir kernel: [  295.090649] sd 6:0:0:0: [sdb] CDB=
: cdb[0]=3D0x28: 28 00 7d c5 eb ff 00 00 f0 00
Jun 16 17:15:47 mithrandir kernel: [  295.090656] end_request: I/O erro=
r, dev sdb, sector 2110123007
Jun 16 17:15:47 mithrandir kernel: [  295.092072] btrfs no csum found f=
or inode 321896 start 164225024

32 of those btrfs no csum found ... messages

Jun 16 17:15:47 mithrandir kernel: [  295.096114] sd 6:0:0:0: [sdb] Syn=
chronizing SCSI cache
Jun 16 17:15:47 mithrandir kernel: [  295.096146] sd 6:0:0:0: [sdb]  Re=
sult: hostbyte=3D0x01 driverbyte=3D0x00
Jun 16 17:15:47 mithrandir kernel: [  295.096336] scsi: killing request=
s for dead queue
Jun 16 17:15:47 mithrandir kernel: [  295.096341] btrfs no csum found f=
or inode 321896 start 164360192

about 1000 more of these btrfs no csum found ... messages

Jun 16 17:15:47 mithrandir kernel: [  295.336045] usb 2-3: new high spe=
ed USB device number 4 using ehci_hcd
Jun 16 17:15:47 mithrandir mtp-probe: checking bus 2, device 4: "/sys/d=
evices/pci0000:00/0000:00:1d.7/usb2/2-3"
Jun 16 17:15:47 mithrandir kernel: [  295.469291] usb 2-3: New USB devi=
ce found, idVendor=3D0411, idProduct=3D0108
Jun 16 17:15:47 mithrandir kernel: [  295.469294] usb 2-3: New USB devi=
ce strings: Mfr=3D1, Product=3D2, SerialNumber=3D3
Jun 16 17:15:47 mithrandir kernel: [  295.469297] usb 2-3: Product: USB=
-SATA Bridge
Jun 16 17:15:47 mithrandir kernel: [  295.469298] usb 2-3: Manufacturer=
: BUFFALO
Jun 16 17:15:47 mithrandir kernel: [  295.469300] usb 2-3: SerialNumber=
: 00000002022EAA7
Jun 16 17:15:47 mithrandir kernel: [  295.469642] scsi7 : usb-storage 2=
-3:1.0
Jun 16 17:15:48 mithrandir mtp-probe: bus: 2, device: 4 was not an MTP =
device
Jun 16 17:15:48 mithrandir kernel: [  296.468835] scsi 7:0:0:0: Direct-=
Access     BUFFALO  External HDD     0000 PQ: 0 ANSI: 3
Jun 16 17:15:48 mithrandir kernel: [  296.469273] sd 7:0:0:0: Attached =
scsi generic sg2 type 0
Jun 16 17:15:48 mithrandir kernel: [  296.470286] sd 7:0:0:0: [sdc] 293=
0277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
Jun 16 17:15:48 mithrandir kernel: [  296.471147] sd 7:0:0:0: [sdc] Wri=
te Protect is off
Jun 16 17:15:48 mithrandir kernel: [  296.471157] sd 7:0:0:0: [sdc] Mod=
e Sense: 3b 00 00 00
Jun 16 17:15:48 mithrandir kernel: [  296.472002] sd 7:0:0:0: [sdc] Wri=
te cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jun 16 17:15:48 mithrandir kernel: [  296.480261]  sdc: sdc1
Jun 16 17:15:48 mithrandir kernel: [  296.483125] sd 7:0:0:0: [sdc] Att=
ached SCSI disk
Jun 16 17:15:48 mithrandir ata_id[4160]: HDIO_GET_IDENTITY failed for '=
/dev/.tmp-block-8:32'
Jun 16 17:15:49 mithrandir kernel: [  296.601221] lost page write due t=
o I/O error on sdb1
Jun 16 17:15:49 mithrandir kernel: [  296.601245] lost page write due t=
o I/O error on sdb1
Jun 16 17:15:49 mithrandir kernel: [  296.601260] lost page write due t=
o I/O error on sdb1
Jun 16 17:15:49 mithrandir kernel: [  296.601263] btrfs: 1 errors while=
 writing supers
Jun 16 17:15:49 mithrandir kernel: [  296.601283] ------------[ cut her=
e ]------------
Jun 16 17:15:49 mithrandir kernel: [  296.601312] kernel BUG at fs/btrf=
s/disk-io.c:2360!
Jun 16 17:15:49 mithrandir kernel: [  296.601337] invalid opcode: 0000 =
[#1] PREEMPT SMP=20
Jun 16 17:15:49 mithrandir kernel: [  296.601369] CPU 0=20
Jun 16 17:15:49 mithrandir kernel: [  296.601381] Modules linked in: us=
b_storage rfcomm bnep snd_hrtimer binfmt_misc dm_crypt dm_mod isofs btr=
fs zlib_deflate crc32c libcrc32c vfat fat fuse loop uinput hso snd_hda_=
codec_realtek btusb bluetooth crc16 snd_hda_intel snd_hda_codec snd_hwd=
ep snd_pcm_oss snd_mixer_oss snd_pcm arc4 snd_seq_dummy snd_seq_oss snd=
_seq_midi snd_rawmidi mxm_wmi snd_seq_midi_event snd_seq snd_timer snd_=
seq_device joydev firewire_ohci firewire_core crc_itu_t snd tpm_infineo=
n sony_laptop iwlagn mac80211 cfg80211 rfkill soundcore snd_page_alloc
Jun 16 17:15:49 mithrandir kernel: [  296.601724]=20
Jun 16 17:15:49 mithrandir kernel: [  296.601734] Pid: 4169, comm: sync=
 Not tainted 3.0.0-rc3+ #3 Sony Corporation VGN-Z11VN_B/VAIO
Jun 16 17:15:49 mithrandir kernel: [  296.601781] RIP: 0010:[<ffffffffa=
023ca5d>]  [<ffffffffa023ca5d>] write_all_supers+0x224/0x237 [btrfs]
Jun 16 17:15:49 mithrandir kernel: [  296.601840] RSP: 0018:ffff88008e5=
c3dc8  EFLAGS: 00010296
Jun 16 17:15:49 mithrandir kernel: [  296.601867] RAX: 000000000000003a=
 RBX: ffff8801202f7970 RCX: 0000000000000002
Jun 16 17:15:49 mithrandir kernel: [  296.601901] RDX: 000000000000e0e0=
 RSI: ffff88008e5c2000 RDI: ffff88008e5c2000
Jun 16 17:15:49 mithrandir kernel: [  296.601935] RBP: ffff88008e5c3e28=
 R08: 0000000000000002 R09: ffff88010e5c3ced
Jun 16 17:15:49 mithrandir kernel: [  296.601968] R10: ffff88010e5c3ced=
 R11: 0000000000000000 R12: 0000000000000001
Jun 16 17:15:49 mithrandir kernel: [  296.602001] R13: ffff8801202f7900=
 R14: ffff88012c904000 R15: 0000000000000000
Jun 16 17:15:49 mithrandir kernel: [  296.602035] FS:  00007ffebdb25700=
(0000) GS:ffff88013fc00000(0000) knlGS:0000000000000000
Jun 16 17:15:49 mithrandir kernel: [  296.602074] CS:  0010 DS: 0000 ES=
: 0000 CR0: 000000008005003b
Jun 16 17:15:49 mithrandir kernel: [  296.602102] CR2: 00007fecbc7cae02=
 CR3: 000000008e60d000 CR4: 00000000000006f0
Jun 16 17:15:49 mithrandir kernel: [  296.602136] DR0: 0000000000000000=
 DR1: 0000000000000000 DR2: 0000000000000000
Jun 16 17:15:49 mithrandir kernel: [  296.602169] DR3: 0000000000000000=
 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jun 16 17:15:49 mithrandir kernel: [  296.602203] Process sync (pid: 41=
69, threadinfo ffff88008e5c2000, task ffff88008e6467b0)
Jun 16 17:15:49 mithrandir kernel: [  296.602242] Stack:
Jun 16 17:15:49 mithrandir kernel: [  296.602254]  0000000011e70000 fff=
f8801202f7970 ffff880111e70e63 0000000000000001
Jun 16 17:15:49 mithrandir kernel: [  296.602298]  0000000000000000 fff=
f8801202f7970 ffff88008e5c3e28 ffff88012c904000
Jun 16 17:15:49 mithrandir kernel: [  296.602342]  ffff8800b51e8738 fff=
f880106377070 0000000000000000 0000000000000000
Jun 16 17:15:49 mithrandir kernel: [  296.602386] Call Trace:
Jun 16 17:15:49 mithrandir kernel: [  296.602409]  [<ffffffffa023ca7e>]=
 write_ctree_super+0xe/0x10 [btrfs]
Jun 16 17:15:49 mithrandir kernel: [  296.602449]  [<ffffffffa0240b93>]=
 btrfs_commit_transaction+0x54e/0x64e [btrfs]
Jun 16 17:15:49 mithrandir kernel: [  296.602488]  [<ffffffff81047fb2>]=
 ? remove_wait_queue+0x35/0x35
Jun 16 17:15:49 mithrandir kernel: [  296.602518]  [<ffffffff810d02a6>]=
 ? __sync_filesystem+0x72/0x72
Jun 16 17:15:49 mithrandir kernel: [  296.602551]  [<ffffffffa0225bd5>]=
 btrfs_sync_fs+0x62/0x66 [btrfs]
Jun 16 17:15:49 mithrandir kernel: [  296.602581]  [<ffffffff810d0292>]=
 __sync_filesystem+0x5e/0x72
Jun 16 17:15:49 mithrandir kernel: [  296.602610]  [<ffffffff810d02b7>]=
 sync_one_sb+0x11/0x13
Jun 16 17:15:49 mithrandir kernel: [  296.602637]  [<ffffffff810b3c39>]=
 iterate_supers+0x6a/0xbf
Jun 16 17:15:49 mithrandir kernel: [  296.602665]  [<ffffffff810d033e>]=
 sys_sync+0x3d/0x4f
Jun 16 17:15:49 mithrandir kernel: [  296.602692]  [<ffffffff8139b5fb>]=
 system_call_fastpath+0x16/0x1b
Jun 16 17:15:49 mithrandir kernel: [  296.602721] Code: 20 01 00 00 48 =
8b b8 28 23 00 00 48 83 c7 50 e8 31 d3 15 e1 44 3b 65 bc 7e 13 44 89 e6=
 48 c7 c7 5c 00 28 a0 31 c0 e8 19 6e 15 e1 <0f> 0b 48 83 c4 38 31 c0 5b=
 41 5c 41 5d 41 5e 41 5f 5d c3 55 48=20
Jun 16 17:15:49 mithrandir kernel: [  296.602969] RIP  [<ffffffffa023ca=
5d>] write_all_supers+0x224/0x237 [btrfs]
Jun 16 17:15:49 mithrandir kernel: [  296.603014]  RSP <ffff88008e5c3dc=
8>
Jun 16 17:15:49 mithrandir kernel: [  296.616310] ---[ end trace 63d761=
3b609d9a58 ]---
Jun 16 17:15:49 mithrandir kernel: [  296.616361] BUG: unable to handle=
 kernel paging request at 000000000000163e
Jun 16 17:15:49 mithrandir kernel: [  296.618131] IP: [<ffffffff81118ce=
2>] journal_start+0x2f/0xc1
Jun 16 17:15:49 mithrandir kernel: [  296.619909] PGD 0=20
Jun 16 17:15:49 mithrandir kernel: [  296.620003] Oops: 0000 [#2] PREEM=
PT SMP=20
Jun 16 17:15:49 mithrandir kernel: [  296.620003] CPU 0=20
Jun 16 17:15:49 mithrandir kernel: [  296.620003] Modules linked in: us=
b_storage rfcomm bnep snd_hrtimer binfmt_misc dm_crypt dm_mod isofs btr=
fs zlib_deflate crc32c libcrc32c vfat fat fuse loop uinput hso snd_hda_=
codec_realtek btusb bluetooth crc16 snd_hda_intel snd_hda_codec snd_hwd=
ep snd_pcm_oss snd_mixer_oss snd_pcm arc4 snd_seq_dummy snd_seq_oss snd=
_seq_midi snd_rawmidi mxm_wmi snd_seq_midi_event snd_seq snd_timer snd_=
seq_device joydev firewire_ohci firewire_core crc_itu_t snd tpm_infineo=
n sony_laptop iwlagn mac80211 cfg80211 rfkill soundcore snd_page_alloc
Jun 16 17:15:49 mithrandir kernel: [  296.620003]=20
Jun 16 17:15:49 mithrandir kernel: [  296.620003] Pid: 4169, comm: sync=
 Tainted: G      D     3.0.0-rc3+ #3 Sony Corporation VGN-Z11VN_B/VAIO
Jun 16 17:15:49 mithrandir kernel: [  296.620003] RIP: 0010:[<ffffffff8=
1118ce2>]  [<ffffffff81118ce2>] journal_start+0x2f/0xc1
Jun 16 17:15:49 mithrandir kernel: [  296.620003] RSP: 0018:ffff88008e5=
c3698  EFLAGS: 00010282
Jun 16 17:15:49 mithrandir kernel: [  296.620003] RAX: 000000000000163e=
 RBX: ffff8800b51e8738 RCX: 0000000000000003
Jun 16 17:15:49 mithrandir kernel: [  296.620003] RDX: 0000000000000002=
 RSI: 000000000000000e RDI: ffff88013b377000
Jun 16 17:15:49 mithrandir kernel: [  296.620003] RBP: ffff88008e5c36b8=
 R08: ffffea00015b3168 R09: 000000000000000d
Jun 16 17:15:49 mithrandir kernel: [  296.620003] R10: ffffffff814182f0=
 R11: 00000000ffffffff R12: ffff88008e6467b0
Jun 16 17:15:49 mithrandir kernel: [  296.620003] R13: ffff88013b377000=
 R14: 000000000000000e R15: 0000000000000040
Jun 16 17:15:49 mithrandir kernel: [  296.620003] FS:  0000000000000000=
(0000) GS:ffff88013fc00000(0000) knlGS:0000000000000000
Jun 16 17:15:49 mithrandir kernel: [  296.620003] CS:  0010 DS: 0000 ES=
: 0000 CR0: 000000008005003b
Jun 16 17:15:49 mithrandir kernel: [  296.620003] CR2: 000000000000163e=
 CR3: 0000000001617000 CR4: 00000000000006f0
Jun 16 17:15:49 mithrandir kernel: [  296.620003] DR0: 0000000000000000=
 DR1: 0000000000000000 DR2: 0000000000000000
Jun 16 17:15:49 mithrandir kernel: [  296.620003] DR3: 0000000000000000=
 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jun 16 17:15:49 mithrandir kernel: [  296.620003] Process sync (pid: 41=
69, threadinfo ffff88008e5c2000, task ffff88008e6467b0)
Jun 16 17:15:49 mithrandir kernel: [  296.620003] Stack:
Jun 16 17:15:49 mithrandir kernel: [  296.620003]  ffffffffffffffe2 fff=
fea00015b3168 0000000000000000 0000000000000480
Jun 16 17:15:49 mithrandir kernel: [  296.620003]  ffff88008e5c36d8 fff=
fffff81109a1d ffff8801397ef740 ffff8801397ef740
Jun 16 17:15:49 mithrandir kernel: [  296.620003]  ffff88008e5c3768 fff=
fffff811044e4 0000000000000246 ffff88008e5c37f8
Jun 16 17:15:49 mithrandir kernel: [  296.620003] Call Trace:
Jun 16 17:15:49 mithrandir kernel: [  296.620003]  [<ffffffff81109a1d>]=
 ext3_journal_start_sb+0x45/0x50
Jun 16 17:15:49 mithrandir kernel: [  296.620003]  [<ffffffff811044e4>]=
 ext3_write_begin+0x93/0x1a1
Jun 16 17:15:49 mithrandir kernel: [  296.620003]  [<ffffffff81085f9f>]=
 ? get_pageblock_flags_group+0x3c/0x76
Jun 16 17:15:49 mithrandir kernel: [  296.620003]  [<ffffffff81081ece>]=
 generic_file_buffered_write+0xf9/0x236
Jun 16 17:15:49 mithrandir kernel: [  296.620003]  [<ffffffff81036172>]=
 ? current_fs_time+0x32/0x39
Jun 16 17:15:49 mithrandir kernel: [  296.620003]  [<ffffffff81082c87>]=
 __generic_file_aio_write+0x240/0x270
Jun 16 17:15:49 mithrandir kernel: [  296.620003]  [<ffffffff81082d13>]=
 generic_file_aio_write+0x5c/0xb5
Jun 16 17:15:49 mithrandir kernel: [  296.620003]  [<ffffffff810b120e>]=
 do_sync_write+0xba/0xfa
Jun 16 17:15:49 mithrandir kernel: [  296.620003]  [<ffffffff810c7325>]=
 ? vfsmount_lock_local_unlock+0x33/0x3e
Jun 16 17:15:49 mithrandir kernel: [  296.620003]  [<ffffffff8109ac87>]=
 ? remove_vma+0x57/0x5f
Jun 16 17:15:49 mithrandir kernel: [  296.620003]  [<ffffffff8104e577>]=
 ? timekeeping_get_ns+0x12/0x31
Jun 16 17:15:49 mithrandir kernel: [  296.620003]  [<ffffffff81062bc5>]=
 do_acct_process+0x28c/0x2bf
Jun 16 17:15:49 mithrandir kernel: [  296.620003]  [<ffffffff810631bc>]=
 acct_process+0x73/0x8f
Jun 16 17:15:49 mithrandir kernel: [  296.620003]  [<ffffffff81034f0a>]=
 do_exit+0x244/0x698
Jun 16 17:15:49 mithrandir kernel: [  296.620003]  [<ffffffff810334d1>]=
 ? kmsg_dump+0xcb/0xda
Jun 16 17:15:49 mithrandir kernel: [  296.620003]  [<ffffffff81004912>]=
 oops_end+0x89/0x8e
Jun 16 17:15:49 mithrandir kernel: [  296.620003]  [<ffffffff81004a4c>]=
 die+0x55/0x61
Jun 16 17:15:49 mithrandir kernel: [  296.620003]  [<ffffffff81001dfc>]=
 do_trap+0x11c/0x12b
Jun 16 17:15:49 mithrandir kernel: [  296.620003]  [<ffffffff8100204d>]=
 do_invalid_op+0x93/0x9c
Jun 16 17:15:49 mithrandir kernel: [  296.620003]  [<ffffffffa023ca5d>]=
 ? write_all_supers+0x224/0x237 [btrfs]
Jun 16 17:15:49 mithrandir kernel: [  296.620003]  [<ffffffff8139c195>]=
 invalid_op+0x15/0x20
Jun 16 17:15:49 mithrandir kernel: [  296.620003]  [<ffffffffa023ca5d>]=
 ? write_all_supers+0x224/0x237 [btrfs]
Jun 16 17:15:49 mithrandir kernel: [  296.620003]  [<ffffffffa023ca5d>]=
 ? write_all_supers+0x224/0x237 [btrfs]
Jun 16 17:15:49 mithrandir kernel: [  296.620003]  [<ffffffffa023ca7e>]=
 write_ctree_super+0xe/0x10 [btrfs]
Jun 16 17:15:49 mithrandir kernel: [  296.620003]  [<ffffffffa0240b93>]=
 btrfs_commit_transaction+0x54e/0x64e [btrfs]
Jun 16 17:15:49 mithrandir kernel: [  296.620003]  [<ffffffff81047fb2>]=
 ? remove_wait_queue+0x35/0x35
Jun 16 17:15:49 mithrandir kernel: [  296.620003]  [<ffffffff810d02a6>]=
 ? __sync_filesystem+0x72/0x72
Jun 16 17:15:49 mithrandir kernel: [  296.620003]  [<ffffffffa0225bd5>]=
 btrfs_sync_fs+0x62/0x66 [btrfs]
Jun 16 17:15:49 mithrandir kernel: [  296.620003]  [<ffffffff810d0292>]=
 __sync_filesystem+0x5e/0x72
Jun 16 17:15:49 mithrandir kernel: [  296.620003]  [<ffffffff810d02b7>]=
 sync_one_sb+0x11/0x13
Jun 16 17:15:49 mithrandir kernel: [  296.620003]  [<ffffffff810b3c39>]=
 iterate_supers+0x6a/0xbf
Jun 16 17:15:49 mithrandir kernel: [  296.713156]  [<ffffffff810d033e>]=
 sys_sync+0x3d/0x4f
Jun 16 17:15:49 mithrandir kernel: [  296.713561]  [<ffffffff8139b5fb>]=
 system_call_fastpath+0x16/0x1b
Jun 16 17:15:49 mithrandir kernel: [  296.713561] Code: 41 56 41 89 f6 =
41 55 49 89 fd 41 54 53 65 4c 8b 24 25 00 b6 00 00 48 85 ff 49 8b 9c 24=
 f8 04 00 00 74 7e 48 85 db 74 0f 48 8b 03=20
Jun 16 17:15:49 mithrandir kernel: [  296.713561] RIP  [<ffffffff81118c=
e2>] journal_start+0x2f/0xc1
Jun 16 17:15:49 mithrandir kernel: [  296.713561]  RSP <ffff88008e5c369=
8>
Jun 16 17:15:49 mithrandir kernel: [  296.713561] CR2: 000000000000163e
Jun 16 17:15:49 mithrandir kernel: [  296.722164] ---[ end trace 63d761=
3b609d9a59 ]---
Jun 16 17:15:49 mithrandir kernel: [  296.722167] Fixing recursive faul=
t but reboot is needed!


Best wishes

Norbert
-----------------------------------------------------------------------=
-
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org=
}
JAIST, Japan                                 TeX Live & Debian Develope=
r
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B09=
4
-----------------------------------------------------------------------=
