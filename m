From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Thu, 29 Oct 2009 21:55:38 GMT
Message-ID: <200910292155.n9TLtcIp012856@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:53952 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbZJ2Vzd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Oct 2009 17:55:33 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9TLtcw2012857
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2009 21:55:38 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #148 from Theodore Tso <tytso@mit.edu>  2009-10-29 21:55:36 ---
>>  - virtually indexed caches might be loaded by the mount, and when you do 
>>    fsck later, the fsck writes back through the physically indexed direct 
>>    device. So the mounted root filesystem may never see those changes, 
>>    even after you re-mount it 'rw'.
>
>Yes, I've been worried about this... but would this be new?

Eric, Linus,

If fsck ever modifies the filesystem, it sets bit 0 in the exit status code.  
For the root file system, bit 1 is set as well.  To quote the fsck man page:

       The exit code returned by fsck is the sum of the following conditions:
            0    - No errors
            1    - File system errors corrected
            2    - System should be rebooted
            4    - File system errors left uncorrected
            8    - Operational error
            16   - Usage or syntax error
            32   - Fsck canceled by user request
            128  - Shared library error
       The exit code returned when multiple file systems are  checked  is  the
       bit-wise OR of the exit codes for each file system that is checked.

Distribution init scripts are supposed to force a reboot when the root file
system is checked, and fsck returns a non-zero exit code.   This should avoid
the problem that Linus is afraid of.   Of course, Ubuntu Karmic *does* have a
new set of fancy-shamncy init scripts that is supposed to run (some) fsck's in
parallel with the rest of the boot process.  Presumably this doesn't include
critical file systems such as the root and whatever filesystems might be
supplying /var or /usr.  But maybe Karmic introduced a bug and the init scripts
aren't forcing a reboot after fsck prints "*** REBOOT LINUX ***" and returns
with an exit status code of 3 (file system errors correct, system should be
rebooted).

Note though that this shouldn't happen on a simple unclean shutdown, since the
journal replay takes place before the root file system is initially mounted
(even read-only).   [n.b. The fact that Avery was using -o noload, is not
normal, and I'm not sure what he was trying to test.]

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
