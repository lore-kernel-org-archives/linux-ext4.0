From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Fri, 30 Oct 2009 16:27:23 GMT
Message-ID: <200910301627.n9UGRN1N018744@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:59852 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932601AbZJ3Q1T (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Oct 2009 12:27:19 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9UGRNiF018745
	for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2009 16:27:23 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #156 from Eric Sandeen <sandeen@redhat.com>  2009-10-30 16:27:16 ---
Reverting 487caeef9fc08c0565e082c40a8aaf58dad92bbb (that i_sem change from Jan)
on .32-rc5 still leads to significant corruption in my testing, so it doesn't
seem to be the (only?) regression.  (that corruption includes many
multiply-claimed blocks, FWIW).

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
