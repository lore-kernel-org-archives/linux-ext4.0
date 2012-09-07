From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: ext4 crash with 3.5.2 in ext4_ext_remove_space
Date: Fri, 7 Sep 2012 11:39:53 -0400 (EDT)
Message-ID: <alpine.LFD.2.00.1209071139320.18459@new-host-2>
References: <alpine.LFD.2.00.1207252023080.4340@(none)> <20120726033223.GA5884@thunk.org> <20120726065412.GB20315@merlins.org> <20120801053042.GG12695@merlins.org> <20120816075004.GE8802@merlins.org> <502CC2A2.4010506@shiftmail.org> <20120816175540.GH8802@merlins.org>
 <20120905165210.GD6955@merlins.org> <alpine.LFD.2.00.1209051349470.509@new-host-2> <20120906042426.GC26051@merlins.org> <20120907151942.GA16562@merlins.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463810303-721624237-1347032395=:18459"
Cc: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753Ab2IGPkJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Sep 2012 11:40:09 -0400
In-Reply-To: <20120907151942.GA16562@merlins.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463810303-721624237-1347032395=:18459
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Fri, 7 Sep 2012, Marc MERLIN wrote:

> Date: Fri, 7 Sep 2012 08:19:42 -0700
> From: Marc MERLIN <marc@merlins.org>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: ext4 crash with 3.5.2 in ext4_ext_remove_space
> 
> On Wed, Sep 05, 2012 at 09:24:26PM -0700, Marc MERLIN wrote:
> > On Wed, Sep 05, 2012 at 01:50:54PM -0400, Lukáš Czerner wrote:
> > > Hi,
> > > 
> > > I believe that this has been fixed with v3.6-rc1-5-g89a4e48 and it
> > > was marked for stable release as well.
> > 
> > If that helps, it was indeed a single orphaned inode. After clearing it, 
> > I was able to mount the partition without problems.
> > 
> > gargamel:~# e2fsck -y /dev/mapper/dshelf2-space
> > e2fsck 1.42.5 (29-Jul-2012)
> > /dev/mapper/dshelf2-space: recovering journal
> > Clearing orphaned inode 92668757 (uid=1002, gid=8, mode=0100660, size=6574695342)
> > /dev/mapper/dshelf2-space: clean, 16987882/114098176 files, 426716110/456392704 blocks
> 
> Would you happen to have a link to the patch, I had this crash again, I'd
> like to check if it's in 3.5.3 or apply it myself to stop further crashes.
> 
> Thanks,
> Marc

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=89a4e48f8479f8145eca9698f39fe188c982212f

-Lukas


