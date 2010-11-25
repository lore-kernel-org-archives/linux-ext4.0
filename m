From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 20902] High IO wait when writing to ext4
Date: Thu, 25 Nov 2010 09:17:28 GMT
Message-ID: <201011250917.oAP9HSwJ020719@demeter1.kernel.org>
References: <bug-20902-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:33896 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab0KYJR2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Nov 2010 04:17:28 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id oAP9HSnU020720
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 25 Nov 2010 09:17:28 GMT
In-Reply-To: <bug-20902-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=20902


Andreas Dilger <adilger.kernelbugzilla@dilger.ca> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |adilger.kernelbugzilla@dilg
                   |                            |er.ca




--- Comment #19 from Andreas Dilger <adilger.kernelbugzilla@dilger.ca>  2010-11-25 09:17:26 ---
(In reply to comment #16)
> Here's mine.  My test case is mount, sleep 5, then do 10 x 128MB writes using
> dd to the just-mounted filesystem.  The first 128MB write took over 20 seconds.
>  Unfortunately I don't have access any more to the box where it took 150
> seconds.

We've seen this problem with Lustre as well.  The root of the problem is that
the initial write to a filesystem that is fairly full causes mballoc to scan
all of the block groups looking for groups with enough space for preallocation
of an 8MB chunk.  On an 8TB filesystem with 64k groups @ 100 seeks/second this
could take up to 10 minutes to complete.

The patch from Curt committed in 8a57d9d61a6e361c7bb159dda797672c1df1a691 fixed
this for small writes at mount time, but does not help for large writes.

We are starting to look at other solutions to this problem in our bugzilla:
https://bugzilla.lustre.org/show_bug.cgi?id=24183

with a patch (currently untested) in:
https://bugzilla.lustre.org/attachment.cgi?id=32320&action=edit


Increasing the flex_bg size is likely going to reduce the severity of this
problem, by reducing the number of seeks needed to load the block bitmaps
proportional to the flex_bg factor (32 by default today).  That would change
the 8TB bitmap scan time from 10 minutes to about 20s.

Other possibilities include starting the bitmap scan at some random group
instead of always starting at group 0, storing some free extent information for
each group in the group descriptor table, or storing some information in the
superblock about which group to start allocations at.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
