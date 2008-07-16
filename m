From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [PATCH 15/15][e2fsprogs] 64-bit mke2fs cleanup
Date: Wed, 16 Jul 2008 14:40:43 -0500
Message-ID: <20080716144043.2859b9b6@ichigo>
References: <20080715164332.28567.27913.stgit@ichigo>
	<20080715165129.28567.7837.stgit@ichigo>
	<87tzeq0z95.fsf@frosties.localdomain>
	<20080716090931.6c8ca875@ichigo>
	<20080716145429.GA2167@mit.edu>
	<20080716101817.4d40a2f9@ichigo>
	<20080716163148.GC2167@mit.edu>
	<20080716122610.20224ee9@ichigo>
	<87tzepk5qb.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	linux-ext4@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:43441 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754032AbYGPTkr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Jul 2008 15:40:47 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6GJek4A002769
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jul 2008 15:40:46 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6GJek2m232240
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jul 2008 15:40:46 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6GJejj6022515
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jul 2008 15:40:46 -0400
In-Reply-To: <87tzepk5qb.fsf@frosties.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 16 Jul 2008 21:07:40 +0200
Goswin von Brederlow <goswin-v-b@web.de> wrote:

> "Jose R. Santos" <jrs@us.ibm.com> writes:
> 
> > On Wed, 16 Jul 2008 12:31:48 -0400
> > Theodore Tso <tytso@mit.edu> wrote:
> >
> >> On Wed, Jul 16, 2008 at 10:18:17AM -0500, Jose R. Santos wrote:
> >> > > It's really important when doing library design to think about future
> >> > > expandability.
> >> > 
> >> > This would not be a API or ABI change so I don't see why another
> >> > renaming function would be needed.  It also doesn't change the
> >> > behavior of ext2fs_get_device_size2() since it returns EFBIG when a
> >> > device is larger than what e2fsprogs currently supports, whether that
> >> > 48bit or 64bits.  Putting the limit ext2fs_get_device_size2() avoid
> >> > folks from abusing something that probably isn't supported. 
> >> 
> >> E2fsprogs utilities are somewhat entitled to assume that they will be
> >> running with a version of libext2fs which is the same as the one that
> >> they shipped with --- although sometimes that assumption can be false,
> >> particularly when people are building a newer version of e2fsprogs
> >> from source and forget to install the newer libraries or forget to set
> >> LD_LIBRARY_PATH if they are building with dynamic libraries.
> >
> > I was mostly referring to external users of the library.
> >  
> >> However there may be other users of that interface, and they won't
> >> know if version of that library they are calling is set to return
> >> EFBIG on a 48bit or 64bit number.  Besides, there may be other
> >> application users of that function where it would be useful to get the
> >> size of a device which is larger than 48-bits, even if mke2fs and ext4
> >> today doesn't support it.  This is just good library design not to
> >> enforce limits like this in a fairly generic function.
> >
> > I agree and have already retracted my previous statement base on this.
> >
> >> 
> >> Finally, in many programming discplines you *do* rename the function
> >> whenever you make major semantic changes to the function, not just for
> >> API or ABI changes.  Otherwise a newer program might depend on
> >> ext2fs_get_device_size() returning a 64-bit size, and then it might
> >> get very confused or fail in unexpected ways if it is linked with an
> >> older library that returns EFBIG if the number is bigger than 48 bits.
> >
> > While I agree that we should not put this limitation on
> > ext2fs_get_device_size2(), why does EFBIG (or something equivalent when
> > we implement this outside of get_size) have to means anything other
> > that the size is bigger than what the current library support.  It
> > could be 48bit, 64bit or 1024bit, if we hit it, the current library
> > will not support it.
> >
> > I dont see the point in having (for example) EFBIG_48 and EFBIG_64 if
> > we implement EFBIG right.
> 
> Here EFBIG means the size is bigger than what is representable in the
> current datatype. Both 48bit and 64bit block counter are representable
> in blk64_t. A 128bit size on the other hand would be not. As long as
> the size can be represented correctly in the return type the caller
> can check itself if it exceeds their own limits.
> 
> As such the ext2fs_get_device_size() function (and all other wrappers
> returning a blk_t) really should do something like this:
> 
> blk64_t size64;
> retval = ext2fs_get_device_size2(device_name, blocksize, &size64);
> if (!retval && size64 >= 2^32) return EFBIG;
> *size = size64;
> return retval;

You've exposed another bug.  I obviously was not paying to much
attention when doing mke2fs changes.  I will fix in the next release.

> 
> MfG
>         Goswin
> 
> PS: as blk64_t can represent any size we can possibly get (ioctl, stat
> and llseek methods only give 64bit) I see no reason to have an EFBIG
> for now.

Agree.

-JRS
