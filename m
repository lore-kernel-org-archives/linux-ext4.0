From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12829] kernel complains on ENOSPC
Date: Fri,  6 Mar 2009 15:02:21 -0800 (PST)
Message-ID: <20090306230222.2732110800D@picon.linux-foundation.org>
References: <bug-12829-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52850 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753132AbZCFXCz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Mar 2009 18:02:55 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n26N2Mhl001696
	for <linux-ext4@vger.kernel.org>; Fri, 6 Mar 2009 15:02:23 -0800
In-Reply-To: <bug-12829-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12829





------- Comment #1 from tytso@mit.edu  2009-03-06 15:02 -------
What are the precise reproduction details?   We're supposed to keep track of
how many delayed allocation blocks are outstanding, so that we return ENOSPC
*before* we get to this stage.

I'm not sure we do the right thing if we mmap into an unallocated region of
file; when do we actually track delayed allocation blocks?   The right answer
would be at mmap() time, but OTOH that means if we mmap a 2GB region, do we
immediately take a 2GB charge because the process might write into this region?
 And does free space returned by 'df' immediately drop by 2GB?

Do you know if there was any allocation by mmap going on in your reproduction
case?   That seems the most likely cause to me, if I had to guess....


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
