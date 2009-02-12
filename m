From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12579] ext4 filesystem hang
Date: Thu, 12 Feb 2009 10:48:52 -0800 (PST)
Message-ID: <20090212184852.E347B108043@picon.linux-foundation.org>
References: <bug-12579-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756772AbZBLSsz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Feb 2009 13:48:55 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1CImrN7020773
	for <linux-ext4@vger.kernel.org>; Thu, 12 Feb 2009 10:48:54 -0800
In-Reply-To: <bug-12579-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12579





------- Comment #4 from tytso@mit.edu  2009-02-12 10:48 -------

>> Finally had some time, and I've tracked this down to the
>> page-writeback.c changes since .28 - backing them all out the
>> testcase runs overnight.  Still working out which one and why.  I
>> suppose it's still possible it's an ext4 bug but if so the
>> page-writeback.c changes exposed it.
>> 
>> It's a classic deadlock; I usually have 2 threads stuck, pdflush
>> vs. the livecd creator doing an fsync.  Each is waiting for a page
>> the other has locked.
>
> Two commits which are already in the mainline which fixed some changes
> after .28 are
> 
> 89e1219004b3657cc014521663eeef0744f1c99d
> dcf6a79dda5cc2a2bec183e50d829030c0972aaa
> 

I read Eric's email as saying he tracked it down to the
page-writeback.c changes *after* 2.6.28.  Eric, is that what you
meant?

                                             - Ted


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
