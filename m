Return-Path: <SRS0=gW7+=OL=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:58836 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725773AbeLBUeq (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 15:34:46 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 489182A515
        for <linux-ext4@vger.kernel.org>; Sun,  2 Dec 2018 20:34:44 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Sun, 02 Dec 2018 20:34:41 +0000
Message-ID: <bug-201685-13602-h113osov7z@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

Andreas Dilger (adilger.kernelbugzilla@dilger.ca) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |adilger.kernelbugzilla@dilg
                   |                            |er.ca

--- Comment #164 from Andreas Dilger (adilger.kernelbugzilla@dilger.ca) ---
There was a recent post on linux-ext4 that this might relate to a compiler bug:

> After four days playing games around git bisect - real winner is
> debian gcc-8.2.0-9. Upgrade it to 8.2.0-10 or use 7.3.0-30 version for
> same kernel + config - does not exhibit ext4 corruption.

> I think I hit this https://gcc.gnu.org/bugzilla/show_bug.cgi?id=87859
> with 8.2.0-9 version.

Can people hitting this please confirm or deny whether this compiler is in use
on your system.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
