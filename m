From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12579] ext4 filesystem hang
Date: Fri, 13 Feb 2009 14:22:34 -0800 (PST)
Message-ID: <20090213222234.60A7911D109@picon.linux-foundation.org>
References: <bug-12579-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47367 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753302AbZBMWXF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Feb 2009 17:23:05 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1DMMY2g028466
	for <linux-ext4@vger.kernel.org>; Fri, 13 Feb 2009 14:22:35 -0800
In-Reply-To: <bug-12579-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12579


sandeen@redhat.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
  Attachment #20238|0                           |1
        is obsolete|                            |




------- Comment #9 from sandeen@redhat.com  2009-02-13 14:22 -------
Created an attachment (id=20239)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=20239&action=view)
updated patch w/ my signoffs

Updated the patch w/ my tested/reviewed by.

I'd like to think about whether we can make write_cache_pages smarter and not
need to sort of recreate bits of it in the ext4 code, but for now this solves
my problem, at least.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
