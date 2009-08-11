From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12793] ext4 gives wrong errno with too long extended attribute
 values
Date: Tue, 11 Aug 2009 02:58:19 GMT
Message-ID: <200908110258.n7B2wJUM022315@demeter.kernel.org>
References: <bug-12793-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:42442 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbZHKMgc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Aug 2009 08:36:32 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n7B2wJB5022316
	for <linux-ext4@vger.kernel.org>; Tue, 11 Aug 2009 02:58:19 GMT
In-Reply-To: <bug-12793-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12793


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu
         Regression|---                         |No




--- Comment #2 from Theodore Tso <tytso@mit.edu>  2009-08-11 02:58:18 ---
I'm not convinced this change to use E2BIG instead of ENOSPC is always the
right thing.   Consider the wording of E2BIG: "The value of the given attribute
is too large, IT EXCEEDS THE MAXIMUM ALLOWABLE SIZE OF AN ATTRIBUTE VALUE".  In
other words E2BIG implies that a request was made to create an attribute where
the size exceeded some static value.

So if we pass in a request to create an attribute which is 2MB, E2BIG makes
sense.  On the other hand, if the EA block is almost full, a request to create
an attribute value which is 2 bytes long could result in an error --- and in
that case, ENOSPC makes a lot more sense that E2BIG.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
