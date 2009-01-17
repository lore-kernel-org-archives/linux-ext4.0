From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12272] at random rmmod/insmod corrupts filesystem
Date: Sat, 17 Jan 2009 10:40:31 -0800 (PST)
Message-ID: <20090117184031.97DAF108043@picon.linux-foundation.org>
References: <bug-12272-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60167 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762502AbZAQSkd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 17 Jan 2009 13:40:33 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0HIeVPZ023332
	for <linux-ext4@vger.kernel.org>; Sat, 17 Jan 2009 10:40:32 -0800
In-Reply-To: <bug-12272-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12272





------- Comment #21 from folkert@vanheusden.com  2009-01-17 10:40 -------
(In reply to comment #18)
> can you always reproduce the problem, if you let this run a second time, i.e.
> you load/unload the modules in the same order as listed ?

Yes, most definately.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
