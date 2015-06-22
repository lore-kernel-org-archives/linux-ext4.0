From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 100321] New: General protection fault (stalls the machine) with
 jbd2 and raid456
Date: Mon, 22 Jun 2015 18:36:30 +0000
Message-ID: <bug-100321-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:54839 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbbFVSgh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Jun 2015 14:36:37 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id B56BE205E7
	for <linux-ext4@vger.kernel.org>; Mon, 22 Jun 2015 18:36:35 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id A66FA205E5
	for <linux-ext4@vger.kernel.org>; Mon, 22 Jun 2015 18:36:30 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=100321

            Bug ID: 100321
           Summary: General protection fault (stalls the machine) with
                    jbd2 and raid456
           Product: File System
           Version: 2.5
    Kernel Version: Linux xpc 4.1.0-rc8 #2 SMP Sun Jun 21 11:16:21 EEST
                    2015 x86_64 x86_64 x86_64 GNU/Linux
          Hardware: IA-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: jouni.karvo@iki.fi
        Regression: No

I have 5 sata disks running as raid6, on which lvm, on which server partitions
and home partition.  Root partition is on separate raid1

>From boot it takes from two hours to two days until the whole machine crashes. 
This is the kern.log excerpt from the last crash this evening.

I am running 4.1-rc8 at the moment:

Linux xpc 4.1.0-rc8 #2 SMP Sun Jun 21 11:16:21 EEST 2015 x86_64 x86_64 x86_64
GNU/Linux

