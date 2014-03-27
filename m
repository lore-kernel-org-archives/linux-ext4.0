From: dafreedm@gmail.com
Subject: Re: Consistent kernel oops with 3.11.10 & 3.12.9 on Haswell CPUs...
Date: Thu, 27 Mar 2014 06:35:25 -0400
Message-ID: <20140327103525.GF426@ofan>
References: <20140318184909.GA26255@ofan>
 <Pine.LNX.4.64.1403192239560.5202@axis700.grange>
 <20140322123706.GE12444@ofan>
 <alpine.DEB.2.02.1403221415380.18573@ionos.tec.linutronix.de>
 <20140323132535.GE2813@quack.suse.cz> <20140323142609.GK1817@ofan>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ew6BAiZeqk4r7MaW"
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	LKML <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Theodore Ts'o <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Jens Axboe <axboe@kernel.dk>, dafreedm@gmail.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140323142609.GK1817@ofan>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I've attached another oops (initial one from untainted kernel, and
then successive ones) on the same machine.

Please see the HW stress-testing I've already done below (without
seeing such an oops).  Any further suggestions?

Also, how can I tell from the registers you decoded (below) that it's
a bit-flip?  (That way I can look at this stuff more myself,
perhaps)...

Thanks.



On Sun, Mar 23, 2014, Daniel Freedman wrote:
> >   Hum, so decodecode shows:
> > ...
> >   26: 48 85 c0                test   %rax,%rax
> >   29: 74 10                   je     0x3b
> >   2b:*        0f b7 80 ac 05 00 00    movzwl 0x5ac(%rax),%eax         <-- trapping instruction
> >   32: 66 85 c0                test   %ax,%ax
> > ...
> >
> >   And the register has:
> > RAX: f7ff880037267140 RBX: 0000000000001000 RCX: 0000000000000000
> >
> >   So that looks like a bitbflip the upper byte.
> 
> Just for my own knowledge / growth --- how can you tell there's a
> "bitbflip" on the upper byte?
> 
> > So I'd check the hardware first...
> 
> 
> Yes, I absolutely did check the HW first --- and repeatedly (over a
> couple of weeks) --- before reaching out to LKML.
> 
> As described in my original email below, here's what I've done so far:
> 
>   I've been very extensively testing all of the likely culprits among
>   hardware components on both of my servers --- running memtest86 upon
>   boot for 3+ days, memtester in userspace for 24 hours, repeated
>   kernel compiles with various '-j' values, and the 'stress' and
>   'stressapptest' load generators (see below for full details) --- and
>   I have never seen even a hiccup in server operation under such
>   "artificial" environments --- however, it consistently occurs with
>   heavy md5sum operation, and randomly at other times.
> 
> More specifically, here are the exact stept I took to try to implicate
> the HW:
> 
>   aptitude install memtest86+  # reboot and run for 3+ days
> 
>   aptitude install memtester
>   memtester 30G
> 
>   aptitude install linux-source
>   cp /usr/src/linux-source-3.2.tar.bz2 /root/
>   tar xvfj linux-source-3.2.tar.bz2
>   cd linux-source-3.2/
>   make defconfig
>   time make 1>LOG 2>ERR
>   make mrproper
>   make defconfig
>   time make -j16 1>LOG 2>ERR
> 
>   aptitude install stress
>   stress --cpu 8 --io 4 --vm 2 --timeout 10s --dry-run
>   stress --cpu 8 --io 4 --vm 2 --hdd 3 --timeout 60s
>   stress --cpu 8 --io 8 --vm 8 --hdd 4 --timeout 5m
> 
>   aptitude install stressapptest
>   stressapptest -m 8 -i 4 -C 4 -W -s 30
>   stressapptest -m 8 -i 4 -C 4 -W -f /root/sat-file-test --filesize 1gb -s 30
>   stressapptest -m 8 -i 4 -C 4 -W -f /root/sat-file-test --filesize 1024 --random-threads 4 -s 30
>   stressapptest -m 8 -i 4 -C 4 -W --cc_test -s 30
>   stressapptest -m 8 -i 4 -C 4 -W --local_numa -s 30
>   stressapptest -m 8 -i 4 -C 4 -W -n 127.0.0.1 --listen -s 30
>   stressapptest -m 12 -i 6 -C 8 -W -f /root/sat-file-test --filesize 1024 --random-threads 4 -n 127.0.0.1 --listen -s 300
> 
> 
> As mentioned earlier --- I just could not make it oops doing the
> above! (or get any errors in the standalone memtest86+ procedure).
> 
> What do you think?  Should I just keep on stress-testing it somewhat
> indefinitely?  Also, please recall that I have two of the identical
> machines, and I suffer the same problems with both of them (and they
> both pass the above artificial stress-testing).
> 
> Thoughts or suggestions, please, for me to explore further...
> 
> Thanks again!

--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=KernelOops
Content-Transfer-Encoding: quoted-printable

