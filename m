Return-Path: <SRS0=gW7+=OL=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:50854 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725781AbeLBKUi (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 05:20:38 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id CE6142B264
        for <linux-ext4@vger.kernel.org>; Sun,  2 Dec 2018 10:20:33 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Sun, 02 Dec 2018 10:20:32 +0000
Message-ID: <bug-201685-13602-zGq2zbcsBd@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #129 from carlphilippreh@gmail.com ---
(In reply to carlphilippreh from comment #29)
> Sorry for the late response, but I have been trying to reproduce the problem
> with 4.19.2 for some while now. It seems that the problem I was experiencing
> only happens with 4.19.1 and 4.19.0, and it did so very frequently. I can at
> least confirm that I have CONFIG_SCSI_MQ_DEFAULT=y set in 4.19 but I didn't
> in 4.18. I hope that this is, at least for me, fixed for now.

While I wasn't able to reproduce the bug for quite some time, it ended up
coming back. I'm currently running 4.19.6 and I see invalid metadata in files
that I have written using this version.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
