From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Tue, 13 Oct 2009 13:16:05 GMT
Message-ID: <200910131316.n9DDG5tM028039@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:40052 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759816AbZJMNQm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Oct 2009 09:16:42 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9DDG5vq028040
	for <linux-ext4@vger.kernel.org>; Tue, 13 Oct 2009 13:16:05 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #33 from Theodore Tso <tytso@mit.edu>  2009-10-13 13:16:01 ---
Alexey, the dmesg outputs you are posting --- are these random dmesg's, or ones
taken right before the system goes read-only, or the boot session *before*
that?   If you can easily trigger the file system corruption, something really
useful to do would be to set up syslog to do remote logging, so we can get the
EXT4 syslog just as or after the root filesystem gets remounted read-only.   In
addition, it would be useful to get the EXT4 syslog messages for one or two
boot sessions *before* the file system was found to be corrupted, as well as
the boot session where the file system was found corrupted.  

If the file system is getting corrupted after the journal is found corrupted
due to a checksum mismatch, the syslog file may not have the EXT4 syslog
messages, since the file system may end up getting remounted read-only.  And in
that case, it's useful to see if there are any EXT4 syslog messages or any
messages from the device driver showing any I/O errors.

The reason why I'm asking about LVM errors and dm-crypt is that at least one
fsck log had the name /dev/mapper/sda5_crypt.   At this point I'm still trying
to find common elements and information leading to a reliable reproduction ---
and something that can confirm that this is indeed a regression, so I know
whether or not focusing on recent commits is productive.  (The theory that it
might have something to do with journal checksums is assuming that this is a
regression, but so far none of the dmesg is showing the "Journal transaction
XXXX is corrupt" that would be expected if the theory that this was caused by a
journal checksum failure is correct.   So I don't want to focus too soon on
recent commits as potential causes of this problem until we know for certain it
is a regression.)

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
