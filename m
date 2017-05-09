From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 195561] Suspicious persistent EXT4-fs error:
 ext4_validate_block_bitmap:395: [Proc] bg 17: block 557056: invalid block
 bitmap
Date: Tue, 09 May 2017 05:01:03 +0000
Message-ID: <bug-195561-13602-LX2iprgMKw@https.bugzilla.kernel.org/>
References: <bug-195561-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:54428 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752232AbdEIFBL (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 9 May 2017 01:01:11 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id EB358269DA
        for <linux-ext4@vger.kernel.org>; Tue,  9 May 2017 05:01:10 +0000 (UTC)
In-Reply-To: <bug-195561-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=195561

--- Comment #28 from Andreas Dilger (adilger.kernelbugzilla@dilger.ca) ---
As Ted has mentioned a couple of times, you could try running make_ext4fs and
then immediately running "e2fsck -f /dev/XXXX" on the filesystem created by
make_ext4fs _before_ it is mounted by the kernel.  It is entirely possible that
make_ext4fs is creating a corrupted filesystem, and the kernel is detecting
this at runtime.  This would explain why the filesystem is corrupted in the
same way for all of the different devices.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
