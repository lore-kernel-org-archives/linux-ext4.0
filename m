From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12579] ext4 filesystem hang
Date: Thu, 12 Feb 2009 07:24:06 -0800 (PST)
Message-ID: <20090212152406.C59BC108041@picon.linux-foundation.org>
References: <bug-12579-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34782 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750774AbZBLPYi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Feb 2009 10:24:38 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1CFO6JO003925
	for <linux-ext4@vger.kernel.org>; Thu, 12 Feb 2009 07:24:08 -0800
In-Reply-To: <bug-12579-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12579


sandeen@redhat.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         Regression|0                           |1




------- Comment #1 from sandeen@redhat.com  2009-02-12 07:24 -------
Finally had some time, and I've tracked this down to the page-writeback.c
changes since .28 - backing them all out the testcase runs overnight.  Still
working out which one and why.  I suppose it's still possible it's an ext4 bug
but if so the page-writeback.c changes exposed it.

It's a classic deadlock; I usually have 2 threads stuck, pdflush vs. the livecd
creator doing an fsync.  Each is waiting for a page the other has locked.

-Eric


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
