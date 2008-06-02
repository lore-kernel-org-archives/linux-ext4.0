From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 3/6] delalloc ENOSPC: reserve blocks
Date: Mon, 2 Jun 2008 14:02:29 +0530
Message-ID: <20080602083229.GB29995@skywalker>
References: <1212363355.4368.66.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:32945 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbYFBIcx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jun 2008 04:32:53 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp01.in.ibm.com (8.13.1/8.13.1) with ESMTP id m528WUio031030
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 14:02:30 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m528WFbb909472
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 14:02:15 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m528WTYs030902
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 14:02:30 +0530
Content-Disposition: inline
In-Reply-To: <1212363355.4368.66.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jun 01, 2008 at 04:35:55PM -0700, Mingming Cao wrote:
> ext4: delalloc ENOSPC handling core
> 
> From: Mingming cao <cmm@us.ibm.com>
> 
> Core part of delaloc ENOSPC (block reservation.) 
> data/meta blocks are reserved on write_begin(), and per-inode reserved counters
> are updated  after block allocation.


I am not clear about ext4_da_release_space. Are we accounting for the
blocks related to meta-data blocks allocated ? . In
ext4_da_get_block_write we get the number of data blocks allocated.
and we don't update sbi->s_freeblocks_counter in the block allocator
any more. So request for meta-data blocks are not updating the
sbi->s_freeblocks_counter. In ext4_da_release_space we  update
the  sbi->s_freeblocks_counter without considering the above. Am  I
missing something ?


-aneesh
