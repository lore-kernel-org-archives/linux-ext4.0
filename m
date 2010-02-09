From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15231] kernel BUG at fs/ext4/inode.c:1852!
Date: Tue, 9 Feb 2010 03:52:50 GMT
Message-ID: <201002090352.o193qo8S003976@demeter.kernel.org>
References: <bug-15231-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:46782 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab0BIDwv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Feb 2010 22:52:51 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o193qoCl003977
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 9 Feb 2010 03:52:50 GMT
In-Reply-To: <bug-15231-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15231


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu




--- Comment #5 from Theodore Tso <tytso@mit.edu>  2010-02-09 03:52:45 ---
OK, so the dump in comment #3 and #4 are a completely different issue.  It's
not even clear it's an ext4 issue.  (An oops in fs/inode.c is quite different
from an oops in fs/ext4/inode.c).

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
