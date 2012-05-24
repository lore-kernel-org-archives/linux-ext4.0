From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43292] New: jdb2 lockup with ext3 and nfs
Date: Thu, 24 May 2012 15:54:30 +0000 (UTC)
Message-ID: <bug-43292-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:58176 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932167Ab2EXPyd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 May 2012 11:54:33 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 8D3332058A
	for <linux-ext4@vger.kernel.org>; Thu, 24 May 2012 15:54:32 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id 345632057A
	for <linux-ext4@vger.kernel.org>; Thu, 24 May 2012 15:54:30 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=43292

           Summary: jdb2 lockup with ext3 and nfs
           Product: File System
           Version: 2.5
    Kernel Version: 3.4
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext3
        AssignedTo: fs_ext3@kernel-bugs.osdl.org
        ReportedBy: flo@xssn.at
        Regression: Yes


When using nfs and writing some files nfsd locks up in D state and I get the
attached backtraces in dmesg. Once nfsd killed the request that triggered the
lockup, the problem will not happen again until the system has been rebooted.
(Tested over a period of 20 days)

I'm not yet sure if it happens on the first write request or only on some
special ones, but I don't really want to reboot my file server and let it hang
that often. However, if you can tell me what to look for or what debugging
features I should use, I'll be happy to try them.

I also didn't yet test if this can be reproduced when writing files directly
(without nfs), but I think it would lock up during boot in that case since I'm
running a mysqld slave on the system.

This started happening around linux 3.2 or 3.3.

I've attached the whole dmesg output (including bootup, in case this is related
to the hardware).

Arch Linux x86_64
Linux 3.4 (config [1])
nfs-utils 1.2.5


[1]:
https://projects.archlinux.org/svntogit/packages.git/plain/trunk/config.x86_64?h=packages/linux&id=f8c396e6ca1e29c3da83431f64074f8c127e1af3

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
