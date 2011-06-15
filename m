From: =?ISO-8859-15?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
Subject: Re: another ext3 kernel BUG
Date: Wed, 15 Jun 2011 11:09:44 +0300
Message-ID: <4DF868C8.3040903@gmail.com>
References: <4DF6C541.5050805@redhat.com> <20110614024307.GA3039@gamma.logic.tuwien.ac.at> <20110614032111.GA5392@redhat.com> <4DF6D644.3010109@redhat.com> <20110611021732.GA18768@gamma.logic.tuwien.ac.at> <20110614011904.GA32521@gamma.logic.tuwien.ac.at> <4DF6C541. <20110615012349.GA19098@gamma.logic.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Norbert Preining <preining@logic.at>, linux-kernel@vger.kernel.org
To: Dave Jones <davej@redhat.com>, Eric Sandeen <sandeen@redhat.com>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36639 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab1FOIJt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Jun 2011 04:09:49 -0400
In-Reply-To: <20110615012349.GA19098@gamma.logic.tuwien.ac.at>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-06-15 04:23, Norbert Preining wrote:
> Hi everyone,
> 
> here we go again.
> 
> On Di, 14 Jun 2011, Norbert Preining wrote:
>>> we've been getting a lot of bug reports in Fedora that have the vbox module
>>> loaded that manifest in various ways that look like it's corrupting kernel data
>>> structures. (Usually it scribbles over some linked list, and the CONFIG_LIST_DEBUG
>>> stuff catches it).
>>
>> Ahh, ok. I thought that if the modules are loaded but NOT in use,
>> in the sense no vbox is running, then they cannot do much harm.
>> At the end it was always on heavy IO load without any vbox interaction.
>>
>> But I will recompile with CONFIG_LIST_DEBUG and see what comes out.
> 
> CONFIG_LIST_DEBUG is compiled in.
> vbox modules are *not* loaded
> again BUG (there is a funny last line ...)
> this is with rc3
> 
> Jun 15 10:12:16 mithrandir kernel: [24645.387482] ------------[ cut here ]------------
> Jun 15 10:12:16 mithrandir kernel: [24645.387516] kernel BUG at fs/inode.c:1368!

Hi,

I just started getting this error too today (I upgrade from 3.0-rc2 ->
3.0-rc3 yesterday).
I also get a warning at WARNING: at fs/fs-writeback.c:356
writeback_single_inode+0xad/0x240(), not just the BUG_ON.

I use ext4, xfs and tmpfs, these errors probably come from ext4 because
I was doing an apt-get install at a time and my root filesystem is ext4.

Apparently this reproduces with either of these, I'll probably try bisecting later today (3.0-rc2 was fine and I've run that for several days):
# apt-get install openjdk-6-jdk
# apt-get remove openjdk-6-jdk

FWIW the Xorg display gets corrupted too, I have to switch to a VT and back in order to get back my desktop (I use KMS).

Here is my mount list, note that /dev/mapper/vgssd-lvssd is a striped logical volume over 2 physical volumes that reside on SSD partitions:

