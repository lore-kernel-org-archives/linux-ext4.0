From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Fri, 16 Oct 2009 14:13:36 GMT
Message-ID: <200910161413.n9GEDam7024695@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:54759 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759430AbZJPOOM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Oct 2009 10:14:12 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9GEDaYr024696
	for <linux-ext4@vger.kernel.org>; Fri, 16 Oct 2009 14:13:36 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #61 from Theodore Tso <tytso@mit.edu>  2009-10-16 14:13:34 ---
On Fri, Oct 16, 2009 at 05:15:58AM -0400, Theodore Tso wrote:
> These are three commits that seem most likely, but there are
> only 93 ext4-related commits, so doing a "git bisect start v2.6.31
> v2.6.32-rc5 -- fs/ext4 fs/jbd2" 

One correction.  The git bsect start usage is:

     git bisect start [<bad> [<good>...]] [--] [<paths>...]

So the correct git bisect start command should be:

     git bisect start v2.6.32-rc5 v2.6.31 -- fs/ext4 fs/jbd2

And similarly, "git bisect start v2.6.31 v2.6.31-rc3" should have been:

     git bisect start v2.6.31-rc3 v2.6.31

My apologies for any confusion.

                        - Ted

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
