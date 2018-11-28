Return-Path: <SRS0=QVqk=OH=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:42444 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727268AbeK1Tba (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 28 Nov 2018 14:31:30 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 091A92CD95
        for <linux-ext4@vger.kernel.org>; Wed, 28 Nov 2018 08:30:42 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Wed, 28 Nov 2018 08:30:41 +0000
Message-ID: <bug-201685-13602-MtKVZSKVup@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #61 from Henrique Rodrigues (henrique.rodrigues@ist.utl.pt) ---
(In reply to Theodore Tso from comment #60)
> Henrique -- what is dm-0?  How is it configured?   And are you using discard
> (either the mount option, or fstrim)?   Thanks!!

dm-o is a LUKS encrypted partition that I use as /. I have fstrim running
weekly with "fstrim -av" (Ubuntu's default).

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