>  
> > Cheers,
> > Marc
> > 
> > > -Lukas
> > > 
> > > On Wed, 5 Sep 2012, Marc MERLIN wrote:
> > > 
> > > > Date: Wed, 5 Sep 2012 09:52:10 -0700
> > > > From: Marc MERLIN <marc@merlins.org>
> > > > To: linux-ext4@vger.kernel.org
> > > > Subject: ext4 crash with 3.5.2 in ext4_ext_remove_space
> > > > 
> > > > I get a crash when mounting a filesystem.
> > > > I'm making an image now with e2image -r before I run e2fsck on it.
> > > > 
> > > > Is there anything else you'd like me to do?
> > > > 
> > > > [13090.175424] BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
> > > > [13090.184897] IP: [<ffffffff8119b92f>] ext4_ext_remove_space+0x83d/0xb51
> > > > [13090.192927] PGD 1120d7067 PUD 1123ac067 PMD 0 
> > > > [13090.198469] Oops: 0000 [#1] PREEMPT SMP 
> > > > [13090.203508] CPU 1 
> > > > [13090.205368] Modules linked in:[13090.209508]  ppdev lp tun autofs4 raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx sata_mv kl5kusb105 ftdi_sio keyspan nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc ipt_REJECT xt_state xt_tcpudp xt_LOG iptable_mangle iptable_filter deflate ctr twofish_generic twofish_x86_64_3way twofish_x86_64 twofish_common camellia_generic camellia_x86_64 serpent_sse2_x86_64 lrw serpent_generic xts gf128mul cast5 des_generic xcbc rmd160 sha512_generic crypto_null af_key xfrm_algo blowfish_generic blowfish_x86_64 blowfish_common dm_crypt dm_mirror dm_region_hash dm_log aes_x86_64 fuse lm85 hwmon_vid dm_snapshot dm_mod iptable_nat ip_tables nf_conntrack_ftp ipt_MASQUERADE nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 x_tables nf_connt
 rack sg st snd_pcm_oss snd_mixer_oss snd_hda_codec_hdmi snd_hda_codec_realtek rc_ati_x10 ati_remote rc_core pl2303 usbserial i915 snd_hda_intel snd_cmipci snd_hda_codec gameport drm_kms_hel!
 per dr!
> > >  m !
> > > >  snd_opl3_lib snd_mpu401_uart eeepc_wmi asus_wmi
> > > >  i2c_algo_bit[13090.315877]  sparse_keymap rfkill snd_hwdep snd_seq_midi acpi_cpufreq snd_seq_midi_event mperf kvm_intel kvm processor snd_seq snd_pcm pci_hotplug ehci_hcd wmi parport_pc xhci_hcd microcode button video sata_sil24 parport snd_rawmidi snd_timer usbcore crc32c_intel ghash_clmulni_intel i2c_i801 snd_seq_device cryptd evdev snd lpc_ich mei i2c_core pcspkr snd_page_alloc thermal_sys usb_common soundcore coretemp r8169 mii tpm_tis tpm tpm_bios [last unloaded: kl5kusb105]
> > > > 
> > > > [13090.370146] Pid: 9658, comm: mount Not tainted 3.5.2-amd64-preempt-noide-20120903 #1 System manufacturer System Product Name/P8H67-M PRO
> > > > [13090.387559] RIP: 0010:[<ffffffff8119b92f>]  [<ffffffff8119b92f>] ext4_ext_remove_space+0x83d/0xb51
> > > > [13090.398254] RSP: 0018:ffff88012b4c7a18  EFLAGS: 00010246
> > > > [13090.406241] RAX: 0000000000000000 RBX: ffff8800a41fb4e8 RCX: ffff8800a41fb450
> > > > [13090.416102] RDX: 0000000000000001 RSI: 0000000000000002 RDI: 000000001b340000
> > > > [13090.426003] RBP: ffff88012b4c7af8 R08: 000000001b340000 R09: ffff88008ae6f6e0
> > > > [13090.435920] R10: ffff880000000000 R11: 0000000000000000 R12: ffff8801156e86f0
> > > > [13090.445782] R13: 0000000000000000 R14: ffff8801156e86c0 R15: 0000000000000000
> > > > [13090.455627] FS:  0000000000000000(0000) GS:ffff88013fa80000(0063) knlGS:00000000f75ae750
> > > > [13090.466451] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
> > > > [13090.475010] CR2: 0000000000000028 CR3: 0000000115614000 CR4: 00000000000407e0
> > > > [13090.484921] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > > [13090.494802] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > > > [13090.504649] Process mount (pid: 9658, threadinfo ffff88012b4c6000, task ffff88008d91c4c0)
> > > > [13090.515567] Stack:
> > > > [13090.520209]  ffff88012b4c7a28 ffffffff81175f65 ffff88012b4c7a88 ffffffff81179c44
> > > > [13090.530426]  ffff880100001000 00000000fffffff5 ffffffffa41fb438 ffff8801156e8748
> > > > [13090.540694]  00000000000a77ff ffff8800a41fb438 0000000008007800 ffff880122e67800
> > > > [13090.551124] Call Trace:
> > > > [13090.556238]  [<ffffffff81175f65>] ? brelse+0xe/0x10
> > > > [13090.564018]  [<ffffffff81179c44>] ? ext4_mark_iloc_dirty+0x51c/0x581
> > > > [13090.573175]  [<ffffffff8119d51c>] ext4_ext_truncate+0xcd/0x179
> > > > [13090.581856]  [<ffffffff81132b1c>] ? __inode_wait_for_writeback+0x67/0xa9
> > > > [13090.591316]  [<ffffffff81177e74>] ext4_truncate+0x9c/0xdf
> > > > [13090.599434]  [<ffffffff8117b721>] ext4_evict_inode+0x1e9/0x2d6
> > > > [13090.608273]  [<ffffffff811282e3>] evict+0xa8/0x162
> > > > [13090.615846]  [<ffffffff81128588>] iput+0x1b3/0x1bb
> > > > [13090.623284]  [<ffffffff8119570d>] ext4_fill_super+0x214b/0x256b
> > > > [13090.631785]  [<ffffffff8128f835>] ? vsnprintf+0x1ce/0x421
> > > > [13090.639778]  [<ffffffff8113f9b2>] ? set_blocksize+0x36/0x86
> > > > [13090.647864]  [<ffffffff811169ae>] mount_bdev+0x14b/0x1ad
> > > > [13090.655707]  [<ffffffff811935c2>] ? ext4_calculate_overhead+0x247/0x247
> > > > [13090.664876]  [<ffffffff8112ada7>] ? alloc_vfsmnt+0xa6/0x198
> > > > [13090.672989]  [<ffffffff81184d5f>] ext4_mount+0x10/0x12
> > > > [13090.680564]  [<ffffffff81117390>] mount_fs+0x64/0x150
> > > > [13090.687944]  [<ffffffff810e5439>] ? __alloc_percpu+0xb/0xd
> > > > [13090.695702]  [<ffffffff8112b156>] vfs_kern_mount+0x64/0xde
> > > > [13090.703435]  [<ffffffff8112b544>] do_kern_mount+0x48/0xda
> > > > [13090.711023]  [<ffffffff8112ce32>] do_mount+0x6a1/0x704
> > > > [13090.718294]  [<ffffffff810e1181>] ? memdup_user+0x38/0x60
> > > > [13090.725767]  [<ffffffff810e11df>] ? strndup_user+0x36/0x4c
> > > > [13090.733260]  [<ffffffff8114ffaa>] compat_sys_mount+0x208/0x242
> > > > [13090.741047]  [<ffffffff814b0b06>] sysenter_dispatch+0x7/0x21
> > > > [13090.748612] Code: ff 4c 63 65 b8 4d 6b e4 30 4c 03 65 b0 e9 fd 00 00 00 48 63 55 b8 4c 6b e2 30 4c 03 65 b0 49 83 7c 24 20 00 75 0e 49 8b 44 24 28 <48> 8b 40 28 49 89 44 24 20 49 8b 44 24 18 48 85 c0 75 22 49 8b 
> > > > [13090.772841] RIP  [<ffffffff8119b92f>] ext4_ext_remove_space+0x83d/0xb51
> > > > [13090.781438]  RSP <ffff88012b4c7a18>
> > > > [13090.786758] CR2: 0000000000000028
> > > > [13090.804674] ---[ end trace 880c73500bb7f09f ]---
> > > > [13090.810808] Kernel panic - not syncing: Fatal exception
> > > > [13090.817346] panic occurred, switching back to text console
> > > > [13090.824556] Rebooting in 20 seconds..
> > > > [13110.758740] ACPI MEMORY or I/O RESET_REG.
> > > > 
> > > 
> > 
> > -- 
> > "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> > Microsoft is to operating systems ....
> >                                       .... what McDonalds is to gourmet cooking
> > Home page: http://marc.merlins.org/
> 
> 
---1463810303-721624237-1347032395=:18459--
