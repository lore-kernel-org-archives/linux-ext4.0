From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 194071] data loss using fallocate and mmap
Date: Thu, 25 May 2017 08:47:38 +0000
Message-ID: <bug-194071-13602-zoHy8ALJuO@https.bugzilla.kernel.org/>
References: <bug-194071-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:52648 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756923AbdEYIrj (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 25 May 2017 04:47:39 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 062AB27CF9
        for <linux-ext4@vger.kernel.org>; Thu, 25 May 2017 08:47:39 +0000 (UTC)
In-Reply-To: <bug-194071-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=194071

Jan Kara (jack@suse.cz) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jack@suse.cz
 Attachment #254231|text/x-csrc                 |text/plain
          mime type|                            |

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
