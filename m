From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14619] ext3/jbd oops in journal_start
Date: Fri, 20 Nov 2009 15:09:12 GMT
Message-ID: <200911201509.nAKF9C1w019685@demeter.kernel.org>
References: <bug-14619-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:36200 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991AbZKTPJG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Nov 2009 10:09:06 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAKF9Chc019686
	for <linux-ext4@vger.kernel.org>; Fri, 20 Nov 2009 15:09:12 GMT
In-Reply-To: <bug-14619-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14619


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu




--- Comment #1 from Theodore Tso <tytso@mit.edu>  2009-11-20 15:09:11 ---
Note that Sage reported in
http://marc.info/?l=linux-kernel&m=125696970418300&w=4
that he saw this with 2.6.31.   So at minimum it's not a regression from
2.6.31; possibly 2.6.30 --- we need more data, though.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
