From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12885] kernel BUG at fs/jbd/transaction.c:1376!
Date: Wed, 18 Mar 2009 11:14:14 -0700 (PDT)
Message-ID: <20090318181414.57C3910800E@picon.linux-foundation.org>
References: <bug-12885-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58426 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751845AbZCRSPZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Mar 2009 14:15:25 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n2IIEEPr031521
	for <linux-ext4@vger.kernel.org>; Wed, 18 Mar 2009 11:14:50 -0700
In-Reply-To: <bug-12885-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12885





------- Comment #11 from andy-kernelbugzilla@splashground.de  2009-03-18 11:14 -------
(In reply to comment #8)
> One interesting thing you could try, if you can go to 2.6.29-rc8, is you could
> try mounting your ext3 filesystem using ext4, and see if the problem goes away
> or not.   If the problem sticks around, then that's actually very interesting,
> since so much has changed between ext3 and ext4.  If it goes away, that could
> be a solution for you, but it also could be that it's just harder to reproduce
> on ext4.

Might we not loose the bug that way, as in it'd be gone for ever?
Can I do that read-only?

> This smells like a bug in jbd layer, or perhaps some assumption which is
> getting violated by LUKS; since if it was as simple as just doing a backup of a
> tree while another process was copying data into it, ext3 is such a commonly
> used file system that I would have thought such a problem would have been
> discovered by now.  So if we have something like this which can be easily
> reproduced, I really want to try to get it chased down.

It's as easy as *reading* the afaics. I'll test this some more.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
