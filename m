From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12885] kernel BUG at fs/jbd/transaction.c:1376!
Date: Wed, 18 Mar 2009 10:41:43 -0700 (PDT)
Message-ID: <20090318174143.5106A108040@picon.linux-foundation.org>
References: <bug-12885-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752452AbZCRRmj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Mar 2009 13:42:39 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n2IHfhGm028218
	for <linux-ext4@vger.kernel.org>; Wed, 18 Mar 2009 10:42:19 -0700
In-Reply-To: <bug-12885-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12885





------- Comment #7 from tytso@mit.edu  2009-03-18 10:41 -------
It's good to know that you can reproduce it easily on that particular ext3 file
system.   One interesting question is whether you can reproduce it on some
other ext3 file system (since then we might be able to reproduce it on our
end); although I haven't played with LUKS at all, and I don't know how much
effort it would take for me to set it up on my system.

How are you backing up the data?   tar?  Amanda?   Some other backup system?


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
