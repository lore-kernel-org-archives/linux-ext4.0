From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 76261] ext4_da_writepages err -30 after remount ro during
 shutdown
Date: Mon, 19 May 2014 13:41:15 +0000
Message-ID: <bug-76261-13602-x3RXnFWoyl@https.bugzilla.kernel.org/>
References: <bug-76261-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:35254 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754499AbaESNlS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 May 2014 09:41:18 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 62915202A7
	for <linux-ext4@vger.kernel.org>; Mon, 19 May 2014 13:41:17 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 0C02A201F4
	for <linux-ext4@vger.kernel.org>; Mon, 19 May 2014 13:41:16 +0000 (UTC)
In-Reply-To: <bug-76261-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=76261

--- Comment #14 from Theodore Tso <tytso@mit.edu> ---
On Mon, May 19, 2014 at 03:41:21AM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> [80.272068] (3)[3075:kworker/u8:5]EXT4-fs (mmcblk0p15): ext4_da_writepages:
> jbd2_start: 1024 pages, ino 131067; err -30

Oh, and since we now have a file system an inode number, you can
investigate what this inode might actually be.  Suggested commands:

debugfs /dev/mmcblk0p15
debugfs: ncheck 131067

and

debugfs: stat <131067>

Cheers,

                    - Ted

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
