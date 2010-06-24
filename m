From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16165] Wrong data returned on read after write if file size was
 changed with ftruncate before
Date: Thu, 24 Jun 2010 22:20:34 GMT
Message-ID: <201006242220.o5OMKYsr016652@demeter.kernel.org>
References: <bug-16165-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:52905 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab0FXWUf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jun 2010 18:20:35 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o5OMKYO2016653
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 24 Jun 2010 22:20:34 GMT
In-Reply-To: <bug-16165-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16165





--- Comment #16 from Eric Sandeen <sandeen@redhat.com>  2010-06-24 22:20:25 ---
And for ext4 perhaps try this on top of the above:

[PATCH] EXT4: move aio completion after unwritten extent conversion
http://marc.info/?l=linux-ext4&m=127741775019003&w=2

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
