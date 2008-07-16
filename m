From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [PATCH 15/15][e2fsprogs] 64-bit mke2fs cleanup
Date: Wed, 16 Jul 2008 09:09:31 -0500
Message-ID: <20080716090931.6c8ca875@ichigo>
References: <20080715164332.28567.27913.stgit@ichigo>
	<20080715165129.28567.7837.stgit@ichigo>
	<87tzeq0z95.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:60750 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754840AbYGPOKF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Jul 2008 10:10:05 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6GEA2iH003513
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jul 2008 10:10:02 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6GE9XUQ163560
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jul 2008 10:09:33 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6GE9WBZ028349
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jul 2008 10:09:33 -0400
In-Reply-To: <87tzeq0z95.fsf@frosties.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 16 Jul 2008 14:50:14 +0200
Goswin von Brederlow <goswin-v-b@web.de> wrote:

> "Jose R. Santos" <jrs@us.ibm.com> writes:
> 
> > diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> > index 7171990..817be56 100644
> > --- a/misc/mke2fs.c
> > +++ b/misc/mke2fs.c
> > @@ -1402,12 +1402,12 @@ static void PRS(int argc, char *argv[])
> >  
> >  	fs_param.s_log_frag_size = fs_param.s_log_block_size;
> >  
> > -	if (noaction && fs_param.s_blocks_count) {
> > -		dev_size = fs_param.s_blocks_count;
> > +	if (noaction && ext2fs_blocks_count(&fs_param)) {
> > +		dev_size = ext2fs_blocks_count(&fs_param);
> >  		retval = 0;
> >  	} else {
> >  	retry:
> > -		retval = ext2fs_get_device_size(device_name,
> > +		retval = ext2fs_get_device_size2(device_name,
> >  						EXT2_BLOCK_SIZE(&fs_param),
> >  						&dev_size);
> >  		if ((retval == EFBIG) &&
> 
> You should not assume that ext2fs_get_device_size2() will return EFBIG
> if the size exceed 2^32 blocks. The point of ext2fs_get_device_size2()
> was to be able to support more than 2^32 blocks and the library
> function will certainly change to return larger numbers in the future.
> 
> So you need something like
> 
> if ((retval == EFBIG || dev_size >= (1ULL << 32)) &&

No, ext2fs_get_device_size2() should return EFBIG size if the device is
larger than 48-bit.  I need to fix that on ext2fs_get_device_size2() but 
this check here is ok.

> MfG
>         Goswin

-JRS
