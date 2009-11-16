From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14602] JBD2 journal abort / checkpoint creation racy?
Date: Mon, 16 Nov 2009 18:59:38 GMT
Message-ID: <200911161859.nAGIxcne024832@demeter.kernel.org>
References: <bug-14602-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:47221 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbZKPS7h (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Nov 2009 13:59:37 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAGIxcSR024833
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2009 18:59:38 GMT
In-Reply-To: <bug-14602-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14602





--- Comment #3 from Theodore Tso <tytso@mit.edu>  2009-11-16 18:59:35 ---
Well, an I/O error won't cause an ext4_error() --- unless the garbage returned
is corrupted enough that it causes the ext4 file system code to decide to throw
an ext4_error.   So the fact that you sometimes get an aborted journal (caused
by an ext4_error) isn't entirely surprising.  

The ext4_error is going to depend on whether or not the ext4 fs code things the
file system is corrupted, which is going to be data dependent, and that might
be variable after an I/O error.   The real problem may be that we need to be
doing a better job of doing error checking....

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
