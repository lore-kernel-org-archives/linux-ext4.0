From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 195561] Suspicious persistent EXT4-fs error:
 ext4_validate_block_bitmap:395: [Proc] bg 17: block 557056: invalid block
 bitmap
Date: Mon, 24 Apr 2017 03:01:57 +0000
Message-ID: <bug-195561-13602-vQpmNIMdTL@https.bugzilla.kernel.org/>
References: <bug-195561-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:51398 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1164361AbdDXDB7 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 23 Apr 2017 23:01:59 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 73C342522B
        for <linux-ext4@vger.kernel.org>; Mon, 24 Apr 2017 03:01:58 +0000 (UTC)
In-Reply-To: <bug-195561-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=195561

Mauro Rossi (issor.oruam@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
            Summary|Suspicious persistent       |Suspicious persistent
                   |EXT4-fs error (device       |EXT4-fs error:
                   |sda1):                      |ext4_validate_block_bitmap:
                   |ext4_validate_block_bitmap: |395: [Proc] bg 17: block
                   |395: [Proc] bg 17: block    |557056: invalid block
                   |557056: invalid block       |bitmap
                   |bitmap                      |

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
