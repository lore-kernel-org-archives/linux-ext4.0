From: Daniel J Blueman <daniel@quora.org>
Subject: Re: 3.9-rc6 ext4: free_rb_tree_fname oops
Date: Mon, 24 Jun 2013 14:34:00 +0800
Message-ID: <CAMVG2ssG0PvedeuT6f3g=20Gv51f6gXWxxMFbtL4H=ngAJ9Gvg@mail.gmail.com>
References: <CAMVG2sskpWgL4JLKZZs8YXqNoLt4gB-UgeeMPnb8bTDKyUeRng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMVG2sskpWgL4JLKZZs8YXqNoLt4gB-UgeeMPnb8bTDKyUeRng@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 16 April 2013 15:37, Daniel J Blueman <daniel@quora.org> wrote:
> When using e4defrag on a ext4 filesystem created a month ago, I ran
> into this fatal page fault [1]
>  while running e4defrag on 3.9-rc6 (Ubuntu mainline).
>
> e2fsdump output is at http://quora.org/2012/e2fsdump.txt ; let me know
> if you need any more info.

With 3.9.6 mainline, I got the exact same protection fault at
free_rb_tree_fname() from ext4_htree_free_dir_info() [1]. This
suggests use-after-free, as there's no pagetable mapping.

There is nothing special with my setups, so there is fair chance it's
reproducible there with e4defrag on a few month old filesystem and
recent kernels.

Thanks,
  Daniel

