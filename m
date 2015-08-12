From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 102731] I have a cough.
Date: Wed, 12 Aug 2015 09:02:48 +0000
Message-ID: <bug-102731-13602-ySPlwnUA3L@https.bugzilla.kernel.org/>
References: <bug-102731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:57950 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933784AbbHLJCx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Aug 2015 05:02:53 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id AE61F203FB
	for <linux-ext4@vger.kernel.org>; Wed, 12 Aug 2015 09:02:51 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 3251420710
	for <linux-ext4@vger.kernel.org>; Wed, 12 Aug 2015 09:02:49 +0000 (UTC)
In-Reply-To: <bug-102731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=102731

--- Comment #2 from John Hughes <john@calva.com> ---
host uptime:

 10:59:22 up 24 days, 14:21,  2 users,  load average: 0.39, 0.51, 0.90

(Last reboot caused by power cut)

PCI config on host:

00:00.0 Host bridge: Intel Corporation E7230/3000/3010 Memory Controller Hub
00:01.0 PCI bridge: Intel Corporation E7230/3000/3010 PCI Express Root Port
00:1c.0 PCI bridge: Intel Corporation NM10/ICH7 Family PCI Express Port 1 (rev
01)
00:1c.4 PCI bridge: Intel Corporation 82801GR/GH/GHM (ICH7 Family) PCI Express
Port 5 (rev 01)
00:1c.5 PCI bridge: Intel Corporation 82801GR/GH/GHM (ICH7 Family) PCI Express
Port 6 (rev 01)
00:1d.0 USB controller: Intel Corporation NM10/ICH7 Family USB UHCI Controller
#1 (rev 01)
00:1d.1 USB controller: Intel Corporation NM10/ICH7 Family USB UHCI Controller
#2 (rev 01)
00:1d.2 USB controller: Intel Corporation NM10/ICH7 Family USB UHCI Controller
#3 (rev 01)
00:1d.7 USB controller: Intel Corporation NM10/ICH7 Family USB2 EHCI Controller
(rev 01)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev e1)
00:1f.0 ISA bridge: Intel Corporation 82801GB/GR (ICH7 Family) LPC Interface
Bridge (rev 01)
00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE Controller
(rev 01)
00:1f.3 SMBus: Intel Corporation NM10/ICH7 Family SMBus Controller (rev 01)
01:00.0 PCI bridge: Intel Corporation 6702PXH PCI Express-to-PCI Bridge A (rev
09)
01:00.1 PIC: Intel Corporation 6700/6702PXH I/OxAPIC Interrupt Controller A
(rev 09)
02:08.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1068 PCI-X
Fusion-MPT SAS (rev 01)
03:00.0 PCI bridge: Intel Corporation 6702PXH PCI Express-to-PCI Bridge A (rev
09)
04:01.0 SCSI storage controller: Adaptec AHA-3960D / AIC-7899A U160/m (rev 01)
04:01.1 SCSI storage controller: Adaptec AHA-3960D / AIC-7899A U160/m (rev 01)
04:02.0 Ethernet controller: Intel Corporation 82543GC Gigabit Ethernet
Controller (Copper) (rev 02)
05:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5721 Gigabit
Ethernet PCI Express (rev 11)
07:00.0 Ethernet controller: Altima (nee Broadcom) AC9100 Gigabit Ethernet (rev
15)
07:05.0 VGA compatible controller: Advanced Micro Devices [AMD] nee ATI ES1000
(rev 02)


Disk configuration on host:

