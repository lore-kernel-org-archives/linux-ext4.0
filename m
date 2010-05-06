From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15910] zero-length files and performance degradation
Date: Thu, 6 May 2010 04:18:59 GMT
Message-ID: <201005060418.o464IxOB012196@demeter.kernel.org>
References: <bug-15910-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:44770 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab0EFES7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 May 2010 00:18:59 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o464Ixli012197
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 6 May 2010 04:18:59 GMT
In-Reply-To: <bug-15910-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15910


Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com




--- Comment #3 from Eric Sandeen <sandeen@redhat.com>  2010-05-06 04:18:57 ---
(In reply to comment #2)

> May be it is useful to introduce compat mount option which force fsync()
> internaly inside rename(). Renames is not what frequent operation so it has
> much less performance penalty as real ordered mode.

ext4 does already have allocate-on-rename heuristics, though not exactly
fsync()

        if (retval == 0 && force_da_alloc)
                ext4_alloc_da_blocks(old_inode);
from

commit 8750c6d5fcbd3342b3d908d157f81d345c5325a7
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Mon Feb 23 23:05:27 2009 -0500

    ext4: Automatically allocate delay allocated blocks on rename

still, more mount options doesn't seem to solve the problem to me, in the end
applications can't rely on it...

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
