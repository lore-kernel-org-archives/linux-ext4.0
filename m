From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Please summarize state of ext4 resize >16TB
Date: Wed, 8 Jan 2014 11:30:18 -0800
Message-ID: <20140108193018.GF9229@birch.djwong.org>
References: <BBC8F4C34A7B5A4DB487459885025E7F018A0BAE0391@EXCLUSTER.iomegacorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Ryan, Michael" <Michael.Ryan2@lenovoemc.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20038 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbaAHTa1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Jan 2014 14:30:27 -0500
Content-Disposition: inline
In-Reply-To: <BBC8F4C34A7B5A4DB487459885025E7F018A0BAE0391@EXCLUSTER.iomegacorp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 08, 2014 at 12:14:17PM -0700, Ryan, Michael wrote:
> I've been searching for info on the ability to resize ext4 from <16TB to
> >16TB.  This was not supported in the past and I've received conflicting
> >information as to if/when this is/will be supported.  I've also seen
> >indications that on disk data structures must be changed for this resize to
> >work.
> 
> Is this capability currently supported?  
> If so, what kernel level (and resize2fs level) is necessary?  Are there
> restrictions as to options at mkfs time?  If not, is this planned for a
> future release?  Or is this just not possible or practical due to on disk
> structures and is likely to never be supported?

In most cases it's necessary to turn on 64bit (the feature flag) to cross the
16T boundary.  I've had patches against resize2fs to add this ability--it
involves moving data blocks and rewriting group descriptors--on the list for a
few months, but I don't know of Ted's plans to put them in a release.  Probably
post-1.43, is my guess.

I don't have any kernel patches to turn on 64bit, and I haven't any current
plans to make any.

--D
> 
> Thank you.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