Jun 22 20:55:34 xpc kernel: [26361.124389] general protection fault: 0000 [#1]
SMP 
Jun 22 20:55:34 xpc kernel: [26361.124408] Modules linked in: usblp binfmt_misc
cfg80211 sp2 si2157 si2168 i2c_mux cx25840 snd_hda_codec_realtek
snd_hda_codec_generic snd_hda_codec_hdmi joydev eeepc_wmi asus_wmi
sparse_keymap mxm_wmi intel_rapl iosf_mbi x86_pkg_temp_thermal cx23885
intel_powerclamp kvm_intel altera_ci tda18271 altera_stapl kvm videobuf2_dvb
tveeprom cx2341x snd_hda_intel dvb_core snd_hda_controller hid_logitech_hidpp
rc_core i915 videobuf2_dma_sg crct10dif_pclmul snd_hda_codec videobuf2_memops
crc32_pclmul videobuf2_core ghash_clmulni_intel snd_hda_core v4l2_common
snd_hwdep aesni_intel videodev snd_seq_midi aes_x86_64 snd_seq_midi_event lrw
media gf128mul snd_rawmidi snd_pcm glue_helper snd_seq ablk_helper
drm_kms_helper cryptd snd_seq_device serio_raw snd_timer drm snd mei_me
i2c_algo_bit soundcore mei lpc_ich shpchp mac_hid video wmi nfsd auth_rpcgss
nfs_acl lockd grace sunrpc nct6775 hwmon_vid coretemp parport_pc ppdev lp
parport autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq
async_xor async_tx xor raid6_pq raid1 hid_logitech_dj raid0 e1000e usbhid ahci
multipath ptp hid libahci psmouse pps_core linear
Jun 22 20:55:34 xpc kernel: [26361.124689] CPU: 6 PID: 797 Comm: jbd2/dm-1-8
Not tainted 4.1.0-rc8 #2
Jun 22 20:55:34 xpc kernel: [26361.124702] Hardware name: ASUS All
Series/MAXIMUS VI EXTREME, BIOS 1603 08/15/2014
Jun 22 20:55:34 xpc kernel: [26361.124718] task: ffff8801b66e2840 ti:
ffff8801b60a8000 task.ti: ffff8801b60a8000
Jun 22 20:55:34 xpc kernel: [26361.124732] RIP: 0010:[<ffffffffc0181490>] 
[<ffffffffc0181490>] __find_stripe+0x30/0xc0 [raid456]
Jun 22 20:55:34 xpc kernel: [26361.124754] RSP: 0018:ffff8801b60ab988  EFLAGS:
00010002
Jun 22 20:55:34 xpc kernel: [26361.124765] RAX: 0001880035c19000 RBX:
0000000000000000 RCX: 0000000000000000
Jun 22 20:55:34 xpc kernel: [26361.124779] RDX: 0000000000000b98 RSI:
000000000248cb98 RDI: ffff880035c07400
Jun 22 20:55:34 xpc kernel: [26361.124793] RBP: ffff8801b60ab9a8 R08:
0000000000000000 R09: 0000000000000000
Jun 22 20:55:34 xpc kernel: [26361.124807] R10: 0000000000000398 R11:
0000000000000003 R12: 000000000248cb98
Jun 22 20:55:34 xpc kernel: [26361.124820] R13: ffff880035c07400 R14:
ffff880035c07414 R15: ffff880035c07400
Jun 22 20:55:34 xpc kernel: [26361.124834] FS:  0000000000000000(0000)
GS:ffff8801bfb80000(0000) knlGS:0000000000000000
Jun 22 20:55:34 xpc kernel: [26361.124849] CS:  0010 DS: 0000 ES: 0000 CR0:
0000000080050033
Jun 22 20:55:34 xpc kernel: [26361.124860] CR2: 0000000000708470 CR3:
0000000001c0d000 CR4: 00000000001407e0
Jun 22 20:55:34 xpc kernel: [26361.124874] DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Jun 22 20:55:34 xpc kernel: [26361.124887] DR3: 0000000000000000 DR6:
00000000fffe0ff0 DR7: 0000000000000400
Jun 22 20:55:34 xpc kernel: [26361.124900] Stack:
Jun 22 20:55:34 xpc kernel: [26361.125844]  0000000000000000 0000000000000000
0000000000000003 ffff88019d63cb20
Jun 22 20:55:34 xpc kernel: [26361.126788]  ffff8801b60aba78 ffffffffc018836d
ffff8801b8253250 0000000000000246
Jun 22 20:55:34 xpc kernel: [26361.127752]  ffff8801b60aba30 ffff880035c0740c
ffff8801b60aba30 0000000000000003
Jun 22 20:55:34 xpc kernel: [26361.128699] Call Trace:
Jun 22 20:55:34 xpc kernel: [26361.129636]  [<ffffffffc018836d>]
get_active_stripe+0x12d/0x7e0 [raid456]
Jun 22 20:55:34 xpc kernel: [26361.130576]  [<ffffffff810bc097>] ?
prepare_to_wait+0x57/0x90
Jun 22 20:55:34 xpc kernel: [26361.131534]  [<ffffffffc018e00d>]
make_request+0x19d/0xda0 [raid456]
Jun 22 20:55:34 xpc kernel: [26361.132479]  [<ffffffff8165e6cb>] ?
__split_and_process_bio+0x2fb/0x3f0
Jun 22 20:55:34 xpc kernel: [26361.133410]  [<ffffffff810bc3b0>] ?
wait_woken+0x90/0x90
Jun 22 20:55:34 xpc kernel: [26361.134332]  [<ffffffff8164bbfc>]
md_make_request+0xdc/0x220
Jun 22 20:55:34 xpc kernel: [26361.135254]  [<ffffffff8165e83a>] ?
dm_make_request+0x7a/0xd0
Jun 22 20:55:34 xpc kernel: [26361.136174]  [<ffffffff81386580>]
generic_make_request+0xc0/0x110
Jun 22 20:55:34 xpc kernel: [26361.137073]  [<ffffffff81386648>]
submit_bio+0x78/0x180
Jun 22 20:55:34 xpc kernel: [26361.137965]  [<ffffffff812df62b>] ?
jbd2_journal_write_metadata_buffer+0x2cb/0x390
Jun 22 20:55:34 xpc kernel: [26361.138857]  [<ffffffff81233d3c>]
_submit_bh+0x11c/0x190
Jun 22 20:55:34 xpc kernel: [26361.139748]  [<ffffffff81233dc0>]
submit_bh+0x10/0x20
Jun 22 20:55:34 xpc kernel: [26361.140621]  [<ffffffff812d7481>]
jbd2_journal_commit_transaction+0x7e1/0x1820
Jun 22 20:55:34 xpc kernel: [26361.141504]  [<ffffffff8101ddd9>] ?
sched_clock+0x9/0x10
Jun 22 20:55:34 xpc kernel: [26361.142381]  [<ffffffff810e50ef>] ?
try_to_del_timer_sync+0x4f/0x70
Jun 22 20:55:34 xpc kernel: [26361.143249]  [<ffffffff812dbe4b>]
kjournald2+0xbb/0x250
Jun 22 20:55:34 xpc kernel: [26361.144110]  [<ffffffff810bc3b0>] ?
wait_woken+0x90/0x90
Jun 22 20:55:34 xpc kernel: [26361.144957]  [<ffffffff812dbd90>] ?
commit_timeout+0x10/0x10
Jun 22 20:55:34 xpc kernel: [26361.145799]  [<ffffffff81098c49>]
kthread+0xc9/0xe0
Jun 22 20:55:34 xpc kernel: [26361.146634]  [<ffffffff81098b80>] ?
kthread_create_on_node+0x180/0x180
Jun 22 20:55:34 xpc kernel: [26361.147470]  [<ffffffff817e2de2>]
ret_from_fork+0x42/0x70
Jun 22 20:55:34 xpc kernel: [26361.148283]  [<ffffffff81098b80>] ?
kthread_create_on_node+0x180/0x180
Jun 22 20:55:34 xpc kernel: [26361.149094] Code: 55 48 89 e5 41 55 41 54 53 49
89 fd 49 89 f4 89 d3 48 83 ec 08 f6 05 39 1b 01 00 04 75 5e 49 8b 45 00 4c 89
e2 81 e2 f8 0f 00 00 <48> 8b 04 02 48 85 c0 75 2d 31 db f6 05 f0 1a 01 00 04 75
57 48 
Jun 22 20:55:34 xpc kernel: [26361.149989] RIP  [<ffffffffc0181490>]
__find_stripe+0x30/0xc0 [raid456]
Jun 22 20:55:34 xpc kernel: [26361.150833]  RSP <ffff8801b60ab988>
Jun 22 20:55:34 xpc kernel: [26361.156521] ---[ end trace c430f52499aa3b3a ]---
Jun 22 20:55:36 xpc kernel: [26363.223855] general protection fault: 0000 [#2]
SMP 
Jun 22 20:55:36 xpc kernel: [26363.225306] Modules linked in: usblp binfmt_misc
cfg80211 sp2 si2157 si2168 i2c_mux cx25840 snd_hda_codec_realtek
snd_hda_codec_generic snd_hda_codec_hdmi joydev eeepc_wmi asus_wmi
sparse_keymap mxm_wmi intel_rapl iosf_mbi x86_pkg_temp_thermal cx23885
intel_powerclamp kvm_intel altera_ci tda18271 altera_stapl kvm videobuf2_dvb
tveeprom cx2341x snd_hda_intel dvb_core snd_hda_controller hid_logitech_hidpp
rc_core i915 videobuf2_dma_sg crct10dif_pclmul snd_hda_codec videobuf2_memops
crc32_pclmul videobuf2_core ghash_clmulni_intel snd_hda_core v4l2_common
snd_hwdep aesni_intel videodev snd_seq_midi aes_x86_64 snd_seq_midi_event lrw
media gf128mul snd_rawmidi snd_pcm glue_helper snd_seq ablk_helper
drm_kms_helper cryptd snd_seq_device serio_raw snd_timer drm snd mei_me
i2c_algo_bit soundcore mei lpc_ich shpchp mac_hid video wmi nfsd auth_rpcgss
nfs_acl lockd grace sunrpc nct6775 hwmon_vid coretemp parport_pc ppdev lp
parport autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq
async_xor async_tx xor raid6_pq raid1 hid_logitech_dj raid0 e1000e usbhid ahci
multipath ptp hid libahci psmouse pps_core linear
Jun 22 20:55:36 xpc kernel: [26363.233599] CPU: 5 PID: 22633 Comm:
kworker/u16:1 Tainted: G      D         4.1.0-rc8 #2
Jun 22 20:55:36 xpc kernel: [26363.235288] Hardware name: ASUS All
Series/MAXIMUS VI EXTREME, BIOS 1603 08/15/2014
Jun 22 20:55:36 xpc kernel: [26363.236982] Workqueue: writeback
bdi_writeback_workfn (flush-252:1)
Jun 22 20:55:36 xpc kernel: [26363.238665] task: ffff880020984670 ti:
ffff880071bfc000 task.ti: ffff880071bfc000
Jun 22 20:55:36 xpc kernel: [26363.240340] RIP: 0010:[<ffffffffc0181490>] 
[<ffffffffc0181490>] __find_stripe+0x30/0xc0 [raid456]
Jun 22 20:55:36 xpc kernel: [26363.242027] RSP: 0018:ffff880071bff578  EFLAGS:
00010002
Jun 22 20:55:36 xpc kernel: [26363.243693] RAX: 0001880035c19000 RBX:
0000000000000000 RCX: 0000000000000000
Jun 22 20:55:36 xpc kernel: [26363.245370] RDX: 0000000000000368 RSI:
000000005047f368 RDI: ffff880035c07400
Jun 22 20:55:36 xpc kernel: [26363.247046] RBP: ffff880071bff598 R08:
0000000000000000 R09: 0000000000000000
Jun 22 20:55:36 xpc kernel: [26363.248704] R10: 0000000000000368 R11:
0000000000000000 R12: 000000005047f368
Jun 22 20:55:36 xpc kernel: [26363.250343] R13: ffff880035c07400 R14:
ffff880035c0741c R15: ffff880035c07400
Jun 22 20:55:36 xpc kernel: [26363.251937] FS:  0000000000000000(0000)
GS:ffff8801bfb40000(0000) knlGS:0000000000000000
Jun 22 20:55:36 xpc kernel: [26363.253493] CS:  0010 DS: 0000 ES: 0000 CR0:
0000000080050033
Jun 22 20:55:36 xpc kernel: [26363.254996] CR2: 00007f25ff0651a0 CR3:
0000000001c0d000 CR4: 00000000001407e0
Jun 22 20:55:36 xpc kernel: [26363.256456] DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Jun 22 20:55:36 xpc kernel: [26363.257861] DR3: 0000000000000000 DR6:
00000000fffe0ff0 DR7: 0000000000000400
Jun 22 20:55:36 xpc kernel: [26363.259226] Stack:
Jun 22 20:55:36 xpc kernel: [26363.260574]  ffff8801bfa94e40 0000000000000000
0000000000000005 ffff88011a296620
Jun 22 20:55:36 xpc kernel: [26363.261945]  ffff880071bff668 ffffffffc018836d
000000005047e3f8 ffff88011a296620
Jun 22 20:55:36 xpc kernel: [26363.263303]  00000000ffffffff ffff880035c07414
000000000000ffff 0000000000000005
Jun 22 20:55:36 xpc kernel: [26363.264653] Call Trace:
Jun 22 20:55:36 xpc kernel: [26363.265994]  [<ffffffffc018836d>]
get_active_stripe+0x12d/0x7e0 [raid456]
Jun 22 20:55:36 xpc kernel: [26363.267351]  [<ffffffff81186600>] ?
mempool_alloc+0x20/0x150
Jun 22 20:55:36 xpc kernel: [26363.268706]  [<ffffffff810bc097>] ?
prepare_to_wait+0x57/0x90
Jun 22 20:55:36 xpc kernel: [26363.270064]  [<ffffffffc018e00d>]
make_request+0x19d/0xda0 [raid456]
Jun 22 20:55:36 xpc kernel: [26363.271420]  [<ffffffff8165e6cb>] ?
__split_and_process_bio+0x2fb/0x3f0
Jun 22 20:55:36 xpc kernel: [26363.272770]  [<ffffffff810bc3b0>] ?
wait_woken+0x90/0x90
Jun 22 20:55:36 xpc kernel: [26363.274111]  [<ffffffff8164bbfc>]
md_make_request+0xdc/0x220
Jun 22 20:55:36 xpc kernel: [26363.275446]  [<ffffffff8165e83a>] ?
dm_make_request+0x7a/0xd0
Jun 22 20:55:36 xpc kernel: [26363.276784]  [<ffffffff81386580>]
generic_make_request+0xc0/0x110
Jun 22 20:55:36 xpc kernel: [26363.278132]  [<ffffffff81386648>]
submit_bio+0x78/0x180
Jun 22 20:55:36 xpc kernel: [26363.279469]  [<ffffffff8118ed32>] ?
__test_set_page_writeback+0x132/0x1b0
Jun 22 20:55:36 xpc kernel: [26363.280805]  [<ffffffff8128dd19>]
ext4_io_submit+0x29/0x60
Jun 22 20:55:36 xpc kernel: [26363.282131]  [<ffffffff8128dee8>]
ext4_bio_write_page+0x168/0x410
Jun 22 20:55:36 xpc kernel: [26363.283460]  [<ffffffff811be580>] ?
page_referenced_one+0x190/0x190
Jun 22 20:55:36 xpc kernel: [26363.284783]  [<ffffffff81284c71>]
mpage_submit_page+0x61/0x90
Jun 22 20:55:36 xpc kernel: [26363.286097]  [<ffffffff81284db0>]
mpage_process_page_bufs+0x110/0x120
Jun 22 20:55:36 xpc kernel: [26363.287409]  [<ffffffff81285f8d>]
mpage_prepare_extent_to_map+0x1dd/0x2d0
Jun 22 20:55:36 xpc kernel: [26363.288722]  [<ffffffff8128a03c>]
ext4_writepages+0x38c/0xca0
Jun 22 20:55:36 xpc kernel: [26363.290031]  [<ffffffff813b94e4>] ?
cpumask_next_and+0x44/0x50
Jun 22 20:55:36 xpc kernel: [26363.291339]  [<ffffffff811910fe>]
do_writepages+0x1e/0x30
Jun 22 20:55:36 xpc kernel: [26363.292646]  [<ffffffff8122a755>]
__writeback_single_inode+0x45/0x2c0
Jun 22 20:55:36 xpc kernel: [26363.293958]  [<ffffffff8122ac2d>]
writeback_sb_inodes+0x25d/0x450
Jun 22 20:55:36 xpc kernel: [26363.295268]  [<ffffffff8122aebf>]
__writeback_inodes_wb+0x9f/0xd0
Jun 22 20:55:36 xpc kernel: [26363.296578]  [<ffffffff8122b113>]
wb_writeback+0x223/0x2c0
Jun 22 20:55:36 xpc kernel: [26363.297883]  [<ffffffff81218541>] ?
get_nr_inodes+0x51/0x80
Jun 22 20:55:36 xpc kernel: [26363.299181]  [<ffffffff8122b78c>]
bdi_writeback_workfn+0x1cc/0x440
Jun 22 20:55:36 xpc kernel: [26363.300485]  [<ffffffff81092bf8>]
process_one_work+0x158/0x440
Jun 22 20:55:36 xpc kernel: [26363.301785]  [<ffffffff8109375b>]
worker_thread+0x5b/0x540
Jun 22 20:55:36 xpc kernel: [26363.303078]  [<ffffffff81093700>] ?
rescuer_thread+0x3a0/0x3a0
Jun 22 20:55:36 xpc kernel: [26363.304369]  [<ffffffff81098c49>]
kthread+0xc9/0xe0
Jun 22 20:55:36 xpc kernel: [26363.305655]  [<ffffffff81098b80>] ?
kthread_create_on_node+0x180/0x180
Jun 22 20:55:36 xpc kernel: [26363.306950]  [<ffffffff817e2de2>]
ret_from_fork+0x42/0x70
Jun 22 20:55:36 xpc kernel: [26363.308245]  [<ffffffff81098b80>] ?
kthread_create_on_node+0x180/0x180
Jun 22 20:55:36 xpc kernel: [26363.309545] Code: 55 48 89 e5 41 55 41 54 53 49
89 fd 49 89 f4 89 d3 48 83 ec 08 f6 05 39 1b 01 00 04 75 5e 49 8b 45 00 4c 89
e2 81 e2 f8 0f 00 00 <48> 8b 04 02 48 85 c0 75 2d 31 db f6 05 f0 1a 01 00 04 75
57 48 
Jun 22 20:55:36 xpc kernel: [26363.310985] RIP  [<ffffffffc0181490>]
__find_stripe+0x30/0xc0 [raid456]
Jun 22 20:55:36 xpc kernel: [26363.312362]  RSP <ffff880071bff578>
Jun 22 20:55:36 xpc kernel: [26363.313736] ---[ end trace c430f52499aa3b3b ]---
Jun 22 20:55:36 xpc kernel: [26363.313786] BUG: unable to handle kernel paging
request at ffffffffffffffd8


The filesystems on LVM:

sudo tune2fs -l /dev//mapper/xpcvg-home 
tune2fs 1.42.12 (29-Aug-2014)
Filesystem volume name:   <none>
Last mounted on:          /home
Filesystem UUID:          db583624-afb4-41cb-8b2d-640bee2de61b
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype
needs_recovery extent sparse_super large_file uninit_bg
Filesystem flags:         signed_directory_hash 
Default mount options:    (none)
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              65536000
Block count:              262144000
Reserved block count:     13107200
Free blocks:              199344244
Free inodes:              65338714
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      961
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
RAID stride:              128
RAID stripe width:        384
Filesystem created:       Mon Jul 25 12:23:50 2011
Last mount time:          Mon Jun 22 21:07:06 2015
Last write time:          Mon Jun 22 21:07:06 2015
Mount count:              35
Maximum mount count:      157
Last checked:             Mon Jun 15 12:21:47 2015
Check interval:           15552000 (6 months)
Next check after:         Sat Dec 12 11:21:47 2015
Lifetime writes:          500 GB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:              256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
First orphan inode:       65143016
Default directory hash:   half_md4
Directory Hash Seed:      ea4a0233-d8af-4c51-9302-140a4affacdf
Journal backup:           inode blocks

sudo tune2fs -l /dev//mapper/xpcvg-data 
tune2fs 1.42.12 (29-Aug-2014)
Filesystem volume name:   <none>
Last mounted on:          /backup
Filesystem UUID:          1949c800-eb8c-4368-b809-3e2606c33d83
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype
needs_recovery extent sparse_super large_file uninit_bg
Filesystem flags:         signed_directory_hash 
Default mount options:    (none)
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              42008576
Block count:              168034304
Reserved block count:     8401715
Free blocks:              114693777
Free inodes:              42005415
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      983
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
RAID stride:              128
RAID stripe width:        384
Filesystem created:       Sun Jul 10 16:17:30 2011
Last mount time:          Mon Jun 22 21:04:50 2015
Last write time:          Mon Jun 22 21:04:50 2015
Mount count:              40
Maximum mount count:      157
Last checked:             Sat Jun  6 22:02:49 2015
Check interval:           15552000 (6 months)
Next check after:         Thu Dec  3 21:02:49 2015
Lifetime writes:          1889 GB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:              256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      a45f9ba2-ceb3-4a22-ab77-a2d5af71b82a
Journal backup:           inode blocks
sudo tune2fs -l /dev//mapper/xpcvg-video 
tune2fs 1.42.12 (29-Aug-2014)
Filesystem volume name:   <none>
Last mounted on:          /var/lib/video.00
Filesystem UUID:          0a8f2b37-4a27-4a06-b236-971af0cf1907
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype
needs_recovery extent sparse_super large_file uninit_bg
Filesystem flags:         signed_directory_hash 
Default mount options:    (none)
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              256114688
Block count:              1024458752
Reserved block count:     51222927
Free blocks:              463675406
Free inodes:              256097372
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      779
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
RAID stride:              128
RAID stripe width:        384
Filesystem created:       Mon Sep 21 21:47:18 2009
Last mount time:          Mon Jun 22 21:04:50 2015
Last write time:          Mon Jun 22 21:04:50 2015
Mount count:              137
Maximum mount count:      200
Last checked:             Thu Apr 16 06:08:46 2015
Check interval:           17280000 (6 months, 2 weeks, 6 days)
Next check after:         Mon Nov  2 05:08:46 2015
Lifetime writes:          15 TB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:              256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      ef0f022c-b41f-4a14-9957-e0f69e74987b
Journal backup:           inode blocks

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
