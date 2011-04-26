From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes when a mounted ext3/4 file system is
 physically removed
Date: Tue, 26 Apr 2011 04:02:49 GMT
Message-ID: <201104260402.p3Q42nCD007140@demeter1.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:47538 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab1DZECu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Apr 2011 00:02:50 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p3Q42n9O007141
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 26 Apr 2011 04:02:49 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #76 from Theodore Tso <tytso@mit.edu>  2011-04-26 03:28:39 ---
So for this latest result, which file systems have you been using?  ext3? ext4?
ntfs? vfat?

--- Comment #77 from rocko <rockorequin@hotmail.com>  2011-04-26 04:02:41 ---
This is with ext4 on both the root file system and the external USB drive.

AFAIK, I have only ever reproduced the crash on ext4, but I haven't done much
experimentation with ext3 as I don't use it. Another user told me he had the
same issue - oops on resume after removing drive - and he was using an ext3
drive. I did try reproducing the crash with vfat and ntfs but couldn't make the
kernel crash.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
