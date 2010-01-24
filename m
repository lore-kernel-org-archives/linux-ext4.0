From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14256] kernel BUG at fs/ext3/super.c:435
Date: Sun, 24 Jan 2010 11:28:08 GMT
Message-ID: <201001241128.o0OBS8fr004081@demeter.kernel.org>
References: <bug-14256-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:36792 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab0AXL2K (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 Jan 2010 06:28:10 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0OBS8sP004082
	for <linux-ext4@vger.kernel.org>; Sun, 24 Jan 2010 11:28:08 GMT
In-Reply-To: <bug-14256-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14256





--- Comment #37 from Mikael Pettersson <mikpe@it.uu.se>  2010-01-24 11:28:05 ---
(In reply to comment #36)
> I've posted a futex bug fix to lkml:
> <http://marc.info/?l=linux-kernel&m=126428261230399&w=2>
> 
> It fixed the standalone test case. I'm now doing a full glibc rebuild and test
> suite run on a machine with the fixed kernel.

Completed. The patch eliminated all orphan inodes from the glibc test suite.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
