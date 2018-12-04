Return-Path: <SRS0=EHOS=ON=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:50740 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725899AbeLDWcx (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Dec 2018 17:32:53 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 3D8DC2BCE7
        for <linux-ext4@vger.kernel.org>; Tue,  4 Dec 2018 22:32:52 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Tue, 04 Dec 2018 22:32:50 +0000
Message-ID: <bug-201685-13602-Wju0Umb6tC@https.bugzilla.kernel.org/>
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
 Attachment #279853|0                           |1
        is obsolete|                            |

--- Comment #253 from Jens Axboe (axboe@kernel.dk) ---
Created attachment 279855
  --> https://bugzilla.kernel.org/attachment.cgi?id=279855&action=edit
4.19 patch v2

Better version of the previous patch. They both solve the issue, but the latter
version seems safer since it doesn't rely on whatever state that SCSI happens
to maintain. If we fail direct dispatch, don't ever touch the request before
dispatch.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
