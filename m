From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16165] Wrong data returned on read after write if file size was
 changed with ftruncate before
Date: Thu, 24 Jun 2010 15:53:27 GMT
Message-ID: <201006241553.o5OFrRkG025158@demeter.kernel.org>
References: <bug-16165-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:53413 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671Ab0FXPx2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jun 2010 11:53:28 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o5OFrRAK025166
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 24 Jun 2010 15:53:28 GMT
In-Reply-To: <bug-16165-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16165





--- Comment #15 from Eric Sandeen <sandeen@redhat.com>  2010-06-24 15:53:20 ---
(In reply to comment #14)
> And like in the mail thread it fails for XFS too.

How about with these 2 patches from the xfs list?

[PATCH 1/2] direct-io: move aio_complete into ->end_io
[PATCH 2/2] xfs: move aio completion after unwritten extent conversion

(thread starts at http://oss.sgi.com/archives/xfs/2010-06/msg00269.html)

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
