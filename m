From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14734] BUG: unable to handle kernel NULL pointer dereference at
 0000000000000808
Date: Sun, 6 Dec 2009 21:02:18 GMT
Message-ID: <200912062102.nB6L2IEc004168@demeter.kernel.org>
References: <bug-14734-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:48245 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757867AbZLFVCL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 6 Dec 2009 16:02:11 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nB6L2I0E004169
	for <linux-ext4@vger.kernel.org>; Sun, 6 Dec 2009 21:02:18 GMT
In-Reply-To: <bug-14734-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14734





--- Comment #1 from Theodore Tso <tytso@mit.edu>  2009-12-06 21:02:16 ---
On Fri, Dec 04, 2009 at 03:39:30PM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> 
> Just let me know what else I should post in addition to the following. I've
> gotten this bug pretty consistently, on 2.6.

Hmm.... there's a strnage fsnotify_clear_marks_by_inode() on the stack
trace which doesn't seem to make any sense and which I can't place.
Are you using the fsnotify feature for some reason (i.e., some
new-fangled proprietnary "linux anti-virus" package or some such?).
If so, does the problem go away if you stop using said package and not
use the fsnotify interface?

Also, do you have to do anything special to trigger it?  Is the "rm"
in the process handle an "rm -rf", or some such?

                                                      - Ted

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
