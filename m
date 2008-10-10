From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH updated] ext4: Use an rb tree for tracking blocks freed
	during transaction.
Date: Fri, 10 Oct 2008 21:04:31 +0530
Message-ID: <20081010153431.GA13533@skywalker>
References: <1223652510-13282-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:34233 "EHLO
	e28esmtp01.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758139AbYJJPem (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Oct 2008 11:34:42 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp01.in.ibm.com (8.13.1/8.13.1) with ESMTP id m9AFYeu2030126
	for <linux-ext4@vger.kernel.org>; Fri, 10 Oct 2008 21:04:40 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m9AFYeMj1052914
	for <linux-ext4@vger.kernel.org>; Fri, 10 Oct 2008 21:04:40 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id m9AFYdU0031131
	for <linux-ext4@vger.kernel.org>; Sat, 11 Oct 2008 02:34:40 +1100
Content-Disposition: inline
In-Reply-To: <1223652510-13282-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 10, 2008 at 08:58:30PM +0530, Aneesh Kumar K.V wrote:
> With this patch we track the block freed during a transaction using
> rb tree. We also make sure contiguos blocks freed are collected
> in one rb node.


The change from the last version is to add proper locking
when adding the new extents to active_transaction list.

        /* Add the extent to active_transaction list */
+       spin_lock(&sbi->s_md_lock);
        list_add(&new_entry->list, &sbi->s_active_transaction);
+       spin_unlock(&sbi->s_md_lock);


-aneesh
