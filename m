From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14936] kernel BUG at fs/ext4/inode.c:1063 if attempted to use
 non-ext4 partition with ext4
Date: Thu, 31 Dec 2009 18:20:45 GMT
Message-ID: <200912311820.nBVIKj93032686@demeter.kernel.org>
References: <bug-14936-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:48590 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017AbZLaSUq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Dec 2009 13:20:46 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id nBVIKjk9032687
	for <linux-ext4@vger.kernel.org>; Thu, 31 Dec 2009 18:20:45 GMT
In-Reply-To: <bug-14936-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14936





--- Comment #7 from Rafael J. Wysocki <rjw@sisk.pl>  2009-12-31 18:20:42 ---
On Thursday 31 December 2009, tytso@mit.edu wrote:
> On Wed, Dec 30, 2009 at 10:52:12PM +0100, Rafael J. Wysocki wrote:
> > > I'm working on a fix, and have a proposed patch.  See the thread on
> > > linux-ext4 here:
> > > 
> > > http://marc.info/?l=linux-kernel&m=126219515024315&w=2
> > > 
> > > This patch also fixes the dq_claim_space kerneloops problem as
> > > well....
> > 
> > Thanks, I've added your patch to the Bugzilla entry.
> 
> This patch has been merged to mainline.  I'm working on improving
> things so that we don't lose performance by unnecessarily forcing
> delalloc blocks out to disk when the (wildly overestimated) number of
> required metadata blocks approaches the user's remaining quota or
> remaining free space on disk, but the fundamental fix is in mainline.
> 
> (The performance hit was something I knew about when I pushed the
> patch to Linus, but after discussing things with Eric Sandeen, we
> figured that for users who were converting from ext3, which didn't
> have delayed allocation support at all, even with the performance hit
> when the user approached the quota limit, ext4 with delalloc+quota was
> still better than ext3 --- and I wanted a fix in mainline ASAP.
> Fortunately, it's not going to be that hard make the required metadata
> much more accurate.)

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
