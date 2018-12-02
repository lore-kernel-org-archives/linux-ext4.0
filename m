Return-Path: <SRS0=gW7+=OL=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:41782 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725751AbeLBMCa (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 07:02:30 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 9C8D52BB7C
        for <linux-ext4@vger.kernel.org>; Sun,  2 Dec 2018 00:48:43 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Sun, 02 Dec 2018 00:48:43 +0000
Message-ID: <bug-201685-13602-lu3DzJbJBJ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #120 from Florian Bruhin (kernel.org@the-compiler.org) ---
> How about people who are seeing this problem, do a recursive sha1sum -b of
> every file on the disk while in a known good state, and then do a sha1sum -c 
> of every file on the disk to see which ones got corrupted.

FWIW, https://github.com/claudehohl/checksummer does that (and saves the
checksums in a sqlite database).

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
