From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12272] at random rmmod/insmod corrupts filesystem
Date: Sat, 17 Jan 2009 10:43:33 -0800 (PST)
Message-ID: <20090117184333.97457108043@picon.linux-foundation.org>
References: <bug-12272-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60728 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763861AbZAQSoE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 17 Jan 2009 13:44:04 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0HIhXDk023491
	for <linux-ext4@vger.kernel.org>; Sat, 17 Jan 2009 10:43:34 -0800
In-Reply-To: <bug-12272-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12272





------- Comment #22 from folkert@vanheusden.com  2009-01-17 10:43 -------
(In reply to comment #20)
[ .. not guaranteed that removing a module works in all cases ]
> P.P.S. In any case, it's pretty clear this isn't a filesystem bug.

Ah ok. I thought it was supposed to work in all cases and that I just found a
bug that should not be there.
Glad it is not a filesystem bug as I became a little afraid to upgrade to
something more recent than 2.6.26.

Thanks


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
