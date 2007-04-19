From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: Missing JBD2_FEATURE_INCOMPAT_64BIT in ext4
Date: Thu, 19 Apr 2007 12:15:00 -0700
Message-ID: <1177010100.6703.8.camel@dyn9047017103.beaverton.ibm.com>
References: <20070415161606.GG5967@schatzie.adilger.int>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:49370 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766939AbXDSTPE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Apr 2007 15:15:04 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.12.11.20060308/8.13.8) with ESMTP id l3JJCKJh000924
	for <linux-ext4@vger.kernel.org>; Thu, 19 Apr 2007 15:12:20 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l3JJF22m077550
	for <linux-ext4@vger.kernel.org>; Thu, 19 Apr 2007 13:15:02 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l3JJF27n011392
	for <linux-ext4@vger.kernel.org>; Thu, 19 Apr 2007 13:15:02 -0600
In-Reply-To: <20070415161606.GG5967@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, 2007-04-15 at 10:16 -0600, Andreas Dilger wrote:
> Just a quick note before I forget.  I thought there was a call in ext4
> to set JBD2_FEATURE_INCOMPAT_64BIT at mount time if the filesystem has
> more than 2^32 blocks?

Question about the online resize case. If the fs is increased to more
than 2^32 blocks, we should set this JBD2_FEATURE_INCOMPAT_64BIT in the
journal. What about existing transactions that still stores 32 bit block
numbers?  I guess the journal need to commit them all so that revoke
will not get confused about the bits for block numbers later.  After
that done then JBD2 can set this feature safely.


> Cheers, Andreas
> --
> Andreas Dilger
> Principal Software Engineer
> Cluster File Systems, Inc.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