[210799.624492] invalid opcode: 0000 [#1] SMP=20
[210799.624516] Modules linked in: dm_crypt dm_mod parport_pc ppdev lp parp=
ort bnep rfcomm bluetooth rfkill cpufreq_stats cpufreq_userspace cpufreq_co=
nservative cpufreq_powersave nfsd auth_rpcgss oid_registry nfs_acl nfs lock=
d fscache sunrpc netconsole configfs loop raid1 md_mod snd_hda_codec_realte=
k snd_hda_codec_hdmi joydev hid_generic hid_kensington usbhid hid x86_pkg_t=
emp_thermal coretemp kvm_intel kvm snd_hda_intel crct10dif_pclmul snd_hda_c=
odec crc32_pclmul crc32c_intel snd_hwdep snd_pcm ghash_clmulni_intel snd_pa=
ge_alloc snd_seq iTCO_wdt snd_seq_device aesni_intel iTCO_vendor_support ae=
s_x86_64 snd_timer evdev lrw gf128mul i915 glue_helper ablk_helper snd cryp=
td drm_kms_helper soundcore psmouse pcspkr drm lpc_ich mei_me mfd_core seri=
o_raw mei i2c_i801 video button processor ext4 crc16 mbcache jbd2 sg sd_mod=
 crc_t10dif crct10dif_common ahci libahci libata xhci_hcd scsi_mod ehci_pci=
 ehci_hcd e1000e igb i2c_algo_bit i2c_core usbcore dca ptp usb_common pps_c=
ore fan thermal thermal_sys
[210799.624870] CPU: 2 PID: 22239 Comm: Timer Not tainted 3.12-0.bpo.1-amd6=
4 #1 Debian 3.12.9-1~bpo70+1
[210799.624891] Hardware name: Supermicro X10SLQ/X10SLQ, BIOS 1.00 05/09/20=
13
[210799.624908] task: ffff88081a485800 ti: ffff88081ba24000 task.ti: ffff88=
081ba24000
[210799.624927] RIP: 0010:[<ffffffff810c1591>]  [<ffffffff810c1591>] futex_=
requeue+0x721/0x7e0
[210799.624957] RSP: 0018:ffff88081ba25e00  EFLAGS: 00010297
[210799.624974] RAX: 0000000000000002 RBX: 0000000000000000 RCX: 00000000ff=
ffffff
[210799.624991] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007fdb3c=
4173d0
[210799.625008] RBP: 00007fdb3c4173d0 R08: 00007fdb35147608 R09: 0000000000=
000000
[210799.625025] R10: 0000000000000001 R11: 0000000000000206 R12: 0000000000=
000001
[210799.625043] R13: 00007fdb35147608 R14: 0000000000000000 R15: 00007fdb3c=
4173d0
[210799.625060] FS:  00007fdb378ff700(0000) GS:ffff88083fa80000(0000) knlGS=
:0000000000000000
[210799.625079] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[210799.625093] CR2: 00007fdb1f68b000 CR3: 00000007e6c0a000 CR4: 0000000000=
1407e0
[210799.625110] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000=
000000
[210799.625127] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000=
000400
[210799.625144] Stack:
[210799.625150]  ffffffff810c1e34 ffff88081ba25ee8 ffff88081b883000 ffff880=
7ec1fac00
[210799.625173]  ffff88081ba25fd8 ffff88081a485800 0000000100000000 ffff880=
800cde0a8
[210799.625199]  ffff880800cde0f0 0000000000000001 ffffffff811c3e1c 0000000=
000000001
[210799.625223] Call Trace:
[210799.625232]  [<ffffffff810c1e34>] ? do_futex+0x344/0xb00
[210799.625247]  [<ffffffff811c3e1c>] ? fsnotify+0x1dc/0x2d0
[210799.625261]  [<ffffffff810c273b>] ? SyS_futex+0x14b/0x1b0
[210799.625277]  [<ffffffff811856dc>] ? vfs_write+0x17c/0x200
[210799.625293]  [<ffffffff814cb7b9>] ? system_call_fastpath+0x16/0x1b
[210799.625308] Code: 83 44 24 20 01 e9 40 fc ff ff c7 44 24 08 f5 ff ff ff=
 e9 2b fb ff ff c7 44 24 08 00 00 00 00 e9 1e fb ff ff 89 44 24 08 e9 70 fb=
 <ff> ff be 96 04 00 00 48 c7 c7 00 af 6f 81 e8 3c ee f9 ff eb a2=20
[210799.625434] RIP  [<ffffffff810c1591>] futex_requeue+0x721/0x7e0
[210799.625456]  RSP <ffff88081ba25e00>
[210799.630421] ---[ end trace 5197659ccd2d2aa0 ]---
[210799.630429] invalid opcode: 0000 [#2] SMP=20
[210799.630445] Modules linked in: dm_crypt dm_mod parport_pc ppdev lp parp=
ort bnep rfcomm bluetooth rfkill cpufreq_stats cpufreq_userspace cpufreq_co=
nservative cpufreq_powersave nfsd auth_rpcgss oid_registry nfs_acl nfs lock=
d fscache sunrpc netconsole configfs loop raid1 md_mod snd_hda_codec_realte=
k snd_hda_codec_hdmi joydev hid_generic hid_kensington usbhid hid x86_pkg_t=
emp_thermal coretemp kvm_intel kvm snd_hda_intel crct10dif_pclmul snd_hda_c=
odec crc32_pclmul crc32c_intel snd_hwdep snd_pcm ghash_clmulni_intel snd_pa=
ge_alloc snd_seq iTCO_wdt snd_seq_device aesni_intel iTCO_vendor_support ae=
s_x86_64 snd_timer evdev lrw gf128mul i915 glue_helper ablk_helper snd cryp=
td drm_kms_helper soundcore psmouse pcspkr drm lpc_ich mei_me mfd_core seri=
o_raw mei i2c_i801 video button processor ext4 crc16 mbcache jbd2 sg sd_mod=
 crc_t10dif crct10dif_common ahci libahci libata xhci_hcd scsi_mod ehci_pci=
 ehci_hcd e1000e igb i2c_algo_bit i2c_core usbcore dca ptp usb_common pps_c=
ore fan thermal thermal_sys
[210799.630738] CPU: 2 PID: 22239 Comm: Timer Tainted: G      D      3.12-0=
=2Ebpo.1-amd64 #1 Debian 3.12.9-1~bpo70+1
[210799.630758] Hardware name: Supermicro X10SLQ/X10SLQ, BIOS 1.00 05/09/20=
13
[210799.630772] task: ffff88081a485800 ti: ffff88081ba24000 task.ti: ffff88=
081ba24000
[210799.630788] RIP: 0010:[<ffffffff810c1591>]  [<ffffffff810c1591>] futex_=
requeue+0x721/0x7e0
[210799.630807] RSP: 0018:ffff88081ba25a70  EFLAGS: 00010297
[210799.630819] RAX: 0000000000000002 RBX: 0000000000000001 RCX: 00000000ff=
ffffff
[210799.630833] RDX: 0000000000000001 RSI: 0000000000000001 RDI: 00007fdb37=
8ff9d0
[210799.630848] RBP: 00007fdb378ff9d0 R08: 0000000000000000 R09: 0000000000=
000000
[210799.630863] R10: 0000000000000001 R11: 00000000ffffffff R12: 0000000000=
000001
[210799.630878] R13: 0000000000000000 R14: 0000000000000000 R15: 00007fdb37=
8ff9d0
[210799.630894] FS:  0000000000000000(0000) GS:ffff88083fa80000(0000) knlGS=
:0000000000000000
[210799.630910] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[210799.630923] CR2: 00007fdb1f68b000 CR3: 00000007e6c0a000 CR4: 0000000000=
1407e0
[210799.630938] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000=
000000
[210799.630952] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000=
000400
[210799.630967] Stack:
[210799.630972]  ffffffff810c1e34 ffff88081c23a424 000000000000003d 0000000=
000005100
[210799.630993]  0000000000000002 613088081b7d6000 396363640000003d 0000000=
00003376f
[210799.631013]  ffff88081b8d4800 00000000000003e8 0000000000000035 fffffff=
f81a102c0
[210799.631034] Call Trace:
[210799.631041]  [<ffffffff810c1e34>] ? do_futex+0x344/0xb00
[210799.631054]  [<ffffffffa04377e5>] ? write_msg+0xd5/0x140 [netconsole]
[210799.631069]  [<ffffffff810c273b>] ? SyS_futex+0x14b/0x1b0
[210799.631082]  [<ffffffff810aa9c8>] ? console_unlock+0x258/0x3a0
[210799.631096]  [<ffffffff810ee9fc>] ? __delayacct_add_tsk+0x16c/0x180
[210799.631110]  [<ffffffff810c1a0b>] ? exit_robust_list+0x8b/0x170
[210799.631125]  [<ffffffff8105d5cf>] ? mm_release+0xdf/0x120
[210799.631138]  [<ffffffff81062679>] ? do_exit+0x159/0xa80
[210799.631151]  [<ffffffff814bb14f>] ? printk+0x4f/0x54
[210799.631163]  [<ffffffff814c4c48>] ? oops_end+0xa8/0xf0
[210799.631176]  [<ffffffff81014f74>] ? do_invalid_op+0x84/0xa0
[210799.631189]  [<ffffffff810c1591>] ? futex_requeue+0x721/0x7e0
[210799.632160]  [<ffffffff814cce5e>] ? invalid_op+0x1e/0x30
[210799.633105]  [<ffffffff810c1591>] ? futex_requeue+0x721/0x7e0
[210799.634027]  [<ffffffff810c1e34>] ? do_futex+0x344/0xb00
[210799.634921]  [<ffffffff811c3e1c>] ? fsnotify+0x1dc/0x2d0
[210799.635789]  [<ffffffff810c273b>] ? SyS_futex+0x14b/0x1b0
[210799.636631]  [<ffffffff811856dc>] ? vfs_write+0x17c/0x200
[210799.637447]  [<ffffffff814cb7b9>] ? system_call_fastpath+0x16/0x1b
[210799.638254] Code: 83 44 24 20 01 e9 40 fc ff ff c7 44 24 08 f5 ff ff ff=
 e9 2b fb ff ff c7 44 24 08 00 00 00 00 e9 1e fb ff ff 89 44 24 08 e9 70 fb=
 <ff> ff be 96 04 00 00 48 c7 c7 00 af 6f 81 e8 3c ee f9 ff eb a2=20
[210799.640004] RIP  [<ffffffff810c1591>] futex_requeue+0x721/0x7e0
[210799.640844]  RSP <ffff88081ba25a70>
[210799.641677] ---[ end trace 5197659ccd2d2aa1 ]---
[210799.641678] Fixing recursive fault but reboot is needed!
[210799.641675] invalid opcode: 0000 [#3] SMP=20
[210799.644149] Modules linked in: dm_crypt dm_mod parport_pc ppdev lp parp=
ort bnep rfcomm bluetooth rfkill cpufreq_stats cpufreq_userspace cpufreq_co=
nservative cpufreq_powersave nfsd auth_rpcgss oid_registry nfs_acl nfs lock=
d fscache sunrpc netconsole configfs loop raid1 md_mod snd_hda_codec_realte=
k snd_hda_codec_hdmi joydev hid_generic hid_kensington usbhid hid x86_pkg_t=
emp_thermal coretemp kvm_intel kvm snd_hda_intel crct10dif_pclmul snd_hda_c=
odec crc32_pclmul crc32c_intel snd_hwdep snd_pcm ghash_clmulni_intel snd_pa=
ge_alloc snd_seq iTCO_wdt snd_seq_device aesni_intel iTCO_vendor_support ae=
s_x86_64 snd_timer evdev lrw gf128mul i915 glue_helper ablk_helper snd cryp=
td drm_kms_helper soundcore psmouse pcspkr drm lpc_ich mei_me mfd_core seri=
o_raw mei i2c_i801 video button processor ext4 crc16 mbcache jbd2 sg sd_mod=
 crc_t10dif crct10dif_common ahci libahci libata xhci_hcd scsi_mod ehci_pci=
 ehci_hcd e1000e igb i2c_algo_bit i2c_core usbcore dca ptp usb_common pps_c=
ore fan thermal thermal_sys
[210799.649776] CPU: 3 PID: 2555 Comm: rsyslogd Tainted: G      D      3.12=
-0.bpo.1-amd64 #1 Debian 3.12.9-1~bpo70+1
[210799.650754] Hardware name: Supermicro X10SLQ/X10SLQ, BIOS 1.00 05/09/20=
13
[210799.651731] task: ffff88081a70d0c0 ti: ffff88081e926000 task.ti: ffff88=
081e926000
[210799.652710] RIP: 0010:[<ffffffff810c1591>]  [<ffffffff810c1591>] futex_=
requeue+0x721/0x7e0
[210799.653699] RSP: 0018:ffff88081e927e00  EFLAGS: 00010297
[210799.654681] RAX: 0000000000000002 RBX: 0000000000000000 RCX: 00000000ff=
ffffff
[210799.655667] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000000001=
816630
[210799.656648] RBP: 0000000001816630 R08: 0000000001816d80 R09: 0000000000=
000000
[210799.657631] R10: 0000000000000001 R11: 0000000000000206 R12: 0000000000=
000001
[210799.658614] R13: 0000000001816d80 R14: 0000000000000000 R15: 0000000001=
816630
[210799.659599] FS:  00007f6122adb700(0000) GS:ffff88083fac0000(0000) knlGS=
:0000000000000000
[210799.660591] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[210799.661562] CR2: 00007fdb2c029000 CR3: 000000081e4ec000 CR4: 0000000000=
1407e0
[210799.662516] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000=
000000
[210799.663466] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000=
000400
[210799.664410] Stack:
[210799.665349]  ffffffff810c1e34 0000000000000246 0000000000000d37 0000000=
000000001
[210799.666286]  ffffffff81a330c8 ffffffff81a324c8 0000000000000000 0000000=
000000001
[210799.667198]  00000004810ab868 0000000000000001 ffff88081e927fd8 fffffff=
f00000001
[210799.668091] Call Trace:
[210799.668951]  [<ffffffff810c1e34>] ? do_futex+0x344/0xb00
[210799.669794]  [<ffffffff810c273b>] ? SyS_futex+0x14b/0x1b0
[210799.670613]  [<ffffffff81185868>] ? vfs_read+0x108/0x180
[210799.671420]  [<ffffffff81185aaf>] ? SyS_read+0x6f/0xa0
[210799.672216]  [<ffffffff814cb7b9>] ? system_call_fastpath+0x16/0x1b
[210799.673008] Code: 83 44 24 20 01 e9 40 fc ff ff c7 44 24 08 f5 ff ff ff=
 e9 2b fb ff ff c7 44 24 08 00 00 00 00 e9 1e fb ff ff 89 44 24 08 e9 70 fb=
 <ff> ff be 96 04 00 00 48 c7 c7 00 af 6f 81 e8 3c ee f9 ff eb a2=20
[210799.674727] RIP  [<ffffffff810c1591>] futex_requeue+0x721/0x7e0
[210799.675556]  RSP <ffff88081e927e00>
[210799.676389] ---[ end trace 5197659ccd2d2aa2 ]---
[210799.676383] invalid opcode: 0000 [#4] SMP=20
[210799.678069] Modules linked in: dm_crypt dm_mod parport_pc ppdev lp parp=
ort bnep rfcomm bluetooth rfkill cpufreq_stats cpufreq_userspace cpufreq_co=
nservative cpufreq_powersave nfsd auth_rpcgss oid_registry nfs_acl nfs lock=
d fscache sunrpc netconsole configfs loop raid1 md_mod snd_hda_codec_realte=
k snd_hda_codec_hdmi joydev hid_generic hid_kensington usbhid hid x86_pkg_t=
emp_thermal coretemp kvm_intel kvm snd_hda_intel crct10dif_pclmul snd_hda_c=
odec crc32_pclmul crc32c_intel snd_hwdep snd_pcm ghash_clmulni_intel snd_pa=
ge_alloc snd_seq iTCO_wdt snd_seq_device aesni_intel iTCO_vendor_support ae=
s_x86_64 snd_timer evdev lrw gf128mul i915 glue_helper ablk_helper snd cryp=
td drm_kms_helper soundcore psmouse pcspkr drm lpc_ich mei_me mfd_core seri=
o_raw mei i2c_i801 video button processor ext4 crc16 mbcache jbd2 sg sd_mod=
 crc_t10dif crct10dif_common ahci libahci libata xhci_hcd scsi_mod ehci_pci=
 ehci_hcd e1000e igb i2c_algo_bit i2c_core usbcore dca ptp usb_common pps_c=
ore fan thermal thermal_sys
[210799.683833] CPU: 1 PID: 2553 Comm: rs:main Q:Reg Tainted: G      D     =
 3.12-0.bpo.1-amd64 #1 Debian 3.12.9-1~bpo70+1
[210799.684832] Hardware name: Supermicro X10SLQ/X10SLQ, BIOS 1.00 05/09/20=
13
[210799.685830] task: ffff88081def1040 ti: ffff88081e4c8000 task.ti: ffff88=
081e4c8000
[210799.686835] RIP: 0010:[<ffffffff810c1591>]  [<ffffffff810c1591>] futex_=
requeue+0x721/0x7e0
[210799.687844] RSP: 0018:ffff88081e4c9e00  EFLAGS: 00010297
[210799.688847] RAX: 0000000000000002 RBX: 0000000000000000 RCX: 00000000ff=
ffffff
[210799.689856] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000000001=
816630
[210799.690861] RBP: 0000000001816630 R08: 0000000000000000 R09: 0000000000=
000000
[210799.691865] R10: 0000000000000001 R11: 0000000000000206 R12: 0000000000=
000001
[210799.692867] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000001=
816630
[210799.693868] FS:  00007f6123add700(0000) GS:ffff88083fa40000(0000) knlGS=
:0000000000000000
[210799.694875] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[210799.695882] CR2: 00007fd5bae3b000 CR3: 000000081e4ec000 CR4: 0000000000=
1407e0
[210799.696899] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000=
000000
[210799.697916] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000=
000400
[210799.698931] Stack:
[210799.699944]  ffffffff810c1e34 ffff88081e4c9ee8 ffff88080126f000 ffff880=
804350000
[210799.700977]  ffff88081e4c9fd8 ffff88081def1040 0000000100000000 ffff880=
81e7bd3a8
[210799.702012]  ffff88081e7bd3f0 ffffffff810da755 ffffffff811c3e1c 0000000=
000000057
[210799.703050] Call Trace:
[210799.704081]  [<ffffffff810c1e34>] ? do_futex+0x344/0xb00
[210799.705121]  [<ffffffff810da755>] ? from_kgid_munged+0x5/0x10
[210799.706161]  [<ffffffff811c3e1c>] ? fsnotify+0x1dc/0x2d0
[210799.707203]  [<ffffffff810c273b>] ? SyS_futex+0x14b/0x1b0
[210799.708244]  [<ffffffff811856dc>] ? vfs_write+0x17c/0x200
[210799.709260]  [<ffffffff81185b4f>] ? SyS_write+0x6f/0xa0
[210799.710250]  [<ffffffff814cb7b9>] ? system_call_fastpath+0x16/0x1b
[210799.711237] Code: 83 44 24 20 01 e9 40 fc ff ff c7 44 24 08 f5 ff ff ff=
 e9 2b fb ff ff c7 44 24 08 00 00 00 00 e9 1e fb ff ff 89 44 24 08 e9 70 fb=
 <ff> ff be 96 04 00 00 48 c7 c7 00 af 6f 81 e8 3c ee f9 ff eb a2=20
[210799.713354] RIP  [<ffffffff810c1591>] futex_requeue+0x721/0x7e0
[210799.714376]  RSP <ffff88081e4c9e00>
[210799.715401] ---[ end trace 5197659ccd2d2aa3 ]---
[210799.715393] invalid opcode: 0000 [#5] SMP=20
[210799.717470] Modules linked in: dm_crypt dm_mod parport_pc ppdev lp parp=
ort bnep rfcomm bluetooth rfkill cpufreq_stats cpufreq_userspace cpufreq_co=
nservative cpufreq_powersave nfsd auth_rpcgss oid_registry nfs_acl nfs lock=
d fscache sunrpc netconsole configfs loop raid1 md_mod snd_hda_codec_realte=
k snd_hda_codec_hdmi joydev hid_generic hid_kensington usbhid hid x86_pkg_t=
emp_thermal coretemp kvm_intel kvm snd_hda_intel crct10dif_pclmul snd_hda_c=
odec crc32_pclmul crc32c_intel snd_hwdep snd_pcm ghash_clmulni_intel snd_pa=
ge_alloc snd_seq iTCO_wdt snd_seq_device aesni_intel iTCO_vendor_support ae=
s_x86_64 snd_timer evdev lrw gf128mul i915 glue_helper ablk_helper snd cryp=
td drm_kms_helper soundcore psmouse pcspkr drm lpc_ich mei_me mfd_core seri=
o_raw mei i2c_i801 video button processor ext4 crc16 mbcache jbd2 sg sd_mod=
 crc_t10dif crct10dif_common ahci libahci libata xhci_hcd scsi_mod ehci_pci=
 ehci_hcd e1000e igb i2c_algo_bit i2c_core usbcore dca ptp usb_common pps_c=
ore fan thermal thermal_sys
[210799.717487] CPU: 3 PID: 2555 Comm: rsyslogd Tainted: G      D      3.12=
-0.bpo.1-amd64 #1 Debian 3.12.9-1~bpo70+1
[210799.717487] Hardware name: Supermicro X10SLQ/X10SLQ, BIOS 1.00 05/09/20=
13
[210799.717487] task: ffff88081a70d0c0 ti: ffff88081e926000 task.ti: ffff88=
081e926000
[210799.717488] RIP: 0010:[<ffffffff810c1591>]  [<ffffffff810c1591>] futex_=
requeue+0x721/0x7e0
[210799.717489] RSP: 0018:ffff88081e927a70  EFLAGS: 00010297
[210799.717490] RAX: 0000000000000002 RBX: 0000000000000001 RCX: 00000000ff=
ffffff
[210799.717490] RDX: 0000000000000001 RSI: 0000000000000001 RDI: 00007f6122=
adb9d0
[210799.717490] RBP: 00007f6122adb9d0 R08: 0000000000000000 R09: 0000000000=
000000
[210799.717491] R10: 0000000000000001 R11: 00000000ffffffff R12: 0000000000=
000001
[210799.717491] R13: 0000000000000000 R14: 0000000000000000 R15: 00007f6122=
adb9d0
[210799.717491] FS:  0000000000000000(0000) GS:ffff88083fac0000(0000) knlGS=
:0000000000000000
[210799.717492] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[210799.717492] CR2: 00007fdb2c029000 CR3: 000000081e4ec000 CR4: 0000000000=
1407e0
[210799.717493] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000=
000000
[210799.717493] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000=
000400
[210799.717493] Stack:
[210799.717493]  ffffffff810c1e34 ffff8807f92e3400 0000000000000030 fffffff=
f81a102e8
[210799.717494]  00ff880800000000 61320000000003e8 3963636432643261 ffff353=
139373635
[210799.717495]  0000000000000087 0000000000000028 ffffffffa04377e5 ffff880=
7f92e3400
[210799.717496] Call Trace:
[210799.717497]  [<ffffffff810c1e34>] ? do_futex+0x344/0xb00
[210799.717498]  [<ffffffffa04377e5>] ? write_msg+0xd5/0x140 [netconsole]
[210799.717500]  [<ffffffff8116eacd>] ? cache_alloc_refill+0x8d/0x2e0
[210799.717501]  [<ffffffff8101c12f>] ? native_sched_clock+0xf/0x70
[210799.717503]  [<ffffffff8101c195>] ? sched_clock+0x5/0x10
[210799.717504]  [<ffffffff810c273b>] ? SyS_futex+0x14b/0x1b0
[210799.717505]  [<ffffffff8116f97c>] ? kmem_cache_alloc+0x1bc/0x1f0
[210799.717506]  [<ffffffff810ee9fc>] ? __delayacct_add_tsk+0x16c/0x180
[210799.717508]  [<ffffffff810c1a0b>] ? exit_robust_list+0x8b/0x170
[210799.717509]  [<ffffffff8105d5cf>] ? mm_release+0xdf/0x120
[210799.717510]  [<ffffffff81062679>] ? do_exit+0x159/0xa80
[210799.717511]  [<ffffffff814bb14f>] ? printk+0x4f/0x54
[210799.717512]  [<ffffffff814c4c48>] ? oops_end+0xa8/0xf0
[210799.717514]  [<ffffffff81014f74>] ? do_invalid_op+0x84/0xa0
[210799.717516]  [<ffffffff810c1591>] ? futex_requeue+0x721/0x7e0
[210799.717517]  [<ffffffff81095d9e>] ? select_task_rq_fair+0x69e/0x740
[210799.717519]  [<ffffffff810980d4>] ? enqueue_task_fair+0xb44/0xb80
[210799.717520]  [<ffffffff8101c195>] ? sched_clock+0x5/0x10
[210799.717522]  [<ffffffff814cce5e>] ? invalid_op+0x1e/0x30
[210799.717523]  [<ffffffff810c1591>] ? futex_requeue+0x721/0x7e0
[210799.717524]  [<ffffffff810c1e34>] ? do_futex+0x344/0xb00
[210799.717525]  [<ffffffff810c273b>] ? SyS_futex+0x14b/0x1b0
[210799.717526]  [<ffffffff81185868>] ? vfs_read+0x108/0x180
[210799.717527]  [<ffffffff81185aaf>] ? SyS_read+0x6f/0xa0
[210799.717528]  [<ffffffff814cb7b9>] ? system_call_fastpath+0x16/0x1b
[210799.717529] Code: 83 44 24 20 01 e9 40 fc ff ff c7 44 24 08 f5 ff ff ff=
 e9 2b fb ff ff c7 44 24 08 00 00 00 00 e9 1e fb ff ff 89 44 24 08 e9 70 fb=
 <ff> ff be 96 04 00 00 48 c7 c7 00 af 6f 81 e8 3c ee f9 ff eb a2=20
[210799.717541] RIP  [<ffffffff810c1591>] futex_requeue+0x721/0x7e0
[210799.717542]  RSP <ffff88081e927a70>
[210799.717543] invalid opcode: 0000 [#6] SMP=20
[210799.717544] Modules linked in: dm_crypt<4>[210799.717545] ---[ end trac=
e 5197659ccd2d2aa4 ]---
[210799.717545]  dm_mod<1>[210799.717546] Fixing recursive fault but reboot=
 is needed!
[210799.717546]  parport_pc ppdev lp parport bnep rfcomm bluetooth rfkill c=
pufreq_stats cpufreq_userspace cpufreq_conservative cpufreq_powersave nfsd =
auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc netconsole config=
fs loop raid1 md_mod snd_hda_codec_realtek snd_hda_codec_hdmi joydev hid_ge=
neric hid_kensington usbhid hid x86_pkg_temp_thermal coretemp kvm_intel kvm=
 snd_hda_intel crct10dif_pclmul snd_hda_codec crc32_pclmul crc32c_intel snd=
_hwdep snd_pcm ghash_clmulni_intel snd_page_alloc snd_seq iTCO_wdt snd_seq_=
device aesni_intel iTCO_vendor_support aes_x86_64 snd_timer evdev lrw gf128=
mul i915 glue_helper ablk_helper snd cryptd drm_kms_helper soundcore psmous=
e pcspkr drm lpc_ich mei_me mfd_core serio_raw mei i2c_i801 video button pr=
ocessor ext4 crc16 mbcache jbd2 sg sd_mod crc_t10dif crct10dif_common ahci =
libahci libata xhci_hcd scsi_mod ehci_pci ehci_hcd e1000e igb i2c_algo_bit =
i2c_core usbcore dca ptp usb_common pps_core fan thermal thermal_sys
[210799.717588] CPU: 1 PID: 2553 Comm: rs:main Q:Reg Tainted: G      D     =
 3.12-0.bpo.1-amd64 #1 Debian 3.12.9-1~bpo70+1
[210799.717588] Hardware name: Supermicro X10SLQ/X10SLQ, BIOS 1.00 05/09/20=
13
[210799.717589] task: ffff88081def1040 ti: ffff88081e4c8000 task.ti: ffff88=
081e4c8000
[210799.717589] RIP: 0010:[<ffffffff810c1591>]  [<ffffffff810c1591>] futex_=
requeue+0x721/0x7e0
[210799.717592] RSP: 0018:ffff88081e4c9a70  EFLAGS: 00010297
[210799.717592] RAX: 0000000000000002 RBX: 0000000000000001 RCX: 00000000ff=
ffffff
[210799.717593] RDX: 0000000000000001 RSI: 0000000000000001 RDI: 00007f6123=
add9d0
[210799.717593] RBP: 00007f6123add9d0 R08: 0000000000000000 R09: 0000000000=
000000
[210799.717594] R10: 0000000000000001 R11: 00000000ffffffff R12: 0000000000=
000001
[210799.717594] R13: 0000000000000000 R14: 0000000000000000 R15: 00007f6123=
add9d0
[210799.717595] FS:  0000000000000000(0000) GS:ffff88083fa40000(0000) knlGS=
:0000000000000000
[210799.717596] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[210799.717597] CR2: 00007fd5bae3b000 CR3: 000000081e4ec000 CR4: 0000000000=
1407e0
[210799.717597] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000=
000000
[210799.717598] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000=
000400
[210799.717598] Stack:
[210799.717598]  ffffffff810c1e34 ffff8807f92e3400 0000000000000030 fffffff=
f81a102e8
[210799.717600]  00ff880800000000 61330000000003e8 3963636432643261 ffff353=
139373635
[210799.717602]  0000000000000087 0000000000000028 ffffffffa04377e5 ffff880=
7f92e3400
[210799.717604] Call Trace:
[210799.717604]  [<ffffffff810c1e34>] ? do_futex+0x344/0xb00
[210799.717606]  [<ffffffffa04377e5>] ? write_msg+0xd5/0x140 [netconsole]
[210799.717608]  [<ffffffff8101c12f>] ? native_sched_clock+0xf/0x70
[210799.717610]  [<ffffffff8101c195>] ? sched_clock+0x5/0x10
[210799.717612]  [<ffffffff810c273b>] ? SyS_futex+0x14b/0x1b0
[210799.717613]  [<ffffffff8108756c>] ? down_trylock+0x2c/0x40
[210799.717615]  [<ffffffff810ee9fc>] ? __delayacct_add_tsk+0x16c/0x180
[210799.717617]  [<ffffffff810c1a0b>] ? exit_robust_list+0x8b/0x170
[210799.717619]  [<ffffffff8105d5cf>] ? mm_release+0xdf/0x120
[210799.717621]  [<ffffffff81062679>] ? do_exit+0x159/0xa80
[210799.717622]  [<ffffffff814bb14f>] ? printk+0x4f/0x54
[210799.717624]  [<ffffffff814c4c48>] ? oops_end+0xa8/0xf0
[210799.717625]  [<ffffffff81014f74>] ? do_invalid_op+0x84/0xa0
[210799.717627]  [<ffffffff810c1591>] ? futex_requeue+0x721/0x7e0
[210799.717629]  [<ffffffff814cce5e>] ? invalid_op+0x1e/0x30
[210799.717630]  [<ffffffff810c1591>] ? futex_requeue+0x721/0x7e0
[210799.717632]  [<ffffffff810c1e34>] ? do_futex+0x344/0xb00
[210799.717633]  [<ffffffff810da755>] ? from_kgid_munged+0x5/0x10
[210799.717635]  [<ffffffff811c3e1c>] ? fsnotify+0x1dc/0x2d0
[210799.717637]  [<ffffffff810c273b>] ? SyS_futex+0x14b/0x1b0
[210799.717638]  [<ffffffff811856dc>] ? vfs_write+0x17c/0x200
[210799.717640]  [<ffffffff81185b4f>] ? SyS_write+0x6f/0xa0
[210799.717641]  [<ffffffff814cb7b9>] ? system_call_fastpath+0x16/0x1b
[210799.717643] Code: 83 44 24 20 01 e9 40 fc ff ff c7 44 24 08 f5 ff ff ff=
 e9 2b fb ff ff c7 44 24 08 00 00 00 00 e9 1e fb ff ff 89 44 24 08 e9 70 fb=
 <ff> ff be 96 04 00 00 48 c7 c7 00 af 6f 81 e8 3c ee f9 ff eb a2=20
[210799.717662] RIP  [<ffffffff810c1591>] futex_requeue+0x721/0x7e0
[210799.717663]  RSP <ffff88081e4c9a70>
[210799.717664] ---[ end trace 5197659ccd2d2aa5 ]---
[210799.717664] Fixing recursive fault but reboot is needed!
[212136.276450] workrave[22140]: segfault at 21 ip 0000000000000021 sp 0000=
7fff17e75df8 error 14 in workrave[400000+15e000]
[212219.839684] workrave[24488]: segfault at 656d69746c7d ip 00007fadceb6e3=
5d sp 00007fff5ac3c870 error 4 in libglib-2.0.so.0.3200.4[7fadceb01000+f500=
0]
[227769.748991] traps: workrave[25273] general protection ip:4f3a49 sp:7fff=
b9a6e8a0 error:0 in workrave[400000+15e000]

--ew6BAiZeqk4r7MaW--
