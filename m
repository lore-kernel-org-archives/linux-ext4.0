From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: BUG: scheduling while atomic: kswapd0/273/0x00000002
Date: Mon, 1 Dec 2008 21:27:55 +0530
Message-ID: <20081201155755.GA30217@skywalker>
References: <20081201152656.GB25876@skywalker> <20081201155341.GB2506@balbir.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:41992 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbYLAP6D (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Dec 2008 10:58:03 -0500
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp03.in.ibm.com (8.13.1/8.13.1) with ESMTP id mB1Fw1gR012687
	for <linux-ext4@vger.kernel.org>; Mon, 1 Dec 2008 21:28:01 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mB1FvFlV4304968
	for <linux-ext4@vger.kernel.org>; Mon, 1 Dec 2008 21:27:16 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id mB1Fw0Ra024331
	for <linux-ext4@vger.kernel.org>; Tue, 2 Dec 2008 02:58:00 +1100
Content-Disposition: inline
In-Reply-To: <20081201155341.GB2506@balbir.in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 01, 2008 at 09:23:41PM +0530, Balbir Singh wrote:
> * Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com> [2008-12-01 20:56:56]:
> 
> > Hi,
> > 
> > With the latest patch queue i am getting the below error
> >
> 
> Did you enable jbd_debug enabled by any chance? 
> 

No. The problem is we cannot call jbd2_log_wait_commit
from blkdev_releasepage because jbd2_log_wait_commit
does a wait_event 

549                 spin_unlock(&journal->j_state_lock);
550                 wait_event(journal->j_wait_done_commit,
551                                 !tid_gt(tid, journal->j_commit_sequence));
552                 spin_lock(&journal->j_state_lock);

-aneesh
