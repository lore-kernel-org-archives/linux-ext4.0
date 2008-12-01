From: Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: BUG: scheduling while atomic: kswapd0/273/0x00000002
Date: Mon, 1 Dec 2008 21:23:41 +0530
Message-ID: <20081201155341.GB2506@balbir.in.ibm.com>
References: <20081201152656.GB25876@skywalker>
Reply-To: balbir@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:41095 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbYLAPxp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Dec 2008 10:53:45 -0500
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp03.in.ibm.com (8.13.1/8.13.1) with ESMTP id mB1FrgHk007442
	for <linux-ext4@vger.kernel.org>; Mon, 1 Dec 2008 21:23:42 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mB1FrhXA3248142
	for <linux-ext4@vger.kernel.org>; Mon, 1 Dec 2008 21:23:43 +0530
Received: from d28av02.in.ibm.com (loopback [127.0.0.1])
	by d28av02.in.ibm.com (8.13.1/8.13.3) with ESMTP id mB1FrgEJ006549
	for <linux-ext4@vger.kernel.org>; Tue, 2 Dec 2008 02:53:42 +1100
Content-Disposition: inline
In-Reply-To: <20081201152656.GB25876@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com> [2008-12-01 20:56:56]:

> Hi,
> 
> With the latest patch queue i am getting the below error
>

Did you enable jbd_debug enabled by any chance? 

-- 
	Balbir
