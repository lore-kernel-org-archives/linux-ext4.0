From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 23232] kernel hang on insert ext4 usb key
Date: Fri, 19 Nov 2010 15:41:41 GMT
Message-ID: <201011191541.oAJFffiD016459@demeter1.kernel.org>
References: <bug-23232-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:34528 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755258Ab0KSPlm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Nov 2010 10:41:42 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id oAJFfg8R016462
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 19 Nov 2010 15:41:42 GMT
In-Reply-To: <bug-23232-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=23232





--- Comment #7 from shal@free.fr  2010-11-19 15:41:40 ---
I have done test without umount the key properly and sometime ugly.

The kernel crash problem is corrected by the patch.

The corruption of the filesystem is strange , I never seen this kind of
corruption (e.g. with lost of all data after fsck, the fsck takes 5 minutes,
even I have only insert/retrieve the key without performed any write on the
key).

One the same suite of tests with another ext4 usb key of only 1gb , there is no
problem in any case.

I am not sure that problems are linked

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
