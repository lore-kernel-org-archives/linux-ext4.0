From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2 for 2.6.31] ext4: Use -1 as the fake block number
	for delayed new buffer_head
Date: Sat, 2 May 2009 00:35:46 +0530
Message-ID: <20090501190546.GA920@skywalker>
References: <1241003611-3652-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20090501185841.GG7681@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:56510 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105AbZEATF4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 May 2009 15:05:56 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id n41J5oBR002759
	for <linux-ext4@vger.kernel.org>; Sat, 2 May 2009 05:05:50 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n41J5sr0389212
	for <linux-ext4@vger.kernel.org>; Sat, 2 May 2009 05:05:55 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n41J5rAE008066
	for <linux-ext4@vger.kernel.org>; Sat, 2 May 2009 05:05:54 +1000
Content-Disposition: inline
In-Reply-To: <20090501185841.GG7681@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 01, 2009 at 02:58:41PM -0400, Theodore Tso wrote:
> You mean "for 2.6.30", right?
> 

The reason for me to post two series one for 2.6.30 and other for 2.6.31
was the [Patch 2/2] for 2.6.31 needs more testing. I added this specific
patch in both the series to make sure  we don't miss the change in case
we decided not to make any changes for 2.6.30. Also in my testing I created
different topgit branches with different dependencies. So having [PATCH
1/2 ] in both the series helped in testing with topgit branches.

-aneesh
