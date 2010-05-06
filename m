From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15910] zero-length files and performance degradation
Date: Thu, 6 May 2010 04:06:10 GMT
Message-ID: <201005060406.o4646A9g008793@demeter.kernel.org>
References: <bug-15910-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:56519 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab0EFEGL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 May 2010 00:06:11 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4646ASQ008795
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 6 May 2010 04:06:10 GMT
In-Reply-To: <bug-15910-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15910


Dmitry Monakhov <dmonakhov@openvz.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |dmonakhov@openvz.org




--- Comment #2 from Dmitry Monakhov <dmonakhov@openvz.org>  2010-05-06 04:06:07 ---
May be it is not best place to ask but still. 

Most of script/app developers was addicted to ordered mode for too long,
so they no longer call fsync() before rename() in usual create new copy and
rename scenario for configs/init scripts. Most of developers not even know
that it is necessary(mandatory).
And in fact consequences are usually fatal because files are usually important
but old version was already unlinked.
This affect both versions because ext3 now use writeback by default,
and ext4 use writeback+delalloc.

May be it is useful to introduce compat mount option which force fsync()
internaly inside rename(). Renames is not what frequent operation so it has
much less performance penalty as real ordered mode.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
