From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12885] kernel BUG at fs/jbd/transaction.c:1376!
Date: Wed, 18 Mar 2009 12:11:00 -0700 (PDT)
Message-ID: <20090318191101.2EEB6108040@picon.linux-foundation.org>
References: <bug-12885-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57084 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753895AbZCRTLn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Mar 2009 15:11:43 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n2IJB1P5004558
	for <linux-ext4@vger.kernel.org>; Wed, 18 Mar 2009 12:11:37 -0700
In-Reply-To: <bug-12885-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12885





------- Comment #13 from tytso@mit.edu  2009-03-18 12:11 -------
Oh, sorry, I misunderstood what you were saying.  All you need to do is "cp
-rp" the directory and you get the system hang?   Uh, that's very interesting. 
 How big is the file system in question?   I thought you were saying you were
doing a backup while some other process was doing a cp -rp *into* the
directory.

I agree, if that's all it takes, then it must be highly sensitive to the
filesystem state, and we want to be careful to preserve it.   In fact, before
you do anything else, you might want to save the filesystem image using
e2image:

        e2image -r /dev/sda1 - | bzip2 > sda1.e2i.bz2

Given that this is an encrypted filesystem, I can imagine that you probably
won't be willing to send this to me, even though this omits all of the data
blocks, and only keeps the metadata blocks (although this does include the
directory blocks and hence the file names).

However, you can take this raw image file, and dump it on a raw disk, and see
if you can replicate the problem on a disk partition.    Something else you
could do is to send me a "scrambled" e2image:

        e2image -rs /dev/sda1 - | bzip2 > sda1.e2i.bz2

This randomizes the directory names, although it means that I would have to
turn off the dir_index flags before I could try using it.  Still, it might be
enough to replicate the problem on my end.

Final question --- have you tried running e2fsck -n on the filesystem; do you
know if the filesystem has been reported as self-consistent by e2fsck?

Thanks,


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
