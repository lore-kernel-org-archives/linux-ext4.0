Return-Path: <SRS0=EHOS=ON=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:56162 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725764AbeLDKQl (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Dec 2018 05:16:41 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id EF8392B768
        for <linux-ext4@vger.kernel.org>; Tue,  4 Dec 2018 10:16:40 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Tue, 04 Dec 2018 10:16:39 +0000
Message-ID: <bug-201685-13602-UO7tSXVeqF@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #221 from Rainer Fiebig (jrf@mailbox.org) ---
#218
If 4.18.20 turns out to be OK, my idea would be to bisect between 4.18 and
4.19.
Jimmy.Jazz has already done that and the result pointed to RCU. But IIRC it was
not a clear cut

> git bisect bad
xyz123 is the first bad commit

With your script we now have a tool to reproduce the problem which makes the
distinction between "good" and "bad" more reliable. And everybody is now also
aware how important it is to ensure that the fs is OK after a bad kernel has
run and that the next step should be done with a known-good kernel. So it
should be possible to identify a bad commit.

Perhaps one could limit the bisect to kernel/rcu or block in a first step. And
if that's inconclusive, extent the search.

But if 4.18.20 is bad, I have no clue at all - at least at the moment.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
