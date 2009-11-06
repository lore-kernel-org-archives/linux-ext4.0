From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Fri, 6 Nov 2009 22:07:15 GMT
Message-ID: <200911062207.nA6M7FgC014166@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:60874 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759960AbZKFWHK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Nov 2009 17:07:10 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nA6M7FBb014167
	for <linux-ext4@vger.kernel.org>; Fri, 6 Nov 2009 22:07:15 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #178 from Linus Torvalds <torvalds@linux-foundation.org>  2009-11-06 22:07:03 ---
On Fri, 6 Nov 2009, Chris Mason <chris.mason@oracle.com> wrote:
> 
> But I hit a much harder case to fix.  ext4_symlink will log the data blocks
> that hold the symlink name (well ext4_write_begin will log them).
> 
> ext4 uses the generic symlink read helpers, so when we read the link we dive
> into page_getlink() which uses nd_terminate_link to stuff a NULL into the end
> of the link's name.

Gaah. We've had some issues with that before too. Sadly, the name lookup 
routines _really_ want the terminating NUL at the end, so the alternatives 
are to (a) allocate scratch space and copy every time you follow a symlink 
or (b) do major surgery on the name lookup code to take a 'ptr,len' 
approach to names. Both seem nasty.

For ext4, one thing I would suggest is to simply always put the NUL at the 
end of the name, even if the filesystem might not need it. Then 
nd_terminate_link() will still write the NUL, but it won't change any data 
(and thus no CRC's).

That said, I haven't looked at how nasty it would be to change the name 
lookup to use <ptr,len>. Maybe it wouldn't be as horrible as I suspect it 
is (the filesystems themselves wouldn't need changing, since the lowlevel 
filesystem name lookup routines always sees a 'struct dentry' rather than 
the pathname).

                Linus

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
