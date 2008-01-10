From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: fix uniniatilized extend splitting error.
Date: Thu, 10 Jan 2008 15:42:55 -0800
Message-ID: <1200008575.4012.7.camel@localhost.localdomain>
References: <20080110143142.GC8685@dmon-lap.sw.ru>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@clusterfs.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:46859 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833AbYAJXm7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Jan 2008 18:42:59 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m0ANgvZd000736
	for <linux-ext4@vger.kernel.org>; Thu, 10 Jan 2008 18:42:57 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m0ANgvnD495248
	for <linux-ext4@vger.kernel.org>; Thu, 10 Jan 2008 18:42:57 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m0ANguPc026744
	for <linux-ext4@vger.kernel.org>; Thu, 10 Jan 2008 18:42:57 -0500
In-Reply-To: <20080110143142.GC8685@dmon-lap.sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks for catching this, I added your fix to the ext4 patch queue
http://repo.or.cz/w/ext4-patch-queue.git

On Thu, 2008-01-10 at 17:31 +0300, Dmitry Monakhov wrote:
> Hi,
> While playing with new fancy fallocate interface on ext4 i've triggered
> bug which corrupted my grub :).
> 
> My testcase:
> ~~~~~~~~~~~~
> blksize = 0x1000;
> fd = open(argv[1], O_RDWR|O_CREAT, 0700);
> unsigned long long sz = 0x10000000UL;
> /* allocating big blocks chunk */
> syscall(__NR_fallocate, fd, 0, 0UL, sz)
> 
> /* grab all other available filesystem space */
> tfd = open("tmp", O_RDWR|O_CREAT|O_DIRECT, 0700);
> while( write(tfd, buf, 4096) > 0); /* loop untill ENOSPC */
> fsync(fd); /* just in case */
> while (pos < sz) {
> 	/* each seek+ write operation result in splits uninitialized extent
> 	in three extents. Splitting may result in new extent allocation
> 	which probably will fail because of ENOSPC*/
> 
> 	lseek(fd, blksize*2 -1, SEEK_CUR);
> 	if ((ret = write(fd, 'a', 1)) != 1)
> 		exit(1);
> 	pos += blksize * 2;
> }
> 
> Buggy place:
> ~~~~~~~~~~~~
> ext4_ext_get_blocks(..., bh_result,..)
> {
> 	err = 0;
> 	allocated = 0;
> ....
> 	 ret = ext4_ext_convert_to_initialized(...)
>  	if (ret < 0)
> << By occasion real error code was lost here.
> 		goto out2
> ....
> out2:
> ....
> 	return err? err: allocated;
> << Wow.. exit with "0", and caller assumes what bh_result was properly filled
> <<   and then will submit it for write. But in fact bh contains random data in
> <<   ->b_bdev, ->b_blocknr fileds :).
> }
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/extents.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 8528774..fc8e508 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2320,9 +2320,10 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
>  			ret = ext4_ext_convert_to_initialized(handle, inode,
>  								path, iblock,
>  								max_blocks);
> -			if (ret <= 0)
> +			if (ret <= 0) {
> +				err = ret;
>  				goto out2;
> -			else
> +			} else
>  				allocated = ret;
>  			goto outnew;
>  		}
