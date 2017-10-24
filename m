From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 197045] renameat2 rename_noreplace
Date: Tue, 24 Oct 2017 12:28:18 +0000
Message-ID: <bug-197045-13602-oyiHIfHKjd@https.bugzilla.kernel.org/>
References: <bug-197045-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:34524 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932273AbdJXM2U (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 24 Oct 2017 08:28:20 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 5542B289F6
        for <linux-ext4@vger.kernel.org>; Tue, 24 Oct 2017 12:28:20 +0000 (UTC)
In-Reply-To: <bug-197045-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=197045

Elvis Stansvik (elvstone@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |elvstone@gmail.com

--- Comment #2 from Elvis Stansvik (elvstone@gmail.com) ---
Created attachment 260359
  --> https://bugzilla.kernel.org/attachment.cgi?id=260359&action=edit
Test case showing the problem

A test case, run with a.out <srcfile> <dstfile>

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
