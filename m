From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] ext4: Fix the soft lockup with multi block allocator.
Date: Fri, 21 Dec 2007 12:10:20 -0700
Message-ID: <20071221191020.GM3214@webber.adilger.int>
References: <1198235390-18485-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, bzzz@sun.com, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:40807 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbXLUTKW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Dec 2007 14:10:22 -0500
Content-Disposition: inline
In-Reply-To: <1198235390-18485-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Dec 21, 2007  16:39 +0530, Aneesh Kumar K.V wrote:
> @@ -3790,7 +3782,9 @@ repeat:
>  
>  	/* if we still need more blocks and some PAs were used, try again */
>  	if (free < needed && busy) {
> +		busy = 0;
>  		ext4_unlock_group(sb, group);
> +		schedule_timeout(HZ);
>  		goto repeat;
>  	}

Is there nothing we could actually wait on instead of just sleeping for
1 second?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
