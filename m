From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 102731] I have a cough.
Date: Wed, 07 Oct 2015 16:17:04 +0000
Message-ID: <bug-102731-13602-ooRVGVBuSt@https.bugzilla.kernel.org/>
References: <bug-102731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41148 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754151AbbJGQRH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Oct 2015 12:17:07 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 1204B2073B
	for <linux-ext4@vger.kernel.org>; Wed,  7 Oct 2015 16:17:06 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id B7D152072B
	for <linux-ext4@vger.kernel.org>; Wed,  7 Oct 2015 16:17:04 +0000 (UTC)
In-Reply-To: <bug-102731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=102731

--- Comment #15 from John Hughes <john@calva.com> ---
On 28/09/15 19:06, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=102731
>
> --- Comment #13 from Theodore Tso <tytso@mit.edu> ---
> So it's been 12 days, and previously when you were using the Debian 3.16
> kernel, it was triggering once every four days, right?  Can I assume that your
> silence indicates that you haven't seen a problem to date?

As I said I was, due to a silly mistake (I rebooted the system and 
forgot that the default kernel was still the 3.18.19 one) not running 
the Debian kernel.

And, after 19 days the problem has shown up again:

Oct  7 17:34:24 olympic kernel: [1657429.788105] EXT4-fs (dm-2): pa
ffff880004211a50: logic 512, phys. 10298368, len 512
Oct  7 17:34:24 olympic kernel: [1657429.790412] EXT4-fs error (device dm-2):
ext4_mb_release_inode_pa:3773: group 314, free 497, pa_free 495
Oct  7 17:34:24 olympic kernel: [1657429.793168] Aborting journal on device
dm-2-8.
Oct  7 17:34:24 olympic kernel: [1657429.795367] EXT4-fs (dm-2): Remounting
filesystem read-only


All the filesystem where it happened, "dm-2", is a LVM volume:

# lvdisplay -m /dev/olympic/olympic-home
   --- Logical volume ---
   LV Path                /dev/olympic/olympic-home
   LV Name                olympic-home
   VG Name                olympic
   LV UUID                drA6nQ-zbcu-SDLc-UeXH-foML-fPcB-ve1HQf
   LV Write Access        read/write
   LV Creation host, time ,
   LV Status              available
   # open                 1
   LV Size                160.00 GiB
   Current LE             40960
   Segments               3
   Allocation             inherit
   Read ahead sectors     auto
   - currently set to     512
   Block device           253:2

   --- Segments ---
   Logical extent 0 to 34999:
     Type        striped
     Stripes        2
     Stripe size        64.00 KiB
     Stripe 0:
       Physical volume    /dev/vdf
       Physical extents    0 to 17499
     Stripe 1:
       Physical volume    /dev/vdb
       Physical extents    0 to 17499

   Logical extent 35000 to 40861:
     Type        striped
     Stripes        2
     Stripe size        64.00 KiB
     Stripe 0:
       Physical volume    /dev/vdd
       Physical extents    4339 to 7269
     Stripe 1:
       Physical volume    /dev/vdc
       Physical extents    4388 to 7318

   Logical extent 40862 to 40959:
     Type        striped
     Stripes        2
     Stripe size        64.00 KiB
     Stripe 0:
       Physical volume    /dev/vdd
       Physical extents    7270 to 7318
     Stripe 1:
       Physical volume    /dev/vdc
       Physical extents    4339 to 4387

The devices, vdf, vdb, vdd, vdc are all unmirrored:

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
     ...
     <disk type='block' device='disk'>
       <driver name='qemu' type='raw' cache='none'/>
       <source dev='/dev/disk/by-id/md-name-olympic:70f'/>
       <target dev='vdf' bus='virtio'/>
       <alias name='virtio-disk5'/>
       <address type='pci' domain='0x0000' bus='0x00' slot='0x09'
function='0x0'/>
     </disk>

lrwxrwxrwx 1 root root 11 Oct  7 17:48 /dev/disk/by-id/md-name-olympic:34c ->
../../md125
lrwxrwxrwx 1 root root 11 Oct  7 17:48 /dev/disk/by-id/md-name-olympic:34d ->
../../md124
lrwxrwxrwx 1 root root 11 Oct  7 17:48 /dev/disk/by-id/md-name-olympic:70b ->
../../md126
lrwxrwxrwx 1 root root 11 Oct  7 17:48 /dev/disk/by-id/md-name-olympic:70f ->
../../md122

md122 : active raid1 sda1[2] sdj1[3](F)
       71680902 blocks super 1.2 [2/1] [U_]
--
md124 : active raid1 sdg1[3] sdf1[2](F)
       35549071 blocks super 1.2 [2/1] [U_]
--
md125 : active raid1 sdh1[2] sde1[3](F)
       35549071 blocks super 1.2 [2/1] [U_]
--
md126 : active raid1 sdc1[0] sdi1[2](F)
       71680902 blocks super 1.2 [2/1] [U_]

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
