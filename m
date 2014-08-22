From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 45941] BUG: soft lockup - CPU#1 stuck for 21s! [kworker/1:1:64]
 BUG: soft lockup - CPU#4 stuck for 22s! [flush-252:0:384]
Date: Fri, 22 Aug 2014 18:30:42 +0000
Message-ID: <bug-45941-13602-IF2XiZAI4O@https.bugzilla.kernel.org/>
References: <bug-45941-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:38204 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932410AbaHVSar (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Aug 2014 14:30:47 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3049A20155
	for <linux-ext4@vger.kernel.org>; Fri, 22 Aug 2014 18:30:46 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 9E06A20172
	for <linux-ext4@vger.kernel.org>; Fri, 22 Aug 2014 18:30:42 +0000 (UTC)
In-Reply-To: <bug-45941-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=45941

Alain Brossard <vmware@alain.homeunix.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |vmware@alain.homeunix.org

--- Comment #4 from Alain Brossard <vmware@alain.homeunix.org> ---
Hi,
  I had the same issue with Ubuntu 14.04 + Xen-4.4 and the same solution
worked: remove irqbalance. Though I suspect it could be a question of lock
timing and this problem could come back.

3.13.0-32-generic
Aug 16 17:11:42 mytv kernel: [   59.284157] BUG: soft lockup - CPU#2 stuck for
23s! [Xorg:3631]
Aug 16 17:11:42 mytv kernel: [   59.284160] Modules linked in: xen_gntdev
xen_evtchn xenfs xen_privcmd nfsv
3 nfsv4 bridge stp llc dm_crypt nfsd auth_rpcgss nfs_acl nfs lockd sunrpc
fscache nls_iso8859_1 eeepc_wmi a
sus_wmi sparse_keymap video mxm_wmi snd_hda_codec_realtek crct10dif_pclmul
crc32_pclmul ghash_clmulni_intel
 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm aesni_intel aes_x86_64 lrw
gf128mul snd_page_alloc glue_help
er ablk_helper cryptd snd_seq_midi snd_seq_midi_event serio_raw snd_rawmidi
fam15h_power k10temp edac_core 
edac_mce_amd snd_seq joydev snd_seq_device snd_timer snd sp5100_tco i2c_piix4
soundcore nvidia(POF) parport
_pc ppdev lp parport wmi mac_hid dm_mirror dm_region_hash dm_log hid_generic
usbhid hid psmouse e1000e r816
9 mii ptp ahci pps_core libahci
Aug 16 17:11:42 mytv kernel: [   59.284210] CPU: 2 PID: 3631 Comm: Xorg
Tainted: PF          O 3.13.0-32-ge
neric #57-Ubuntu
Aug 16 17:11:42 mytv kernel: [   59.284212] Hardware name: To be filled by
O.E.M. To be filled by O.E.M./SA
BERTOOTH 990FX R2.0, BIOS 2501 04/08/2014
Aug 16 17:11:42 mytv kernel: [   59.284216] task: ffff880425155fc0 ti:
ffff8804265f6000 task.ti: ffff880426
5f6000
Aug 16 17:11:42 mytv kernel: [   59.284218] RIP: e030:[<ffffffffa077d0da>] 
[<ffffffffa077d0da>] rm_shutdow
n_gvi_device+0x187/0x295 [nvidia]
Aug 16 17:11:42 mytv kernel: [   59.284315] RSP: e02b:ffff8804265f78d0  EFLAGS:
00000282
Aug 16 17:11:42 mytv kernel: [   59.284317] RAX: ffff8800000dc97c RBX:
ffff880415192e24 RCX: ffffffffa0b616
70
Aug 16 17:11:42 mytv kernel: [   59.284318] RDX: 00000000000000ff RSI:
00000000000dc97c RDI: 00000000000dc9
7c
Aug 16 17:11:42 mytv kernel: [   59.284319] RBP: ffff880415192e20 R08:
0000000000000001 R09: ffffffffa0b6d1
40
Aug 16 17:11:42 mytv kernel: [   59.284320] R10: ffff880425ace808 R11:
ffffffffa079c8db R12: ffff880415192e
28
Aug 16 17:11:42 mytv kernel: [   59.284321] R13: ffff880415192e2c R14:
0000000000009bed R15: ffff880415192e
90
Aug 16 17:11:42 mytv kernel: [   59.284325] FS:  00007fc4235f79c0(0000)
GS:ffff880447280000(0000) knlGS:000
0000000000000
Aug 16 17:11:42 mytv kernel: [   59.284327] CS:  e033 DS: 0000 ES: 0000 CR0:
000000008005003b
Aug 16 17:11:42 mytv kernel: [   59.284328] CR2: 00007fd1e4edcff0 CR3:
0000000425a8a000 CR4: 00000000000406
60
Aug 16 17:11:42 mytv kernel: [   59.284329] Stack:
Aug 16 17:11:42 mytv kernel: [   59.284330]  ffffffffa079c8db ffffffffa077f9da
ffff8804151b8008 00000000000
0cfde
Aug 16 17:11:42 mytv kernel: [   59.284333]  ffff880415192e8c ffffffffa0789d58
ffff8804265f7910 ffff8804151
b8008
Aug 16 17:11:42 mytv kernel: [   59.284336]  000000000000cfde ffffffffa077f976
ffff8804151b8008 ffffffffa07
7d639
Aug 16 17:11:42 mytv kernel: [   59.284338] Call Trace:
Aug 16 17:11:42 mytv kernel: [   59.284384]  [<ffffffffa079c8db>] ?
os_free_mem+0x1b/0x30 [nvidia]
Aug 16 17:11:42 mytv kernel: [   59.284428]  [<ffffffffa077f9da>] ?
_nv007991rm+0x33/0x56 [nvidia]
Aug 16 17:11:42 mytv kernel: [   59.284472]  [<ffffffffa0789d58>] ?
_nv019222rm+0x970b/0xcee3 [nvidia]
Aug 16 17:11:42 mytv kernel: [   59.284517]  [<ffffffffa077f976>] ?
_nv001242rm+0x83/0xa4 [nvidia]
Aug 16 17:11:42 mytv kernel: [   59.284560]  [<ffffffffa077d639>] ?
_nv014418rm+0x1f0/0xc97 [nvidia]
Aug 16 17:11:42 mytv kernel: [   59.284605]  [<ffffffffa076ad9e>] ?
_nv014859rm+0xce/0x3da [nvidia]
Aug 16 17:11:42 mytv kernel: [   59.284653]  [<ffffffffa076b176>] ?
_nv014923rm+0x4c/0x59 [nvidia]
Aug 16 17:11:42 mytv kernel: [   59.284716]  [<ffffffffa02e083c>] ?
_nv018571rm+0x35/0x79 [nvidia]
Aug 16 17:11:42 mytv kernel: [   59.284765]  [<ffffffffa072e0ab>] ?
_nv018447rm+0x46/0xbf [nvidia]
Aug 16 17:11:42 mytv kernel: [   59.284827]  [<ffffffffa02a3ce1>] ?
_nv012729rm+0x551/0x13cb [nvidia]
Aug 16 17:11:42 mytv kernel: [   59.284890]  [<ffffffffa02c05a5>] ?
_nv017460rm+0x405/0x42f [nvidia]
Aug 16 17:11:42 mytv kernel: [   59.284954]  [<ffffffffa03111f5>] ?
_nv005690rm+0x1e5/0x1f3 [nvidia]
Aug 16 17:11:42 mytv kernel: [   59.285033]  [<ffffffffa03df9ee>] ?
_nv005044rm+0x9a/0xc4 [nvidia]
Aug 16 17:11:42 mytv kernel: [   59.285129]  [<ffffffffa0539d22>] ?
_nv004050rm+0x8858/0xaef1 [nvidia]
Aug 16 17:11:42 mytv kernel: [   59.285225]  [<ffffffffa0538573>] ?
_nv004050rm+0x70a9/0xaef1 [nvidia]
Aug 16 17:11:42 mytv kernel: [   59.285264]  [<ffffffffa0166e80>] ?
_nv010039rm+0x25/0x40 [nvidia]
Aug 16 17:11:42 mytv kernel: [   59.285310]  [<ffffffffa0779558>] ?
_nv015014rm+0x808/0x982 [nvidia]
Aug 16 17:11:42 mytv kernel: [   59.285354]  [<ffffffffa077a538>] ?
_nv001097rm+0x483/0x6b8 [nvidia]
Aug 16 17:11:42 mytv kernel: [   59.285398]  [<ffffffffa0772aa4>] ?
rm_init_adapter+0xac/0x146 [nvidia]
Aug 16 17:11:42 mytv kernel: [   59.285443]  [<ffffffffa0792b71>] ?
nv_kern_open+0x191/0x810 [nvidia]
Aug 16 17:11:42 mytv kernel: [   59.285448]  [<ffffffff811c14ef>] ?
chrdev_open+0x9f/0x1d0
Aug 16 17:11:42 mytv kernel: [   59.285451]  [<ffffffff811ba033>] ?
do_dentry_open+0x233/0x2e0
Aug 16 17:11:42 mytv kernel: [   59.285453]  [<ffffffff811c1450>] ?
cdev_put+0x30/0x30
Aug 16 17:11:42 mytv kernel: [   59.285455]  [<ffffffff811ba369>] ?
vfs_open+0x49/0x50
Aug 16 17:11:42 mytv kernel: [   59.285464]  [<ffffffff811c8f04>] ?
do_last+0x554/0x1200
Aug 16 17:11:42 mytv kernel: [   59.285467]  [<ffffffff81311bdb>] ?
apparmor_file_alloc_security+0x5b/0x180
Aug 16 17:11:42 mytv kernel: [   59.285470]  [<ffffffff811cc38b>] ?
path_openat+0xbb/0x640
Aug 16 17:11:42 mytv kernel: [   59.285473]  [<ffffffff812d3d5e>] ?
security_inode_alloc+0x1e/0x20
Aug 16 17:11:42 mytv kernel: [   59.285476]  [<ffffffff811e2988>] ?
simple_xattr_get+0x68/0xb0
Aug 16 17:11:42 mytv kernel: [   59.285478]  [<ffffffff811cd76a>] ?
do_filp_open+0x3a/0x90
Aug 16 17:11:42 mytv kernel: [   59.285481]  [<ffffffff811da527>] ?
__alloc_fd+0xa7/0x130
Aug 16 17:11:42 mytv kernel: [   59.285484]  [<ffffffff811bbe89>] ?
do_sys_open+0x129/0x280
Aug 16 17:11:42 mytv kernel: [   59.285487]  [<ffffffff81020d45>] ?
syscall_trace_enter+0x145/0x250
Aug 16 17:11:42 mytv kernel: [   59.285489]  [<ffffffff811bbffe>] ?
SyS_open+0x1e/0x20
Aug 16 17:11:42 mytv kernel: [   59.285492]  [<ffffffff8172c87f>] ?
tracesys+0xe1/0xe6
Aug 16 17:11:42 mytv kernel: [   59.285493] Code: c3 e8 e2 28 00 00 b8 00 00 00
00 48 83 c4 08 c3 48 83 ec 
08 be 01 00 00 00 e8 96 ff ff ff ba 00 00 00 00 48 85 c0 74 03 0f b6 10 <89> d0
48 83 c4 08 c3 48 83 ec 08 
be 02 00 00 00 e8 74 ff ff ff 
Aug 16 17:12:10 mytv kernel: [   87.283580] BUG: soft lockup - CPU#2 stuck for
23s! [Xorg:3631]
 and loop...  Xorg never starts properly though ssh through works. All attempts
to shutdown cleanly hang as does tcpdump if it matters.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
