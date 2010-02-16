From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15025] Oops in ext4 driver
Date: Tue, 16 Feb 2010 23:57:08 GMT
Message-ID: <201002162357.o1GNv8mB025193@demeter.kernel.org>
References: <bug-15025-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:41683 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933636Ab0BPX5L (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Feb 2010 18:57:11 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o1GNv8jd025195
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 16 Feb 2010 23:57:08 GMT
In-Reply-To: <bug-15025-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15025


Steinar H. Gunderson <sgunderson@bigfoot.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         Resolution|CODE_FIX                    |UNREPRODUCIBLE




--- Comment #9 from Steinar H. Gunderson <sgunderson@bigfoot.com>  2010-02-16 23:56:59 ---
Dmitry: That seems impossible, as I'm not using quota on the machine in
question (it's not even compiled into the kernel).

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
