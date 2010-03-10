From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15420] EXT4_USE_FOR_EXT23 causes wrong free space calculation
 on ext2 and ext3
Date: Wed, 10 Mar 2010 15:44:48 GMT
Message-ID: <201003101544.o2AFimBW026206@demeter.kernel.org>
References: <bug-15420-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:44016 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756701Ab0CJPot (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Mar 2010 10:44:49 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2AFim3A026207
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 10 Mar 2010 15:44:48 GMT
In-Reply-To: <bug-15420-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15420





--- Comment #13 from Theodore Tso <tytso@mit.edu>  2010-03-10 15:44:46 ---
OK, I can confirm that the problem is with delayed allocation and indirect
files.   While downloading a 70 meg kernel source tar ball, the amount of space
shown as being used by df goes as high as 1 gigabyte (50% of the space on my
disk, about 25% of my available free memory) before dropping back down. as the
blocks get allocated.   Mounting with nodelalloc makes the problem go away.
Using extents, the df result will occasionally be as much as 1-2 megs but it is
much smaller in practice.

Using nodelalloc for ext2/3 mounts may make sense not just as a workaround, but
to help protect users using crappy desktop applications that don't know how to
use fsync().  (They'll still get screwed by btrfs, but the lazy application
writers and Phoronix they can complain to the btrfs developers about how they
are incompetent, and it's no longer my problem at that point.  :-)

We should try to improve the estimation logic for indirect blocks (I remember
being in a hurry to write the code to work around the regression caused by the
quota bugfix that has caused us so much heartache), but I don't think this is a
problem for people who are migrating from ext3 to ext4, since it's rare that
they will be extending an already existing indirect-mapped file.  The problem
with EXT4_USE_FOR_EXT23 is that they are _not_ migrating, and we're seeing a
weakness in delalloc with indirect block files; a weakness that was only
introduced recently, and one that I hope we can fix.   But for other reasons
mentioned above, we probably want to turn on nodelalloc anyway...

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
