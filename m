From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 186551] mkfs.ext4 tries to discard sector beyond the end of the
 device
Date: Tue, 01 Nov 2016 17:48:00 +0000
Message-ID: <bug-186551-13602-KkBbJcawJa@https.bugzilla.kernel.org/>
References: <bug-186551-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:51112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753076AbcKARsF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 1 Nov 2016 13:48:05 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 3114B20454
        for <linux-ext4@vger.kernel.org>; Tue,  1 Nov 2016 17:48:04 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 306E72043C
        for <linux-ext4@vger.kernel.org>; Tue,  1 Nov 2016 17:48:01 +0000 (UTC)
In-Reply-To: <bug-186551-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=186551

--- Comment #2 from Tamas Vincze <tom@vincze.org> ---
# cat /proc/partitions 
major minor  #blocks  name

   8        0  292935982 sda
   8        1     512000 sda1
   8        2    1048576 sda2
   8        3    1048576 sda3
   8        4  290325504 sda4
  11        0    1048575 sr0
 259        0  781412184 nvme0n1
 259        1  781410304 nvme0n1p1
 253        0   16777216 dm-0
 253        1   33554432 dm-1
 253        2  134217728 dm-2

I thought that the sector number in
"blk_update_request: I/O error, dev nvme0n1, sector 1530955776"
is a 4k sector number.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