/dev/mapper/vgssd-lvssd on / type ext4 (rw,noatime,nodiratime,discard,errors=remount-ro,commit=0)
tmpfs on /lib/init/rw type tmpfs (rw,nosuid,size=5242880,mode=755,size=5242880,mode=755)
tmpfs on /run type tmpfs (rw,noexec,nosuid,size=10%,mode=755,size=10%,mode=755)
tmpfs on /tmp type tmpfs (rw,noexec,nosuid,nodev,noatime,nodiratime,size=20%,mode=1777)
proc on /proc type proc (rw,noexec,nosuid,nodev)
sysfs on /sys type sysfs (rw,noexec,nosuid,nodev)
udev on /dev type tmpfs (rw,mode=0755)
tmpfs on /run/shm type tmpfs (rw,nosuid,nodev,size=20%,mode=1777,size=20%,mode=1777)
devpts on /dev/pts type devpts (rw,noexec,nosuid,gid=5,mode=620,gid=5,mode=620)
/dev/md0 on /boot type ext3 (rw,noexec,nosuid,nodev,noatime,commit=0)
none on /tmp type tmpfs (rw,noexec,nosuid,nodev,noatime,nodiratime)
/dev/md1p1 on /mnt/home_data type ext4 (rw,nodev,noatime,nodiratime)
/dev/md1p2 on /mnt/var_data type xfs (rw,noatime,nodiratime,logbufs=8,logbsize=256k,logdev=/dev/disk/by-id/scsi-SATA_WDC_WD740ADFD-0_WD-WMARF1007797-part5)
/dev/md1p3 on /mnt/samples type xfs (rw,noexec,nosuid,nodev,noatime,nodiratime,logbufs=8,logbsize=256k,logdev=/dev/disk/by-id/scsi-SATA_WDC_WD740ADFD-0_WD-WMARF1007797-part6)
/dev/md1p4 on /var/cache/rsnapshot type ext4 (rw,noexec,nosuid,noatime,nodiratime,commit=0)
/mnt/var_data/tmp on /var/tmp type none (rw,bind)
/mnt/var_data/cache_apt on /var/cache/apt type none (rw,bind)
/mnt/var_data/libvirt on /var/lib/libvirt type none (rw,bind)
/mnt/var_data/local on /var/local type none (rw,bind)
/mnt/var_data/log on /var/log type none (rw,bind)
/mnt/var_data/buildbot on /var/lib/buildbot type none (rw,bind)
/mnt/home_data on /home/edwin/HDD type none (rw,bind,commit=0)
/mnt/samples on /var/local/samples type none (rw,bind)
rpc_pipefs on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw)
fusectl on /sys/fs/fuse/connections type fusectl (rw)
/var/local/sid-ia32 on /var/lib/schroot/mount/sid-ia32-66022012-37fc-459c-af86-1c25d83a844d type none (rw,bind)
/proc on /var/lib/schroot/mount/sid-ia32-66022012-37fc-459c-af86-1c25d83a844d/proc type none (rw,bind)
/sys on /var/lib/schroot/mount/sid-ia32-66022012-37fc-459c-af86-1c25d83a844d/sys type none (rw,bind)
/dev on /var/lib/schroot/mount/sid-ia32-66022012-37fc-459c-af86-1c25d83a844d/dev type none (rw,bind)
/dev/pts on /var/lib/schroot/mount/sid-ia32-66022012-37fc-459c-af86-1c25d83a844d/dev/pts type none (rw,bind)
/home on /var/lib/schroot/mount/sid-ia32-66022012-37fc-459c-af86-1c25d83a844d/home type none (rw,bind,commit=0)
/tmp on /var/lib/schroot/mount/sid-ia32-66022012-37fc-459c-af86-1c25d83a844d/tmp type none (rw,bind)
/var/local/sid-ia32 on /var/lib/schroot/mount/sid-ia32-8815279a-04c8-4539-9354-e7a49c910490 type none (rw,bind)
/proc on /var/lib/schroot/mount/sid-ia32-8815279a-04c8-4539-9354-e7a49c910490/proc type none (rw,bind)
/sys on /var/lib/schroot/mount/sid-ia32-8815279a-04c8-4539-9354-e7a49c910490/sys type none (rw,bind)
/dev on /var/lib/schroot/mount/sid-ia32-8815279a-04c8-4539-9354-e7a49c910490/dev type none (rw,bind)
/dev/pts on /var/lib/schroot/mount/sid-ia32-8815279a-04c8-4539-9354-e7a49c910490/dev/pts type none (rw,bind)
/home on /var/lib/schroot/mount/sid-ia32-8815279a-04c8-4539-9354-e7a49c910490/home type none (rw,bind,commit=0)
/tmp on /var/lib/schroot/mount/sid-ia32-8815279a-04c8-4539-9354-e7a49c910490/tmp type none (rw,bind)
binfmt_misc on /proc/sys/fs/binfmt_misc type binfmt_misc (rw,noexec,nosuid,nodev)
nfsd on /proc/fs/nfsd type nfsd (rw)

