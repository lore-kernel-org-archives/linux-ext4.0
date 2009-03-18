From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12885] kernel BUG at fs/jbd/transaction.c:1376!
Date: Wed, 18 Mar 2009 10:51:14 -0700 (PDT)
Message-ID: <20090318175114.6F2F6108040@picon.linux-foundation.org>
References: <bug-12885-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44798 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758692AbZCRRwS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Mar 2009 13:52:18 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n2IHpE5B029110
	for <linux-ext4@vger.kernel.org>; Wed, 18 Mar 2009 10:51:50 -0700
In-Reply-To: <bug-12885-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12885





------- Comment #9 from tytso@mit.edu  2009-03-18 10:51 -------
Trying to mount ext4 over LUKS on 2.6.28 should work as well.  (Sorry, the
reason why I said going to 2.6.29-rc was because I confused myself for a moment
and thought this was an ext2 problem, and 2.6.29-rc1 and later will allow you
to mount an ext2 filesystem using the ext4 filesystem code.)   But simply a
quick try to see if it will reproduce with using ext4 to mount your ext3
filesystem over LUKS would also be worth a very quick test.   Again, if the
problem still sticks around, that's the much more interesting data point; if
you can't reproduce it, that's good to know, but it doesn't help us chase down
the ext3/jbd bug....


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
