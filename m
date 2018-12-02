Return-Path: <SRS0=gW7+=OL=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:48898 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725535AbeLBTRh (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 14:17:37 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 44B972A7D4
        for <linux-ext4@vger.kernel.org>; Sun,  2 Dec 2018 19:17:34 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Sun, 02 Dec 2018 19:17:31 +0000
Message-ID: <bug-201685-13602-QWuoDTDERH@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

Michael Duell (reg@akurei.me) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |reg@akurei.me

--- Comment #157 from Michael Duell (reg@akurei.me) ---
I have had file system corruption with 4.19 on a BTRFS file system as well.
4.19.2 Kernel. I think this has to be related. No files were actually corrupted
but the Kernel set the file system read-only as soon as the error occurred.

I have even tried a NEW and FRESH btrfs file system created via a LiveCD system
and it happened there as well as soon as I did a btrfs send/receive operation.

I am on a Thinkpad T450.

lspci -vvv 
https://paste.pound-python.org/show/9tZLWlry0Iy7Z629VPea/

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
