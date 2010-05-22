From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16019] Resume from hibernate corrupts ext4
Date: Sat, 22 May 2010 17:10:06 GMT
Message-ID: <201005221710.o4MHA6bf014090@demeter.kernel.org>
References: <bug-16019-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:34887 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab0EVRKH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 22 May 2010 13:10:07 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4MHA68a014091
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 22 May 2010 17:10:06 GMT
In-Reply-To: <bug-16019-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16019





--- Comment #16 from Eric Sandeen <sandeen@redhat.com>  2010-05-22 17:10:04 ---
David, do you know if this regressed for you at some point?  Has it ever
worked?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching someone on the CC list of the bug.
