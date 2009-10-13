From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Tue, 13 Oct 2009 21:10:01 GMT
Message-ID: <200910132110.n9DLA13G005897@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:46547 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934181AbZJMVKh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Oct 2009 17:10:37 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9DLA1Yo005898
	for <linux-ext4@vger.kernel.org>; Tue, 13 Oct 2009 21:10:01 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #39 from Eric Sandeen <sandeen@redhat.com>  2009-10-13 21:10:00 ---
Alexey, when you say corrupted files what do you mean.  Are the files missing? 
Full of 0s?  Random data in part or all of the file?

As for data loss, -some- data loss on a power fail is not unexpected; buffered
data which has not been synced -will- be lost, so we need to be careful about
how we use these terms I think ...

-Eric

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