[0:0:0:0]    cd/dvd  LITE-ON  CD-ROM LTN-4891S NDS3  /dev/sr0 
[2:0:0:0]    disk    HITACHI  HUS151473VL3800  S110  /dev/sda 
[2:0:1:0]    disk    FUJITSU  MAP3735NC        5605  /dev/sdb 
[2:0:2:0]    disk    FUJITSU  MAP3735NC        5605  /dev/sdc 
[2:0:3:0]    disk    FUJITSU  MAP3735NC        5605  /dev/sdd 
[2:0:8:0]    disk    QUANTUM  ATLAS10K2-TY367J DA40  /dev/sde 
[2:0:10:0]   disk    QUANTUM  ATLAS10K2-TY367J DA40  /dev/sdf 
[3:0:0:0]    disk    IBM      IC35L036UCDY10-0 S27E  /dev/sdg 
[3:0:1:0]    disk    QUANTUM  ATLAS10K2-TY367J DA40  /dev/sdh 
[3:0:2:0]    disk    FUJITSU  MAP3735NC        5608  /dev/sdi 
[3:0:3:0]    disk    FUJITSU  MAP3735NC        5608  /dev/sdj 
[3:0:4:0]    disk    FUJITSU  MAP3735NC        5608  /dev/sdk 
[3:0:5:0]    disk    FUJITSU  MAP3735NC        5608  /dev/sdl 
[3:0:9:0]    disk    IBM      DMVS18M          0220  /dev/sdm 
[3:0:10:0]   disk    IBM      DMVS18D          02B0  /dev/sdn 
[3:0:11:0]   disk    IBM      IC35L036UCDY10-0 S27F  /dev/sdo 
[3:0:12:0]   disk    SEAGATE  ST318305LC       2203  /dev/sdp 
[3:0:13:0]   disk    FUJITSU  MAX3073NC        0104  /dev/sdq 
[3:0:15:0]   process Dell     12 BAY U2W CU    0209  -        
[4:0:0:0]    disk    ATA      ST3808110AS      J     /dev/sds 
[4:0:1:0]    disk    ATA      ST3808110AS      J     /dev/sdr 
[4:0:2:0]    disk    ATA      ST3808110AS      J     /dev/sdt 
[4:0:3:0]    disk    ATA      ST3808110AS      J     /dev/sdu 

mdadm config on host:

Personalities : [raid1] 
md122 : active raid1 sda1[2] sdj1[3]
      71680902 blocks super 1.2 [2/2] [UU]
      bitmap: 1/1 pages [4KB], 65536KB chunk

md123 : active raid1 sdb1[0] sdk1[1]
      71616384 blocks super 1.2 [2/2] [UU]
      bitmap: 1/1 pages [4KB], 65536KB chunk

md124 : active raid1 sdg1[3] sdf1[2]
      35549071 blocks super 1.2 [2/2] [UU]
      bitmap: 0/1 pages [0KB], 65536KB chunk

md125 : active raid1 sdh1[2] sde1[3]
      35549071 blocks super 1.2 [2/2] [UU]
      bitmap: 0/1 pages [0KB], 65536KB chunk

md126 : active raid1 sdc1[0] sdi1[2]
      71680902 blocks super 1.2 [2/2] [UU]
      bitmap: 1/1 pages [4KB], 65536KB chunk

md127 : active raid1 sdd[0] sdl[1]
      71621696 blocks super 1.2 [2/2] [UU]

md2 : active (auto-read-only) raid1 sdt1[2] sdu1[1]
      78121912 blocks super 1.2 [2/2] [UU]
      bitmap: 0/1 pages [0KB], 65536KB chunk

md1 : active raid1 sds2[0] sdr2[1]
      77623224 blocks super 1.2 [2/2] [UU]
      bitmap: 0/1 pages [0KB], 65536KB chunk

md0 : active raid1 sds1[0] sdr1[1]
      498676 blocks super 1.2 [2/2] [UU]
      bitmap: 0/1 pages [0KB], 65536KB chunk

Last dmesg messages on host:

[1225118.952197] md: data-check of RAID array md0
[1225118.952291] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[1225118.952384] md: using maximum available idle IO bandwidth (but not more
than 200000 KB/sec) for data-check.
[1225118.952528] md: using 128k window, over a total of 498676k.
[1225119.166383] md: delaying data-check of md1 until md0 has finished (they
share one or more physical units)
[1225119.178563] md: data-check of RAID array md122
[1225119.178644] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[1225119.178735] md: using maximum available idle IO bandwidth (but not more
than 200000 KB/sec) for data-check.
[1225119.178877] md: using 128k window, over a total of 71680902k.
[1225119.192249] md: data-check of RAID array md123
[1225119.192331] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[1225119.192422] md: using maximum available idle IO bandwidth (but not more
than 200000 KB/sec) for data-check.
[1225119.192564] md: using 128k window, over a total of 71616384k.
[1225119.205378] md: data-check of RAID array md124
[1225119.205461] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[1225119.210851] md: using maximum available idle IO bandwidth (but not more
than 200000 KB/sec) for data-check.
[1225119.216548] md: using 128k window, over a total of 35549071k.
[1225119.230698] md: data-check of RAID array md125
[1225119.236498] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[1225119.242171] md: using maximum available idle IO bandwidth (but not more
than 200000 KB/sec) for data-check.
[1225119.247721] md: using 128k window, over a total of 35549071k.
[1225119.265408] md: data-check of RAID array md126
[1225119.270962] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[1225119.276552] md: using maximum available idle IO bandwidth (but not more
than 200000 KB/sec) for data-check.
[1225119.282158] md: using 128k window, over a total of 71680902k.
[1225119.296781] md: data-check of RAID array md127
[1225119.302834] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[1225119.309046] md: using maximum available idle IO bandwidth (but not more
than 200000 KB/sec) for data-check.
[1225119.315202] md: using 128k window, over a total of 71621696k.
[1225127.248170] md: md0: data-check done.
[1225127.284640] md: data-check of RAID array md1
[1225127.290534] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[1225127.296453] md: using maximum available idle IO bandwidth (but not more
than 200000 KB/sec) for data-check.
[1225127.302521] md: using 128k window, over a total of 77623224k.
[1226450.960973] md: md1: data-check done.
[1226756.371905] md: md125: data-check done.
[1227131.051785] md: md127: data-check done.
[1227141.431898] md: md124: data-check done.
[1227808.276946] md: md126: data-check done.
[1227847.417636] md: md123: data-check done.
[1227978.744149] md: md122: data-check done.

