From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Wed, 4 Nov 2009 03:33:27 GMT
Message-ID: <200911040333.nA43XRFc012375@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:44131 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158AbZKDDdW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Nov 2009 22:33:22 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nA43XRsh012376
	for <linux-ext4@vger.kernel.org>; Wed, 4 Nov 2009 03:33:27 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #176 from Theodore Tso <tytso@mit.edu>  2009-11-04 03:33:25 ---
> Double-hrm; if it's not the transaction that was right during the power-fail,
> maybe this is a hint/clue for the other bug that claims corruption after a
> -clean- shutdown.  Probably time to go look for races, buffer re-use, etc in
> the checksumming code...?

I *hope* that is what it is.  The scarrier alternative is that we have
a race/buffer re-use or some other race that we've never noticed
because it's relatively rare enough, and if it's a block that ends up
getting overwritten by a subsequent transaction, it would be a
self-healing problem....

                        - Ted

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
