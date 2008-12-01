From: Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: BUG: scheduling while atomic: kswapd0/273/0x00000002
Date: Mon, 1 Dec 2008 23:07:37 +0530
Message-ID: <20081201173737.GC2506@balbir.in.ibm.com>
References: <20081201152656.GB25876@skywalker> <20081201155341.GB2506@balbir.in.ibm.com> <20081201155755.GA30217@skywalker>
Reply-To: balbir@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:42497 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbYLARpU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Dec 2008 12:45:20 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp05.au.ibm.com (8.13.8/8.13.8) with ESMTP id mB1Hifmp3367058
	for <linux-ext4@vger.kernel.org>; Tue, 2 Dec 2008 04:44:42 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mB1HbeUC281414
	for <linux-ext4@vger.kernel.org>; Tue, 2 Dec 2008 04:37:40 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mB1Hbe2f019896
	for <linux-ext4@vger.kernel.org>; Tue, 2 Dec 2008 04:37:40 +1100
Content-Disposition: inline
In-Reply-To: <20081201155755.GA30217@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com> [2008-12-01 21:27:55]:

> On Mon, Dec 01, 2008 at 09:23:41PM +0530, Balbir Singh wrote:
> > * Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com> [2008-12-01 20:56:56]:
> > 
> > > Hi,
> > > 
> > > With the latest patch queue i am getting the below error
> > >
> > 
> > Did you enable jbd_debug enabled by any chance? 
> > 
> 
> No. The problem is we cannot call jbd2_log_wait_commit
> from blkdev_releasepage because jbd2_log_wait_commit
> does a wait_event 
> 
> 549                 spin_unlock(&journal->j_state_lock);
> 550                 wait_event(journal->j_wait_done_commit,
> 551                                 !tid_gt(tid, journal->j_commit_sequence));
> 552                 spin_lock(&journal->j_state_lock);
>

Yes, I should have seen the stack. The same problem seems to exist for
ext3 as well (with log_wait_commit). kswapd() passes GFP_KERNEL as
gfp_mask in scan_control and that confuses the journalling layer,
since we hold the lock on page in shrink_page_list().

-- 
	Balbir
