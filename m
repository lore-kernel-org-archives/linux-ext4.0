From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Fri, 30 Oct 2009 13:54:43 GMT
Message-ID: <200910301354.n9UDshGu004484@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:49990 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095AbZJ3Nyi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Oct 2009 09:54:38 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9UDsh16004485
	for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2009 13:54:43 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #155 from Eric Sandeen <sandeen@redhat.com>  2009-10-30 13:54:35 ---
Theodore Tso wrote:
> On Thu, Oct 29, 2009 at 04:38:57PM -0500, Eric Sandeen wrote:
>> I've been running my testcase, and I just hit the usual corruption with  
>> this patch in place after 8 iterations, I'm afraid.
> 
> Eric, since you have a relatively controllable reproduction case, have
> you tried reproducing Alexey's bisection results?  Specifically he
> seemed to find that commit fe188c0e shows no problem, and commit
> 91ac6f43 is the first commit with problems?

I can try it but I have very little faith in that result to be honest.

> Having to do multiple iterations will make doing a bisection a major
> pain, but maybe we'll get something out of that.

Well I've been doing bisects but I'm getting skeptical of the results; 
either my testcase isn't reliable enough or all the merges are confusing 
git-bisect (?)  Anyway it keeps ending up on nonsensical commits.

> Other things that might be worth doing given that you have a test case
> would be to try reverting commit 91ac6f43, and see if that helps, and
> to try this patch: http://bugzilla.kernel.org/attachment.cgi?id=23468
> 
> Or have you tried some of these experiments already?
> 
> Regards,
> 
> 						- Ted

After talking to Aneesh last night, I think other good spot-checks will 
be to revert 487caeef9fc08c0565e082c40a8aaf58dad92bbb, and to test Jan's 
sync patches.

-Eric

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.