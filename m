Return-Path: <SRS0=gW7+=OL=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:45876 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725745AbeLBMju (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 07:39:50 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 355262BCB4
        for <linux-ext4@vger.kernel.org>; Sun,  2 Dec 2018 01:26:00 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Sun, 02 Dec 2018 01:25:59 +0000
Message-ID: <bug-201685-13602-6qwFO70Xf0@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #125 from Bart Van Assche (bvanassche@acm.org) ---
(In reply to James Courtier-Dutton from comment #118)
> How about people who are seeing this problem, do a recursive sha1sum -b of
> every file on the disk while in a known good state, and then do a sha1sum -c
> of every file on the disk to see which ones got corrupted.
> This might help when doing git bisect and checking that we are back to a
> known good file system, and in cases like comment #116, item 2.

That could take a lot of CPU time. On my system git status told me that about
ten source files had disappeared from the kernel tree that I definitely had not
deleted myself. In other words, git can be used to detect filesystem
corruption.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
