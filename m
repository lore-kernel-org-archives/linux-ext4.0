From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Fri, 30 Oct 2009 10:42:40 GMT
Message-ID: <200910301042.n9UAge7p015766@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:48054 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756972AbZJ3Kmg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Oct 2009 06:42:36 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9UAgf3X015770
	for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2009 10:42:41 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #154 from Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>  2009-10-30 10:42:38 ---
To further update on 487caeef9fc08c0565e082c40a8aaf58dad92bbb, If we happen to
create a prealloc space mapping the same offset that we are truncating them we
can end up having multiple claimed blocks. ext4_mb_return_to_preallocation
which is done during truncate doesn't put the blocks back into prealloc space
because it depends on us discarding the prealloc space at the beginning of the
truncate.

Now whether we can end up having block allocation that can get a prealloc space
mapping the same offset that we are truncating is something i haven't yet
figured out. We do invalidate all pages before we start a truncate. That would
imply flusher threads will not find any of those dirty pages. Also for multiple
claimed blocks to happen we should get the same block number that we are
freeing via truncate. AFAIU that cannot happen because bits mapping those
blocks are marked used in buddy cache. So we cannot preallocate them. 

But i guess discarding prealloc space after reacquiring i_data_sem seemed to be
a safe bet to me. But still doesn't fully explain why we end up having multiple
claimed blocks. May be i am missing some code paths in the above analysis.

-aneesh

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
