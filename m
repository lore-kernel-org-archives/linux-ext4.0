From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Tue, 17 Nov 2009 22:20:16 GMT
Message-ID: <200911172220.nAHMKGj4024388@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:35039 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756335AbZKQWUM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Nov 2009 17:20:12 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAHMKGiN024389
	for <linux-ext4@vger.kernel.org>; Tue, 17 Nov 2009 22:20:16 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #186 from Rafael J. Wysocki <rjw@sisk.pl>  2009-11-17 22:20:08 ---
On Tuesday 17 November 2009, Theodore Tso wrote:
> On Mon, Nov 16, 2009 at 11:37:39PM +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.31.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14354
> > Subject		: Bad corruption with 2.6.32-rc1 and upwards
> > Submitter	: Holger Freyther <zecke@selfish.org>
> > Date		: 2009-10-09 15:42 (39 days old)
> 
> Um, this was marked as resolved, until you reopened it and then reset
> the state to New.  Why did you do this?
> 
> It's fixed in mainline as of commit d4da6c9 when Linus reverted commit
> d0646f7.  Users could still see it if they mount a file system with -o
> journal_checksum, but (a) it's no longer the default, and (b)
> corruption if you use the non-default journal_checksum mount option is
> not a regression.
> 
> We have fixes to make journal_checksum safe queued for 2.6.33, but the
> revert fixes the regression problem.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.