From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42872] fstat()/ext3_iget() sometime takes over 2 minutes...
Date: Wed, 4 Apr 2012 23:31:59 GMT
Message-ID: <201204042331.q34NVxdL022415@bugzilla.kernel.org>
References: <bug-42872-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:43102 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757286Ab2DDXb7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Apr 2012 19:31:59 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q34NVxL8022416
	for <linux-ext4@vger.kernel.org>; Wed, 4 Apr 2012 23:31:59 GMT
In-Reply-To: <bug-42872-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42872





--- Comment #4 from Petr Vandrovec <petr@vandrovec.name>  2012-04-04 23:31:57 ---
I've looked at my box, and it says:

[   9.329354] EXT3-fs (sda5): mounted filesystem with writeback data mode
[  69.269122] EXT3-fs (sda1): mounted filesystem with writeback data mode
[  69.606184] EXT3-fs (sdb2): mounted filesystem with writeback data mode
[  69.641482] EXT3-fs (sdf1): mounted filesystem with writeback data mode
[  69.677489] EXT3-fs (sdg1): mounted filesystem with writeback data mode
[  69.792985] EXT3-fs (sdh1): mounted filesystem with writeback data mode
[  69.883098] EXT3-fs (sdc1): mounted filesystem with writeback data mode

So I'm already using writeback...

But for unknown reason system did not reboot for last 6 days and 5 hours.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
