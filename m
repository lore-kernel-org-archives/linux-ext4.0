From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 72401] New: EXT4-fs error (device sdf1):
 ext4_mb_complex_scan_group:1786: group 11890254 free clusters as per group
 info. But got 256 blocks
Date: Tue, 18 Mar 2014 08:37:28 +0000
Message-ID: <bug-72401-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:59797 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbaCSRn5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Mar 2014 13:43:57 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id DB87B20171
	for <linux-ext4@vger.kernel.org>; Tue, 18 Mar 2014 08:37:30 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 1C04F20179
	for <linux-ext4@vger.kernel.org>; Tue, 18 Mar 2014 08:37:29 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=72401

            Bug ID: 72401
           Summary: EXT4-fs error (device sdf1):
                    ext4_mb_complex_scan_group:1786: group 11890254 free
                    clusters as per group info. But got 256 blocks
           Product: File System
           Version: 2.5
    Kernel Version: 3.2
          Hardware: IA-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: zweiustc@gmail.com
        Regression: No

EXT4-fs error (device sdf1): ext4_mb_complex_scan_group:1786: group 11890254
free clusters as per group info. But got 256 blocks
EXT4-fs error (device sdf1): ext4_mb_complex_scan_group:1786: group 11890494
free clusters as per group info. But got 496 blocks
EXT4-fs error (device sdf1): ext4_mb_complex_scan_group:1786: group 125222297
free clusters as per group info. But got 2304 blocks


The server log showed that the num of free blocks diffs from the result we
calculate from the extent tree. I have not found how to reproduce it but it
happened on several servers. I am trying to reproduce it and look into the
code. I wonder anyone once confronted such a case before.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
