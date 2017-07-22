From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196405] mkdir mishandles st_nlink in ext4 directory with 64997
 subdirectories
Date: Sat, 22 Jul 2017 14:41:47 +0000
Message-ID: <bug-196405-13602-PRWmiANPzS@https.bugzilla.kernel.org/>
References: <bug-196405-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:56064 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750838AbdGVOls (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 22 Jul 2017 10:41:48 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 2BFB8286B2
        for <linux-ext4@vger.kernel.org>; Sat, 22 Jul 2017 14:41:48 +0000 (UTC)
In-Reply-To: <bug-196405-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196405

--- Comment #22 from Theodore Tso (tytso@mit.edu) ---
Right, the fact that the two bugs that Michael cited was about the st_nlinks
being "wrong" is in fact a good thing.  Paul is asserting that there is vast
amount of breakage because ext4 can return an st_nlinks value of 1 on a
directory, to the extent that he believes we should withdrawing the dir_nlinks
feature.   My argument is if we've lived with this for ten years without users
screaming about things being broken, then we're probably ok and we should fix
this by changing the documentation.   Paul then responded by pointing out the
bugs.  But if the bugs are about st_nlinks being "wrong" causing users to be
confused, and not about real life use cases breaking, then I'm going to be much
less concerned.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
