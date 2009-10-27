From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [Bug 14422] New: EXT4 is corrupted after clean shutdown
Date: Tue, 27 Oct 2009 15:46:23 +0530
Message-ID: <20091027101623.GB27584@skywalker.linux.vnet.ibm.com>
References: <bug-14422-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:44368 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbZJ0KBU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Oct 2009 06:01:20 -0400
Received: from d28relay01.in.ibm.com (d28relay01.in.ibm.com [9.184.220.58])
	by e28smtp01.in.ibm.com (8.14.3/8.13.1) with ESMTP id n9RA1NJ0023976
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2009 15:31:23 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay01.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n9RA1N8A1257562
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2009 15:31:23 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n9RA1NCw008428
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2009 21:01:23 +1100
Content-Disposition: inline
In-Reply-To: <bug-14422-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Can you try this patch ?

commit a8836b1d6f92273e001012c7705ae8f4c3d5fb65
Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date:   Tue Oct 27 15:36:38 2009 +0530

    ext4: discard preallocation during truncate
    
    We need to make sure when we drop and reacquire the inode's
    i_data_sem we discard the inode preallocation. Otherwise we
    could have blocks marked as free in bitmap but still belonging
    to prealloc space.
    
    Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5c5bc5d..a1ef1c3 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -209,6 +209,12 @@ static int try_to_extend_transaction(handle_t *handle, struct inode *inode)
 	up_write(&EXT4_I(inode)->i_data_sem);
 	ret = ext4_journal_restart(handle, blocks_for_truncate(inode));
 	down_write(&EXT4_I(inode)->i_data_sem);
+	/*
+	 * We have dropped i_data_sem. So somebody else could have done
+	 * block allocation. So discard the prealloc space created as a
+	 * part of block allocation
+	 */
+	ext4_discard_preallocations(inode);
 
 	return ret;
 }
