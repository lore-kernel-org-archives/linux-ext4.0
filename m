Return-Path: <SRS0=c0SX=OB=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:51002 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730412AbeKVTxY (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 22 Nov 2018 14:53:24 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id A82A12C323
        for <linux-ext4@vger.kernel.org>; Thu, 22 Nov 2018 09:14:48 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Thu, 22 Nov 2018 09:14:48 +0000
Message-ID: <bug-201685-13602-8yfcUxmRoE@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #29 from carlphilippreh@gmail.com ---
Sorry for the late response, but I have been trying to reproduce the problem
with 4.19.2 for some while now. It seems that the problem I was experiencing
only happens with 4.19.1 and 4.19.0, and it did so very frequently. I can at
least confirm that I have CONFIG_SCSI_MQ_DEFAULT=y set in 4.19 but I didn't in
4.18. I hope that this is, at least for me, fixed for now.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
