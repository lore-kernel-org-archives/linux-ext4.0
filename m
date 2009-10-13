From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Tue, 13 Oct 2009 22:02:32 GMT
Message-ID: <200910132202.n9DM2WTP018504@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:58930 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760113AbZJMWDJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Oct 2009 18:03:09 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9DM2WRb018505
	for <linux-ext4@vger.kernel.org>; Tue, 13 Oct 2009 22:02:32 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #40 from Theodore Tso <tytso@mit.edu>  2009-10-13 22:02:31 ---
Alexey, in addition to Eric's very good comments, the other thing that's worth
checking is to do a "sudo touch /forcefsck" (which will force an fsck on the
next reboot) before shutting down your system -- or do it early in your login
session, before you do something dangeorus that might require a forced
reboot/power cycle of your system).   

We need to distinguish between a file which was being replaced at the time of
the power failure (and some desktop applications/toolkits are very update-happy
in terms of constantly rewriting application dot files) versus the file system
actually becoming corrupt.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
