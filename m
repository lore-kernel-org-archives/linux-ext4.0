From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12579] ext4 filesystem hang
Date: Fri, 13 Feb 2009 19:52:11 -0800 (PST)
Message-ID: <20090214035211.E92B511D109@picon.linux-foundation.org>
References: <bug-12579-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52732 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752226AbZBNDwo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Feb 2009 22:52:44 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1E3qCnA017102
	for <linux-ext4@vger.kernel.org>; Fri, 13 Feb 2009 19:52:13 -0800
In-Reply-To: <bug-12579-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12579





------- Comment #11 from sandeen@redhat.com  2009-02-13 19:52 -------
Ted, all good questions.  :)  If you think we need to digest this a bit that's
fine, though I'd rather this go in than not at all, before 2.6.29 gets out the
door.  But I think we still have some time.

The problem has not been seen on 2.6.28 kernels; I can't right now point for
sure to one of Nick's patch series that changed the behavior; in fact many
points in the series seemed to not work at all; even building kernels on other
filesystems got me hung up.  Didn't inspire tons of confidence.  :)

You're probably right though, and echoing my concern in the previous comment,
that we might need to look at this holistically and decide if this exact change
to ext4 is the right path or if the page-writeback infrastructure needs a
tweak...

-Eric


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
