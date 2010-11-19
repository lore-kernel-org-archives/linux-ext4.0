From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 23232] kernel hang on insert ext4 usb key
Date: Fri, 19 Nov 2010 15:45:50 GMT
Message-ID: <201011191545.oAJFjoLF018880@demeter2.kernel.org>
References: <bug-23232-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:46994 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab0KSPpu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Nov 2010 10:45:50 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id oAJFjovm018881
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 19 Nov 2010 15:45:50 GMT
In-Reply-To: <bug-23232-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=23232





--- Comment #8 from Eric Sandeen <sandeen@redhat.com>  2010-11-19 15:45:48 ---
It may well be related to the firmware on the usb key, I don't think there's a
lot we can do on the ext4/kernel side.  (other than to "not crash" when it's
terribly corrupted)

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
