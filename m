From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12697] ext4_journal_start() spews errors on readonly filesystem
Date: Thu, 12 Feb 2009 12:53:19 -0800 (PST)
Message-ID: <20090212205320.0E36110800D@picon.linux-foundation.org>
References: <bug-12697-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46349 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758752AbZBLUxi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Feb 2009 15:53:38 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1CKrKYa029826
	for <linux-ext4@vger.kernel.org>; Thu, 12 Feb 2009 12:53:21 -0800
In-Reply-To: <bug-12697-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12697


tytso@mit.edu changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |CLOSED
         Resolution|                            |PATCH_ALREADY_AVAILABLE




------- Comment #2 from tytso@mit.edu  2009-02-12 12:53 -------
Yes, it's fixed already in 2.6.29-rcX, and it's in the queue of patches that
I'm preparing for 2.6.27 and 2.6.28.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
