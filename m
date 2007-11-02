From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH][RFC]JBD2: Fix journal checksum kernel oops on NUMA
Date: Fri, 2 Nov 2007 13:20:31 +0800
Message-ID: <20071102052031.GC18505@webber.adilger.int>
References: <46D7097F.4020501@linux.vnet.ibm.com> <1188552066.3781.15.camel@dhcp5.linsyssoft.com> <1193964035.4014.23.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Girish Shilamkar <girish@clusterfs.com>,
	Avantika Mathur <mathur@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:51622 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbXKBFVr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Nov 2007 01:21:47 -0400
Content-Disposition: inline
In-Reply-To: <1193964035.4014.23.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Nov 01, 2007  17:40 -0700, Mingming Cao wrote:
> Current journal checksumming patch failed fsstress test on NUMA. The 
> bh->b_data passed to the crc32_be () function could be NULL pointer, 
> which caused kernel oops immediately when running fsstress with -o 
> journal_checksum. It is because the page is part of highmem on NUMA box.
> We need to kmap the page before access the bh->b_data to calculate
> the checksums.

I have no objection to the patch, per-se, but I'm surprised that there
would ever be a buffer head pointing at a page in high memory?  That
seems contrary to what I would expect...

Cheers, Andreas
--
Andreas Dilger
Sr. Software Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
