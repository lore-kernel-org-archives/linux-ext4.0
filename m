From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16019] Resume from hibernate corrupts ext4
Date: Fri, 18 Jun 2010 06:32:42 GMT
Message-ID: <201006180632.o5I6Wgv6027213@demeter.kernel.org>
References: <bug-16019-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:51058 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab0FRGcq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jun 2010 02:32:46 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o5I6Wgk4027214
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jun 2010 06:32:42 GMT
In-Reply-To: <bug-16019-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16019





--- Comment #32 from Klaus Lichtenwalder <lichtenwalder@acm.org>  2010-06-18 06:32:19 ---
Well, just going in runlevel 3 is not enough, as drm loads i915 even then, from
initramfs. You need to create an initramfs without the i915 moule.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching someone on the CC list of the bug.
