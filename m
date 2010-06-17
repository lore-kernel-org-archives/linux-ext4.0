From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16019] Resume from hibernate corrupts ext4
Date: Thu, 17 Jun 2010 16:47:52 GMT
Message-ID: <201006171647.o5HGlqOa012277@demeter.kernel.org>
References: <bug-16019-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:42981 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933066Ab0FQQrx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Jun 2010 12:47:53 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o5HGlqME012278
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 17 Jun 2010 16:47:52 GMT
In-Reply-To: <bug-16019-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16019





--- Comment #26 from Eric Sandeen <sandeen@redhat.com>  2010-06-17 16:47:50 ---
That may be affected.  You might try unloading/blacklisting i915 and test
hibernate again, either from plain VGA X, or a text console, see if it makes a
difference.  (I don't know if ubuntu has a different i915 driver... feel free
to test the lvm theory too!)

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching someone on the CC list of the bug.
