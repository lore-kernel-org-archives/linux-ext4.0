From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16019] Resume from hibernate corrupts ext4
Date: Thu, 1 Jul 2010 05:04:39 GMT
Message-ID: <201007010504.o6154daO029967@demeter.kernel.org>
References: <bug-16019-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:42816 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab0GAFEk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Jul 2010 01:04:40 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o6154dqG029968
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 1 Jul 2010 05:04:39 GMT
In-Reply-To: <bug-16019-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16019





--- Comment #38 from Klaus Lichtenwalder <lichtenwalder@acm.org>  2010-07-01 05:04:30 ---
I don'r know whether this is related, but one in a while I have a lockup of the
X server. I can move the mouse, and switch to the tty consoles, and log in, but
for a working X I have to reboot. Yesterday I saw in dmesg:
[drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
render error detected, EIR: 0x00000000
[drm:i915_do_wait_request] *ERROR* i915_do_wait_request returns -5 (awaiting
302900 at 302900)

Klaus

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching someone on the CC list of the bug.
