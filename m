From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16711] Oops with 2.6.36-rc1
Date: Wed, 25 Aug 2010 07:52:46 GMT
Message-ID: <201008250752.o7P7qkOe016438@demeter1.kernel.org>
References: <bug-16711-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:57176 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab0HYHwr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Aug 2010 03:52:47 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o7P7qkru016439
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 25 Aug 2010 07:52:46 GMT
In-Reply-To: <bug-16711-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16711





--- Comment #4 from Tobias <devnull@plzk.org>  2010-08-25 07:52:43 ---
Both rc1 and rc2 seem to oops regardless of apparmor being enabled or not.

Please see [1] for a boot attempt of rc1 with apparmor disabled and [2] for a
failed rc2 boot. I am actually not sure if apparmor was disabled on this rc2
boot, I tried several times and can only say that this is not the only trace
that scrolls by, just the last one that stays on screen.

Sorry for the horrible pics btw.

[1]http://img819.imageshack.us/img819/221/imag0033qx.jpg
[2]http://img842.imageshack.us/img842/4300/imag0037ij.jpg

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
