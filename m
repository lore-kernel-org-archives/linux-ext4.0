From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151491] free space lossage on busy system with bigalloc enabled
 and 128KB cluster
Date: Sat, 27 Jan 2018 14:20:32 +0000
Message-ID: <bug-151491-13602-eZ1GbVcLeS@https.bugzilla.kernel.org/>
References: <bug-151491-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:52794 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752828AbeA0OUe (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 27 Jan 2018 09:20:34 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 4C45C28CA7
        for <linux-ext4@vger.kernel.org>; Sat, 27 Jan 2018 14:20:33 +0000 (UTC)
In-Reply-To: <bug-151491-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=151491

--- Comment #17 from Theodore Tso (tytso@mit.edu) ---
Eric has still been working on it (he has been reporting on it on our weekly
ext4 concalls, and we've been discussing it).   He's identified an approach and
has patches which he is refining, perfecting, and testing.   Hopefully there
will be something that can be released for users to test in the near future.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
