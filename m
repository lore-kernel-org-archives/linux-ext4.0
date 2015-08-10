From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 101011] Kernel Oops when disconnecting a mounted ext4 usb stick
Date: Mon, 10 Aug 2015 18:02:02 +0000
Message-ID: <bug-101011-13602-N8wfQfJJLT@https.bugzilla.kernel.org/>
References: <bug-101011-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:36140 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932291AbbHJSCG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Aug 2015 14:02:06 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9157F20794
	for <linux-ext4@vger.kernel.org>; Mon, 10 Aug 2015 18:02:05 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id D47AD20738
	for <linux-ext4@vger.kernel.org>; Mon, 10 Aug 2015 18:02:02 +0000 (UTC)
In-Reply-To: <bug-101011-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=101011

k.kotlenga@sims.pl changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |hch@lst.de,
                   |                            |linux-ext4@vger.kernel.org

--- Comment #6 from k.kotlenga@sims.pl ---
This bug is still present in 4.2-rc6. Reverting:

commit 08439fec266c3cc5702953b4f54bdf5649357de0
Author: Christoph Hellwig <hch@lst.de>
Date:   Thu Apr 2 23:56:32 2015 -0400

    ext4: remove block_device_ejected

    bdi->dev now never goes away, so this function became useless.

    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

makes the oops go away, at least for me (I've tested this on v4.1.4 i386 only).
I hope this rings some bells.

-- 
You are receiving this mail because:
You are on the CC list for the bug.
