From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 194693] Repeated ext4 corruption
Date: Fri, 24 Feb 2017 08:34:44 +0000
Message-ID: <bug-194693-13602-0g1U5dlyBk@https.bugzilla.kernel.org/>
References: <bug-194693-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:40126 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751649AbdBXIl7 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 24 Feb 2017 03:41:59 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 5927D28783
        for <linux-ext4@vger.kernel.org>; Fri, 24 Feb 2017 08:34:47 +0000 (UTC)
Received: from pdx-korg-bugzilla-1.web.codeaurora.org (unknown [172.30.200.120])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 2FD01286E0
        for <linux-ext4@vger.kernel.org>; Fri, 24 Feb 2017 08:34:47 +0000 (UTC)
In-Reply-To: <bug-194693-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=194693

--- Comment #1 from Steinar H. Gunderson (steinar+kernel@gunderson.no) ---
Created attachment 254907
  --> https://bugzilla.kernel.org/attachment.cgi?id=254907&action=edit
e2fsck log (serial console)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
