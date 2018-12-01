Return-Path: <SRS0=IALa=OK=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:37900 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726577AbeLBCFg (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 1 Dec 2018 21:05:36 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id A816F2DA91
        for <linux-ext4@vger.kernel.org>; Sat,  1 Dec 2018 14:52:55 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Sat, 01 Dec 2018 14:52:55 +0000
Message-ID: <bug-201685-13602-HaYIyfQ83G@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #108 from Rainer Fiebig (jrf@mailbox.org) ---
(In reply to Guenter Roeck from comment #107)
> #104: Possibly, but it doesn't explain why I see the problem only on two of
> four systems, all running the same kernel.

Right. Bye bye DAX-theory.

I'm wondering by now whether I made a config-mistake somewhere and *that's* why
I don't have the problem. ;)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
