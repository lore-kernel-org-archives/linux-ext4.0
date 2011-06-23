From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: filesystems bigger than 16 TB?
Date: Thu, 23 Jun 2011 14:56:24 -0600
Message-ID: <5B254D74-114B-4126-91BE-1DECBC029AD8@dilger.ca>
References: <4E03251F.4040603@wpkg.org>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:65380 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932755Ab1FWU4b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Jun 2011 16:56:31 -0400
In-Reply-To: <4E03251F.4040603@wpkg.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-06-23, at 5:35 AM, Tomasz Chmielewski wrote:
> With mkfs.ext4 from 1.41.14, it is not possible to create a filesystem which is bigger than 16 TB:
> 
> mkfs.ext4: Size of device /dev/sdb too big to be expressed in 32 bits
> 	using a blocksize of 4096.
> 
> But I see it succeeds with the latest git version of e2fsprogs.
> 
> 
> 
> The question is: how reliable such a filesystem is?
> 
> On a system which is supposed to be reliable, perhaps I'll be better off with xfs for such large filesystems?
> 
> I'm using Debian Squeeze, which has a 2.6.32 kernel.

We are starting to use filesystems over 16TB, so far without problems.
Kernel is either RHEL5.4 (2.6.18), or RHEL6.1 (2.6.32), with e2fsprogs
from git (based on 7d9e31655fca48e9d6c2647ad443124113508b73).

We've tested up to 24TB quite a bit, and recently started testing a 128TB
filesystem and haven't run into any problems.  Beyond 128TB there are
some memory allocation issues that prevent the filesystem from mounting,
but aren't critical to be fixed quite yet...

Cheers, Andreas





