From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Fri, 30 Oct 2009 08:16:43 GMT
Message-ID: <200910300816.n9U8Ghxd009055@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:52636 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263AbZJ3IQi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Oct 2009 04:16:38 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9U8GhOc009057
	for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2009 08:16:43 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #151 from Theodore Tso <tytso@mit.edu>  2009-10-30 08:16:22 ---
On Thu, Oct 29, 2009 at 04:38:57PM -0500, Eric Sandeen wrote:
>
> I've been running my testcase, and I just hit the usual corruption with  
> this patch in place after 8 iterations, I'm afraid.

Eric, since you have a relatively controllable reproduction case, have
you tried reproducing Alexey's bisection results?  Specifically he
seemed to find that commit fe188c0e shows no problem, and commit
91ac6f43 is the first commit with problems?

Having to do multiple iterations will make doing a bisection a major
pain, but maybe we'll get something out of that.

Other things that might be worth doing given that you have a test case
would be to try reverting commit 91ac6f43, and see if that helps, and
to try this patch: http://bugzilla.kernel.org/attachment.cgi?id=23468

Or have you tried some of these experiments already?

Regards,

                        - Ted

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
