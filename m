Return-Path: <SRS0=iZZ9=OM=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:35048 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725785AbeLCBDD (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 20:03:03 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 0B8822A704
        for <linux-ext4@vger.kernel.org>; Mon,  3 Dec 2018 01:03:02 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Mon, 03 Dec 2018 01:03:00 +0000
Message-ID: <bug-201685-13602-fDeICv0Nq2@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

Lei Ming (tom.leiming@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tom.leiming@gmail.com

--- Comment #173 from Lei Ming (tom.leiming@gmail.com) ---
The commit 2a5cf35cd6c56b2924("block: fix single range discard merge") in linus
tree may address one possible data loss, anyone who saw corruption in scsi
may try this fix and see if it makes a difference.

Given the merged discard request isn't removed from elevator queue, it might
be possible to be submitted to hardware again.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
