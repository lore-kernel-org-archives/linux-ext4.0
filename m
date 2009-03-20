From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12885] kernel BUG at fs/jbd/transaction.c:1376!
Date: Fri, 20 Mar 2009 06:26:49 -0700 (PDT)
Message-ID: <20090320132649.38B37108040@picon.linux-foundation.org>
References: <bug-12885-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35769 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750836AbZCTN2d (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Mar 2009 09:28:33 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n2KDRPln024625
	for <linux-ext4@vger.kernel.org>; Fri, 20 Mar 2009 06:28:01 -0700
In-Reply-To: <bug-12885-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12885





------- Comment #24 from tytso@mit.edu  2009-03-20 06:26 -------
Andreas, if you can send me the compressed e2image file (it should compress
well, since all of the data blocks have been taken out) via some kind of
private download URL, I'd really appreciate it.   At this point that's probably
going to be the fastest way to track down what is happening.

The possibly related bug you pointed at in Comment #22 is a reiserfs bug, which
uses totally unrelated journalling machinery to ext4, so I very much doubt it
is related.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
