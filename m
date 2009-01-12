From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12424] ext4_da_writepages error while downloading a file w/firefox
Date: Mon, 12 Jan 2009 07:07:36 -0800 (PST)
Message-ID: <20090112150736.10FCE10800D@picon.linux-foundation.org>
References: <bug-12424-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39188 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752408AbZALPIK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Jan 2009 10:08:10 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0CF7a7C009980
	for <linux-ext4@vger.kernel.org>; Mon, 12 Jan 2009 07:07:37 -0800
In-Reply-To: <bug-12424-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12424





------- Comment #6 from tytso@mit.edu  2009-01-12 07:07 -------
There was at least one ext4 bug that could have caused this that was fixed in
2.6.28 as well as in the 2.6.29 merge window.   Unfortunately, we need to see
the original bug to know which bug might as caused the problem.   There was
also a more recent bug fix that makes ext4_da_writepages much less verbose,
since that tends to hide the original root cause of the problem....


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
