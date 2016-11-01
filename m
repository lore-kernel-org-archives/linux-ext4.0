From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 186551] mkfs.ext4 tries to discard sector beyond the end of the
 device
Date: Tue, 01 Nov 2016 17:50:28 +0000
Message-ID: <bug-186551-13602-nAwka7nylz@https.bugzilla.kernel.org/>
References: <bug-186551-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:51476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751845AbcKARub (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 1 Nov 2016 13:50:31 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 442F020454
        for <linux-ext4@vger.kernel.org>; Tue,  1 Nov 2016 17:50:30 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 43AE52044C
        for <linux-ext4@vger.kernel.org>; Tue,  1 Nov 2016 17:50:28 +0000 (UTC)
In-Reply-To: <bug-186551-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=186551

--- Comment #3 from Tamas Vincze <tom@vincze.org> ---
Created attachment 243511
  --> https://bugzilla.kernel.org/attachment.cgi?id=243511&action=edit
full dmesg

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
