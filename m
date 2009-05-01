From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12151] Unexplained fsck errors on a ext4 filesystem
Date: Fri, 1 May 2009 15:19:38 GMT
Message-ID: <200905011519.n41FJcBu021652@demeter.kernel.org>
References: <bug-12151-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:44225 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756063AbZEAPTi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 May 2009 11:19:38 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n41FJcAE021653
	for <linux-ext4@vger.kernel.org>; Fri, 1 May 2009 15:19:38 GMT
In-Reply-To: <bug-12151-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12151





--- Comment #9 from Eric Sandeen <sandeen@redhat.com>  2009-05-01 15:19:38 ---
(In reply to comment #7)
> I have been running Fedora's kernels the whole time, and I haven't seen this
> issue with 2.6.29 kernels. I don't think I saw it with 2.6.28 kernels either. I
> wonder if Fedora has been putting more patches for ext4 in over what goes into
> Linus's tree.

Nathan - well, not really.  I'll never put something in fedora that hasn't been
sent upstream, it's not how we work.

One difference may be that the 2.6.27 kernels in F10 did have the ext4 "stable"
backports that Ted was doing...

If you're running .29 kernels from fedora, it should be equivalent to what's
upstream.  The only changes in F11 for example are:

Patch2920: linux-2.6-ext4-flush-on-close.patch
Patch2921: linux-2.6-ext4-really-print-warning-once.patch

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
