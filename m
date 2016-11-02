From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 186551] mkfs.ext4 tries to discard sector beyond the end of the
 device
Date: Wed, 02 Nov 2016 14:30:15 +0000
Message-ID: <bug-186551-13602-cPM3J6woMA@https.bugzilla.kernel.org/>
References: <bug-186551-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:37146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755645AbcKBOaV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 2 Nov 2016 10:30:21 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 698C920383
        for <linux-ext4@vger.kernel.org>; Wed,  2 Nov 2016 14:30:19 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 2EF4F20412
        for <linux-ext4@vger.kernel.org>; Wed,  2 Nov 2016 14:30:16 +0000 (UTC)
In-Reply-To: <bug-186551-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=186551

Tamas Vincze <tom@vincze.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |PATCH_ALREADY_AVAILABLE

--- Comment #11 from Tamas Vincze <tom@vincze.org> ---
Updated the SSD's firmware and now it works:

# blkdiscard -v /dev/nvme0n1p1
/dev/nvme0n1p1: Discarded 800164151296 bytes from the offset 0

For the record: old firmware: 8DV10171, updated to: 8DV101F0
Oddly enough its release notes doesn't mention any discard-related fix.

Thanks Eric for your help!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
