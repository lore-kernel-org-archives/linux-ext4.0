From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16081] Data loss after crash during heavy I/O
Date: Wed, 2 Jun 2010 18:06:56 GMT
Message-ID: <201006021806.o52I6uqH032115@demeter.kernel.org>
References: <bug-16081-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:39144 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660Ab0FBSG4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Jun 2010 14:06:56 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o52I6uDC032116
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 2 Jun 2010 18:06:56 GMT
In-Reply-To: <bug-16081-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16081





--- Comment #10 from Eric Sandeen <sandeen@redhat.com>  2010-06-02 18:06:54 ---
(In reply to comment #8)
> Created an attachment (id=26619)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=26619) [details]
> root-filesystem borkage

How confident are you in your storage?

> [  765.812082] attempt to access beyond end of device
> [  765.812088] dm-6: rw=256, want=18808645176, limit=8388608

the "want" value (in sectors) is ~9T.

The limit is oddly (?) 2^23 - 8388608, that many sectors comes out to exactly
4T.

IOW, now your block device appears to be much smaller than your filesystem....

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
