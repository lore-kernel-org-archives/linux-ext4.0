From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15420] EXT4_USE_FOR_EXT23 causes wrong free space calculation
 on ext2 and ext3
Date: Thu, 11 Mar 2010 16:17:02 GMT
Message-ID: <201003111617.o2BGH2ts015927@demeter.kernel.org>
References: <bug-15420-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:54474 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933184Ab0CKQRE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Mar 2010 11:17:04 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2BGH2Bq015930
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 11 Mar 2010 16:17:02 GMT
In-Reply-To: <bug-15420-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15420





--- Comment #17 from Eric Sandeen <sandeen@redhat.com>  2010-03-11 16:16:46 ---
(In reply to comment #16)
> As for comment #13 - I fully agree with Ted. When admin does "mount -t ext3
> ...", I think we should give him as close behavior to ext3 as possible by the
> principle of the least surprise - and that means nodelalloc. If user wishes
> better performance etc, he can always mount the filesystem as ext4 explicitely.

Under what circumstances, then, do we recommend mounting ext3 with the ext4
driver?

The user will get different allocation behavior as well; will that also be a
surprise?

I just want to be clear in our recommendations about this stuff...

> Also I remember some discussions with KDE guys when they were at some point
> considering detecting filesystem type and avoid doing fsync if it was ext3 -
> hopefully, I convinced them not to do it but I bet someone else had the same
> idea and actually implemented it. Not that I'd have too much pity with broken
> applications but I prefer to avoid breaking them silently like this...

I think by having this config option at -all- we have really muddied the
waters, to be honest ... but I suppose this is all better hashed outon the
list, not in this bug.  :)

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
