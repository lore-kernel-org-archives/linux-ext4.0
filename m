From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 197045] renameat2 rename_noreplace
Date: Tue, 24 Oct 2017 17:41:33 +0000
Message-ID: <bug-197045-13602-pmxj7l4k1o@https.bugzilla.kernel.org/>
References: <bug-197045-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:49600 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751334AbdJXRlf (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 24 Oct 2017 13:41:35 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 7DCC328A52
        for <linux-ext4@vger.kernel.org>; Tue, 24 Oct 2017 17:41:35 +0000 (UTC)
In-Reply-To: <bug-197045-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=197045

Thiago Macieira (thiago@macieira.org) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |thiago@macieira.org

--- Comment #4 from Thiago Macieira (thiago@macieira.org) ---
Martin: can you confirm you did see these issues on 4.4 and 4.11? Elvis is
reporting he did not see the issue on 4.4.

By any chance, are you also on Ubuntu?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
