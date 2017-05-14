From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 195561] Suspicious persistent EXT4-fs error:
 ext4_validate_block_bitmap:395: [Proc] bg 17: block 557056: invalid block
 bitmap
Date: Sun, 14 May 2017 04:14:02 +0000
Message-ID: <bug-195561-13602-eaIwrQLDxJ@https.bugzilla.kernel.org/>
References: <bug-195561-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:52802 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752258AbdENEOF (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 14 May 2017 00:14:05 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 12619285FF
        for <linux-ext4@vger.kernel.org>; Sun, 14 May 2017 04:14:04 +0000 (UTC)
In-Reply-To: <bug-195561-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=195561

--- Comment #31 from Theodore Tso (tytso@mit.edu) ---
So I'm just curious.  Android's fix for the problem landed in October 2016[1]. 
It's now May 2017.  Why is it that so many folks are still using an old version
of AOSP that apparently does not have this fix?   

[1]
https://android.googlesource.com/platform/system/extras/+/c71eaf37486bed9163ad528f51de29dd56b34fd2

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
