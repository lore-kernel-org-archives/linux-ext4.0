From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12224] journal activity on inactive partition causes inactive harddrive spinup
Date: Sun, 14 Dec 2008 15:10:54 -0800 (PST)
Message-ID: <20081214231054.86C82108041@picon.linux-foundation.org>
References: <bug-12224-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47635 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754928AbYLNXLZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Dec 2008 18:11:25 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBENAsRA021664
	for <linux-ext4@vger.kernel.org>; Sun, 14 Dec 2008 15:10:55 -0800
In-Reply-To: <bug-12224-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12224





------- Comment #2 from sandeen@redhat.com  2008-12-14 15:10 -------
bugme-daemon@bugzilla.kernel.org wrote:

> OK, that's a huge mess because bugzilla went and wordwrapped it.  Let
> me fix it:
> 
>> Dec   9 11:15:32 localhost logger:    8,0      0            1       0.000000000    1109   A   WS 14375 + 8 <- (8,1) 14312
>> Dec   9 11:15:32 localhost logger:    8,0      0            2       0.000006705   1109   Q   WS 14375 + 8 [kjournald]
>> Dec   9 11:15:32 localhost logger:    8,0      0            3       0.000043581   1109   G   WS 14375 + 8 [kjournald] 
>> Dec   9 11:15:32 localhost logger:    8,0      0            4       0.000065651   1109   P    N [kjournald]
>> Dec   9 11:15:32 localhost logger:    8,0      0            5       0.000076267   1109   I    W 14375 + 8 [kjournald]
>> Dec   9 11:15:32 localhost logger:    8,0      0            6       0.000300318   1109   D    W 14375 + 8 [kjournald]
>> Dec   9 11:15:32 localhost logger:    8,0      0            7       0.000423518   1109   U    N [kjournald] 1
>> Dec   9 11:15:32 localhost logger:    8,0      0            8       0.010028373      3   C    W 14375 + 8 [0]
>> Dec   9 11:15:35 localhost logger:    8,0      0            9       3.219049689   1109   A   WS 14383 + 8 <- (8,1) 14320
>> Dec   9 11:15:35 localhost logger:    8,0      0           10       3.219058350   1109   Q   WS 14383 + 8 [kjournald]
>> Dec   9 11:15:35 localhost logger:    8,0      0           11       3.219095505   1109   G   WS 14383 + 8 [kjournald]
>> Dec   9 11:15:35 localhost logger:    8,0      0           12       3.219115061   1109   P    N [kjournald]
>> Dec   9 11:15:35 localhost logger:    8,0      0           13       3.219127074   1109   I    W 14383 + 8 [kjournald]
>> Dec   9 11:15:35 localhost logger:    8,0      0           14       3.219344699   1109   D    W 14383 + 8 [kjournald]
>> Dec   9 11:15:35 localhost logger:    8,0      0           15       3.219543607   1109   U    N [kjournald] 1
>> Dec   9 11:15:35 localhost logger:    8,0      0           16       3.229477275       3   C    W 14383 + 8 [0]
> 
> I'm not familar with btrace.  What are we looking at here?

Andrew, it's blktrace/blkparse output, basically.  blkparse(1) manpage
has the details.

maj,min cpu  seq  time           pid   act rwbs off+len
8,0      0    1   0.000000000    1109   A   WS 14375 + 8 <- (8,1) 14312

... etc

I'm not sure it gives us enough info; all we see is that there was an IO
on sdb (from sdb1)

I might suggest

# sysctl -w vm.block_dump=1

to see if you get any info about inodes on sda1 being dirtied.

(Also, I didn't see any info about sda1 in the posted fstab...)

-Eric


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
