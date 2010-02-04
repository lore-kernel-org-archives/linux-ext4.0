From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15230] oops on ext4 remount with -o barrier
Date: Thu, 4 Feb 2010 22:38:51 GMT
Message-ID: <201002042238.o14Mcpas025417@demeter.kernel.org>
References: <bug-15230-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:42356 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758514Ab0BDWiw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Feb 2010 17:38:52 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o14McpHQ025419
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 4 Feb 2010 22:38:51 GMT
In-Reply-To: <bug-15230-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15230


Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com
         AssignedTo|fs_ext4@kernel-bugs.osdl.or |sandeen@redhat.com
                   |g                           |




--- Comment #1 from Eric Sandeen <sandeen@redhat.com>  2010-02-04 22:38:48 ---
Can you try it with the patch at:

http://marc.info/?l=linux-ext4&m=126523161410367&w=2

?

I think that likely will fix it for you.  ext4 had 2 options for which it tried
to accept -optional- arguments, and was doing that in a way such that if the
arg was given w/ no option things went badly due to the option structure being
uninitialized.

Something else may have changed in the option parsing, but I think it may be
simplest / most obvious to just fix up ext4.

-Eric

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
