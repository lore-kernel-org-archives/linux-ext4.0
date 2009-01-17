From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12272] at random rmmod/insmod corrupts filesystem
Date: Sat, 17 Jan 2009 05:47:46 -0800 (PST)
Message-ID: <20090117134746.2E70A108042@picon.linux-foundation.org>
References: <bug-12272-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40760 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753849AbZAQNrs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 17 Jan 2009 08:47:48 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0HDlkDr006582
	for <linux-ext4@vger.kernel.org>; Sat, 17 Jan 2009 05:47:47 -0800
In-Reply-To: <bug-12272-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12272





------- Comment #16 from tytso@mit.edu  2009-01-17 05:47 -------
Well, the first thing I would do is optimize the test-cycle.   I would create
partition the disk so you can install a stable debian system (I think you said
you were stable with 2.6.26?), a fixed image of your test system (using 2.6.28
or 2.6.29-rc1), using the smallest posible system you can that still reproduces
the problem.    Then copy, using dd, the fixed image of the test system to the
scratch partition, and then rig up grub (where the menu.conf file is on your
stable system) so you can boot the scratch partition.   Hopefully that way you
can cut down your test cycle down to 5-10 minutes.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
