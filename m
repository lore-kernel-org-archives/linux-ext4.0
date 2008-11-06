From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11964] New: JBD: grub-probe wants too many credits (266 > 256)
Date: Thu,  6 Nov 2008 13:34:28 -0800 (PST)
Message-ID: <bug-11964-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35381 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751401AbYKFVei (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Nov 2008 16:34:38 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mA6LYSLA007779
	for <linux-ext4@vger.kernel.org>; Thu, 6 Nov 2008 13:34:30 -0800
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=11964

           Summary: JBD: grub-probe wants too many credits (266 > 256)
           Product: File System
           Version: 2.5
     KernelVersion: 2.6.27.4
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: tytso@mit.edu
OtherBugsDependingO 11808
             nThis:
        Regression: 1


Latest working kernel version: 2.6.26
Earliest failing kernel version: 2.6.27

Reported by Joseph Fannin (I can't find this in the web archives for some
reason, so I'll cut and paste the relevant pars of the report):

Date:  Sun, 2 Nov 2008 19:48:27 -0500
From: Joseph Fannin <jfannin@gmail.com>
Subject: JBD2/ext4 error
To: linux-ext4@vger.kernel.org
Mail-Followup-To: linux-ext4@vger.kernel.org

Hi,

I'm hitting what's probably a bug in ext4 on one of my boxes. It
always happens on the boot partition, which is extentless, since it
seems likely GRUB will choke on extents.

On with the backtrace, already:

[ 4586.330338] JBD: grub-probe wants too many credits (266 > 256)
[ 4586.330384] ext4_da_writepages: jbd2_start: 18691 pages, ino 39; err
-28
[ 4586.330398] Pid: 7365, comm: grub-probe Not tainted 2.6.27.4-1jhf-686
#4
[ 4586.330456]  [<d806a2f4>] ext4_da_writepages+0x165/0x2c0 [ext4]
[ 4586.330562]  [<d80babf2>] scsi_pool_alloc_command+0x30/0x4a [scsi_mod]
[ 4586.330647]  [<c01dd1fd>] blk_rq_map_sg+0xf1/0x240
[ 4586.330671]  [<c01e4558>] kobject_get+0xf/0x13
[ 4586.330690]  [<d806a18f>] ext4_da_writepages+0x0/0x2c0 [ext4]


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
