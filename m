Return-Path: <SRS0=gW7+=OL=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:53412 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725859AbeLBOGX (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 09:06:23 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 669B62AD5E
        for <linux-ext4@vger.kernel.org>; Sun,  2 Dec 2018 14:06:20 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Sun, 02 Dec 2018 14:06:19 +0000
Message-ID: <bug-201685-13602-1RmJF1WMAC@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #145 from Rainer Fiebig (jrf@mailbox.org) ---
(In reply to Reindl Harald from comment #138)
> at least continue security updates for 4.18.x would probably be a good idea
> 
> Fedora 28 is already on 4.19.x
> 
> i run now 4.18.20-100.fc27.x86_64 which was the last Fedora 27 update on
> every F28 server and until this problem is solved i refuse to run 4.19.x in
> production which essentially means no security fixes for a unknown amount of
> time

Perhaps you can use one of the LTS-kernels, like 4.14.84.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
