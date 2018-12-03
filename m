Return-Path: <SRS0=iZZ9=OM=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:37862 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725914AbeLCOTT (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Dec 2018 09:19:19 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 173AA2B2EA
        for <linux-ext4@vger.kernel.org>; Mon,  3 Dec 2018 14:18:08 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Mon, 03 Dec 2018 14:18:06 +0000
Message-ID: <bug-201685-13602-smtUZMEbbd@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

Sebastian Jastrzebski (shopper2k@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |shopper2k@gmail.com

--- Comment #198 from Sebastian Jastrzebski (shopper2k@gmail.com) ---
I can also confirm the fs corruption issue on Fedora 29 with 4.19.5 kernel. I
run it on ThinkPad T480 with NVME Samsung drive. 

* Workload 

The workload involves doing a bunch of compile sessions and/or running a VM
(under KVM hypervisor) with NFS server. It usually takes anywhere from few
hours to a day for the corruption to occur.

* Symptoms

- /dev/nvm0n1* entries disappear from /dev/
- unable to start any program as i get I/O errors 

* System Info

> uname -a
Linux skyline.origin 4.19.5-300.fc29.x86_64 #1 SMP Tue Nov 27 19:29:23 UTC 2018
x86_64 x86_64 x86_64 GNU/Linux

> cat /proc/cmdline
BOOT_IMAGE=/vmlinuz-4.19.5-300.fc29.x86_64 root=/dev/mapper/fedora_skyline-root
ro rd.lvm.lv=fedora_skyline/root
rd.luks.uuid=luks-b66e85a5-f7b1-4d87-8fab-a01687e35056
rd.lvm.lv=fedora_skyline/swap rhgb quiet LANG=en_US.UTF-8

> cat /sys/block/nvme0n1/queue/scheduler 
[none] mq-deadline

> lsblk 
NAME                                          MAJ:MIN RM   SIZE RO TYPE 
MOUNTPOINT
nvme0n1                                       259:0    0 238.5G  0 disk  
├─nvme0n1p1                                   259:1    0   200M  0 part 
/boot/efi
├─nvme0n1p2                                   259:2    0     1G  0 part  /boot
├─nvme0n1p3                                   259:3    0   160G  0 part  
│ └─luks-b66e85a5-f7b1-4d87-8fab-a01687e35056 253:0    0   160G  0 crypt 
│   ├─fedora_skyline-root                     253:1    0   156G  0 lvm   /
│   └─fedora_skyline-swap                     253:2    0     4G  0 lvm   [SWAP]
└─nvme0n1p4                                   259:4    0  77.3G  0 part  
  ├─skyline_vms-atomic_00                     253:3    0    20G  0 lvm   
  └─skyline_vms-win10_00                      253:4    0    40G  0 lvm   

This is dumpe2fs output on the currently booted system.

> dumpe2fs /dev/mapper/fedora_skyline-root
dumpe2fs 1.44.3 (10-July-2018)
Filesystem volume name:   <none>
Last mounted on:          /
Filesystem UUID:          410261f3-0779-455b-9642-d52800292fd7
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype
needs_recovery extent 64bit flex_bg sparse_super large_file h
uge_file uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash 
Default mount options:    user_xattr acl
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              10223616
Block count:              40894464
Reserved block count:     2044723
Free blocks:              26175785
Free inodes:              9255977
First block:              0
Block size:               4096
Fragment size:            4096
Group descriptor size:    64
Reserved GDT blocks:      1024
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
Flex block group size:    16
Filesystem created:       Mon Feb 19 18:48:05 2018
Last mount time:          Mon Dec  3 08:07:30 2018
Last write time:          Mon Dec  3 03:07:29 2018
Mount count:              137
Maximum mount count:      -1
Last checked:             Sat Jul 14 07:11:08 2018
Check interval:           0 (<none>)
Lifetime writes:          1889 GB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     32
Desired extra isize:      32
Journal inode:            8
First orphan inode:       9318809
Default directory hash:   half_md4
Directory Hash Seed:      ad5a6f9c-6250-4dc5-84d9-4a3b14edc7b7
Journal backup:           inode blocks
Journal features:         journal_incompat_revoke journal_64bit
Journal size:             1024M
Journal length:           262144
Journal sequence:         0x00508e50
Journal start:            1

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
