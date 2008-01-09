From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] set s_raid_stride and s_raid_stripe_width
Date: Wed, 9 Jan 2008 15:46:04 -0700
Message-ID: <20080109224604.GZ3351@webber.adilger.int>
References: <20080109083131.GK3351@webber.adilger.int> <20080109160327.GA8259@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:39298 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504AbYAIWqG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Jan 2008 17:46:06 -0500
Content-Disposition: inline
In-Reply-To: <20080109160327.GA8259@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jan 09, 2008  21:33 +0530, Aneesh Kumar K.V wrote:
> > +	if (param->s_raid_stride &&
> > +	    (param->s_raid_stripe_width % param->s_raid_stride) != 0)
> > +		fprintf(stderr, _("\nWarning: RAID stripe-width %u not an even "
> > +				  "multiple of stride %u.\n\n"),
> > +			param->s_raid_stripe_width, param->s_raid_stride);
> 
> 
> We also want to validate that s_raid_stripe_width is not >=
> blocks_per_group.

And probably that s_raid_stripe_width <= s_raid_stride.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
