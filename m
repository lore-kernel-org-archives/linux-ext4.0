From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12885] kernel BUG at fs/jbd/transaction.c:1376!
Date: Sat, 21 Mar 2009 00:12:08 -0700 (PDT)
Message-ID: <20090321071209.13354108040@picon.linux-foundation.org>
References: <bug-12885-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36221 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750871AbZCUHMr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 21 Mar 2009 03:12:47 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n2L7C9tD013352
	for <linux-ext4@vger.kernel.org>; Sat, 21 Mar 2009 00:12:45 -0700
In-Reply-To: <bug-12885-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12885


andy-kernelbugzilla@splashground.de changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |REJECTED
         Resolution|                            |INVALID




------- Comment #25 from andy-kernelbugzilla@splashground.de  2009-03-21 00:12 -------
Turns out the grub root was wrong and so an old kernel got loaded,
leading to a mismatch between kernel and modules.

If you still consider this a bug, i'll submit the e2image.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
