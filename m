Return-Path: <SRS0=OKzU=N3=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:48624 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728079AbeKQBWi (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 16 Nov 2018 20:22:38 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id F14B02C850
        for <linux-ext4@vger.kernel.org>; Fri, 16 Nov 2018 15:09:52 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Fri, 16 Nov 2018 15:09:52 +0000
Message-ID: <bug-201685-13602-rt91b8cQlU@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

carlphilippreh@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |carlphilippreh@gmail.com

--- Comment #5 from carlphilippreh@gmail.com ---
Two of my Linux machines experience regular ext4 file system corruption since I
updated them to 4.19. 4.18 was fine. I noticed the problem first when certain
file operations returned "Structure needs cleaning". fsck then mostly finds
dangling inodes (of files I have written recently), incorrect reference counts,
and so on. Both machines do not use RAID, don't use any proprietary drivers and
both have an Intel board. One of them uses an SSD and one of them a HDD.
Unfortunately, I don't know which information might be useful to you.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
