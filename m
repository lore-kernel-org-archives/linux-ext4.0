From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Thu, 29 Oct 2009 17:34:51 GMT
Message-ID: <200910291734.n9THYpkX009195@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:37819 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755688AbZJ2Rer (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Oct 2009 13:34:47 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9THYqpp009196
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2009 17:34:52 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #142 from Maxim Levitsky <maximlevitsky@gmail.com>  2009-10-29 17:34:49 ---
Eric Sandeen, Thanks!


I tried similar approaches, I copied lots of files, I created/removed random
files, I tried to use apt-get upgrade, many things.

Sometimes I see corruption, but very rarely....

Since I feel more and more frustrated with this VM, and feel that this is a
dead end,  I removed it, and now I think about some way to reproduce on real
system without mass corruption.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
