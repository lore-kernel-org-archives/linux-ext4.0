From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12676]
 fs/ext4/extents.c:=?UTF-8?Q?=20In=20function=20=E2=80=98ext4=5Fext=5Fsearch=5Fright=E2=80=99?=: fs/ext4/extents.c:1120: warning:=?UTF-8?Q?=20=E2=80=98ix=E2=80=99=20may=20be=20used=20uninitialized=20in=20this=20function?=
Date: Tue, 19 May 2009 18:36:00 GMT
Message-ID: <200905191836.n4JIa0KA017486@demeter.kernel.org>
References: <bug-12676-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:55025 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbZESSf7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 May 2009 14:35:59 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n4JIa0m2017487
	for <linux-ext4@vger.kernel.org>; Tue, 19 May 2009 18:36:00 GMT
In-Reply-To: <bug-12676-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12676


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |tytso@mit.edu
         Resolution|                            |UNREPRODUCIBLE
         Regression|---                         |No




--- Comment #3 from Theodore Tso <tytso@mit.edu>  2009-05-19 18:36:00 ---
No response from the person filing the bug, and I don't see any compiler
warnings gcc 4.3.x, so I'm closing this bug.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
