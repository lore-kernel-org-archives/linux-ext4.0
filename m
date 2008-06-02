From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Need clear buffer_delay after page writeout for
	delayed allocation
Date: Mon, 2 Jun 2008 08:44:33 +0530
Message-ID: <20080602031433.GA17678@skywalker>
References: <1212154769-16486-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212354602.4368.12.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:55086 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbYFBDOt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Jun 2008 23:14:49 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id m523Dslu007917
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 13:13:54 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m523IwFW273752
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 13:18:58 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m523EkNY009878
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 13:14:46 +1000
Content-Disposition: inline
In-Reply-To: <1212354602.4368.12.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jun 01, 2008 at 02:10:02PM -0700, Mingming Cao wrote:
> ext4:  Need clear buffer_delay after page writeout for delayed allocation
> 
> From: Mingming Cao <cmm@us.ibm.com>
> 
> Need clear buffer_delay in ext4_da_writepage() after page has been writeout
> 
> Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> 
> ---

We do that in mpage_put_bnr_to_bhs.


-aneesh
