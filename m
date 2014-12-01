From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89131] New: Hangs when checking torrent through libtorrent;
 kernel BUG at mm/iov_iter.c:219!
Date: Mon, 01 Dec 2014 13:19:19 +0000
Message-ID: <bug-89131-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:43661 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404AbaLANTX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Dec 2014 08:19:23 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 51D2420266
	for <linux-ext4@vger.kernel.org>; Mon,  1 Dec 2014 13:19:21 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id A607B2026C
	for <linux-ext4@vger.kernel.org>; Mon,  1 Dec 2014 13:19:19 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89131

            Bug ID: 89131
           Summary: Hangs when checking torrent through libtorrent; kernel
                    BUG at mm/iov_iter.c:219!
           Product: File System
           Version: 2.5
    Kernel Version: 3.17.3
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: kokoko3k@gmail.com
        Regression: No

Created attachment 159351
  --> https://bugzilla.kernel.org/attachment.cgi?id=159351&action=edit
Backtraces from both the systems

When i use qbittorrent (libtorrent) by explicitely disable the os cache and do
the hash-check on a specific torrent data (it does not happen on all of the
torrents), linux hangs leaving me no choice but to reboot somehow.

I managed to get two backtraces from completely different systems (an e7300
desktop and an ivybridge laptop), they're attached.

As a reference, i started to talk about the issue here:
https://github.com/qbittorrent/qBittorrent/issues/2200#issuecomment-64951598

...seems the issue is given by the use of the O_DIRECT flag

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
