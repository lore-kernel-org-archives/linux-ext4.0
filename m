Return-Path: <SRS0=EHOS=ON=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:36044 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725880AbeLDWGr (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Dec 2018 17:06:47 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 591B42BB66
        for <linux-ext4@vger.kernel.org>; Tue,  4 Dec 2018 22:06:47 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Tue, 04 Dec 2018 22:06:45 +0000
Message-ID: <bug-201685-13602-rTjVIxUPY1@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #249 from Jens Axboe (axboe@kernel.dk) ---
Created attachment 279853
  --> https://bugzilla.kernel.org/attachment.cgi?id=279853&action=edit
4.19 fix

Here's a fix, verifying it now. It might be better to fully unprep the request
after the direct issue fails, but this one should be the safe no-brainer. And
at times like this, that feels prudent...

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
