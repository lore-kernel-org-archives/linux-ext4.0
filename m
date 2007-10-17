From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] i_dir_acl related cleanup
Date: Wed, 17 Oct 2007 15:34:33 -0600
Message-ID: <20071017213433.GG8122@schatzie.adilger.int>
References: <47146AAD.3010801@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:57125 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626AbXJQVfI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Oct 2007 17:35:08 -0400
Content-Disposition: inline
In-Reply-To: <47146AAD.3010801@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 16, 2007  13:09 +0530, Aneesh Kumar K.V wrote:
> I am wondering whether we can use i_size_high without looking at
> file mode (why restrict only to regular files  ? )

Well, traditionally this was restricted to S_IFREG files, but to be honest
I've thought recently that directories should also be able to pass 2GB in
size (which we've hit in our testing, at "only" 25M files/dir or so, depending
on the length of the filenames).  So, my opinion is that we should start
allowing this, and fix up e2fsprogs in the same way.

There are other things that need to be fixed in order to allow larger
directories (number of levels in htree is currently limited to 2 by the
code, even though the format is more flexible, and the logical htree block
number is currently limited to 2^24 blocks = 64GB for 4kB blocksize).
The extra 8 bits of the logical block number were reserved for "leaf fullness"
data so that it was also possible to merge nearly empty adjacent directory
leaf blocks efficiently, but that was never implemented.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
