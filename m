From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16019] Resume from hibernate corrupts ext4
Date: Tue, 15 Feb 2011 15:31:13 GMT
Message-ID: <201102151531.p1FFVDQx010049@demeter1.kernel.org>
References: <bug-16019-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:56642 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab1BOPbP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Feb 2011 10:31:15 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p1FFVE5Z010051
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 15 Feb 2011 15:31:14 GMT
In-Reply-To: <bug-16019-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16019





--- Comment #44 from Klaus Lichtenwalder <lichtenwalder@acm.org>  2011-02-15 15:31:10 ---
Hi, 
running 2.6.37-2.fc15.i686 works fine, but using rawhide
kernel-2.6.38-0.rc4.git0.2.fc15.i686 or kernel-2.6.38-0.rc3.git0.1.fc15.i686
shows errors very fast! Even faster than in 2.6.35... Most of the time in
/sys...

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching someone on the CC list of the bug.
