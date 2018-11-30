Return-Path: <SRS0=01R6=OJ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:48564 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726521AbeK3XTd (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 30 Nov 2018 18:19:33 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 1167F30012
        for <linux-ext4@vger.kernel.org>; Fri, 30 Nov 2018 12:10:28 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Fri, 30 Nov 2018 12:10:27 +0000
Message-ID: <bug-201685-13602-MYeU74AAh8@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #86 from Rainer Fiebig (jrf@mailbox.org) ---
(In reply to Hao Wei Tee from comment #85)
> (In reply to Rainer Fiebig from comment #83)
> > Interesting idea. But what works in one direction might not necessarily
> work
> > the other way round.
> 
> Exactly my point. We know that (4.19 ext4 and kernel is broken), (4.18 ext4
> and kernel is working), and (4.18 ext4 and 4.19 kernel is working).
> 
> If (4.19 ext4 and 4.18 kernel) is broken, then _most likely_ the bug is
> caused by something that changed in v4.18..v4.19. If (4.19 ext4 and 4.18
> kernel) *works*, then either the bug is in something else that changed, or
> there is an interaction between two changes that happened in v4.18..v4.19.
> 
Sure, I understand this. I would just shy away from recommending this to others
without a nod from higher powers. But of course it's up to Nestor whether he
wants to try this or not.

> In any case, bisecting v4.18..v4.19 will probably give us a clue.
Let's hope for the best. Perhaps bisecting fs/ext4 will provide enough of a
clue already and spare the poor bisecter to have to bisect the whole beast. ;)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
