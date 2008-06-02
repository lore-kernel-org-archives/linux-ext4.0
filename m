From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: Need clear buffer_delay after page writeout for
	delayed allocation
Date: Sun, 01 Jun 2008 20:50:32 -0700
Message-ID: <1212378632.4368.79.camel@localhost.localdomain>
References: <1212154769-16486-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1212354602.4368.12.camel@localhost.localdomain>
	 <20080602031433.GA17678@skywalker>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: jack@suse.cz, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:33316 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753773AbYFBDu4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 1 Jun 2008 23:50:56 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m523omlT006299
	for <linux-ext4@vger.kernel.org>; Sun, 1 Jun 2008 23:50:48 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m523ocjq146574
	for <linux-ext4@vger.kernel.org>; Sun, 1 Jun 2008 23:50:39 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m523ocfF024539
	for <linux-ext4@vger.kernel.org>; Sun, 1 Jun 2008 23:50:38 -0400
In-Reply-To: <20080602031433.GA17678@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2008-06-02 at 08:44 +0530, Aneesh Kumar K.V wrote:
> On Sun, Jun 01, 2008 at 02:10:02PM -0700, Mingming Cao wrote:
> > ext4:  Need clear buffer_delay after page writeout for delayed allocation
> > 
> > From: Mingming Cao <cmm@us.ibm.com>
> > 
> > Need clear buffer_delay in ext4_da_writepage() after page has been writeout
> > 
> > Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> > 
> > ---
> 
> We do that in mpage_put_bnr_to_bhs.
> 
Normally delayed buffer could be cleared in that case, but if allocation
failed in __mapge_da_writepages(), it will keep buffer_delay marked and
deferring to later ext4_da_writepage() to do block allocation. This
patch handles clear bh delay bit in this case.

Mingming

