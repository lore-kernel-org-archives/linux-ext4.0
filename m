From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: fix uniniatilized extend splitting error.
Date: Thu, 10 Jan 2008 17:08:45 -0800
Message-ID: <1200013725.4012.19.camel@localhost.localdomain>
References: <20080110143142.GC8685@dmon-lap.sw.ru>
	 <20080110213103.GJ3351@webber.adilger.int>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42116 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755458AbYAKBIu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Jan 2008 20:08:50 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m0B18lxL017489
	for <linux-ext4@vger.kernel.org>; Thu, 10 Jan 2008 20:08:47 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m0B18lLN106568
	for <linux-ext4@vger.kernel.org>; Thu, 10 Jan 2008 20:08:47 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m0B18lXs022409
	for <linux-ext4@vger.kernel.org>; Thu, 10 Jan 2008 20:08:47 -0500
In-Reply-To: <20080110213103.GJ3351@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2008-01-10 at 14:31 -0700, Andreas Dilger wrote:
> On Jan 10, 2008  17:31 +0300, Dmitry Monakhov wrote:
> > While playing with new fancy fallocate interface on ext4 i've triggered
> > bug which corrupted my grub :).
> 
> I notice I'm CC'd on this, but in fact Amit wrote the code.  I've CC'd
> him even though I expect he will notice it anyways.
> 
> > My testcase:
> > ~~~~~~~~~~~~
> > blksize = 0x1000;
> > fd = open(argv[1], O_RDWR|O_CREAT, 0700);
> > unsigned long long sz = 0x10000000UL;
> > /* allocating big blocks chunk */
> > syscall(__NR_fallocate, fd, 0, 0UL, sz)
> > 
> > /* grab all other available filesystem space */
> > tfd = open("tmp", O_RDWR|O_CREAT|O_DIRECT, 0700);
> > while( write(tfd, buf, 4096) > 0); /* loop untill ENOSPC */
> > fsync(fd); /* just in case */
> > while (pos < sz) {
> > 	/* each seek+ write operation result in splits uninitialized extent
> > 	in three extents. Splitting may result in new extent allocation
> > 	which probably will fail because of ENOSPC*/
> > 
> > 	lseek(fd, blksize*2 -1, SEEK_CUR);
> > 	if ((ret = write(fd, 'a', 1)) != 1)
> > 		exit(1);
> > 	pos += blksize * 2;
> > }
> 
> Interesting test, and well thought out...
> 
> > Buggy place:
> > ~~~~~~~~~~~~
> > ext4_ext_get_blocks(..., bh_result,..)
> > {
> > 	err = 0;
> > 	allocated = 0;
> > ....
> > 	 ret = ext4_ext_convert_to_initialized(...)
> >  	if (ret < 0)
> > << By occasion real error code was lost here.
> > 		goto out2
> > ....
> > out2:
> > ....
> > 	return err? err: allocated;
> > << Wow.. exit with "0", and caller assumes what bh_result was properly filled
> > <<   and then will submit it for write. But in fact bh contains random data in
> > <<   ->b_bdev, ->b_blocknr fileds :).
> > }
> 
> The other item that Amit and I discussed in the past is in the case of
> ENOSPC it would be possible instead of splitting the extent to zero-fill
> the smaller extent (1 block in your test case) and write the whole thing
> as an initialized extent.  This could then either be merged with the
> previous or following allocated extent, or the whole extent zeroed if that
> was not possible.
> 
> It would add some latency in the worst case to do this in the kernel,
> but this would only happen if there is no free space at all.  It might
> even be desirable to always zero-fill small extents instead of splitting
> uninitialized extents, because a random write of 64kB is not more expensive
> than 4kB and avoids overhead of splitting the nicely contiguous extent tree.
> 

Zero-fill uninitialized extents all the time can cause extra IO, as that
zero-out (via get_block()) is happened at prepare write time rather than
page write out time.

I'd prefer the latency zero-out happens only when it needed. 


> > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> > ---
> >  fs/ext4/extents.c |    5 +++--
> >  1 files changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index 8528774..fc8e508 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -2320,9 +2320,10 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
> >  			ret = ext4_ext_convert_to_initialized(handle, inode,
> >  								path, iblock,
> >  								max_blocks);
> > -			if (ret <= 0)
> > +			if (ret <= 0) {
> > +				err = ret;
> >  				goto out2;
> > -			else
> > +			} else
> >  				allocated = ret;
> >  			goto outnew;
> >  		}
> > -- 
> > 1.5.3.1.40.g6972-dirty
> > 
> > 
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
