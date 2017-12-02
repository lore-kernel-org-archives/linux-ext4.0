From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151491] free space lossage on busy system with bigalloc enabled
 and 128KB cluster
Date: Sat, 02 Dec 2017 11:35:37 +0000
Message-ID: <bug-151491-13602-H6TDLQCpaS@https.bugzilla.kernel.org/>
References: <bug-151491-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:60720 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751613AbdLBLfk (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Dec 2017 06:35:40 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id BE5B52A00D
        for <linux-ext4@vger.kernel.org>; Sat,  2 Dec 2017 11:35:39 +0000 (UTC)
In-Reply-To: <bug-151491-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=151491

--- Comment #15 from Fischreiher (mfe555@web.de) ---
Thanks a lot for your investigation, Eric, and for describing these details. It
is great to know that this issue is in competent hands.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
