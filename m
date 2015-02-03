From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 92271] Provide a way to really delete files, please
Date: Tue, 03 Feb 2015 17:29:29 +0000
Message-ID: <bug-92271-13602-jLK2Jo000t@https.bugzilla.kernel.org/>
References: <bug-92271-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:38613 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbbBCR3c (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Feb 2015 12:29:32 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 44D6E20272
	for <linux-ext4@vger.kernel.org>; Tue,  3 Feb 2015 17:29:31 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id B191120253
	for <linux-ext4@vger.kernel.org>; Tue,  3 Feb 2015 17:29:29 +0000 (UTC)
In-Reply-To: <bug-92271-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=92271

--- Comment #22 from Theodore Tso <tytso@mit.edu> ---
Alexander, merely overwriting the blocks won't necessarily help if you are
using a SSD or something like dm-thin.   That's the point; such patches will be
making promises that can't be kept in all circumstances. In the case of an SSD,
it might be require accessing the flash cells directly without the FTL getting
in the way. 

So before you advertise such a scheme, you need to be very clear what your
threat model and what capabilities the adversary is supposed to have.   And,
also, what responsibility you might bear (or a commercial company like Red Hat
or SuSE might bear --- both in terms of legal liability and reputational
damage) if they advertise such a feature, and then it turns out that the way
the user happened to configure their system, it wasn't secure after all.


-- Ted

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
