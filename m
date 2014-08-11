From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 61601] rootflags=noatime causes kernel panic when booting
 without initrd.
Date: Mon, 11 Aug 2014 14:24:13 +0000
Message-ID: <bug-61601-13602-obGetyG9Oc@https.bugzilla.kernel.org/>
References: <bug-61601-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:57811 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753370AbaHKOYQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Aug 2014 10:24:16 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 1DE6220131
	for <linux-ext4@vger.kernel.org>; Mon, 11 Aug 2014 14:24:15 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 417252010F
	for <linux-ext4@vger.kernel.org>; Mon, 11 Aug 2014 14:24:13 +0000 (UTC)
In-Reply-To: <bug-61601-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=61601

--- Comment #13 from Theodore Tso <tytso@mit.edu> ---
Jacob, there are very good programs to help people learn how to get involved
with kernel development.  See the kernelnewbies.org web site and mailing list,
for example.   But you need to have some amount of basic competence; being able
to use Google well, for example, and doing silly things like making sure the
patches compile before you submit patches for review.

Also, if you have clueless people asking users completely random questions that
are completely useless in terms of fixing the problem, it wastes the user's
time and causes them to get very frustrated.   So having newbies trying to help
users who are reporting kernel bugs is not a good idea.  If they want to help
users install Linux distributions, that's fine --- so long as you are minimally
competent in doing installation.  Similarly, if you are completely incompetent
in doing kernel development, you should not be offering to help users.

There are ways for newbies to get involved.  The problem is Nick has
consistently ignored advice of people who have wasted a huge amount of time
trying to get him on the right path.  Which is why he has gotten banned.

If you are someone who wants to get started, there is the Eudyptula Challenge
(http://eudyptula-challenge.org).   Nick finally got involved with this, and
then violated the very simple rules, which caused him to get ejected from the
Challenge within hours, thus setting a new record for the Eudyuptula Challenge.
 Anyway, this is off topic for the bug.  So please stop discussing this here,
please.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
