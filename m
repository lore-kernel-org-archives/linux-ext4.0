From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 36722] TRIM support is broken for Crucial M4 drives
Date: Mon, 6 Jun 2011 14:43:22 GMT
Message-ID: <201106061443.p56EhMMc025423@demeter1.kernel.org>
References: <bug-36722-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:60307 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab1FFOnX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Jun 2011 10:43:23 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p56EhM4c025424
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 6 Jun 2011 14:43:22 GMT
In-Reply-To: <bug-36722-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=36722





--- Comment #2 from devsk <kernel-bugs.dev1world@spamgourmet.com>  2011-06-06 14:41:55 ---
I am on 2.6.38.8

$ grep $ /sys/block/sdk/queue/discard_*
/sys/block/sdk/queue/discard_granularity:0
/sys/block/sdk/queue/discard_max_bytes:0
/sys/block/sdk/queue/discard_zeroes_data:0

# /tmp/discard /dev/sdk5
discard: Operation not supported

Is this because of the LSI card not passing the TRIM onto the drive? Why does
hdparm report that TRIM is supported then?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
