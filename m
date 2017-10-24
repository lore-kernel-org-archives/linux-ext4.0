From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 197045] renameat2 rename_noreplace
Date: Tue, 24 Oct 2017 21:35:32 +0000
Message-ID: <bug-197045-13602-n4Wuuqabpg@https.bugzilla.kernel.org/>
References: <bug-197045-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:50780 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751330AbdJXVfg (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 24 Oct 2017 17:35:36 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id DD10828A93
        for <linux-ext4@vger.kernel.org>; Tue, 24 Oct 2017 21:35:35 +0000 (UTC)
In-Reply-To: <bug-197045-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=197045

--- Comment #12 from Thiago Macieira (thiago@macieira.org) ---
Thanks Ted.

For the record, I'm applying a fix to the Qt code, since the error is
legitimate for non-local fs: https://codereview.qt-project.org/209385

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
