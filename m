From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15576] New: Data Loss (flex_bg and ext4_mb_generate_buddy
 errors)
Date: Fri, 19 Mar 2010 01:05:23 GMT
Message-ID: <bug-15576-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:54575 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab0CSBFY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Mar 2010 21:05:24 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2J15OGX028975
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 19 Mar 2010 01:05:24 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15576

           Summary: Data Loss (flex_bg and ext4_mb_generate_buddy errors)
           Product: File System
           Version: 2.5
    Kernel Version: Linux elitemx-desktop 2.6.31-20-generic #58-Ubuntu SMP
                    Fri Mar 12 05:23:09 UTC 2010 i686 GNU/Linux
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: xpenev@gmail.com
        Regression: No


# create a 484 cylinder disk [3.7 GB]
dd of=disk.bin bs=512 count=0 seek=$((484*255*63))

# associate with loop device
losetup /dev/loop0 disk.bin

# generate bad blocks file [600 MB]
for((i=360491;i<=497992;i++)); do echo $i; done > omit

# format disk with ext4
mkfs.ext4 -l omit /dev/loop0

# mount disk
mkdir foobar; mount /dev/loop0 foobar

# create a 2 GB file
cd foobar; dd if=/dev/zero bs=1024 count=$((1024 * 1024 * 2))

# check dmesg
[ 9200.006021] EXT4-fs error (device loop0): ext4_mb_generate_buddy: EXT4-fs:
group 12: 0 blocks in bitmap, 2 in gd
[ 9200.010311] EXT4-fs error (device loop0): ext4_mb_generate_buddy: EXT4-fs:
group 13: 0 blocks in bitmap, 2 in gd
[ 9200.010359] EXT4-fs error (device loop0): ext4_mb_generate_buddy: EXT4-fs:
group 14: 0 blocks in bitmap, 2 in gd
[ 9200.010683] EXT4-fs error (device loop0): ext4_mb_generate_buddy: EXT4-fs:
group 15: 9911 blocks in bitmap, 9913 in gd

Worse off, however, if rather than creating a 2 GB file, you use this partition
as the target root partition for installation using the latest [32-bit] Ubuntu
installer ... consistently at 57 percent of the install ext4 reports data loss.

[ 1129.344600] EXT4-fs error (device sda1): ext4_mb_generate_buddy: EXT4-fs:
group 12: 0 blocks in bitmap, 2 in gd
[ 1129.344626] Aborting journal on device sda1:8.
[ 1129.380671] EXT4-fs error (device sda1): ext4_journal_start_sb: Detected
aborted journal
[ 1129.380697] EXT4-fs (sda1): Remounting filesystem read-only
[ 1129.492154] EXT4-fs (sda1): Remounting filesystem read-only
[ 1129.542049] EXT4-fs error (device sda1): ext4_mb_generate_buddy: EXT4-fs:
group 13: 0 blocks in bitmap, 2 in gd
[ 1129.554043] EXT4-fs error (device sda1): ext4_mb_generate_buddy: EXT4-fs:
group 14: 0 blocks in bitmap, 2 in gd
[ 1129.574283] EXT4-fs error (device sda1): ext4_mb_generate_buddy: EXT4-fs:
group 15: 9911 blocks in bitmap, 9913 in gd
[ 1129.574343] mpage_da_map_blocks block allocation failed for inode 41510 at
logical offset 0 with max blocks 6 with error -30
[ 1129.574352] This should not happen.!! Data will be lost
[ 1129.574393] ext4_da_writepages: jbd2_start: 1000 pages, ino 41510; err -30
[ 1129.574406] Pid: 11796, comm: pdflush Not tainted 2.6.31-14-generic
#48-Ubuntu
[ 1129.574414] Call Trace:
[ 1129.574440]  [<c056e41c>] ? printk+0x18/0x1c
[ 1129.574456]  [<c0266162>] ext4_da_writepages+0x452/0x490
[ 1129.574474]  [<c01ba551>] do_writepages+0x21/0x40
[ 1129.574489]  [<c02033fe>] writeback_single_inode+0x16e/0x3d0
[ 1129.574503]  [<c0150510>] ? process_timeout+0x0/0x10
[ 1129.574515]  [<c0203afd>] generic_sync_sb_inodes+0x38d/0x4a0
[ 1129.574528]  [<c0203ced>] writeback_inodes+0x4d/0xe0
[ 1129.574539]  [<c01b9432>] wb_kupdate+0xa2/0x110
[ 1129.574551]  [<c01bac27>] __pdflush+0xf7/0x1f0
[ 1129.574562]  [<c01bad20>] ? pdflush+0x0/0x40
[ 1129.574573]  [<c01bad20>] ? pdflush+0x0/0x40
[ 1129.574583]  [<c01bad59>] pdflush+0x39/0x40
[ 1129.574594]  [<c01b9390>] ? wb_kupdate+0x0/0x110
[ 1129.574606]  [<c015bf8c>] kthread+0x7c/0x90
[ 1129.574616]  [<c015bf10>] ? kthread+0x0/0x90
[ 1129.574630]  [<c0104007>] kernel_thread_helper+0x7/0x10

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
