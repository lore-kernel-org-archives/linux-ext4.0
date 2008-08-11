From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Bug in delayed allocation: really bad block layouts!
Date: Mon, 11 Aug 2008 23:45:24 +0530
Message-ID: <20080811181524.GA9769@skywalker>
References: <E1KSEkA-00009o-CV@closure.thunk.org> <20080811143911.GA6455@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:33678 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbYHKSPd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Aug 2008 14:15:33 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id m7BIEQLC028991
	for <linux-ext4@vger.kernel.org>; Tue, 12 Aug 2008 04:14:26 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7BIFUSs244890
	for <linux-ext4@vger.kernel.org>; Tue, 12 Aug 2008 04:15:30 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7BIFUMA031514
	for <linux-ext4@vger.kernel.org>; Tue, 12 Aug 2008 04:15:30 +1000
Content-Disposition: inline
In-Reply-To: <20080811143911.GA6455@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 11, 2008 at 08:09:12PM +0530, Aneesh Kumar K.V wrote:
> Can you try this patch ? The patch make group preallocation use the goal
> block.
> 

Results with and without patch.

http://www.radian.org/~kvaneesh/ext4/lg-fragmentation/

-aneesh
