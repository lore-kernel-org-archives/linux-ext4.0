From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 29752] Possible i_nlink race in ext2_rename
Date: Sat, 5 Mar 2011 01:20:28 GMT
Message-ID: <201103050120.p251KSLH016904@demeter2.kernel.org>
References: <bug-29752-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:45111 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760091Ab1CEBU3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Mar 2011 20:20:29 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p251KS5r016905
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 5 Mar 2011 01:20:28 GMT
In-Reply-To: <bug-29752-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=29752


Josh Hunt <joshhunt00@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |CODE_FIX




--- Comment #3 from Josh Hunt <joshhunt00@gmail.com>  2011-03-05 01:20:27 ---
Fix accepted upstream. Commit id:e8a80c6f769dd4622d8b211b398452158ee60c0b

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
