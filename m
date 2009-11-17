From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14601] Wrong handling of META_BG when getting number of blocks
 for group descriptors
Date: Tue, 17 Nov 2009 21:47:50 GMT
Message-ID: <200911172147.nAHLloT6018102@demeter.kernel.org>
References: <bug-14601-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:46664 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbZKQVro (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Nov 2009 16:47:44 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAHLloa7018103
	for <linux-ext4@vger.kernel.org>; Tue, 17 Nov 2009 21:47:50 GMT
In-Reply-To: <bug-14601-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14601


Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jack@suse.cz




--- Comment #1 from Jan Kara <jack@suse.cz>  2009-11-17 21:47:49 ---
Thanks for the patch. It looks good but please look at
Documentation/SubmittingPatches how a patch for kernel should look like (most
notably it misses a Signed-off-by, it should be in a unified format and with a
changelog). Also please create one patch for ext3 and one patch for ext4 since
I will merge the ext3 part and Ted Tso takes care of ext4. Thanks.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