> --- [1]
>
> general protection fault: 0000 [#1] SMP
> Modules linked in: btrfs raid6_pq zlib_deflate xor ufs qnx4 hfsplus
> hfs minix ntfs msdos jfs xfs libcrc32c reiserfs ext2 8021q garp
> parport_pc ppdev rfcomm bnep nfsd auth_rpcgss nfs_acl nfs lockd sunrpc
> fscache snd_hda_codec_hdmi snd_hda_codec_realtek coretemp kvm_intel
> kvm snd_hda_intel snd_hda_codec snd_hwdep ghash_clmulni_intel arc4
> bridge iwldvm joydev i915 cryptd snd_pcm mac80211 stp llc
> snd_page_alloc drm_kms_helper drm snd_seq_midi snd_seq_midi_event
> snd_rawmidi snd_seq psmouse snd_seq_device btusb ir_sony_decoder
> ir_rc5_decoder ir_lirc_codec lirc_dev ir_sanyo_decoder
> ir_mce_kbd_decoder ir_jvc_decoder serio_raw ir_rc6_decoder iwlwifi
> ir_nec_decoder snd_timer i2c_algo_bit rc_rc6_mce microcode nuvoton_cir
> snd rc_core bluetooth soundcore mac_hid cfg80211 mei lpc_ich video lp
> parport hid_generic usbhid hid r8169 ahci libahci
> CPU 0
> Pid: 18139, comm: e4defrag Not tainted 3.9.0-030900rc6-generic
> #201304080035 ZOTAC XXXXXX/XXXXXX
> RIP: 0010:[<ffffffff81238188>] [<ffffffff81238188>] free_rb_tree_fname+0x28/0xb0
> RSP: 0018:ffff8801134a9e28 EFLAGS: 00010202
> RAX: 0036b44b00008001 RBX: ffff880080e09018 RCX: 0000000180400028
> RDX: 0036b44b00008001 RSI: 0000000000000001 RDI: ffff88013b001700
> RBP: ffff8801134a9e48 R08: 0000000000000000 R09: ffffea0000dbe380
> R10: ffffffff812381bc R11: 0000000000000206 R12: 0000000000000000
> R13: ffff880036f8ec80 R14: ffff880036f8ebc8 R15: ffff8800ade074c0
> FS: 00007fd1923d7740(0000) GS:ffff88013fa00000(0000) knlGS:0000000000000000
> CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000013974d8 CR3: 00000001352f2000 CR4: 00000000000407f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process e4defrag (pid: 18139, threadinfo ffff8801134a8000, task
> ffff880138d9c5f0)
> Stack:
>  ffff880036f8ec80 0000000040000010 ffff880021a2f900 ffff8800ade074c0
>  ffff8801134a9e68 ffffffff81238f36 0000000040000010 ffff88013890f000
>  ffff8801134a9e78 ffffffff81238f6a ffff8801134a9ec8 ffffffff8119f57a
> Call Trace:
>  [<ffffffff81238f36>] ext4_htree_free_dir_info+0x16/0x30
>  [<ffffffff81238f6a>] ext4_release_dir+0x1a/0x20
>  [<ffffffff8119f57a>] __fput+0xba/0x240
>  [<ffffffff8119f70e>] ____fput+0xe/0x10
>  [<ffffffff8107ca58>] task_work_run+0xc8/0xf0
>  [<ffffffff81014d7a>] do_notify_resume+0xaa/0xc0
>  [<ffffffff8170d0da>] int_signal+0x12/0x17
> Code: 90 90 90 66 66 66 66 90 55 48 89 e5 41 56 41 55 49 89 fd 41 54
> 53 48 8b 1f 48 85 db 74 67 48 8b 43 10 eb 11 0f 1f 80 00 00 00 00 <48>
> 8b 50 10 48 89 c3 48 89 d0 48 85 c0 75 f1 48 8b 43 08 48 85
> RIP [<ffffffff81238188>] free_rb_tree_fname+0x28/0xb0
>  RSP <ffff8801134a9e28>
> ---[ end trace 02741f61e6b3c24b ]---
> general protection fault: 0000 [#2] SMP
> Modules linked in: btrfs raid6_pq zlib_deflate xor ufs qnx4 hfsplus
> hfs minix ntfs msdos jfs xfs libcrc32c reiserfs ext2 8021q garp
> parport_pc ppdev rfcomm bnep nfsd auth_rpcgss nfs_acl nfs lockd sunrpc
> fscache snd_hda_codec_hdmi snd_hda_codec_realtek coretemp kvm_intel
> kvm snd_hda_intel snd_hda_codec snd_hwdep ghash_clmulni_intel arc4
> bridge iwldvm joydev i915 cryptd snd_pcm mac80211 stp llc
> snd_page_alloc drm_kms_helper drm snd_seq_midi snd_seq_midi_event
> snd_rawmidi snd_seq psmouse snd_seq_device btusb ir_sony_decoder
> ir_rc5_decoder ir_lirc_codec lirc_dev ir_sanyo_decoder
> ir_mce_kbd_decoder ir_jvc_decoder serio_raw ir_rc6_decoder iwlwifi
> ir_nec_decoder snd_timer i2c_algo_bit rc_rc6_mce microcode nuvoton_cir
> snd rc_core bluetooth soundcore mac_hid cfg80211 mei lpc_ich video lp
> parport hid_generic usbhid hid r8169 ahci libahci
> CPU 0
> Pid: 18139, comm: e4defrag Tainted: G   D   3.9.0-030900rc6-generic
> #201304080035 ZOTAC XXXXXX/XXXXXX
> RIP: 0010:[<ffffffff81238188>] [<ffffffff81238188>] free_rb_tree_fname+0x28/0xb0
> RSP: 0018:ffff8801134a9b78 EFLAGS: 00010202
> RAX: 0036b44b00008001 RBX: ffff880080e09018 RCX: 0000000000000001
> RDX: 0036b44b00008001 RSI: ffff88013890fb00 RDI: ffff880036f8ef80
> RBP: ffff8801134a9b98 R08: 0000000000000000 R09: 0000000000000000
> R10: ffff88013890fb10 R11: 0000000000000000 R12: 0000000040000010
> R13: ffff880036f8ef80 R14: ffff8800ade07108 R15: ffff8800ade07108
> FS: 0000000000000000(0000) GS:ffff88013fa00000(0000) knlGS:0000000000000000
> CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f718650aed4 CR3: 0000000001c0d000 CR4: 00000000000407f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process e4defrag (pid: 18139, threadinfo ffff8801134a8000, task
> ffff880138d9c5f0)
> Stack:
>  ffff880036f8ef80 0000000040000010 ffff880021a2fb40 ffff8800ade07108
>  ffff8801134a9bb8 ffffffff81238f36 0000000040000010 ffff88013890fb00
>  ffff8801134a9bc8 ffffffff81238f6a ffff8801134a9c18 ffffffff8119f57a
> Call Trace:
>  [<ffffffff81238f36>] ext4_htree_free_dir_info+0x16/0x30
>  [<ffffffff81238f6a>] ext4_release_dir+0x1a/0x20
>  [<ffffffff8119f57a>] __fput+0xba/0x240
>  [<ffffffff8119f70e>] ____fput+0xe/0x10
>  [<ffffffff8107ca58>] task_work_run+0xc8/0xf0
>  [<ffffffff81060876>] do_exit+0x196/0x480
>  [<ffffffff81705329>] oops_end+0xb9/0x100
>  [<ffffffff81017d88>] die+0x58/0x90
>  [<ffffffff81704d9c>] do_general_protection+0xdc/0x160
>  [<ffffffff81704728>] general_protection+0x28/0x30
>  [<ffffffff812381bc>] ? free_rb_tree_fname+0x5c/0xb0
>  [<ffffffff81238188>] ? free_rb_tree_fname+0x28/0xb0
>  [<ffffffff812381bc>] ? free_rb_tree_fname+0x5c/0xb0
>  [<ffffffff81238f36>] ext4_htree_free_dir_info+0x16/0x30
>  [<ffffffff81238f6a>] ext4_release_dir+0x1a/0x20
>  [<ffffffff8119f57a>] __fput+0xba/0x240
>  [<ffffffff8119f70e>] ____fput+0xe/0x10
>  [<ffffffff8107ca58>] task_work_run+0xc8/0xf0
>  [<ffffffff81014d7a>] do_notify_resume+0xaa/0xc0
>  [<ffffffff8170d0da>] int_signal+0x12/0x17
> Code: 90 90 90 66 66 66 66 90 55 48 89 e5 41 56 41 55 49 89 fd 41 54
> 53 48 8b 1f 48 85 db 74 67 48 8b 43 10 eb 11 0f 1f 80 00 00 00 00 <48>
> 8b 50 10 48 89 c3 48 89 d0 48 85 c0 75 f1 48 8b 43 08 48 85
> RIP [<ffffffff81238188>] free_rb_tree_fname+0x28/0xb0
>  RSP <ffff8801134a9b78>
> ---[ end trace 02741f61e6b3c24c ]---
> Fixing recursive fault but reboot is needed!
--
Daniel J Blueman
