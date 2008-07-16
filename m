From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [PATCH 15/15][e2fsprogs] 64-bit mke2fs cleanup
Date: Wed, 16 Jul 2008 09:18:46 -0500
Message-ID: <20080716091846.44174452@ichigo>
References: <20080715164332.28567.27913.stgit@ichigo>
	<20080715165129.28567.7837.stgit@ichigo>
	<87tzeq0z95.fsf@frosties.localdomain>
	<87ej5ugcn2.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Goswin von Brederlow <goswin-v-b@web.de>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:47560 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758836AbYGPOTF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Jul 2008 10:19:05 -0400
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6GEJ3ol023922
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jul 2008 10:19:03 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6GEIuWS087726
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jul 2008 08:18:59 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6GEIlCY007105
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jul 2008 08:18:47 -0600
In-Reply-To: <87ej5ugcn2.fsf@frosties.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 16 Jul 2008 15:52:01 +0200
Goswin von Brederlow <goswin-v-b@web.de> wrote:

> Goswin von Brederlow <goswin-v-b@web.de> writes:
> 
> > "Jose R. Santos" <jrs@us.ibm.com> writes:
> >
> >> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> >> index 7171990..817be56 100644
> >> --- a/misc/mke2fs.c
> >> +++ b/misc/mke2fs.c
> >> @@ -1402,12 +1402,12 @@ static void PRS(int argc, char *argv[])
> >>  
> >>  	fs_param.s_log_frag_size = fs_param.s_log_block_size;
> >>  
> >> -	if (noaction && fs_param.s_blocks_count) {
> >> -		dev_size = fs_param.s_blocks_count;
> >> +	if (noaction && ext2fs_blocks_count(&fs_param)) {
> >> +		dev_size = ext2fs_blocks_count(&fs_param);
> >>  		retval = 0;
> >>  	} else {
> >>  	retry:
> >> -		retval = ext2fs_get_device_size(device_name,
> >> +		retval = ext2fs_get_device_size2(device_name,
> >>  						EXT2_BLOCK_SIZE(&fs_param),
> >>  						&dev_size);
> >>  		if ((retval == EFBIG) &&
> >
> > You should not assume that ext2fs_get_device_size2() will return EFBIG
> > if the size exceed 2^32 blocks. The point of ext2fs_get_device_size2()
> > was to be able to support more than 2^32 blocks and the library
> > function will certainly change to return larger numbers in the future.
> >
> > So you need something like
> >
> > if ((retval == EFBIG || dev_size >= (1ULL << 32)) &&
> >
> > MfG
> >         Goswin
> 
> Actualy that is already a problem. The ext2fs_get_device_size2() only
> returns EFBIG if sizeof(dev_size) < sizeof(unsigned long long), which
> was the case for blk_t but no longer.
> 
> As a result mke2fs no longer stops with the right error on devices >
> 16TiB. My test device is exactly 32 TiB large and gives the following:
> 
> root@beo-13:~# LD_LIBRARY_PATH=/tmpa/ext4 /tmpa/ext4/mke2fs -T ext4dev
> -j -m0 /dev/mapper/ext4
> mke2fs 1.41.0 (10-Jul-2008)
> mke2fs: inode_size (256) * inodes_count (0) too big for a
>         filesystem with 0 blocks, specify higher inode_ratio (-i)
>         or lower inode count (-N).

hehe, I put a FIXME-64 around this since I knew it was going to be a
problem.  I just wasn't sure what was the right approach for fixing.
You'll have to specify an inode count for now.

The "filesystem with 0 blocks" surprise me though.  Looks like I missed
something somewhere.

> I'm guessing somewhere along the line it converts to 32bit choping of
> the higher bits.
> 
> MfG
>         Goswin

-JRS
