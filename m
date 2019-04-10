Return-Path: <SRS0=PpJq=SM=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4A8BC10F11
	for <linux-ext4@archiver.kernel.org>; Wed, 10 Apr 2019 17:57:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFD5E2063F
	for <linux-ext4@archiver.kernel.org>; Wed, 10 Apr 2019 17:57:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731000AbfDJR5s convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 10 Apr 2019 13:57:48 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:42232 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730819AbfDJR5s (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 10 Apr 2019 13:57:48 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id F2F46284FC
        for <linux-ext4@vger.kernel.org>; Wed, 10 Apr 2019 17:57:46 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id E73E228A08; Wed, 10 Apr 2019 17:57:46 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 203247] jbd2 gets stuck at jbd2_journal_commit_transaction
 frequently
Date:   Wed, 10 Apr 2019 17:57:45 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext3@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext3
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: pankajcabs@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext3@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-203247-13602-cPGCcf4Ckz@https.bugzilla.kernel.org/>
In-Reply-To: <bug-203247-13602@https.bugzilla.kernel.org/>
References: <bug-203247-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=203247

--- Comment #5 from pkb07815 (pankajcabs@gmail.com) ---
Here is the information:

# show raid
Raid configuration:
  Model:            LSI MegaRAID SAS 9260-4i
  Serial:           SK72468112
  Firmware Version: 2.130.383-2315

Apr  9 00:44:22 ex-etp3 kernel:scsi host0: Avago SAS based MegaRAID driver
Apr  9 00:44:22 ex-etp3 kernel:scsi 0:2:0:0: Direct-Access     LSI     
MR9260-4i        2.13 PQ: 0 ANSI: 5

Apr  9 00:44:22 ex-etp3 kernel:sd 0:2:0:0: [sda] 1171062784 512-byte logical
blocks: (600 GB/558 GiB)
Apr  9 00:44:22 ex-etp3 kernel:sd 0:2:0:0: Attached scsi generic sg0 type 0
Apr  9 00:44:22 ex-etp3 kernel:sd 0:2:0:0: [sda] Write Protect is off
Apr  9 00:44:22 ex-etp3 kernel:sd 0:2:0:0: [sda] Mode Sense: 1f 00 10 08
Apr  9 00:44:22 ex-etp3 kernel:sd 0:2:0:0: [sda] Write cache: disabled, read
cache: enabled, supports DPO and FUA

[admin@ex-etp3 ~]# df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda5       2.0G  1.8G  106M  95% /
tmpfs            63G  3.0G   60G   5% /dev/shm
/dev/sda2       120M   30M   84M  27% /boot
/dev/sda1       119M  1.8M  111M   2% /bootmgr
/dev/sda8       182M   50M  123M  29% /config
/dev/sda9        30G   22G  6.3G  78% /var
/dev/sda10      453G  329G  102G  77% /data
tmpfs            63G   24K   63G   1% /run
tmpfs            64M  980K   64M   2% /vtmp
[admin@ex-etp3 ~]# mount
/dev/sda5 on / type ext3 (rw)
proc on /proc type proc (rw)
sysfs on /sys type sysfs (rw)
devpts on /dev/pts type devpts (rw,gid=5,mode=620)
tmpfs on /dev/shm type tmpfs (rw)
/dev/sda2 on /boot type ext3 (ro,noatime,noexec)
/dev/sda1 on /bootmgr type ext3 (ro,noatime,noexec)
/dev/sda8 on /config type ext3 (rw,noatime,noexec)
/dev/sda9 on /var type ext3 (rw,noatime)
/dev/sda10 on /data type ext3 (rw,noatime,barrier=0)
tmpfs on /dev/shm type tmpfs (rw)
tmpfs on /run type tmpfs (rw,nosuid,nodev,strictatime,mode=0755)
tmpfs on /vtmp type tmpfs (rw,size=64M)




 description: Motherboard
       product: H8DGU
       vendor: Supermicro
       physical id: 0
       version: 1234567890
       serial: NM179S600489
       slot: To Be Filled By O.E.M.
     *-firmware
          description: BIOS
          vendor: American Megatrends Inc.
          physical id: 0
          version: FI3.0c
          date: 12/31/2013

cpu:0
          description: CPU
          product: (To Be Filled By O.E.M.)
          vendor: Advanced Micro Devices [AMD]
          physical id: 4
          bus info: cpu@0
          version: AMD Opteron(tm) Processor 6380

 *-storage
                description: RAID bus controller
                product: MegaRAID SAS 2108 [Liberator]
                vendor: LSI Logic / Symbios Logic
                physical id: 0
                bus info: pci@0000:02:00.0
                logical name: scsi0
                version: 05
                width: 64 bits
                clock: 33MHz
                capabilities: storage pm pciexpress vpd msi msix bus_master
cap_list rom
                configuration: driver=megaraid_sas latency=0
                resources: irq:19 ioport:c000(size=256)
memory:fd59c000-fd59ffff memory:fd5c0000-fd5fffff memory:fd5a0000-fd5bffff
              *-disk
                   description: SCSI Disk
                   product: MR9260-4i
                   vendor: LSI
                   physical id: 2.0.0
                   bus info: scsi@0:2.0.0
                   logical name: /dev/sda
                   version: 2.13
                   serial: 003307152fc3005222f0e91a0db00506
                   size: 558GiB (599GB)


kernel:Linux version 4.9.86 (gcc version 4.8.5 20150623 (Red Hat 4.8.5-4) (GCC)
) #1 SMP PREEMPT


the system has lot of IO traffic, this happens intermittently. We are seeing
issue mainly after upgrading from 4.1 to 4.9.75 and 4.9.86.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
