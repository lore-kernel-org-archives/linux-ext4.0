From: Andreas Dilger <adilger@sun.com>
Subject: Re: Patches for the patchqueue
Date: Thu, 05 Jun 2008 12:51:48 -0600
Message-ID: <20080605185148.GY2961@webber.adilger.int>
References: <20080605095032.GE8942@skywalker> <20080605095158.GF8942@skywalker>
 <20080605095350.GG8942@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Mingming Cao <cmm@us.ibm.com>, Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:45341 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762092AbYFESvv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Jun 2008 14:51:51 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m55IpoWm010876
	for <linux-ext4@vger.kernel.org>; Thu, 5 Jun 2008 11:51:50 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K20009017290800@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 05 Jun 2008 11:51:50 -0700 (PDT)
In-reply-to: <20080605095350.GG8942@skywalker>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 05, 2008  15:23 +0530, Aneesh Kumar K.V wrote:
> vfs: Don't flush delay buffer to disk
> 
> In block_write_full_page() error case, we need to check the
> delayed flag before flush bh to disk when trying to recover from
> error.

> @@ -1775,7 +1775,8 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
>  	bh = head;
>  	/* Recovery: lock and submit the mapped buffers */
>  	do {
> -		if (buffer_mapped(bh) && buffer_dirty(bh)) {
> +		if (buffer_mapped(bh) && buffer_dirty(bh)
> +			&& !buffer_delay(bh)) {

Please use proper CodingStyle here.  Firstly, this can fit on the previous
line < 80 columns so it shouldn't be split.  Secondly, if the line had to
be split, the "&&" should go at the end of the previous line.  Thirdly,
the continued line should align with the 'if (' on the previous line.


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

