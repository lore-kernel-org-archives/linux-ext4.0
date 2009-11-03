From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Tue, 3 Nov 2009 14:32:31 GMT
Message-ID: <200911031432.nA3EWV8l020006@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:56570 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792AbZKCOc1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Nov 2009 09:32:27 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nA3EWVw8020007
	for <linux-ext4@vger.kernel.org>; Tue, 3 Nov 2009 14:32:31 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #173 from Eric Sandeen <sandeen@redhat.com>  2009-11-03 14:32:26 ---
(In reply to comment #172)
> There's a lot more we need to understand --- including why we weren't seeing a
> printk message indicating a journal checksum, and which commit was showing the
> checksum failure, and why we ended up seeing a checksum failure in the first
> place.   If it was the last commit that was being written right before the
> system crash, the commit block simply should have been missing due to the
> barrier.   But we can do this without having to worry about 2.6.32 being a QA
> disaster for ext4.  :-)

I am looking for the checksum problem today.  I agree, seeing an
otherwise-valid commit block w/ a bad checksum is very troubling - barrier
infrastructure problems?  Or something else, will have to see.

I know why we're not seeing a printk, already; it's under a RDONLY test, and
the root fs is mounted readonly; I have a patch for that though I wonder what
the right choice is when we encounter this corruption - I'm leaning towards
treating it like any other corruption and going through ext4_error...

...anyway, still looking at all this today, even w/ the .32 qa disaster averted
for now.  :)

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
