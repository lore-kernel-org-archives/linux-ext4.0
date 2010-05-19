From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15579] ext4 -o discard produces incorrect blocks of zeroes in
 newly created files under heavy read+truncate+append-new-file load
Date: Wed, 19 May 2010 10:50:50 GMT
Message-ID: <201005191050.o4JAoo3T024527@demeter.kernel.org>
References: <bug-15579-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:46182 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050Ab0ESKuv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 May 2010 06:50:51 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4JAoo3R024528
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 19 May 2010 10:50:50 GMT
In-Reply-To: <bug-15579-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15579





--- Comment #12 from Andreas Beckmann <kernel-bugs@abeckmann.de>  2010-05-19 10:50:44 ---
I just saw that this patch went into 2.6.34
commmit b90f687018e6d6c77d981b09203780f7001407e5

Thanks!

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
