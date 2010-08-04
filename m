From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16165] Wrong data returned on read after write if file size was
 changed with ftruncate before
Date: Wed, 4 Aug 2010 03:40:12 GMT
Message-ID: <201008040340.o743eCJg008840@demeter.kernel.org>
References: <bug-16165-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:55090 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758201Ab0HDDkO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Aug 2010 23:40:14 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o743eDGB008841
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 4 Aug 2010 03:40:13 GMT
In-Reply-To: <bug-16165-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16165





--- Comment #22 from Theodore Tso <tytso@mit.edu>  2010-08-04 03:40:03 ---
The patches are in my tree and I'll push them during this merge window, and
then get them into 2.6.35.1.   Sorry, things got busy and I didn't have a
chance to push them to Linus before 2.6.35 shipped.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
