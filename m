From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14830] When other IO is running sync times go to 10 to 20
 minutes
Date: Mon, 15 Feb 2010 18:29:23 GMT
Message-ID: <201002151829.o1FITNcx026939@demeter.kernel.org>
References: <bug-14830-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:54540 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755844Ab0BOS3X (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Feb 2010 13:29:23 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o1FITN6H026940
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 15 Feb 2010 18:29:23 GMT
In-Reply-To: <bug-14830-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14830





--- Comment #19 from Michael Godfrey <godfrey@isl.stanford.edu>  2010-02-15 18:29:18 ---
On 02/15/2010 06:28 AM, bugzilla-daemon@bugzilla.kernel.org wrote:
> Last week, I've noticed a bug in writeback code causing sync to take longer
> than necessary. This patch should fix it. Is it possible for you to try it?
> Thanks.
>    
I have been following this.  But right now I am leaving on a trip.  And,
I cannot right now build kernels for the system where we get the
problem.  These systems are in production use for backup.

Sorry that I cannot help more.

Michael

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
