From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Thu, 15 Oct 2009 19:10:36 GMT
Message-ID: <200910151910.n9FJAasR019746@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:33754 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762948AbZJOTLM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Oct 2009 15:11:12 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9FJAaSP019747
	for <linux-ext4@vger.kernel.org>; Thu, 15 Oct 2009 19:10:36 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #57 from Mikulas Patocka <mpatocka@redhat.com>  2009-10-15 19:10:35 ---
On Tue, 13 Oct 2009, Mike Snitzer wrote:

> On Mon, Oct 12 2009 at  2:15pm -0400,
> Theodore Ts'o <tytso@mit.edu> wrote:
> 
> > Hi, I'm trying to track down a problem relating to ext4 problems, in
> > kernel bugzilla 14354.  Originally it was thought this was a regression
> > 2.6.31->2.6.32-rc1 regression, but the Aneesh Kumar's report shows a
> > very similar fsck transcript using a 2.6.30-1 kernel (which makes makes
> > it unclear whether this is really a regression or not), and all three
> > reports are tied together by the use of device-mapper.  
> > 
> > The fsck logs are consistent barriers being disabled.  As I recall under
> > some circumstances device mapper silently drops barrier requests --- I
> > thought this was fixed for device mapper in some cases.  What's the
> > current status of barrier requests in device mapper?  Are they
> > faithfully passed for standard (non-RAID) LVM2 volumes?  When was this
> > changed?   What about dm-crypto volumes?  (One of the reports was with a
> > dm-crypt volume from what I can tell.)
> 
> Barrier infrastructure started to get added to the DM core in 2.6.30, see:
> http://git.kernel.org/linus/af7e466a1ace
> 
> But barriers were not enabled for all DM targets (_except_ dm-multipath)
> until 2.6.31.  So 2.6.31's dm-crypt does support barriers, see:
> http://git.kernel.org/linus/647c7db14ef9
> 
> If the underlying device(s) support barriers DM should faithfully pass
> them on (again except for dm-multipath).  Also, requests with barriers
> that result in -EOPNOTSUPP are retried without the barrier, see:
> http://git.kernel.org/linus/51aa32284958
> 
> Mike

Hi

Device mapper never drops data in the barrier request.

It converts barrier to non-barrier request or drops zero-sized barrier if 
the underlying device doesn't support barrier. Device mapped doesn't 
support barriers for dm-raid1 target (pending some other upstream patch 
that was ignored).

If the underlying device doesn't support barriers or if dm-raid1 target is 
being used, device mapper returns success on barriers and it simply waits 
for the request queue to drain when accepting a barrier.

The problems with "not flushing disk cache" only show up only if you pull 
the power plug out --- in this case, make sure that if you use dm-raid1, 
disk cache is turned off (hdparm -W 0). With other dm-targets, you can 
leave the disk cache on, because they accept barriers.

If you see errors under normal operations, without power loss, then it has 
probably nothing to do with barriers at all.

Mikulas

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
