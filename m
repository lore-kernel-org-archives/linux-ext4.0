Return-Path: <SRS0=gW7+=OL=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:49102 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725844AbeLBN2u (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 08:28:50 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id DAA2E2A43C
        for <linux-ext4@vger.kernel.org>; Sun,  2 Dec 2018 13:28:46 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Sun, 02 Dec 2018 13:28:45 +0000
Message-ID: <bug-201685-13602-X2GCNeflXq@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #142 from Rainer Fiebig (jrf@mailbox.org) ---
(In reply to carlphilippreh from comment #134)
> Created attachment 279781 [details]
> Config of second computer

Thanks. It'll take a while to sift through this.

As an alternative to 4.19 you may want to use one of the latest LTS-kernels,
4.14.84 perhaps.[1]
But before compiling/installing it, make sure the fs is OK (s. comment 114).

[1] https://www.kernel.org/

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
