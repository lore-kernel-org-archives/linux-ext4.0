From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16019] Resume from hibernate corrupts ext4
Date: Fri, 16 Jul 2010 21:15:11 GMT
Message-ID: <201007162115.o6GLFBbV028800@demeter.kernel.org>
References: <bug-16019-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:39509 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966094Ab0GPVPN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Jul 2010 17:15:13 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o6GLFC1d028801
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 16 Jul 2010 21:15:12 GMT
In-Reply-To: <bug-16019-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16019





--- Comment #39 from Klaus Lichtenwalder <lichtenwalder@acm.org>  2010-07-16 21:13:56 ---
Well, it looks like the newest Fedora 13 kernel hibernates just fine without fs
corruption

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching someone on the CC list of the bug.
