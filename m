From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14830] When other IO is running sync times go to 10 to 20
 minutes
Date: Tue, 19 Jan 2010 19:38:36 GMT
Message-ID: <201001191938.o0JJcac7009370@demeter.kernel.org>
References: <bug-14830-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:42349 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab0ASTih (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Jan 2010 14:38:37 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0JJcaCP009371
	for <linux-ext4@vger.kernel.org>; Tue, 19 Jan 2010 19:38:36 GMT
In-Reply-To: <bug-14830-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14830


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu




--- Comment #5 from Theodore Tso <tytso@mit.edu>  2010-01-19 19:38:34 ---
So the Linux write cache mystery is unlikely to solve the problem since that
was talking about backporting some tuning parameters from 2.6.22 to the
RHEL/CentOS 2.6.18 kernel, and here the problem seems to be that the sync is
taking much longer on a 2.6.31 FC 12 kernel. 

So the first thing I notice is the fact that you have the nodelalloc mount
option enabled.   Any particular reason why you did that?   Try removing that;
one of the reasons why ext4 is generally described as being much better than
ext3 with respect to this problem (of the machine becoming unresponsive during
a sync) is because of delayed allocation, and you've turned it off.   So try
removing nodelalloc and see if that makes the performance come back.

Another thing that might be worth testing is to see whether an ext3 filesystem
on a 2.6.31 FC 12 kernel behaves any differently.   This may be something that
is some kind of VM tuning issue between RHEL 5.4 and a modern kernel; I don't
know how many people try running Fedora 12 on a system with large amounts of
memory and an NFS load, and maybe there is some kind of tuning issue that has
been exposed.   So that's a quick experiment that's worth doing just so we can
figure out where we need to concentrate our diagnostic efforts.

Another thing to try is to do some instrumentation using iostat to see what the
system is doing, before, during, and after the sync command.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
