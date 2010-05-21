From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16019] Resume from hibernate corrupts ext4
Date: Fri, 21 May 2010 17:11:01 GMT
Message-ID: <201005211711.o4LHB1iE032019@demeter.kernel.org>
References: <bug-16019-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:40555 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758512Ab0EURLE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 May 2010 13:11:04 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4LHB1DV032020
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 21 May 2010 17:11:01 GMT
In-Reply-To: <bug-16019-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16019





--- Comment #6 from Eric Sandeen <sandeen@redhat.com>  2010-05-21 17:10:58 ---
Just to test a theory, could you try doing "hdparm -W" on your disk(s) to check
the write cache status?

If it's 1 (on), then prior to hibernate, can you try hdparm -W 0 on the disk(s)
and see if the problem persists?  I'm wondering if it's possible that data in
the drive's write cache got lost when the system powered down, if it wasn't
properly flushed during hibernate.

You'll want to do hdparm -W 1 later to turn them back on if that was the
original state.

Thanks,

-Eric

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching someone on the CC list of the bug.
