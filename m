From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14936] kernel BUG at fs/ext4/inode.c:1063 if attempted to use
 non-ext4 partition with ext4
Date: Wed, 30 Dec 2009 21:50:45 GMT
Message-ID: <200912302150.nBULoj7Z019990@demeter.kernel.org>
References: <bug-14936-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:57845 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbZL3Vuq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Dec 2009 16:50:46 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id nBULojnU019991
	for <linux-ext4@vger.kernel.org>; Wed, 30 Dec 2009 21:50:45 GMT
In-Reply-To: <bug-14936-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14936





--- Comment #6 from Rafael J. Wysocki <rjw@sisk.pl>  2009-12-30 21:50:43 ---
On Wednesday 30 December 2009, tytso@mit.edu wrote:
> On Tue, Dec 29, 2009 at 11:57:12AM -0500, tytso@MIT.EDU wrote:
> > On Tue, Dec 29, 2009 at 04:10:01PM +0100, Rafael J. Wysocki wrote:
> > > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14936
> > > Subject		: kernel BUG at fs/ext4/inode.c:1063 if attempted to use non-ext4 partition with ext4
> > > Submitter	: Gene Heskett <gene.heskett@verizon.net>
> > > Date		: 2009-12-26 14:13 (4 days old)
> > > References	: http://marc.info/?l=linux-kernel&m=126183682330809&w=4
> > > 		  http://marc.info/?l=linux-kernel&m=126169372613898&w=4
> > 
> > Bisected to commit d21cd8, and reverting this commit seems to fix the
> > problem.  The problem appeared between -rc1 and -rc2.  It was a fix
> > that was pushed as part of a quota/ext4 fixes.  For more information:
> > 
> > http://marc.info/?l=linux-ext4&m=126197233225936&w=2
> > 
> > I will take a look at this to see if I can find an easy fix;
> > otherwise, we'll probably want to revert commit d21cd8 before -rc3.
> 
> I'm working on a fix, and have a proposed patch.  See the thread on
> linux-ext4 here:
> 
> http://marc.info/?l=linux-kernel&m=126219515024315&w=2
> 
> This patch also fixes the dq_claim_space kerneloops problem as
> well....

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.