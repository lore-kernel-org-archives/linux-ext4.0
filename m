From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15875] Add an option to disable file/directory permissions for
 ACL'ed file systems
Date: Thu, 4 Nov 2010 15:48:25 GMT
Message-ID: <201011041548.oA4FmPl4005005@demeter2.kernel.org>
References: <bug-15875-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [140.211.167.42] ([140.211.167.42]:57151 "EHLO
	demeter2.kernel.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab0KDPs0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Nov 2010 11:48:26 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id oA4FmPDj005006
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 4 Nov 2010 15:48:25 GMT
In-Reply-To: <bug-15875-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15875


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu




--- Comment #11 from Theodore Tso <tytso@mit.edu>  2010-11-04 15:48:22 ---
So this bug report is highly confused.  Reading the original request, I think
what the original poster was requesting was actually a way of disabling all
access controls, and ACL's (meaning Access Control Lists) has nothing to do
with this at all.

Ideally I think this should be a VFS-level mount option (like read-only,
noatime) so that it's not an ext4 specific option.  But if we can't get
consensus across other file system developer teams, doing it as an ext4
specific mount option is a possibility.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
