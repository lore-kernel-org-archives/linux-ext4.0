From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12568] BUG: filefrag errors on non-journal ext4 filesystem
Date: Thu, 29 Jan 2009 23:43:35 -0800 (PST)
Message-ID: <20090130074335.6E224108042@picon.linux-foundation.org>
References: <bug-12568-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49923 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752024AbZA3Hnh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 Jan 2009 02:43:37 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0U7hZUs010991
	for <linux-ext4@vger.kernel.org>; Thu, 29 Jan 2009 23:43:36 -0800
In-Reply-To: <bug-12568-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12568


k-mio@sx.jp.nec.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |CODE_FIX




------- Comment #2 from k-mio@sx.jp.nec.com  2009-01-29 23:43 -------
The patch fixes this issue for me.
Thanks for your help.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
