From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42895] jbd2 makes all system unresponsive
Date: Thu, 17 May 2012 21:18:25 +0000 (UTC)
Message-ID: <20120517211825.DD9BC11FCF6@bugzilla.kernel.org>
References: <bug-42895-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:34636 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759953Ab2EQVS2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 May 2012 17:18:28 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 22E17205D6
	for <linux-ext4@vger.kernel.org>; Thu, 17 May 2012 21:18:27 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id E8179205C5
	for <linux-ext4@vger.kernel.org>; Thu, 17 May 2012 21:18:25 +0000 (UTC)
In-Reply-To: <bug-42895-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42895


Sami Liedes <sliedes@cc.hut.fi> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sliedes@cc.hut.fi




--- Comment #19 from Sami Liedes <sliedes@cc.hut.fi>  2012-05-17 21:18:25 ---
I have seen this too; basically latencies have always been a problem with KDE
(at least KDE 4) on ext4, as far as I can tell. Switching to XFS solved the
problem for me.

One thing I might be able to add to the discussion:

While this problem manifests without disk crypto, adding dm-crypt to the soup,
especially on a computer _without_ hardware AES support, generally makes it
*much* worse. I've seen disk accesses, especially fsync()s (per latencytop),
take minutes in the worst case under some medium disk load; 5-10 seconds are a
norm on light I/O load. I can't see much reason why disk crypto should make it
that much slower. But since it's a problem also without crypto, perhaps
dm-crypt just somehow makes it worse and more obvious?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
