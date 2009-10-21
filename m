From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Wed, 21 Oct 2009 00:53:03 GMT
Message-ID: <200910210053.n9L0r3en009274@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:56853 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbZJUAw7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Oct 2009 20:52:59 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9L0r313009275
	for <linux-ext4@vger.kernel.org>; Wed, 21 Oct 2009 00:53:03 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #96 from Theodore Tso <tytso@mit.edu>  2009-10-21 00:52:57 ---
Alexey, what version of GCC are you using?   If applying the patch in
attachment #23468 stops file system corruption, but you're not seeing the
message or the kernel stack dump that would be triggered by WARN_ON(1) in your
logs, then the conditional is never triggering.   So the only thing that might
be making a difference is if this is either moving some code around or some
kind of compiler bug.   Something really doesn't make sense, and there is
definitely something very subtle going on here.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
