From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14472] EXT4 corruption
Date: Thu, 29 Oct 2009 21:31:10 GMT
Message-ID: <200910292131.n9TLVARY005771@demeter.kernel.org>
References: <bug-14472-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:41266 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945AbZJ2VbF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Oct 2009 17:31:05 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9TLVA4K005772
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2009 21:31:10 GMT
In-Reply-To: <bug-14472-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14472





--- Comment #1 from Rafael J. Wysocki <rjw@sisk.pl>  2009-10-29 21:31:10 ---
On Thursday 29 October 2009, Andrew Lutomirski wrote:
> On Mon, Oct 26, 2009 at 2:55 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.31.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14472
> > Subject         : EXT4 corruption
> > Submitter       : Shawn Starr <shawn.starr@rogers.com>
> > Date            : 2009-10-13 2:07 (14 days old)
> > References      : http://marc.info/?l=linux-kernel&m=125539997508256&w=4
> > Handled-By      : Theodore Tso <tytso@mit.edu>
> >
> 
> 
> This but is *not* fixed.  I just triggered it a few minutes ago by
> abusing i915 and drm, which caused a panic.  This is slightly newer
> than 2.6.32-rc5, with a couple of i915 bugfixes thrown in.
> 
> Photos are here:
> http://web.mit.edu/luto/www/ext4_crashphotos/
> 
> This is a very nasty regression, for obvious reasons.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
