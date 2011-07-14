From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 39072] jbd2 writes on disk every few seconds
Date: Thu, 14 Jul 2011 17:25:50 GMT
Message-ID: <201107141725.p6EHPo5R008149@demeter2.kernel.org>
References: <bug-39072-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:44606 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139Ab1GNRZu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Jul 2011 13:25:50 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.4) with ESMTP id p6EHPoYe008150
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 14 Jul 2011 17:25:50 GMT
In-Reply-To: <bug-39072-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=39072





--- Comment #12 from mkkot <marcin2006@gmail.com>  2011-07-14 17:25:48 ---
It does in special circumstances which is vm.block_dump enabled. For the rest
go to: https://lists.balabit.hu/pipermail/syslog-ng/2011-July/016893.html

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
