From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12543] ext4_da_writepages error in 2.6.28.1 after a disk error
Date: Tue, 27 Jan 2009 10:26:05 -0800 (PST)
Message-ID: <20090127182606.0A9EB10803F@picon.linux-foundation.org>
References: <bug-12543-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55465 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753226AbZA0S0k (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Jan 2009 13:26:40 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0RIQ6ro006564
	for <linux-ext4@vger.kernel.org>; Tue, 27 Jan 2009 10:26:07 -0800
In-Reply-To: <bug-12543-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12543





------- Comment #2 from abaptist@cleversafe.com  2009-01-27 10:26 -------
The disk was failing, really the purpose of this bug was just to have ext4
handle this gracefully. The continuous emerg level messages printed to console
(about 2/sec) make it very hard to work with (at least with default of emerg
going to *)


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
