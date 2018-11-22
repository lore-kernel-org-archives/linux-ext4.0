Return-Path: <SRS0=c0SX=OB=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:32890 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730633AbeKVMYG (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 22 Nov 2018 07:24:06 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 769452C7D5
        for <linux-ext4@vger.kernel.org>; Thu, 22 Nov 2018 01:47:04 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Thu, 22 Nov 2018 01:47:04 +0000
Message-ID: <bug-201685-13602-IOkHjggUiw@https.bugzilla.kernel.org/>
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
                 CC|                            |axboe@kernel.dk

--- Comment #24 from Jens Axboe (axboe@kernel.dk) ---
It'd be critical to know if 4.19.3 is still showing the issue with MQ being on.
I'm going to try my luck at reproducing this issue as well, but given that
there hasn't been a lot of noise about it, not sure I'll have too much luck.

I've got a few suspects, so I'm also willing to spin a patch against 4.19.3 if
folks are willing to give that a go.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
