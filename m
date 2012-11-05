From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 50021] ext4 discard option not working on journal dissabled
 filesystem
Date: Mon,  5 Nov 2012 13:50:28 +0000 (UTC)
Message-ID: <20121105135028.9B60311FB5A@bugzilla.kernel.org>
References: <bug-50021-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:45494 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754285Ab2KENug (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Nov 2012 08:50:36 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 33023201C9
	for <linux-ext4@vger.kernel.org>; Mon,  5 Nov 2012 13:50:31 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 2C2E320167
	for <linux-ext4@vger.kernel.org>; Mon,  5 Nov 2012 13:50:29 +0000 (UTC)
In-Reply-To: <bug-50021-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=50021


Tao Ma <tm@tao.ma> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tm@tao.ma




--- Comment #1 from Tao Ma <tm@tao.ma>  2012-11-05 13:50:28 ---
Interesting, it works fine here with my intel ssd.
So could you please do:
1. mount -t debugfs none /sys/kernel/debug/
2. echo 1 > /sys/kernel/debug/tracing/events/ext4/ext4_discard_blocks/enable 
3. run you test
4. after 'rm', do
cat /sys/kernel/debug/tracing/trace

If your see something like 
jbd2/sdb2-8-23853 [000] .... 30125.695303: ext4_discard_blocks: dev 8,18 blk
34816 count 3072
              rm-23870 [000] .... 30130.908415: ext4_discard_blocks: dev 8,17
blk 34816 count 3072

(The first one is captured by the device with journal and the second one is
captured by the device without journal).
Then that does mean ext4 has sent out the discard command to the underlying
device.

btw, my kernel version is 3.6.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
