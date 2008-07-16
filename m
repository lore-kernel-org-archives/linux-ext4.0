From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [PATCH 15/15][e2fsprogs] 64-bit mke2fs cleanup
Date: Wed, 16 Jul 2008 10:18:17 -0500
Message-ID: <20080716101817.4d40a2f9@ichigo>
References: <20080715164332.28567.27913.stgit@ichigo>
	<20080715165129.28567.7837.stgit@ichigo>
	<87tzeq0z95.fsf@frosties.localdomain>
	<20080716090931.6c8ca875@ichigo>
	<20080716145429.GA2167@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Goswin von Brederlow <goswin-v-b@web.de>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:43569 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757000AbYGPPSW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Jul 2008 11:18:22 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6GFIJmw019492
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jul 2008 11:18:19 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6GFIJvG180384
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jul 2008 11:18:19 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6GFIJ4g028352
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jul 2008 11:18:19 -0400
In-Reply-To: <20080716145429.GA2167@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 16 Jul 2008 10:54:29 -0400
Theodore Tso <tytso@mit.edu> wrote:

> On Wed, Jul 16, 2008 at 09:09:31AM -0500, Jose R. Santos wrote:
> > No, ext2fs_get_device_size2() should return EFBIG size if the device is
> > larger than 48-bit.  I need to fix that on ext2fs_get_device_size2() but 
> > this check here is ok.
> 
> No, please don't do that.  Make it reuturn EFBIG if the device won't
> fit in a blk64_t type (i.e., larger than 64-bits).  In mke2fs, there
> should be a separate check to make sure the size is no larger than
> 48-bits.  Otherwise, at some future point, perhaps we might enhance
> ext4 to support full a 64-bit physical block number, and then we would
> have to make behavioural changes to ext2fs_get_device_size2() that
> would necessitate renaming the function yet again.
> 
> It's really important when doing library design to think about future
> expandability.

This would not be a API or ABI change so I don't see why another
renaming function would be needed.  It also doesn't change the
behavior of ext2fs_get_device_size2() since it returns EFBIG when a
device is larger than what e2fsprogs currently supports, whether that
48bit or 64bits.  Putting the limit ext2fs_get_device_size2() avoid
folks from abusing something that probably isn't supported. 

> 						- Ted

-JRS
