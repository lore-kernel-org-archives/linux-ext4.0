From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: fix sleep inside spinlock issue aka #14739
Date: Fri, 18 Dec 2009 15:32:40 +0530
Message-ID: <20091218100240.GB9437@skywalker.linux.vnet.ibm.com>
References: <1260409362-4349-1-git-send-email-dmonakhov@openvz.org>
 <20091210161553.GG26516@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org,
	cmm@us.ibm.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:39811 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbZLRKCr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Dec 2009 05:02:47 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.31.245])
	by e23smtp03.au.ibm.com (8.14.3/8.13.1) with ESMTP id nBI9xw7L025014
	for <linux-ext4@vger.kernel.org>; Fri, 18 Dec 2009 20:59:58 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id nBIA2jfv847904
	for <linux-ext4@vger.kernel.org>; Fri, 18 Dec 2009 21:02:46 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id nBIA2jXt018637
	for <linux-ext4@vger.kernel.org>; Fri, 18 Dec 2009 21:02:45 +1100
Content-Disposition: inline
In-Reply-To: <20091210161553.GG26516@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 10, 2009 at 05:15:53PM +0100, Jan Kara wrote:
> > drop i_block_reservation_lock before vfs_dq_reserve_block().
> > this patch fix http://bugzilla.kernel.org/show_bug.cgi?id=14739
> > 
> > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>   Sorry if someone already refused this (I didn't follow the previous
> discussion too closely) but: Looking at the code I see no reason why
> ext4_claim_free_blocks needs i_block_reservation_lock. In fact mballoc
> calls this function without the lock. So could not we just compute
> 'total' under the lock, release it, reserve quota and then claim free
> blocks? You'd get rid of undoing the block reservation and obtain quota
> and blocks in the usual order...

The code is protecting i_reserved_meta_blocks. We are recalculating the
the value and need to make sure we don't get the value wrong. I guess
we need to hold i_block_reservation_lock while we recalculate the
meta data block.

-aneesh
