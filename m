From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15579] ext4 -o discard produces incorrect blocks of zeroes in
 newly created files under heavy read+truncate+append-new-file load
Date: Fri, 19 Mar 2010 12:41:03 GMT
Message-ID: <201003191241.o2JCf34n007238@demeter.kernel.org>
References: <bug-15579-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:57487 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab0CSMlG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Mar 2010 08:41:06 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2JCf37M007240
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 19 Mar 2010 12:41:04 GMT
In-Reply-To: <bug-15579-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15579


Dmitry Monakhov <dmonakhov@openvz.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |dmonakhov@openvz.org




--- Comment #1 from Dmitry Monakhov <dmonakhov@openvz.org>  2010-03-19 12:40:57 ---
Some time ago i've posted comat discard support which simulate 
discard by generating simple zero filled request 
http://lkml.org/lkml/2010/2/11/74
Many changes was requested so i'm still working on new version (it will be
ready
soon).
But it may be useful for debugging needs with conjunction with blktrace.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
