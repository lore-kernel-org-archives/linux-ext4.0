From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Need clear buffer_delay after page writeout for
	delayed allocation
Date: Mon, 2 Jun 2008 09:39:34 +0530
Message-ID: <20080602040934.GB17678@skywalker>
References: <1212154769-16486-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212354602.4368.12.camel@localhost.localdomain> <20080602031433.GA17678@skywalker> <1212378632.4368.79.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:44746 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbYFBEKM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jun 2008 00:10:12 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id m5249Dhp030950
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 14:09:13 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m5249lk14198552
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 14:09:48 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m524A4NX024829
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 14:10:04 +1000
Content-Disposition: inline
In-Reply-To: <1212378632.4368.79.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jun 01, 2008 at 08:50:32PM -0700, Mingming Cao wrote:
> On Mon, 2008-06-02 at 08:44 +0530, Aneesh Kumar K.V wrote:
> > On Sun, Jun 01, 2008 at 02:10:02PM -0700, Mingming Cao wrote:
> > > ext4:  Need clear buffer_delay after page writeout for delayed allocation
> > > 
> > > From: Mingming Cao <cmm@us.ibm.com>
> > > 
> > > Need clear buffer_delay in ext4_da_writepage() after page has been writeout
> > > 
> > > Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> > > 
> > > ---
> > 
> > We do that in mpage_put_bnr_to_bhs.
> > 
> Normally delayed buffer could be cleared in that case, but if allocation
> failed in __mapge_da_writepages(), it will keep buffer_delay marked and
> deferring to later ext4_da_writepage() to do block allocation. This
> patch handles clear bh delay bit in this case.
> 

Why not do it in ext4_da_get_block_write then. The reason being
block_write_full_page can return an error even though we have some of
the blocks allocated. With 1K block size we could allocate 3 blocks and 
fail for the last block in that case with the above patch we don't
clear the delay bit of the buffer head of all the blocks allocated.

-aneesh
