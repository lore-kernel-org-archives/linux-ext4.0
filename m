Return-Path: <SRS0=gW7+=OL=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:42076 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725812AbeLBM13 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 07:27:29 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id B841D2A8D4
        for <linux-ext4@vger.kernel.org>; Sun,  2 Dec 2018 12:27:25 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Sun, 02 Dec 2018 12:27:25 +0000
Message-ID: <bug-201685-13602-pofe34sDnZ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #140 from jaapbuurman@gmail.com ---
(In reply to Marc Burkhardt from comment #137)
> (In reply to jaapbuurman from comment #135)
> > Doesn't the Linux kernel team have any procedures in place for when such a
> > critical bug is found? There are many people running this "stable" 4.19
> > branch, many of whom are unaware of this bug. Shouldn't the stable branch
> be
> > rolled back to the last known good version? Going back to 4.18 is certainly
> > a better option, but people unaware of this bug might still be running
> 4.19.
> 
> That would mean depublishing of the 4.19 release as a whole as nobody knows
> _what_ exactly to roll back. And if one would know, they would fix the bug
> instead.
> 
> I cannot remember such a scenario/bug in the past...

I know it sounds bad, but isn't depublishing 4.19 the best course of action
right now? There's probably a lot of people running 4.19 that are completely
unaware of this bug and might or might not run into this later.

Data corruption issues are one of the worst, and should be addressed ASAP, even
if it means temporary depublishing the latest kernel, right?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
