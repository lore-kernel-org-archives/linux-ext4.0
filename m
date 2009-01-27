From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12551] end_request: I/O error, dev cciss/c0d0, sector 87435720
Date: Tue, 27 Jan 2009 08:51:36 -0800 (PST)
Message-ID: <20090127165136.C510F108040@picon.linux-foundation.org>
References: <bug-12551-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43499 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755463AbZA0Qv6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Jan 2009 11:51:58 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0RGpaIX029426
	for <linux-ext4@vger.kernel.org>; Tue, 27 Jan 2009 08:51:38 -0800
In-Reply-To: <bug-12551-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12551


mike.miller@hp.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         AssignedTo|fs_ext4@kernel-bugs.osdl.org|mike.miller@hp.com
             Status|NEW                         |ASSIGNED




------- Comment #3 from mike.miller@hp.com  2009-01-27 08:51 -------
cciss does not support write barriers at this time. Seems that someone in the
community requested updated specs so they might implement the support, but I
can't find that particular mail.
I'll have to look at how other drivers implement write barriers.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
You are the assignee for the bug, or are watching the assignee.
