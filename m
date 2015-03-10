From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 94641] New: Kernel source tarball download incomplete despite
 Firefox report of complete download
Date: Tue, 10 Mar 2015 10:32:36 +0000
Message-ID: <bug-94641-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:47208 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbbCJKci (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Mar 2015 06:32:38 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 2A29D201E4
	for <linux-ext4@vger.kernel.org>; Tue, 10 Mar 2015 10:32:37 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 4E92520148
	for <linux-ext4@vger.kernel.org>; Tue, 10 Mar 2015 10:32:36 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=94641

            Bug ID: 94641
           Summary: Kernel source tarball download incomplete despite
                    Firefox report of complete download
           Product: File System
           Version: 2.5
    Kernel Version: Linux hal9000 3.13.0-37-generic #64-Ubuntu SMP Mon Sep
                    22 21:28:38 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext3
          Assignee: fs_ext3@kernel-bugs.osdl.org
          Reporter: mdcrawford@gmail.com
        Regression: No

This may well be a bug in Firefox or some other userspace component, however it
is serious enough that the kernel developers ought to know about it.

I tried several times to download a Linux kernel tarball; each time Firefox
reported that the entire file was downloaded, however the file in my filesystem
was quite a lot shorter than the size reported at kernel.org.

I speculated that Firefox had a caching bug, and so closed all my tabs one by
one, then closed the window.  The file was still incomplete.

I launched a new Firefox, retried the download, still incomplete.

I shut down my box, booted it, then was able to download successfully.

Perhaps the problem has something to do with Hibernate; I do know there were
some problems in the past with hibernating my motherboard, a SuperMicro
X7DWA-N.  Under a much earlier kernel, with Fedora 7, while I could go into and
out of hibernation, after coming out the networking did not work.

With my present Linux Mint Cinnamon 17.1 64-bit install, I've been using
hibernation quite a bit.

I am just now seeing some evidence that I may have a more serious problem,
perhaps I have bad memory or something.  I'm going to run Memtest86.

I'm using an AMCC3ware 9690-SA 4-disk RAID5, with battery backup so as to
enable write caching.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
