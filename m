From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16081] Data loss after crash during heavy I/O
Date: Wed, 2 Jun 2010 12:10:01 GMT
Message-ID: <201006021210.o52CA1Qo024668@demeter.kernel.org>
References: <bug-16081-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:37570 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793Ab0FBMKB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Jun 2010 08:10:01 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o52CA1E9024669
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 2 Jun 2010 12:10:01 GMT
In-Reply-To: <bug-16081-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16081





--- Comment #6 from Eric Sandeen <sandeen@redhat.com>  2010-06-02 12:10:00 ---
If a barrier failed outright you'd see a note in dmesg / logs shortly after the
mount, FWIW.  Anyway you didn't explicitly disable it.  Barrier support in
dm/lvm is rather new, as well.  Just a thought...

Capturing a core from the segfaulted e2fsck would help fix -that- bug ... and
attaching the output of the fscks might yield a clue as to what is damaged.

-Eric

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
