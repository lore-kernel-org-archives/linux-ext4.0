From: Dave Chinner <david@fromorbit.com>
Subject: Re: filesystems bigger than 16 TB?
Date: Mon, 27 Jun 2011 10:40:23 +1000
Message-ID: <20110627004023.GE32466@dastard>
References: <4E03251F.4040603@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:16523 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756069Ab1F0Ak3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 26 Jun 2011 20:40:29 -0400
Content-Disposition: inline
In-Reply-To: <4E03251F.4040603@wpkg.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 23, 2011 at 01:35:59PM +0200, Tomasz Chmielewski wrote:
> With mkfs.ext4 from 1.41.14, it is not possible to create a
> filesystem which is bigger than 16 TB:
> 
> 
> mkfs.ext4: Size of device /dev/sdb too big to be expressed in 32 bits
> 	using a blocksize of 4096.
> 
> 
> But I see it succeeds with the latest git version of e2fsprogs.
> 
> 
> 
> The question is: how reliable such a filesystem is?

Regardless of the filesystem or the feature, if it is not in
officially released packages, do you really want to risk your
production data on an experimental filesystem/feature?

> On a system which is supposed to be reliable, perhaps I'll be better
> off with xfs for such large filesystems?
> 
> I'm using Debian Squeeze, which has a 2.6.32 kernel.

On a 2.6.32 kernel, I'd strongly recommend using XFS for >16TB
filesystems....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
