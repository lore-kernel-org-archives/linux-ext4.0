From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Sun, 8 Nov 2009 21:12:44 GMT
Message-ID: <200911082112.nA8LCia7003432@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:56804 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094AbZKHVMi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 8 Nov 2009 16:12:38 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nA8LCiTb003433
	for <linux-ext4@vger.kernel.org>; Sun, 8 Nov 2009 21:12:44 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #184 from Theodore Tso <tytso@mit.edu>  2009-11-08 21:12:42 ---
> First off, it's slower. Secondly, 'l' is already 'strlen+1', so it looks 
> like ext4 _already_ copies the NUL terminating character.
> 
> So I suspect the debugging patch complained about writing a NUL to a 
> location that was already NUL to begin with.

Umm, yeah.  Good point.  Since the debugging patch marks the page ro,
short of doing a test before trying to null-terminate the symlink, the
debugging patch is always going to flag a false-positive here.

                              - Ted

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
