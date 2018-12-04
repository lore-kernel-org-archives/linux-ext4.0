Return-Path: <SRS0=EHOS=ON=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:58648 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725886AbeLDWuR (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Dec 2018 17:50:17 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id B359C2C668
        for <linux-ext4@vger.kernel.org>; Tue,  4 Dec 2018 22:50:16 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Tue, 04 Dec 2018 22:50:14 +0000
Message-ID: <bug-201685-13602-gVSMXKGvul@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

Jens Axboe (axboe@kernel.dk) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
 Attachment #279855|0                           |1
        is obsolete|                            |

--- Comment #255 from Jens Axboe (axboe@kernel.dk) ---
Created attachment 279857
  --> https://bugzilla.kernel.org/attachment.cgi?id=279857&action=edit
4.19/4.20 patch v3

Here's the one I sent upstream, also tested this one. Should be the safest of
them all, as we set REQ_NOMERGE at the source of when we attempt to queue it.
That'll cover all cases, guaranteed.

The folks that have seen this, please try this patch on top of 4.19 or 4.20-rc
and report back.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
