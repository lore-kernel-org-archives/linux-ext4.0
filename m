From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12579] ext4 filesystem hang
Date: Sat, 14 Feb 2009 00:07:33 -0800 (PST)
Message-ID: <20090214080733.99D5311D10A@picon.linux-foundation.org>
References: <bug-12579-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58079 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751153AbZBNIIH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 14 Feb 2009 03:08:07 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1E87XPL003978
	for <linux-ext4@vger.kernel.org>; Sat, 14 Feb 2009 00:07:35 -0800
In-Reply-To: <bug-12579-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12579





------- Comment #12 from aneesh.kumar@linux.vnet.ibm.com  2009-02-14 00:07 -------
On Fri, Feb 13, 2009 at 02:06:06PM -0800, bugme-daemon@bugzilla.kernel.org
wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=12579
> 
> 
> 
> 
> 
> ------- Comment #8 from sandeen@redhat.com  2009-02-13 14:06 -------
> Created an attachment (id=20238)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=20238&action=view)
>  --> (http://bugzilla.kernel.org/attachment.cgi?id=20238&action=view)
> Tested patch
> 
> Patch from Aneesh, un-whitespace-mangled.
> 
> Ted, can you push this out?  Works great.  :)  We might want to ask the other
> reporter of something similar (next-20090206: deadlock on ext4) to test it too.
>  I'll ping him.
> 

I think this small changes is also needed.

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f743524..c80e038 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2495,7 +2495,10 @@ static int ext4_da_writepages(struct address_space
*mapping,
                wbc->range_end  = LLONG_MAX;
                wbc->range_cyclic = 0;
                range_cyclic = 1;
-               cycled = 0;
+               if (index == 0)
+                       cycled = 1;
+               else
+                       cycled = 0;
        } else
                index = wbc->range_start >> PAGE_CACHE_SHIFT;



-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
