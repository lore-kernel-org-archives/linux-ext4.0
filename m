From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Fri, 6 Nov 2009 22:26:15 GMT
Message-ID: <200911062226.nA6MQFbV018947@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:33339 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760268AbZKFW0J (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Nov 2009 17:26:09 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nA6MQFN0018948
	for <linux-ext4@vger.kernel.org>; Fri, 6 Nov 2009 22:26:15 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #180 from Linus Torvalds <torvalds@linux-foundation.org>  2009-11-06 22:26:13 ---
On Fri, 6 Nov 2009, Eric Sandeen <sandeen@redhat.com> wrote:
> 
> > For ext4, one thing I would suggest is to simply always put the NUL at the 
> > end of the name, even if the filesystem might not need it. Then 
> > nd_terminate_link() will still write the NUL, but it won't change any data 
> > (and thus no CRC's).
> 
> Ah, good idea in the short term at least.

Btw, if you do that, then for Chris' debug patch you might then make 
nd_terminate_link() do a conditional write ("only write NUL if it isn't 
already NUL"), and thus avoid the debug code triggering for that case.

        Linus

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
