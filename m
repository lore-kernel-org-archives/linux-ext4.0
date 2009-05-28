From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13292] ext4 without journal reproductible file corruption
Date: Thu, 28 May 2009 21:16:10 GMT
Message-ID: <200905282116.n4SLGAbh003298@demeter.kernel.org>
References: <bug-13292-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:49786 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762029AbZE1VQI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 May 2009 17:16:08 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n4SLGAKY003299
	for <linux-ext4@vger.kernel.org>; Thu, 28 May 2009 21:16:10 GMT
In-Reply-To: <bug-13292-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13292





--- Comment #7 from Frank Mayhar <fmayhar@google.com>  2009-05-28 21:16:09 ---
Yesterday I pulled down Ted's ext4-stable tree and built it.  Today I used it
to actually reproduce this problem.  Now to try to track it down...

BTW, my suspicion is that the problem is either somewhere in the rest of the
kernel or maybe some post-2.6.26 change elsewhere is tickling a problem in ext4
itself.  I suspect this because we're very nearly up-to-date with ext4 itself
(modulo some patches that don't seem directly relevant to this issue) but the
rest of our kernel is still pretty much straight 2.6.26.  If it were strictly
an ext4 issue I would think we would be able to reproduce it with our kernel,
but we can't.

I'm going to work on tracking it down; I'm posting here just to make sure I'm
not duplicating someone else's effort.  Ted?

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
