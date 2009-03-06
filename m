From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12821] filesystem corrupts on heavy I/O
Date: Thu,  5 Mar 2009 22:11:43 -0800 (PST)
Message-ID: <20090306061143.85D92108042@picon.linux-foundation.org>
References: <bug-12821-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32944 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750808AbZCFGMO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Mar 2009 01:12:14 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n266Bhsu026802
	for <linux-ext4@vger.kernel.org>; Thu, 5 Mar 2009 22:11:45 -0800
In-Reply-To: <bug-12821-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12821





------- Comment #8 from sandeen@redhat.com  2009-03-05 22:11 -------
Created an attachment (id=20443)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=20443&action=view)
potential fix

I have not yet tested this patch, but it may fix your problem.

you can wait 'til I've had a chance to test it, or give it a go; if I'm wrong,
the worst you should get is more corrupt header messages and EIO errors.  :)

The ext4_ext_search_right() function is confusing; it uses a "depth" variable
which is 0 at the root and maximum at the leaves, but the on-disk metadata uses
a "depth" (actually eh_depth) which is opposite: maximum at the root, and 0 at
the leaves.

The ext4_ext_check_header() function expects the on-disk semantics, but we are
feeding it the opposite in the while loop in this function.  We should be
feeding it the on-disk notion of "depth" which we can get with (p_depth -
depth) - and if you look, the last (more commonly hit) call to
ext4_ext_check_header() does just this.

For a depth 4 tree (p_depth 3) (which would be an incredible amount of extents,
so perhaps not your problem, but perhaps....), then, you'd have:

"depth" in function  eh_depth                      p_depth - depth
0                    3                             3
1                    2                             2
2                    1 <---- I think you are here  1
3                    0                             0

Your error messages:
[1099257.456522] EXT4-fs error (device sdb1): ext4_ext_search_right: bad header
in inode #2621457: unexpected eh_depth - magic f30a, entries 340, max 340(0),
depth 1(2)

indicate that it was asked to check that the header was depth (2) but it
actually found depth 1 in the disk metadata.

I've not yet crafted a test to hit this codepath at all, so have not tested
this yet, but by inspection I *think* it is correct.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