Configuration of guest:

<domain type='kvm' id='4'>
  <name>olympic</name>
  <uuid>b42a5958-4258-1e0b-cbd0-05a0768c250b</uuid>
  <memory unit='KiB'>2097152</memory>
  <currentMemory unit='KiB'>1048576</currentMemory>
  <vcpu placement='static'>1</vcpu>
  <os>
    <type arch='x86_64' machine='pc-1.1'>hvm</type>
    <boot dev='hd'/>
  </os>
  <clock offset='utc' adjustment='reset'/>
  <on_poweroff>destroy</on_poweroff>
  <on_reboot>restart</on_reboot>
  <on_crash>restart</on_crash>
  <devices>
    <emulator>/usr/bin/kvm</emulator>
    <disk type='block' device='disk'>
      <driver name='qemu' type='raw' cache='none'/>
      <source dev='/dev/disk/by-id/md-name-olympic:70a'/>
      <target dev='vda' bus='virtio'/>
      <alias name='virtio-disk0'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x04'
function='0x0'/>
    </disk>
    <disk type='block' device='disk'>
      <driver name='qemu' type='raw' cache='none'/>
      <source dev='/dev/disk/by-id/md-name-olympic:70b'/>
      <target dev='vdb' bus='virtio'/>
      <alias name='virtio-disk1'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x05'
function='0x0'/>
    </disk>
    <disk type='block' device='disk'>
      <driver name='qemu' type='raw' cache='none'/>
      <source dev='/dev/disk/by-id/md-name-olympic:34c'/>
      <target dev='vdc' bus='virtio'/>
      <alias name='virtio-disk2'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x06'
function='0x0'/>
    </disk>
    <disk type='block' device='disk'>
      <driver name='qemu' type='raw' cache='none'/>
      <source dev='/dev/disk/by-id/md-name-olympic:34d'/>
      <target dev='vdd' bus='virtio'/>
      <alias name='virtio-disk3'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x07'
function='0x0'/>
    </disk>
    <disk type='block' device='disk'>
      <driver name='qemu' type='raw' cache='none'/>
      <source dev='/dev/disk/by-id/md-name-olympic:70e'/>
      <target dev='vde' bus='virtio'/>
      <alias name='virtio-disk4'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x08'
function='0x0'/>
    </disk>
    <disk type='block' device='disk'>
      <driver name='qemu' type='raw' cache='none'/>
      <source dev='/dev/disk/by-id/md-name-olympic:70f'/>
      <target dev='vdf' bus='virtio'/>
      <alias name='virtio-disk5'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x09'
function='0x0'/>
    </disk>
    <controller type='usb' index='0'>
      <alias name='usb0'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x01'
function='0x2'/>
    </controller>
    <interface type='bridge'>
      <mac address='00:16:3e:4b:86:33'/>
      <source bridge='calvaedi'/>
      <target dev='vnet0'/>
      <model type='virtio'/>
      <alias name='net0'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x03'
function='0x0'/>
    </interface>
    <serial type='pty'>
      <source path='/dev/pts/0'/>
      <target port='0'/>
      <alias name='serial0'/>
    </serial>
    <console type='pty' tty='/dev/pts/0'>
      <source path='/dev/pts/0'/>
      <target type='serial' port='0'/>
      <alias name='serial0'/>
    </console>
    <memballoon model='virtio'>
      <alias name='balloon0'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x0a'
function='0x0'/>
    </memballoon>
  </devices>
  <seclabel type='none'/>
</domain>

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
