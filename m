From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12624] umount hangs after fsstress with data=journal
Date: Mon, 25 May 2009 18:21:00 GMT
Message-ID: <200905251821.n4PIL0VG001196@demeter.kernel.org>
References: <bug-12624-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:46233 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbZEYSU7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 May 2009 14:20:59 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n4PIL0Y7001197
	for <linux-ext4@vger.kernel.org>; Mon, 25 May 2009 18:21:00 GMT
In-Reply-To: <bug-12624-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12624





--- Comment #4 from Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>  2009-05-25 18:21:00 ---
Filesystem with 4K blocksize works fine.
Filesystem with 1k blocksize fails when fsx-linux is run with mmap write
anebled.
Filesystem with 1k blocksize works fine when we disable mmap write in
fsx-linux with -W option.

-aneesh

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
