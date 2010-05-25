From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13964] ext4: panic causes lost data in git
Date: Tue, 25 May 2010 17:57:00 GMT
Message-ID: <201005251757.o4PHv0YB027280@demeter.kernel.org>
References: <bug-13964-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:59681 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053Ab0EYR5C (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 May 2010 13:57:02 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4PHv0Dl027281
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 25 May 2010 17:57:01 GMT
In-Reply-To: <bug-13964-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=13964





--- Comment #5 from Jesse Brandeburg <jesse.brandeburg@intel.com>  2010-05-25 17:56:58 ---
I was unable to continue using ext4 for development since it was not reliable
through panic.  Was there ever any progress on this issue?  Due to this bug I
have been telling everyone I work with to not use ext4.

It is a pretty easy bug to reproduce, isn't there something we can do about it?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
