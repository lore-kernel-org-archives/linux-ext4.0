From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13930] non-contiguous files (64.9%) on a ext4 fs
Date: Fri, 7 Aug 2009 14:40:12 GMT
Message-ID: <200908071440.n77EeCVu015148@demeter.kernel.org>
References: <bug-13930-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:33852 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932558AbZHGOkL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Aug 2009 10:40:11 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n77EeCaH015149
	for <linux-ext4@vger.kernel.org>; Fri, 7 Aug 2009 14:40:12 GMT
In-Reply-To: <bug-13930-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13930


Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com




--- Comment #1 from Eric Sandeen <sandeen@redhat.com>  2009-08-07 14:40:11 ---
It might be interesting to poke around with filefrag and see which files are
fragmented, and compare that to how big they are.  Summary stats like this can
sometimes be misleading.

Or to put it another way, if half your files are < 100M and contiguous, and the
other half are > 100M and all of those have 2 50M extents each, I think e2fsck
would say "50.0% non-contiguous" - but this isn't really indicative of a
problem.

If you can demonstrate that simply copying a large file (or files) from cifs
leads to bad fragmentation of that file (or files), then we probably have
something to work on.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
