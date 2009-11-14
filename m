From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14601] New: Wrong handling of META_BG when getting number of
 blocks for group descriptors
Date: Sat, 14 Nov 2009 11:15:18 GMT
Message-ID: <bug-14601-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:55269 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbZKNLPM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 14 Nov 2009 06:15:12 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAEBFIAL021441
	for <linux-ext4@vger.kernel.org>; Sat, 14 Nov 2009 11:15:18 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14601

           Summary: Wrong handling of META_BG when getting number of
                    blocks for group descriptors
           Product: File System
           Version: 2.5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: DamienDGU@hotmail.com
        Regression: No


Created an attachment (id=23778)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=23778)
ext3/balloc.c and ext4/balloc.c change to count number of descriptors blocks

When computing number of blocks for group descriptors for a given group, the
total number of blocks for group descriptors is returned in case META_BG is
enabled and group is inside the first groups (such as block of its descriptor
is below s_first_meta_bg). I think it should be limited to s_first_meta_bg.
This behaviour is incoherent with e2fsprogs behaviour (see
http://marc.info/?l=linux-ext4&m=125794126219545&w=2) and can lead to
corruption in case performing e2fsck on a filesystem where an uninitialized
block bitmap was initialized by kernel.
I attach a proposed change, but:
- I did not compiled, nor tried it.
- it is for ext3 and ext4.
- I am not sure it is enough: there is some other location where s_gdb_count is
used and where perhaps ext4_bg_num_gdb should be used instead as in
ext4_setup_system_zone (I do not understand the behaviour here, it seems to not
take META_BG flag into account at all) or ex4_iget.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
