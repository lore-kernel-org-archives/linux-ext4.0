From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12272] New: at random rmmod/insmod corrupts filesystem
Date: Mon, 22 Dec 2008 06:01:40 -0800 (PST)
Message-ID: <bug-12272-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753620AbYLVOBn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Dec 2008 09:01:43 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBME1e6N002536
	for <linux-ext4@vger.kernel.org>; Mon, 22 Dec 2008 06:01:41 -0800
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12272

           Summary: at random rmmod/insmod corrupts filesystem
           Product: File System
           Version: 2.5
     KernelVersion: 2.6.26 and 2.6.27
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext3
        AssignedTo: fs_ext3@kernel-bugs.osdl.org
        ReportedBy: folkert@vanheusden.com


Latest working kernel version: 2.6.18
Earliest failing kernel version: 2.6.26
Distribution: Debian
Hardware Environment: P4 (with HT), IDE disk (PATA), 512MB ram
Software Environment: http://vanheusden.com/pyk/
Problem Description: filesystem corrupted:
[85202.195563] rtc0: alarms up to one month, y3k, hpet irqs
[85204.035802] journal_bmap: journal block not found at offset 2060 on dm-0
[85204.035818] Aborting journal on device dm-0.
[85311.242093] ext3_abort called.
[85311.242120] EXT3-fs error (device dm-0): ext3_journal_start_sb: Detected
aborted journal
[85311.242154] Remounting filesystem read-only
[86331.285847] EXT3-fs error (device dm-0): htree_dirblock_to_tree: bad entry
in directory #24568: rec_len % 4 != 0 - offset=0, inode=4098364138,
rec_len=59542, name_len=76
[89931.353863] EXT3-fs error (device dm-0): htree_dirblock_to_tree: bad entry
in directory #24568: rec_len % 4 != 0 - offset=0, inode=4098364138,
rec_len=59542, name_len=76

[92499.263276] attempt to access beyond end of device
[92499.263296] dm-2: rw=17, want=4177066240, limit=6004736
[92499.263311] Buffer I/O error on device dm-2, logical block 522133279
[92499.263333] lost page write due to I/O error on dm-2
[92499.263341] Aborting journal on device dm-2.
[92499.263504] ext3_abort called.
[92499.263515] EXT3-fs error (device dm-2): ext3_journal_start_sb: Detected
aborted journal
[92499.263543] Remounting filesystem read-only

[93531.419902] EXT3-fs error (device dm-0): htree_dirblock_to_tree: bad entry
in directory #24568: rec_len % 4 != 0 - offset=0, inode=4098364138,
rec_len=59542, name_len=76

Steps to reproduce: run pyk script and run something like a git clone of the
mainline kernel git tree, rm -rf the tree, touch /forcefsk, reboot


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
