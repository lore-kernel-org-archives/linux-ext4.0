From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 194695] size overflow detected in function ext4_mb_new_group_pa
Date: Tue, 28 Feb 2017 05:28:49 +0000
Message-ID: <bug-194695-13602-VPhlwpHvHu@https.bugzilla.kernel.org/>
References: <bug-194695-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:36734 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751390AbdB1Fh2 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 28 Feb 2017 00:37:28 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 354C128514
        for <linux-ext4@vger.kernel.org>; Tue, 28 Feb 2017 05:28:50 +0000 (UTC)
Received: from pdx-korg-bugzilla-1.web.codeaurora.org (unknown [172.30.200.120])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id C0490284AD
        for <linux-ext4@vger.kernel.org>; Tue, 28 Feb 2017 05:28:49 +0000 (UTC)
In-Reply-To: <bug-194695-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=194695

Theodore Tso (tytso@mit.edu) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

--- Comment #2 from Theodore Tso (tytso@mit.edu) ---
I don't think we use the pa_lstart value for group preallocations --- a logical
number doesn't really have meaning for group pa's.  That being said, the
preallocation code is really quite a mess, and it makes it hard to follow.   We
should really look at cleaning it up....

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
