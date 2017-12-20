From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 198187] jbd2_log_wait_commit hangs
Date: Wed, 20 Dec 2017 05:40:26 +0000
Message-ID: <bug-198187-13602-hWDLiZFA92@https.bugzilla.kernel.org/>
References: <bug-198187-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:34076 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751752AbdLTFk2 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 20 Dec 2017 00:40:28 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 0C864289D1
        for <linux-ext4@vger.kernel.org>; Wed, 20 Dec 2017 05:40:28 +0000 (UTC)
In-Reply-To: <bug-198187-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=198187

--- Comment #5 from Alexander V. Lukyanov (lav@yar.ru) ---
Created attachment 261273
  --> https://bugzilla.kernel.org/attachment.cgi?id=261273&action=edit
LA graph

here is the LA graph from our monitoring. The server was rebooted many times in
November.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
