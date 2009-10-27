From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Tue, 27 Oct 2009 12:24:36 +0530
Message-ID: <20091027065436.GA25569@skywalker.linux.vnet.ibm.com>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
 <200910262240.n9QMegX2008177@demeter.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:59700 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756199AbZJ0Gjd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Oct 2009 02:39:33 -0400
Received: from d28relay03.in.ibm.com (d28relay03.in.ibm.com [9.184.220.60])
	by e28smtp03.in.ibm.com (8.14.3/8.13.1) with ESMTP id n9R6da4e020588
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2009 12:09:36 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay03.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n9R6dasY2810054
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2009 12:09:36 +0530
Received: from d28av02.in.ibm.com (loopback [127.0.0.1])
	by d28av02.in.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n9R6daHZ030992
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2009 17:39:36 +1100
Content-Disposition: inline
In-Reply-To: <200910262240.n9QMegX2008177@demeter.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Can you test with the below patch

Commit 487caeef9fc08c0565e082c40a8aaf58dad92bbb fixed a deadlock
between get_block and truncate by dropping the i_data_sem during
truncate. But i guess we should make sure we drop any preallocation
that we did as a part of the block allocation. Otherwise we definitely
can get multiple claimed blocks. But this can happen only if we have
block allocation and truncate happening on the same file simultaneously.

With delayed allocation i guess it is possible that pdflush tries to do
block allocation while application does a truncate


diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 10539e3..14539b5 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -113,6 +113,7 @@ static int ext4_ext_truncate_extend_restart(handle_t *handle,
 	 */
 	ext4_ext_invalidate_cache(inode);
 
+	ext4_discard_preallocations(inode);
 	return err;
 }
 

