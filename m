From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] set s_raid_stride and s_raid_stripe_width
Date: Wed, 9 Jan 2008 21:33:27 +0530
Message-ID: <20080109160327.GA8259@skywalker>
References: <20080109083131.GK3351@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:46959 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751986AbYAIQDq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Jan 2008 11:03:46 -0500
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp03.in.ibm.com (8.13.1/8.13.1) with ESMTP id m09G3TYo006100
	for <linux-ext4@vger.kernel.org>; Wed, 9 Jan 2008 21:33:29 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m09G3TCs766066
	for <linux-ext4@vger.kernel.org>; Wed, 9 Jan 2008 21:33:29 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m09G3VHv001021
	for <linux-ext4@vger.kernel.org>; Wed, 9 Jan 2008 16:03:31 GMT
Content-Disposition: inline
In-Reply-To: <20080109083131.GK3351@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


[..snip...]

> +	if (param->s_raid_stride &&
> +	    (param->s_raid_stripe_width % param->s_raid_stride) != 0)
> +		fprintf(stderr, _("\nWarning: RAID stripe-width %u not an even "
> +				  "multiple of stride %u.\n\n"),
> +			param->s_raid_stripe_width, param->s_raid_stride);


We also want to validate that s_raid_stripe_width is not >=
blocks_per_group.


-aneesh
