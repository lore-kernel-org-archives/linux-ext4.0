From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15074] Problem with quota on ext4
Date: Wed, 10 Feb 2010 06:38:32 GMT
Message-ID: <201002100638.o1A6cWeR024552@demeter.kernel.org>
References: <bug-15074-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:58815 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab0BJGie (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Feb 2010 01:38:34 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o1A6cWsm024575
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 10 Feb 2010 06:38:32 GMT
In-Reply-To: <bug-15074-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15074





--- Comment #11 from Dmitri Monakhov <dmonakhov@openvz.org>  2010-02-10 06:37:41 ---
(In reply to comment #8)
> Created an attachment (id=24972)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=24972) [details]
> Fix warning at dquot_claim_space()
> 
> Dmitry, your patch didn't fix the whole issue for me. I also need this patch to
> avoid the warnings...
This is dangerous changes because this may this remove important sanity
check. It is false(not invalid) after few seconds after quotaon.
But later it can helps us to catch a lot of bugs. I have found chown bug
only because of this check.
I've attached a patch which add warning message, but after some thougths i
comes
in to idea to add force charging a reserved space in ->initialize() method
This allow us to preserve warning in claim_space, and helps us to handle
user misbehaviour. Will prepare patch in minute.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
