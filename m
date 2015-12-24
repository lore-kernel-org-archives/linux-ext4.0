From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 109901] New: linux-image-4.4.0-rc4-amd64: Fails to boot on
 kernel 4.4rc4
Date: Thu, 24 Dec 2015 11:28:03 +0000
Message-ID: <bug-109901-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:43638 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323AbbLXL2H (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Dec 2015 06:28:07 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 2B32420600
	for <linux-ext4@vger.kernel.org>; Thu, 24 Dec 2015 11:28:05 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 8EC3D2051D
	for <linux-ext4@vger.kernel.org>; Thu, 24 Dec 2015 11:28:03 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=109901

            Bug ID: 109901
           Summary: linux-image-4.4.0-rc4-amd64: Fails to boot on kernel
                    4.4rc4
           Product: File System
           Version: 2.5
    Kernel Version: 4.4.0-rc4
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: ar.kernel@ange7.com
        Regression: No

Actually, i'm usging linux-image-4.3.0-amd64 on Dell XPS 13 9350. 

In order to fix WiFi problem i would install linux-image-4.4.0rc4 but it makes
it impossible to boot my laptop.

I have this message before Luks ask passphrase :

Loading, please wait...
modprobe: module microcode not found in modules.dep
lvmetad is not active yet, using direct activation during sysinit
volume group "vg" not found
Cannot process volume group vg
/run/lvm/lvmetad.socket: connect failed: No such file or directory
WARNING: Failed to connect to lvmetad. Falling back to internal scanning.
Reading all physical volumes. This may take a while...
/run/lvm/lvmetad.socket: connect failed: No such file or directory
WARNING: Failed to connect to lvmetad. Falling back to internal scanning.
Reading all physical volumes. This may take a while...
/run/lvm/lvmetad.socket: connect failed: No such file or directory
WARNING: Failed to connect to lvmetad. Falling back to internal scanning.
Reading all physical volumes. This may take a while...
/run/lvm/lvmetad.socket: connect failed: No such file or directory
WARNING: Failed to connect to lvmetad. Falling back to internal scanning.
Reading all physical volumes. This may take a while...
/run/lvm/lvmetad.socket: connect failed: No such file or directory
WARNING: Failed to connect to lvmetad. Falling back to internal scanning.
Reading all physical volumes. This may take a while...
/run/lvm/lvmetad.socket: connect failed: No such file or directory
WARNING: Failed to connect to lvmetad. Falling back to internal scanning.

I have the same problem with Rc5 & Rc6

- Debian Jessie
- dell XPS 9350 (december 2015, professionnal version, no developer version)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
