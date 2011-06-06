From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 36722] TRIM support is broken for Crucial M4 drives
Date: Mon, 6 Jun 2011 09:04:54 GMT
Message-ID: <201106060904.p5694snm015139@demeter2.kernel.org>
References: <bug-36722-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:33290 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab1FFJEz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Jun 2011 05:04:55 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p5694s1t015170
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 6 Jun 2011 09:04:54 GMT
In-Reply-To: <bug-36722-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=36722





--- Comment #1 from Lukas Czerner <lczerner@redhat.com>  2011-06-06 09:04:51 ---
Created an attachment (id=60892)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=60892)
BLKDISCARD testing program

Hi,

thanks for reporting! Could you please provide the output of this simple test
program ? Also the output of the following command.

grep $ /sys/block/sda/queue/discard_*

What kernel version are you using ?

Thanks!
-Lukas

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
