From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12885] kernel BUG at fs/jbd/transaction.c:1376!
Date: Wed, 18 Mar 2009 07:57:42 -0700 (PDT)
Message-ID: <20090318145743.1A4CC108040@picon.linux-foundation.org>
References: <bug-12885-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38858 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752147AbZCRO6v (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Mar 2009 10:58:51 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n2IEvhEj008214
	for <linux-ext4@vger.kernel.org>; Wed, 18 Mar 2009 07:58:19 -0700
In-Reply-To: <bug-12885-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12885





------- Comment #4 from tytso@mit.edu  2009-03-18 07:57 -------
Oh, this looks pretty likely to be a software bug.  It just seems to be one of
these "should never happen; why isn't anyone else seeing it?" things.  Maybe it
has something to do with the luks encrpytion layer?  I don't know.

If you could do some experiments to see how easily you can reproduce it, and
maybe some hints about how we could reproduce it on one of our machines, that
would be really appreciated.   If you're willing to work with us on some
debugging patches, that would be really great as well.

Once you can reproduce it, then we can try to twiddle various variables, such
as whether it goes away if you remove the luks layer.  We can also try
introducing some patches that might log some in-flight information, etc.  So
trying to see if we can get an easy reproduction case is the first thing that
we really need to do.   If you have the time to help us out, it will really
help us track it down.  (If not, we'll understand, of course.)

Thanks in advance...


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
