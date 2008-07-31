From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Rework the ext4_da_writepages
Date: Thu, 31 Jul 2008 23:17:46 +0530
Message-ID: <20080731174746.GE20838@skywalker>
References: <1217525605-23000-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:57159 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbYGaRsN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Jul 2008 13:48:13 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id m6VHmXvA009773
	for <linux-ext4@vger.kernel.org>; Fri, 1 Aug 2008 03:48:33 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6VHmAEv263276
	for <linux-ext4@vger.kernel.org>; Fri, 1 Aug 2008 03:48:10 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6VHm91C018125
	for <linux-ext4@vger.kernel.org>; Fri, 1 Aug 2008 03:48:09 +1000
Content-Disposition: inline
In-Reply-To: <1217525605-23000-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 31, 2008 at 11:03:25PM +0530, Aneesh Kumar K.V wrote:
> With the below changes we reserve credit needed to insert only one extent
> resulting from a call to single get_block. That make sure we don't take
> too much journal credits during writeout. We also don't limit the pages
> to write. That means we loop through the dirty pages building largest
> possible contiguous block request. Then we issue a single get_block request.
> We may get less block that we requested. If so we would end up not mapping
> some of the buffer_heads. That means those buffer_heads are still marked delay.
> Later in the writepage callback via __mpage_writepage we redirty those pages.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Tested with 
a) fsstress with falloc
b) fsxlinux with falloc
c) fs_inode
d) ffsb
e) cp -ax / .

with fsck after each test

-aneesh
