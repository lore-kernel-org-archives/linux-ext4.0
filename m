From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 20902] High IO wait when writing to ext4
Date: Wed, 24 Nov 2010 03:14:08 GMT
Message-ID: <201011240314.oAO3E8wS005828@demeter1.kernel.org>
References: <bug-20902-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:38065 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab0KXDOJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Nov 2010 22:14:09 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id oAO3E8lu005829
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 24 Nov 2010 03:14:08 GMT
In-Reply-To: <bug-20902-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=20902





--- Comment #16 from Justin Maggard <jmaggard10@gmail.com>  2010-11-24 03:14:05 ---
Created an attachment (id=38002)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=38002)
blktrace showing initial write slowness

Here's mine.  My test case is mount, sleep 5, then do 10 x 128MB writes using
dd to the just-mounted filesystem.  The first 128MB write took over 20 seconds.
 Unfortunately I don't have access any more to the box where it took 150
seconds.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
