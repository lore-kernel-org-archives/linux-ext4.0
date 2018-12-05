Return-Path: <SRS0=z94b=OO=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:41464 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727495AbeLEKRq (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Dec 2018 05:17:46 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 136DA2CD99
        for <linux-ext4@vger.kernel.org>; Wed,  5 Dec 2018 10:17:46 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] Incorrect disk writes caused by blk-mq lead to file
 system corruption
Date: Wed, 05 Dec 2018 10:17:45 +0000
Message-ID: <bug-201685-13602-P94YvQJviz@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

Artem S. Tashkinov (aros@gmx.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
          Component|ext4                        |Block Layer
     Kernel Version|maybe one of 4.18.18 4.19.1 |4.19.x 4.20-rc
                   |4.20-rc2                    |
           Assignee|fs_ext4@kernel-bugs.osdl.or |axboe@kernel.dk
                   |g                           |
            Product|File System                 |IO/Storage
         Regression|No                          |Yes
            Summary|ext4 file system corruption |Incorrect disk writes
                   |                            |caused by blk-mq lead to
                   |                            |file system corruption

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
