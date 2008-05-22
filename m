From: Mingming <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: Fix delalloc sync hang with journal lock
	inversion
Date: Thu, 22 May 2008 11:10:17 -0700
Message-ID: <1211479817.8596.42.camel@BVR-FS.beaverton.ibm.com>
References: <1211391859-17399-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1211391859-17399-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1211391859-17399-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1211391859-17399-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:46963 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758519AbYEVSKj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 May 2008 14:10:39 -0400
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e32.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m4MI6sWx009764
	for <linux-ext4@vger.kernel.org>; Thu, 22 May 2008 14:06:54 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4MIAKTS141382
	for <linux-ext4@vger.kernel.org>; Thu, 22 May 2008 12:10:20 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4MIAGrI013997
	for <linux-ext4@vger.kernel.org>; Thu, 22 May 2008 12:10:17 -0600
In-Reply-To: <1211391859-17399-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Wed, 2008-05-21 at 23:14 +0530, Aneesh Kumar K.V wrote:
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/inode.c |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 46cc610..076d00f 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1571,13 +1571,17 @@ static int ext4_da_writepages(struct address_space *mapping,
>  		 */
>  		if (wbc->nr_to_write > EXT4_MAX_WRITEBACK_PAGES)
>  			wbc->nr_to_write = EXT4_MAX_WRITEBACK_PAGES;
> -		to_write -= wbc->nr_to_write;
> 
> +		to_write -= wbc->nr_to_write;
>  		ret = mpage_da_writepages(mapping, wbc, ext4_da_get_block_write);
>  		ext4_journal_stop(handle);
> -		to_write +=wbc->nr_to_write;
> +		if (wbc->nr_to_write) {
> +			/* We failed to write what we requested for */
> +			to_write += wbc->nr_to_write;
> +			break;
> +		}

Not sure about the break here...
> +		wbc->nr_to_write = to_write;

Looks right. thanks.

>  	}
> -
>  out_writepages:
>  	wbc->nr_to_write = to_write;
>  	wbc->range_cyclic = range_cyclic;

