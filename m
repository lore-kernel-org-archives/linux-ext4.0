From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 194567] ext4 no longer mounts
Date: Wed, 15 Feb 2017 11:30:50 +0000
Message-ID: <bug-194567-13602-sN3Laoo7O8@https.bugzilla.kernel.org/>
References: <bug-194567-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:56306 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751569AbdBOLax (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 15 Feb 2017 06:30:53 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id B528E28472
        for <linux-ext4@vger.kernel.org>; Wed, 15 Feb 2017 11:30:52 +0000 (UTC)
Received: from pdx-korg-bugzilla-1.web.codeaurora.org (unknown [172.30.200.120])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 00C862846D
        for <linux-ext4@vger.kernel.org>; Wed, 15 Feb 2017 11:30:51 +0000 (UTC)
In-Reply-To: <bug-194567-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=194567

--- Comment #4 from bugzilla.kernel.org@plan9.de ---
First, I'm impressed how quickly this was handled. I am in no pressing need of
a fix (4.4.47 works just as well) and would like to avoid compiling a kernel
just for this fix. Hope this is ok and the issue is "obvious" enough to fix
without it, so from my side, all is well and I can check once this hits a
release kernel.

As for resizing, my lvm history doesn't go back that far, and I don't
specifically remember having it resized, but since the fs has moved through at
least three different disks and contains a slowly growing database, it would be
a prime target for resizing - I certainly do have a habit of resizing
filesystems in general.

On the other hand, wouldn't -O ^resize_inode preclude online resizing? No need
to answer that, you certainly know best. If, however, online resizing wouldn't
work I probably would have played ayround with tune2fs andf/or offline resizing
to make it work.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
