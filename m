From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 109331] New: EXT4-fs (sda1): couldn't mount as ext3 due to
 feature incompatibilities
Date: Mon, 14 Dec 2015 04:26:05 +0000
Message-ID: <bug-109331-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56137 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167AbbLNE0I (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 13 Dec 2015 23:26:08 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 27B07204FC
	for <linux-ext4@vger.kernel.org>; Mon, 14 Dec 2015 04:26:07 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id AA782204D9
	for <linux-ext4@vger.kernel.org>; Mon, 14 Dec 2015 04:26:05 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=109331

            Bug ID: 109331
           Summary: EXT4-fs (sda1): couldn't mount as ext3 due to feature
                    incompatibilities
           Product: File System
           Version: 2.5
    Kernel Version: 3.4.2
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: 3fdd1e5d@opayq.com
        Regression: No

Created attachment 197281
  --> https://bugzilla.kernel.org/attachment.cgi?id=197281&action=edit
config-4.3.2

I compiled 4.3.2 and when I was looking over the logs I noticed this message in
dmesg;

EXT4-fs (sda1): couldn't mount as ext3 due to feature incompatibilities

I personally don't get this message, as to why the kernel is trying to mount
ext4 as ext3? Or at least it's the way the message comes across.

Can't say I've ever seen anything like this before in the kernel logs...

Hmm

I've attached my config

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
