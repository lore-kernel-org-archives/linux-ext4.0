From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12272] at random rmmod/insmod corrupts filesystem
Date: Sat, 17 Jan 2009 11:01:06 -0800 (PST)
Message-ID: <20090117190106.4BBA7108040@picon.linux-foundation.org>
References: <bug-12272-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57806 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754588AbZAQTBh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 17 Jan 2009 14:01:37 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0HJ162F024374
	for <linux-ext4@vger.kernel.org>; Sat, 17 Jan 2009 11:01:07 -0800
In-Reply-To: <bug-12272-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12272


tytso@mit.edu changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         AssignedTo|fs_ext3@kernel-bugs.osdl.org|other_modules@kernel-
                   |                            |bugs.osdl.org
           Severity|normal                      |low
          Component|ext3                        |Modules
            Product|File System                 |Other




------- Comment #25 from tytso@mit.edu  2009-01-17 11:01 -------
I agree this would be a desirable thing to do, but it takes time for this to
happen, and the people who are most interested in determining which modules are
runing into problems when unloaded frequently are the ones who need to do this
testing.   

I'll note there are also those modules which *can* be safely unloaded, as long
as you ifconfig down the interface, make sure there are no active programs
accessing them, wait a few seconds, (save your files just in case), and then
unload it, while crossing your fingers.  It's sufficiently useful to unload
this driver that even though you have to be ***very*** careful to unload it,
I'd prefer that it not be made completely impossible to remove.   Note that
there already is a config option to prevent rmmod from working at all, and
rmmod requires root privs, and we do expect root to have at least some
background skills....


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
You are the assignee for the bug, or are watching the assignee.
