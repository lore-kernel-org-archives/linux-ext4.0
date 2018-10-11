Return-Path: <SRS0=dqau=MX=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:45232 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725995AbeJKOxL (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 11 Oct 2018 10:53:11 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 2489528EDD
        for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2018 07:27:12 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 85381] ext4 & tmpfs: Splicing to regular files doesn't trigger
 inotify
Date: Thu, 11 Oct 2018 07:27:11 +0000
Message-ID: <bug-85381-13602-rOMO16TqWM@https.bugzilla.kernel.org/>
In-Reply-To: <bug-85381-13602@https.bugzilla.kernel.org/>
References: <bug-85381-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=85381

Dario Andreani (darioandre@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |darioandre@gmail.com

--- Comment #2 from Dario Andreani (darioandre@gmail.com) ---
I still see this issue on kernel versions 4.4 and 4.9. But not on 4.15.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
