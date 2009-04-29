From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13201] kernel BUG at fs/ext4/extents.c:2737
Date: Wed, 29 Apr 2009 03:15:34 GMT
Message-ID: <200904290315.n3T3FYbe015926@demeter.kernel.org>
References: <bug-13201-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:39434 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbZD2DPe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Apr 2009 23:15:34 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n3T3FYZ6015927
	for <linux-ext4@vger.kernel.org>; Wed, 29 Apr 2009 03:15:34 GMT
In-Reply-To: <bug-13201-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13201


Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com




--- Comment #3 from Eric Sandeen <sandeen@redhat.com>  2009-04-29 03:15:31 ---
Franco, sorry we haven't gotten back with suggestions on this.  It looks like
you have hit a couple different end results.  We've had a few reports of
corruption on larger filesystems which makes us wonder if there might be a
problem above 8T somewhere... 

The current upstream git tree (or the 2.6.30-rc3-git5 prepatch) has more extent
validity checking in it; if you do have the time for another test, running on
that codebase may yield more info, depending on where the problem lies.

-Eric

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
