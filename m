Return-Path: <SRS0=7vaa=OF=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:55836 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726203AbeKZXR5 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 26 Nov 2018 18:17:57 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id CEECD29695
        for <linux-ext4@vger.kernel.org>; Mon, 26 Nov 2018 12:23:58 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Mon, 26 Nov 2018 12:23:58 +0000
Message-ID: <bug-201685-13602-aSsimTl4JC@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #49 from Jimmy.Jazz@gmx.net ---
to be short,

Release 4.19.0-rc2-radeon-00922-gf48097d294-dirty

A: Nothing append at first when the computer is nearly idle.

B: I mounted an usb SD media first ro (default) then rw.
Transfer to it some big files (cp and tar) from two different xterms.
Lot of errors, stick became for the kernel read only.
Transfer failed.
Umount then remount the filesystem without doing an fsck and restart the
transfer again.
Transfer ok.
umount ok.

I will next declare it git bisect bad and then reboot.

please see attachements.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