And here is the error:
[ 2862.500029] ------------[ cut here ]------------
[ 2862.500126] kernel BUG at fs/inode.c:1368!
[ 2862.500199] invalid opcode: 0000 [#1] PREEMPT SMP
[ 2862.500295] CPU 0
[ 2862.500332] Modules linked in: xt_CHECKSUM iptable_mangle bridge stp llc powernow_k8 cpufreq_stats cpufreq_powersave cpufreq_ondemand rfcomm cpufreq_conservative bnep cpufreq_userspace binfmt_misc
fuse nfsd nfs lockd sunrpc ipv6 ipt_REJECT xt_state xt_tcpudp iptable_filter ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables radeon ttm
drm_kms_helper drm i2c_algo_bit cfbcopyarea cfbimgblt cfbfillrect freq_table mperf it87 hwmon_vid loop firewire_sbp2 hid_a4tech snd_hda_codec_hdmi usbhid snd_hda_codec_realtek evdev snd_hda_intel
k10temp hwmon snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss btusb snd_pcm bluetooth i2c_piix4 snd_seq_oss snd_seq_midi_event snd_seq snd_timer snd_seq_device snd soundcore snd_page_alloc
parport_pc parport processor wmi button thermal_sys ohci_hcd sr_mod cdrom firewire_ohci firewire_core crc_itu_t ehci_hcd ssb xhci_hcd usbcore [last unloaded: scsi_wait_scan]
[ 2862.501007]
[ 2862.501007] Pid: 6595, comm: rm Not tainted 3.0.0-rc3 #131 Gigabyte Technology Co., Ltd. GA-870A-UD3/GA-870A-UD3
[ 2862.501007] RIP: 0010:[<ffffffff8116d1a6>]  [<ffffffff8116d1a6>] iput+0x176/0x1b0
[ 2862.501007] RSP: 0018:ffff880225a5de48  EFLAGS: 00010202
[ 2862.501007] RAX: 0000000000000000 RBX: ffff8800cb9ed6f0 RCX: 00000001002719c3
[ 2862.501007] RDX: ffff880225070cc0 RSI: ffffffff811d94f0 RDI: ffff8800cb9ed6f0
[ 2862.501007] RBP: ffff880225a5de68 R08: 00cb9ed7180c0000 R09: ffff8800cb9ed640
[ 2862.501007] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8800cb9ed6f0
[ 2862.501007] R13: ffff88001238f6c0 R14: ffff880143f6af5c R15: ffff88022e993a00
[ 2862.501007] FS:  00007f4237387700(0000) GS:ffff88022fc00000(0000) knlGS:0000000000000000
[ 2862.501007] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2862.501007] CR2: 00000000025210f8 CR3: 0000000225053000 CR4: 00000000000006f0
[ 2862.501007] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2862.501007] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2862.501007] Process rm (pid: 6595, threadinfo ffff880225a5c000, task ffff8802112fda40)
[ 2862.501007] Stack:
[ 2862.501007]  ffff880143f6af00 ffff8800cb9ed6f0 ffff88001238f6c0 ffff880143f6af5c
[ 2862.501007]  ffff880225a5de98 ffffffff811691d8 ffff880225a5de98 ffff880143f6af00
[ 2862.501007]  ffff8800cb9ed6f0 ffff88001238f6c0 ffff880225a5dec8 ffffffff81169c19
[ 2862.501007] Call Trace:
[ 2862.501007]  [<ffffffff811691d8>] d_kill+0xf8/0x140
[ 2862.501007]  [<ffffffff81169c19>] dput+0xc9/0x190
[ 2862.501007]  [<ffffffff8115577f>] fput+0x15f/0x210
[ 2862.501007]  [<ffffffff81152171>] filp_close+0x61/0x90
[ 2862.501007]  [<ffffffff81152251>] sys_close+0xb1/0x110
[ 2862.501007]  [<ffffffff814c14fb>] system_call_fastpath+0x16/0x1b
[ 2862.501007] Code: 8b 15 1f 23 8f 00 ff 05 3d 4b a5 00 48 89 05 12 23 8f 00 48 89 42 08 48 89 93 80 00 00 00 48 c7 83 88 00 00 00 a0 f4 a5 81 eb c6 <0f> 0b be 2d 05 00 00 48 c7 c7 fa 09 79 81 e8 17
3c f1 ff e9 dc
[ 2862.501007] RIP  [<ffffffff8116d1a6>] iput+0x176/0x1b0
[ 2862.501007]  RSP <ffff880225a5de48>
[ 2862.541441] ---[ end trace 3fc903d2307ef2ff ]---
[ 2889.624372] ------------[ cut here ]------------
[ 2889.624391] WARNING: at fs/fs-writeback.c:356 writeback_single_inode+0xad/0x240()
[ 2889.624397] Hardware name: GA-870A-UD3
[ 2889.624401] Modules linked in: xt_CHECKSUM iptable_mangle bridge stp llc powernow_k8 cpufreq_stats cpufreq_powersave cpufreq_ondemand rfcomm cpufreq_conservative bnep cpufreq_userspace binfmt_misc
fuse nfsd nfs lockd sunrpc ipv6 ipt_REJECT xt_state xt_tcpudp iptable_filter ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables radeon ttm
drm_kms_helper drm i2c_algo_bit cfbcopyarea cfbimgblt cfbfillrect freq_table mperf it87 hwmon_vid loop firewire_sbp2 hid_a4tech snd_hda_codec_hdmi usbhid snd_hda_codec_realtek evdev snd_hda_intel
k10temp hwmon snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss btusb snd_pcm bluetooth i2c_piix4 snd_seq_oss snd_seq_midi_event snd_seq snd_timer snd_seq_device snd soundcore snd_page_alloc
parport_pc parport processor wmi button thermal_sys ohci_hcd sr_mod cdrom firewire_ohci firewire_core crc_itu_t ehci_hcd ssb xhci_hcd usbcore [last unloaded: scsi_wait_scan]
[ 2889.624546] Pid: 3606, comm: flush-253:0 Tainted: G      D     3.0.0-rc3 #131
[ 2889.624552] Call Trace:
[ 2889.624566]  [<ffffffff81080d9a>] warn_slowpath_common+0x7a/0xb0
[ 2889.624576]  [<ffffffff81080de5>] warn_slowpath_null+0x15/0x20
[ 2889.624584]  [<ffffffff81178a6d>] writeback_single_inode+0xad/0x240
[ 2889.624592]  [<ffffffff81178e6b>] writeback_sb_inodes+0xdb/0x1b0
[ 2889.624599]  [<ffffffff811799ab>] writeback_inodes_wb+0x7b/0x150
[ 2889.624607]  [<ffffffff81179f4b>] wb_writeback+0x4cb/0x520
[ 2889.624615]  [<ffffffff8117a068>] wb_check_old_data_flush+0xc8/0xd0
[ 2889.624623]  [<ffffffff8117a1fd>] wb_do_writeback+0x18d/0x270
[ 2889.624631]  [<ffffffff81090ad2>] ? del_timer_sync+0x32/0x50
[ 2889.624640]  [<ffffffff8108f510>] ? init_timer_deferrable_key+0x20/0x20
[ 2889.624648]  [<ffffffff8117a364>] bdi_writeback_thread+0x84/0x300
[ 2889.624656]  [<ffffffff8117a2e0>] ? wb_do_writeback+0x270/0x270
[ 2889.624664]  [<ffffffff810a1247>] kthread+0x87/0x90
[ 2889.624672]  [<ffffffff814c22d4>] kernel_thread_helper+0x4/0x10
[ 2889.624680]  [<ffffffff810a11c0>] ? kthread_worker_fn+0x190/0x190
[ 2889.624687]  [<ffffffff814c22d0>] ? gs_change+0xb/0xb
[ 2889.624692] ---[ end trace 3fc903d2307ef300 ]---
[ 2889.624698] ------------[ cut here ]------------
[ 2889.624706] WARNING: at fs/fs-writeback.c:356 writeback_single_inode+0xad/0x240()
[ 2889.624711] Hardware name: GA-870A-UD3
[ 2889.624714] Modules linked in: xt_CHECKSUM iptable_mangle bridge stp llc powernow_k8 cpufreq_stats cpufreq_powersave cpufreq_ondemand rfcomm cpufreq_conservative bnep cpufreq_userspace binfmt_misc
fuse nfsd nfs lockd sunrpc ipv6 ipt_REJECT xt_state xt_tcpudp iptable_filter ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables radeon ttm
drm_kms_helper drm i2c_algo_bit cfbcopyarea cfbimgblt cfbfillrect freq_table mperf it87 hwmon_vid loop firewire_sbp2 hid_a4tech snd_hda_codec_hdmi usbhid snd_hda_codec_realtek evdev snd_hda_intel
k10temp hwmon snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss btusb snd_pcm bluetooth i2c_piix4 snd_seq_oss snd_seq_midi_event snd_seq snd_timer snd_seq_device snd soundcore snd_page_alloc
parport_pc parport processor wmi button thermal_sys ohci_hcd sr_mod cdrom firewire_ohci firewire_core crc_itu_t ehci_hcd ssb xhci_hcd usbcore [last unloaded: scsi_wait_scan]
[ 2889.624833] Pid: 3606, comm: flush-253:0 Tainted: G      D W   3.0.0-rc3 #131
[ 2889.624838] Call Trace:
[ 2889.624846]  [<ffffffff81080d9a>] warn_slowpath_common+0x7a/0xb0
[ 2889.624855]  [<ffffffff81080de5>] warn_slowpath_null+0x15/0x20
[ 2889.624862]  [<ffffffff81178a6d>] writeback_single_inode+0xad/0x240
[ 2889.624869]  [<ffffffff81178e6b>] writeback_sb_inodes+0xdb/0x1b0
[ 2889.624877]  [<ffffffff811799ab>] writeback_inodes_wb+0x7b/0x150
[ 2889.624885]  [<ffffffff81179f4b>] wb_writeback+0x4cb/0x520
[ 2889.624893]  [<ffffffff8117a068>] wb_check_old_data_flush+0xc8/0xd0
[ 2889.624901]  [<ffffffff8117a1fd>] wb_do_writeback+0x18d/0x270
[ 2889.624908]  [<ffffffff81090ad2>] ? del_timer_sync+0x32/0x50
[ 2889.624917]  [<ffffffff8108f510>] ? init_timer_deferrable_key+0x20/0x20
[ 2889.624925]  [<ffffffff8117a364>] bdi_writeback_thread+0x84/0x300
[ 2889.624932]  [<ffffffff8117a2e0>] ? wb_do_writeback+0x270/0x270
[ 2889.624940]  [<ffffffff810a1247>] kthread+0x87/0x90
[ 2889.624947]  [<ffffffff814c22d4>] kernel_thread_helper+0x4/0x10
[ 2889.624955]  [<ffffffff810a11c0>] ? kthread_worker_fn+0x190/0x190
[ 2889.624962]  [<ffffffff814c22d0>] ? gs_change+0xb/0xb
[ 2889.624967] ---[ end trace 3fc903d2307ef301 ]---

Best regards,
--Edwin
