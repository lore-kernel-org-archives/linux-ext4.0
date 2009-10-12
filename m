From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14256] kernel BUG at fs/ext3/super.c:435
Date: Mon, 12 Oct 2009 16:19:55 GMT
Message-ID: <200910121619.n9CGJtP0032209@demeter.kernel.org>
References: <bug-14256-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:36728 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932754AbZJLQUc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Oct 2009 12:20:32 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9CGJtwI032216
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2009 16:19:55 GMT
In-Reply-To: <bug-14256-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14256


Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com




--- Comment #5 from Eric Sandeen <sandeen@redhat.com>  2009-10-12 16:19:54 ---
I can give this a whirl on fedora.  Just to try to reproduce more exactly,
which version of the glibc rpm package are you rebuilding?

I'm also curious, does simply rebuilding the package and rebooting lead to the
same issue (w/o installing the result?)

Do you have rpm configured in any unique way or is the build happening in all
the normal/standard places?

So you have /tmp as ext3 as a separate fs, any other interesting fs config?

Thanks,
-Eric

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
