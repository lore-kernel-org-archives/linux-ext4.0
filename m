From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15074] Problem with quota on ext4
Date: Wed, 10 Feb 2010 08:50:34 GMT
Message-ID: <201002100850.o1A8oY11017405@demeter.kernel.org>
References: <bug-15074-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:48601 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab0BJIuh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Feb 2010 03:50:37 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o1A8oZgQ017406
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 10 Feb 2010 08:50:35 GMT
In-Reply-To: <bug-15074-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15074





--- Comment #12 from Dmitri Monakhov <dmonakhov@openvz.org>  2010-02-10 08:49:56 ---
Created an attachment (id=24986)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=24986)
print warning about inconsistent quota usage

Jan this patch does as much as we can in case of unexpected quota
inconsistency.
I should be applied on top of
http://marc.info/?l=linux-ext4&m=126106356824375&w=2
Should i combine it in to one patch ?
1) It charge reserved space during quotaon
2) fixup quota_reservation on claim and release.
In both cases error message will be printed(in first case it will be printed
twice)

test
dd if=/dev/zero of=/mnt bs=1k &
quotaon /mnt
killall dd
sync
I've test it and has got nice warning messages without triggering WARN(true)
in claim_rsv and free_rsv

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
