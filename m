From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196405] mkdir mishandles st_nlink in ext4 directory with 64997
 subdirectories
Date: Tue, 18 Jul 2017 21:57:35 +0000
Message-ID: <bug-196405-13602-I8nReaxO6S@https.bugzilla.kernel.org/>
References: <bug-196405-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:38884 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752892AbdGRV5h (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 18 Jul 2017 17:57:37 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 838A628600
        for <linux-ext4@vger.kernel.org>; Tue, 18 Jul 2017 21:57:37 +0000 (UTC)
In-Reply-To: <bug-196405-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196405

Andreas Dilger (adilger.kernelbugzilla@dilger.ca) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |adilger.kernelbugzilla@dilg
                   |                            |er.ca

--- Comment #5 from Andreas Dilger (adilger.kernelbugzilla@dilger.ca) ---
FYI, the "link count == 1" meaning is historical for ancient filesystems which
didn't track the link count of the directory at all.  In that respect, it
didn't mean "lots of subdirectories", but rather "I don't know the subdirectory
count at all".

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
