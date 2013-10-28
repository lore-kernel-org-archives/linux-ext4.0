From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 63981] Bad: Buffer I/O errors make disk unusable
Date: Mon, 28 Oct 2013 23:31:31 +0000
Message-ID: <bug-63981-13602-AmxD2IDcJp@https.bugzilla.kernel.org/>
References: <bug-63981-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:41648 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757686Ab3J1Xbe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Oct 2013 19:31:34 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id F1F2C2015F
	for <linux-ext4@vger.kernel.org>; Mon, 28 Oct 2013 23:31:33 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 7170E2012C
	for <linux-ext4@vger.kernel.org>; Mon, 28 Oct 2013 23:31:31 +0000 (UTC)
In-Reply-To: <bug-63981-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=63981

--- Comment #4 from Theodore Tso <tytso@mit.edu> ---
BTW, I'm using a 512GB Samsung 840 PRO (2.5" SATA SSD) and an 240GB Intel 525
SSD (mSata) on my Lenovo T430s, and they both work like a charm.

Hmm... I wasn't able to get detailed specs on your SAMSUNG MZNTD256HAGL-00000,
but upon doing some further research, it appears to be a new-fangled M.2 PCIe
interface.  So it's not a mSATA nor a 2.5" SATA interface, but Something New.

So whether or not this is a Linux bug, or an implementation bug in this new
Samsung part (or a failure in the standardization of this new M.2 PCIe
interface), I can't say, but this looks like the most likely cause is a problem
with this new SSD or its new M.2 interface[1].

[1] http://en.wikipedia.org/wiki/Next_Generation_Form_Factor

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
