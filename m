From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14472] EXT4 corruption
Date: Tue, 17 Nov 2009 22:30:41 GMT
Message-ID: <200911172230.nAHMUfpg027225@demeter.kernel.org>
References: <bug-14472-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:54323 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbZKQWaf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Nov 2009 17:30:35 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAHMUfLG027226
	for <linux-ext4@vger.kernel.org>; Tue, 17 Nov 2009 22:30:41 GMT
In-Reply-To: <bug-14472-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14472





--- Comment #4 from Rafael J. Wysocki <rjw@sisk.pl>  2009-11-17 22:30:40 ---
On Tuesday 17 November 2009, Andy Lutomirski wrote:
> I'm think this was the journal checksumming bug, which is fixed.
> 
> 
> On Nov 16, 2009, at 5:37 PM, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.31.  Please verify if it still should be listed and let me  
> > know
> > (either way).
> >
> >
> > Bug-Entry    : http://bugzilla.kernel.org/show_bug.cgi?id=14472
> > Subject        : EXT4 corruption
> > Submitter    : Shawn Starr <shawn.starr@rogers.com>
> > Date        : 2009-10-13 2:07 (35 days old)
> > References    : http://marc.info/?l=linux-kernel&m=125539997508256&w=4
> > Handled-By    : Theodore Tso <tytso@mit.edu>

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
