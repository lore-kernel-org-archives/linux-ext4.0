From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15231] kernel BUG at fs/ext4/inode.c:1852!
Date: Mon, 15 Feb 2010 17:14:33 GMT
Message-ID: <201002151714.o1FHEXcG029168@demeter.kernel.org>
References: <bug-15231-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:60501 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768Ab0BOROf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Feb 2010 12:14:35 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o1FHEXKX029180
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 15 Feb 2010 17:14:33 GMT
In-Reply-To: <bug-15231-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15231





--- Comment #16 from Theodore Tso <tytso@mit.edu>  2010-02-15 17:14:25 ---
Franco,

Could you file a separate bug for the fs/inode.c:1343 problem?   And I'd
suggest attaching it to the NFS component since that's what I strongly suspect
is going on.

The other thing that would be really big help for me is if you could try
running 2.6.33-rc8.  It has a series of fixes which I believe should address
the quota problem, while still leaving the quota fix in place, and it would be
really good to know if it has been fixed before Linus releases 2.6.33. 
2.6.33-rc8 is pretty close to 2.6.33-final, so it should be relatively safe to
run it.  Still, if you're hesitant to exposing your production machines to a
pre-release kernel, I'll completely understand.

Thanks,

- Ted

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
