From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: info about filesystem errors in /sys/fs/ext4/... ?
Date: Mon, 5 May 2014 15:15:57 -0400
Message-ID: <20140505191557.GM22287@thunk.org>
References: <20140505070823.GM3017@pcnci.linuxbox.cz>
 <alpine.LFD.2.00.1405051253400.2223@localhost.localdomain>
 <20140505115919.GB18305@thunk.org>
 <5367A5E5.10809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50407 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611AbaEETQI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 May 2014 15:16:08 -0400
Content-Disposition: inline
In-Reply-To: <5367A5E5.10809@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

For the record, since this was discussed on the ext4 weekly
teleconference...

The reason why I've been hesitant about allowing any file system to be
checked by e2fsck while being mounted read-only is because of the
following failure scenario:

1) The kernel discovers that a file system has been corrupted, so it
marks the file system as being inconsistent and it remounts the file
system read-only.

2) The user runs e2fsck on the file system, while it is still mounted
read-only, and fixes it.

3) The kernel still has cached data structures with incorrect inode
reference counts, etc.  So when the user then remounts the file system
read/write, the file system gets corrupted again, and the user suffers
data loss.


This could happen with the root file system as well, of course, but
there is a big, large, scary message making it clear that you *MUST*
reboot after repairing a corrupted root file system.  The real issue
is encouraging users from checking mounted file systems at all.  One
approach would be do to require a command-line option of the form
--i-know-this-is-dangerous-and-I-could-lose-data, or some such.
Apparently xfs does something like this, with a xfs_repair -d ('D' is
for Dangerous).

Another approach which Andreas Dilger suggested, and which we will
likely use, is one where we snapshot the last fsck time from the
superblock when the file system is mounted or remounted read-only.
Then when the user tries to remount the file system read-write, if the
last fsck time has been changed, we reject the r/w remount request.

Regards,

						- Ted
