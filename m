From: Eric Whitney <enwlinux@gmail.com>
Subject: Re: ext4_mb_generate_buddy: 18745 clusters in bitmap, 18746 in gd;
 block bitmap corrupt
Date: Thu, 31 Jul 2014 19:30:07 -0400
Message-ID: <20140731233007.GA2454@wallace>
References: <20140731195138.GA22842@hexapodia.org>
 <20140731203303.GB22842@hexapodia.org>
 <20140731225311.GC22842@hexapodia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andy Isaacson <adi@hexapodia.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qg0-f51.google.com ([209.85.192.51]:60914 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbaGaXaL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Jul 2014 19:30:11 -0400
Received: by mail-qg0-f51.google.com with SMTP id a108so4745515qge.38
        for <linux-ext4@vger.kernel.org>; Thu, 31 Jul 2014 16:30:10 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140731225311.GC22842@hexapodia.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It's likely your problem was fixed by a commit in 3.15.6.  The symptoms you
describe are very familiar:

f9ae9cf5d7 - ext4: revert commit which was causing fs corruption after journal
replays

Eric


* Andy Isaacson <adi@hexapodia.org>:
> Ran with 3.14.9 long enough to pull and build, then 3.15.7 booted
> successfully where 3.15.5 had failed several times in a row.
> 
> -andy
> 
> On Thu, Jul 31, 2014 at 01:33:03PM -0700, Andy Isaacson wrote:
> > 3.14.9 boots just fine after a fsck.
> > 
> > -andy
> > 
> > On Thu, Jul 31, 2014 at 12:51:38PM -0700, Andy Isaacson wrote:
> > > 3.15.5 amd64, ext4 rootfs on LVM on LUKS on Samsung SSD 840 EVO on
> > > Thinkpad T440s.
> > > 
> > > System has been quite stable for ~9 months, always running a very recent
> > > stable tree.
> > > 
> > > kernel panicked this morning probably due to an external drive
> > > triggering UAS errors in 3.15 (but the syslog didn't make it to disk
> > > alas).  The system remained powered on for >30 seconds after the panic,
> > > finally I shut down by holding down the power button.  So there should
> > > not have been any writes in flight to the SSD.
> > > 
> > > After reboot, rootfs was deeply unhappy:
> > > 
> > > [    7.248400] EXT4-fs (dm-1): INFO: recovery required on readonly filesystem
> > > [    7.248404] EXT4-fs (dm-1): write access will be enabled during recovery
> > > [    7.303580] EXT4-fs (dm-1): orphan cleanup on readonly fs
> > > [    7.326277] EXT4-fs (dm-1): 10 orphan inodes deleted
> > > [    7.326280] EXT4-fs (dm-1): recovery complete
> > > [    7.380065] EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: (null)
> > > ...
> > > [    8.829221] EXT4-fs (dm-1): re-mounted. Opts: errors=remount-ro
> > > ...
> > > [   39.354383] EXT4-fs error (device dm-1): ext4_mb_generate_buddy:756: group 835, 18745 clusters in bitmap, 18746 in gd; block bitmap corrupt.
> > > [   39.354389] Aborting journal on device dm-1-8.
> > > [   39.354478] EXT4-fs (dm-1): Remounting filesystem read-only
> > > [   39.354485] ------------[ cut here ]------------
> > > [   39.354517] WARNING: CPU: 0 PID: 2312 at fs/ext4/ext4_jbd2.c:259 __ext4_handle_dirty_metadata+0xf4/0x1a4 [ext4]()
> > > [   39.354519] Modules linked in: snd_hda_codec_realtek snd_hda_codec_hdmi snd_hda_codec_generic nls_utf8 nls_cp437 vfat fat ext2 joydev uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core videodev arc4 media ecb btusb bluetooth 6lowpan_iphc x86_pkg_temp_thermal intel_rapl kvm_intel iwlmvm kvm mac80211 pcspkr psmouse evdev serio_raw iwlwifi snd_hda_intel snd_hda_controller cfg80211 i2c_i801 snd_hda_codec snd_hwdep snd_pcm snd_seq i915 snd_seq_device thinkpad_acpi snd_timer nvram tpm_tis rfkill battery tpm ac drm_kms_helper drm snd video acpi_cpufreq intel_gtt shpchp i2c_algo_bit intel_smartconnect i2c_core soundcore button processor loop fuse autofs4 ext4 crc16 jbd2 mbcache hid_generic usbhid hid dm_crypt dm_mod sg sd_mod crc_t10dif crct10dif_generic crct10dif_common rtsx_pci_
 sdmmc mmc_core ahci e1000e ptp pps_core aesni_intel libahci aes_x86_64 glue_helper libata lrw gf128mul ablk_helper cryptd scsi_mod ehci_pci ehci_hcd xhci_hcd rtsx_pci mfd_core usbcore thermal usb_common thermal_sys
> > > [   39.354598] CPU: 0 PID: 2312 Comm: systemd-tmpfile Not tainted 3.15.5 #19
> > > [   39.354600] Hardware name: LENOVO 20AQCTO1WW/20AQCTO1WW, BIOS GJET61WW (2.11 ) 10/02/2013
> > > [   39.354602]  0000000000000000 ffff880213c67b78 ffffffff81378c2a 0000000000000000
> > > [   39.354605]  ffff880213c67bb0 ffffffff8103dc62 ffffffffa03a3d33 ffff8800d607eea0
> > > [   39.354608]  00000000ffffffe2 0000000000000000 ffff8800d60a3030 ffff880213c67bc0
> > > [   39.354611] Call Trace:
> > > [   39.354617]  [<ffffffff81378c2a>] dump_stack+0x45/0x56
> > > [   39.354621]  [<ffffffff8103dc62>] warn_slowpath_common+0x7f/0x98
> > > [   39.354643]  [<ffffffffa03a3d33>] ? __ext4_handle_dirty_metadata+0xf4/0x1a4 [ext4]
> > > [   39.354648]  [<ffffffff8103dd2e>] warn_slowpath_null+0x1a/0x1c
> > > [   39.354666]  [<ffffffffa03a3d33>] __ext4_handle_dirty_metadata+0xf4/0x1a4 [ext4]
> > > [   39.354686]  [<ffffffffa03aa380>] ext4_free_blocks+0x713/0x809 [ext4]
> > > [   39.354704]  [<ffffffffa03a0639>] ext4_ext_remove_space+0x698/0xbdc [ext4]
> > > [   39.354723]  [<ffffffffa03af7b1>] ? __es_remove_extent+0x46/0x27d [ext4]
> > > [   39.354741]  [<ffffffffa03a246f>] ext4_ext_truncate+0x89/0xad [ext4]
> > > [   39.354756]  [<ffffffffa0383024>] ext4_truncate+0x199/0x281 [ext4]
> > > [   39.354770]  [<ffffffffa038379b>] ext4_evict_inode+0x1a7/0x2d0 [ext4]
> > > [   39.354775]  [<ffffffff8113f390>] evict+0xa8/0x14c
> > > [   39.354778]  [<ffffffff8113fa75>] iput+0x12d/0x136
> > > [   39.354783]  [<ffffffff81136d5b>] do_unlinkat+0x14e/0x1f4
> > > [   39.354788]  [<ffffffff8112bfe9>] ? ____fput+0xe/0x10
> > > [   39.354794]  [<ffffffff8105659d>] ? task_work_run+0x87/0x98
> > > [   39.354798]  [<ffffffff81137b98>] SyS_unlinkat+0x29/0x2b
> > > [   39.354802]  [<ffffffff81137b98>] ? SyS_unlinkat+0x29/0x2b
> > > [   39.354807]  [<ffffffff8137d0d2>] system_call_fastpath+0x16/0x1b
> > > [   39.354810] ---[ end trace 80365b8da4738adc ]---
> > > [   39.354814] EXT4: jbd2_journal_dirty_metadata failed: handle type 5 started at line 241, credits 91/89, errcode -30
> > > [   39.354817] EXT4: jbd2_journal_dirty_metadata failed: handle type 5 started at line 241, credits 91/89, errcode -30<2>[   39.354821] EXT4-fs error (device dm-1) in ext4_free_blocks:4867: Journal has aborted
> > > [   39.354906] EXT4-fs error (device dm-1) in ext4_reserve_inode_write:4879: Journal has aborted
> > > [   39.354976] EXT4-fs error (device dm-1) in ext4_reserve_inode_write:4879: Journal has aborted
> > > [   39.355042] EXT4-fs error (device dm-1) in ext4_ext_remove_space:3018: Journal has aborted
> > > [   39.355109] EXT4-fs error (device dm-1) in ext4_ext_truncate:4666: Journal has aborted
> > > [   39.355179] EXT4-fs error (device dm-1) in ext4_reserve_inode_write:4879: Journal has aborted
> > > [   39.355248] EXT4-fs error (device dm-1) in ext4_truncate:3790: Journal has aborted
> > > [   39.355314] EXT4-fs error (device dm-1) in ext4_reserve_inode_write:4879: Journal has aborted
> > > [   39.355382] EXT4-fs error (device dm-1) in ext4_orphan_del:2684: Journal has aborted
> > > 
> > > 
> > > Rebooted again and rootfs came up dirty, of course, but journal seems
> > > sadder than expected:
> > > 
> > > [   12.465200] EXT4-fs (dm-1): warning: mounting fs with errors, running e2fsck is recommended
> > > [   12.465403] EXT4-fs (dm-1): re-mounted. Opts: errors=remount-ro
> > > [   12.504024] systemd-journald[230]: Received request to flush runtime journal from PID 1
> > > [   12.506433] EXT4-fs error (device dm-1): ext4_free_inode:323: comm systemd-tmpfile: bit already cleared for inode 3801146
> > > [   12.506527] Aborting journal on device dm-1-8.
> > > [   12.506950] EXT4-fs (dm-1): Remounting filesystem read-only
> > > [   12.506957] EXT4-fs error (device dm-1) in ext4_evict_inode:310: IO failure
> > > [   12.506991] EXT4-fs error (device dm-1): mb_free_blocks:1441: group 464, block 15212940:freeing already freed block (bit 8588); block bitmap corrupt.
> > > [   12.507004] EXT4-fs error (device dm-1): ext4_mb_generate_buddy:756: group 464, 24180 clusters in bitmap, 24181 in gd; block bitmap corrupt.
> > > 
> > > 
> > > fsck claims to have fixed it but on reboot it blows up the same way:
> > > 
> > > e2fsck 1.42.11 (09-Jul-2014)
> > > /dev/mapper/t440s-root: recovering journal
> > > /dev/mapper/t440s-root contains a file system with errors, check forced.
> > > Pass 1: Checking inodes, blocks, and sizes
> > > Pass 2: Checking directory structure
> > > Pass 3: Checking directory connectivity
> > > Unconnected directory inode 3801092 (/tmp/???)
> > > Connect to /lost+found<y>? yes
> > > Unconnected directory inode 3801093 (/tmp/???)
> > > Connect to /lost+found<y>? yes
> > > Unconnected directory inode 3801106 (/tmp/???)
> > > Connect to /lost+found<y>? yes
> > > Unconnected directory inode 3801107 (/lost+found/#3801106/???)
> > > Connect to /lost+found<y>? yes
> > > Unconnected directory inode 3801111 (/tmp/???)
> > > Connect to /lost+found<y>? yes
> > > Unconnected directory inode 3801116 (/tmp/???)
> > > Connect to /lost+found<y>? yes
> > > Unconnected directory inode 3801118 (/tmp/???)
> > > Connect to /lost+found<y>? yes
> > > Pass 4: Checking reference counts
> > > Inode 3801089 ref count is 61, should be 42.  Fix<y>? yes
> > > Inode 3801092 ref count is 3, should be 2.  Fix<y>? yes
> > > Inode 3801093 ref count is 3, should be 2.  Fix<y>? yes
> > > Unattached inode 3801099
> > > Connect to /lost+found<y>? yes
> > > Inode 3801099 ref count is 2, should be 1.  Fix<y>? yes
> > > Unattached inode 3801103
> > > Connect to /lost+found<y>? yes
> > > Inode 3801103 ref count is 2, should be 1.  Fix<y>? yes
> > > Inode 3801106 ref count is 3, should be 2.  Fix<y>? yes
> > > Inode 3801107 ref count is 3, should be 2.  Fix<y>? yes
> > > Inode 3801111 ref count is 3, should be 2.  Fix<y>? yes
> > > Unattached inode 3801112
> > > Connect to /lost+found<y>? yes
> > > Inode 3801112 ref count is 2, should be 1.  Fix<y>? yes
> > > Inode 3801116 ref count is 3, should be 2.  Fix<y>? yes
> > > Inode 3801118 ref count is 3, should be 2.  Fix<y>? yes
> > > 
> > > Pass 5: Checking group summary information
> > > Block bitmap differences:  -(15212585--15212586) -(15212756--15212757) -15212761 -15212765 -15212883 -15212886 -(15212888--15212891) -15212905 -15212907 -15212911 -(15212923--15212924) -15212938 -15212940 -15213385 +15237175 +(27371328--27371391) +(27427126--27427191) +(27427648--27427711) +82127850
> > > Fix<y>? yes
> > > Free blocks count wrong for group #464 (24160, counted=24180).
> > > Fix<y>? yes
> > > Free blocks count wrong for group #465 (25520, counted=25827).
> > > Fix<y>? yes
> > > Free blocks count wrong for group #835 (18809, counted=18745).
> > > Fix<y>? yes
> > > Free blocks count wrong for group #837 (23154, counted=23024).
> > > Fix<y>? yes
> > > Free blocks count wrong for group #2506 (28536, counted=28535).
> > > Fix<y>? yes
> > > Free blocks count wrong for group #2842 (2415, counted=2478).
> > > Fix<y>? yes
> > > Free blocks count wrong for group #2844 (27816, counted=28135).
> > > Fix<y>? yes
> > > Free blocks count wrong (108044209, counted=108044918).
> > > Fix<y>? yes
> > > Inode bitmap differences:  -3801122 -3801126 -(3801128--3801129) -3801134 -3801137 -(3801139--3801142) -3801146 -(3801149--3801150) -(3801152--3801154) -3801158 -3801160 -3801168 -(3801176--3801179) -(3801182--3801183) -3801186 -3801189 -3801193 -(3801199--3801200) -(3801203--3801205) -(3801208--3801211) -(3801213--3801214) -3801216 -3801220 -(3801223--3801224) -3801226 -(3801228--3801232) -(3801238--3801239) -3801738 -3801753 -3801755 -(3801758--3801759) -(3801762--3801763) -3801769 -3801792 -(3801805--3801806) -3801809 -(3801813--3801817) -3801822 -(3801826--3801828) -(3801832--3801834) -(3801836--3801837) -(3801842--3801843) -3801848 -3801853 -3801857 -(3801863--3801864) -3801871 -(3801873--3801876) -3801879 -3801881 -3801883 -3801885 -(3801888--3801889) -(3801891--3801892) -(3801
 896--3801897) -3801899 -(3801901--3801902) -(3801905--3801906) -(3801909--3801910) -3801912 -3801914 -(3801920--3801921) -(3801923--3801924) -3801926 -3802690 -3805907
> > > Fix<y>? yes
> > > Free inodes count wrong for group #464 (6581, counted=6696).
> > > Fix<y>? yes
> > > Directories count wrong for group #464 (366, counted=346).
> > > Fix<y>? yes
> > > Free inodes count wrong (29348331, counted=29348445).
> > > Fix<y>? yes
> > > 
> > > /dev/mapper/t440s-root: ***** FILE SYSTEM WAS MODIFIED *****
> > > /dev/mapper/t440s-root: ***** REBOOT LINUX *****
> > > /dev/mapper/t440s-root: 617891/29966336 files (0.7% non-contiguous), 11796874/119841792 blocks
> > > 
> > > 
> > > After fsck reports clean, reboot still shows failures:
> > > 
> > > 
> > > [    7.378361] EXT4-fs (dm-1): INFO: recovery required on readonly filesystem
> > > [    7.378365] EXT4-fs (dm-1): write access will be enabled during recovery
> > > [    7.384663] EXT4-fs (dm-1): recovery complete
> > > [    7.386479] EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: (null)
> > > 
> > > [    7.710694] EXT4-fs (dm-1): re-mounted. Opts: errors=remount-ro
> > > 
> > > [    9.820974] EXT4-fs error (device dm-1): ext4_mb_generate_buddy:756: group 465, 29923 clusters in bitmap, 29922 in gd; block bitmap corrupt.
> > > [    9.820975] Aborting journal on device dm-1-8.
> > > [    9.821614] EXT4-fs (dm-1): Remounting filesystem read-only
> > > 
> > > 
> > > Similar repeated problems repeat on every reboot.
> > > 
> > > SMART stats on the SSD do not indicate any signs of failing hardware:
> > > 
> > > Device Model:     Samsung SSD 840 EVO 500GB
> > > Serial Number:    S1DHNSAD929048M
> > > LU WWN Device Id: 5 002538 8a00452f8
> > > Firmware Version: EXT0BB0Q
> > > User Capacity:    500,107,862,016 bytes [500 GB]
> > > Sector Size:      512 bytes logical/physical
> > > Rotation Rate:    Solid State Device
> > > Device is:        Not in smartctl database [for details use: -P showall]
> > > ATA Version is:   ACS-2, ATA8-ACS T13/1699-D revision 4c
> > > SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
> > > Local Time is:    Thu Jul 31 12:36:59 2014 PDT
> > > ...
> > > ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
> > >   5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail  Always       -       0
> > >   9 Power_On_Hours          0x0032   099   099   000    Old_age   Always       -       1693
> > >  12 Power_Cycle_Count       0x0032   099   099   000    Old_age   Always       -       165
> > > 177 Wear_Leveling_Count     0x0013   099   099   000    Pre-fail  Always       -       2
> > > 179 Used_Rsvd_Blk_Cnt_Tot   0x0013   100   100   010    Pre-fail  Always       -       0
> > > 181 Program_Fail_Cnt_Total  0x0032   100   100   010    Old_age   Always       -       0
> > > 182 Erase_Fail_Count_Total  0x0032   100   100   010    Old_age   Always       -       0
> > > 183 Runtime_Bad_Block       0x0013   100   100   010    Pre-fail  Always       -       0
> > > 187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always       -       0
> > > 190 Airflow_Temperature_Cel 0x0032   069   053   000    Old_age   Always       -       31
> > > 195 Hardware_ECC_Recovered  0x001a   200   200   000    Old_age   Always       -       0
> > > 199 UDMA_CRC_Error_Count    0x003e   100   100   000    Old_age   Always       -       0
> > > 235 Unknown_Attribute       0x0012   099   099   000    Old_age   Always       -       7
> > > 241 Total_LBAs_Written      0x0032   099   099   000    Old_age   Always       -       2102932957
> > > 
> > > -andy
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
