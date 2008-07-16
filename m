From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [PATCH 15/15][e2fsprogs] 64-bit mke2fs cleanup
Date: Wed, 16 Jul 2008 10:30:56 -0500
Message-ID: <20080716103056.2a635075@ichigo>
References: <20080715164332.28567.27913.stgit@ichigo>
	<20080715165129.28567.7837.stgit@ichigo>
	<87tzeq0z95.fsf@frosties.localdomain>
	<20080716090931.6c8ca875@ichigo>
	<87bq0x97mx.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Goswin von Brederlow <goswin-v-b@web.de>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:59445 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756756AbYGPPbY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Jul 2008 11:31:24 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6GFVMZP025507
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jul 2008 11:31:22 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6GFV8ZR067984
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jul 2008 09:31:08 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6GFV24e020445
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jul 2008 09:31:04 -0600
In-Reply-To: <87bq0x97mx.fsf@frosties.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 16 Jul 2008 17:21:58 +0200
Goswin von Brederlow <goswin-v-b@web.de> wrote:

> "Jose R. Santos" <jrs@us.ibm.com> writes:
> 
> > On Wed, 16 Jul 2008 14:50:14 +0200
> > Goswin von Brederlow <goswin-v-b@web.de> wrote:
> >
> >> "Jose R. Santos" <jrs@us.ibm.com> writes:
> >> 
> >> > diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> >> > index 7171990..817be56 100644
> >> > --- a/misc/mke2fs.c
> >> > +++ b/misc/mke2fs.c
> >> > @@ -1402,12 +1402,12 @@ static void PRS(int argc, char *argv[])
> >> >  
> >> >  	fs_param.s_log_frag_size = fs_param.s_log_block_size;
> >> >  
> >> > -	if (noaction && fs_param.s_blocks_count) {
> >> > -		dev_size = fs_param.s_blocks_count;
> >> > +	if (noaction && ext2fs_blocks_count(&fs_param)) {
> >> > +		dev_size = ext2fs_blocks_count(&fs_param);
> >> >  		retval = 0;
> >> >  	} else {
> >> >  	retry:
> >> > -		retval = ext2fs_get_device_size(device_name,
> >> > +		retval = ext2fs_get_device_size2(device_name,
> >> >  						EXT2_BLOCK_SIZE(&fs_param),
> >> >  						&dev_size);
> >> >  		if ((retval == EFBIG) &&
> >> 
> >> You should not assume that ext2fs_get_device_size2() will return EFBIG
> >> if the size exceed 2^32 blocks. The point of ext2fs_get_device_size2()
> >> was to be able to support more than 2^32 blocks and the library
> >> function will certainly change to return larger numbers in the future.
> >> 
> >> So you need something like
> >> 
> >> if ((retval == EFBIG || dev_size >= (1ULL << 32)) &&
> >
> > No, ext2fs_get_device_size2() should return EFBIG size if the device is
> > larger than 48-bit.  I need to fix that on ext2fs_get_device_size2() but 
> > this check here is ok.
> >
> >> MfG
> >>         Goswin
> >
> > -JRS
> 
> Why? The decision what device size if too big depends on the features
> for this filesystem. By default 32bit is the limit, with
> EXT4_FEATURE_INCOMPAT_64BIT it is 48bit. (shouldn't that be named
> EXT4_FEATURE_INCOMPAT_48BIT?). Maybe later there will be a true 64bit
> feature.

You have a point.  The ext2fs_get_device_size2() should really be
concerned with what file system features are supported.  That is
outside of the scope of this routine.

I retract the previous statement I just reply to Ted. :)

> 
> If you make ext2fs_get_device_size2() return EFBIG for >48bit then you
> have to check for EFBIG and conditionally for 2^32 which makes the
> code more complex. Better to just check the actual size the device has
> in mke2fs.c.
> 
> Also the user might give a size that is actually small enough while
> the device would be too big. Say, with current mke2fs, you have a disk
> that is 16.000001TiB large. You could tell mke2fs to only use 2^32-1
> blocks. The EFBIG check prevents that.
> 
> See the patch I just send.
> 
> MfG
>         Goswin

-JRS
