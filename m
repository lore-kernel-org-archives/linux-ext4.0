From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13549] Kernel oops while online resizing of an ext4 filesystem
Date: Sat, 27 Mar 2010 18:26:53 GMT
Message-ID: <201003271826.o2RIQr2Y006614@demeter.kernel.org>
References: <bug-13549-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:49033 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab0C0S0z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 27 Mar 2010 14:26:55 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2RIQri4006616
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 27 Mar 2010 18:26:54 GMT
In-Reply-To: <bug-13549-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=13549





--- Comment #17 from Eric Sandeen <sandeen@redhat.com>  2010-03-27 18:26:26 ---
Great, thanks for the reproducer, I'll give that a shot.

Alessandro, I have your image but still haven't made time to test with it,
hopefully soon (maybe today) - did you start your filesystem out as ext3?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
