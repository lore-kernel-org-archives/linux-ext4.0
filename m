From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16081] Data loss after crash during heavy I/O
Date: Wed, 2 Jun 2010 18:28:33 GMT
Message-ID: <201006021828.o52ISXjD006097@demeter.kernel.org>
References: <bug-16081-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:41781 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932641Ab0FBS2e (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Jun 2010 14:28:34 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o52ISXCM006098
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 2 Jun 2010 18:28:33 GMT
In-Reply-To: <bug-16081-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16081





--- Comment #12 from Eric Sandeen <sandeen@redhat.com>  2010-06-02 18:28:32 ---
I don't know if it's at all possible, but testing on block devices and
filesystems just smaller than 8T would be an interesting datapoint, if that
yields success...  we really should be perfectly safe at 9T but this is looking
like maybe a write has wrapped somewhere and corrupted things.

A resident dm expert also requested the output of "dmsetup table" for the
machine that yielded the "access beyond end of device" message.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
