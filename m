From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 198187] jbd2_log_wait_commit hangs
Date: Tue, 23 Jan 2018 07:20:06 +0000
Message-ID: <bug-198187-13602-XkRPiJ7yJZ@https.bugzilla.kernel.org/>
References: <bug-198187-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:47502 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750897AbeAWHUH (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 23 Jan 2018 02:20:07 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 5370928647
        for <linux-ext4@vger.kernel.org>; Tue, 23 Jan 2018 07:20:07 +0000 (UTC)
In-Reply-To: <bug-198187-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=198187

--- Comment #10 from Alexander A. (dralex2004@yandex.ru) ---
Created attachment 273805
  --> https://bugzilla.kernel.org/attachment.cgi?id=273805&action=edit
output of the 'dmsetup table'

Posting output of the 'dmsetup table'

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
