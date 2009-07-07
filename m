From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Return error if we fail to allocate block in
	noalloc_get_block_write
Date: Tue, 7 Jul 2009 14:50:58 +0530
Message-ID: <20090707092058.GB6311@skywalker>
References: <1246441575-20311-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:46731 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727AbZGGJVJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jul 2009 05:21:09 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id n679KFVq015828
	for <linux-ext4@vger.kernel.org>; Tue, 7 Jul 2009 19:20:15 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n679LCwh295084
	for <linux-ext4@vger.kernel.org>; Tue, 7 Jul 2009 19:21:12 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n679LBHJ027266
	for <linux-ext4@vger.kernel.org>; Tue, 7 Jul 2009 19:21:11 +1000
Content-Disposition: inline
In-Reply-To: <1246441575-20311-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 01, 2009 at 03:16:15PM +0530, Aneesh Kumar K.V wrote:
> block_write_full_page consider a zero return from get_block as success.
> noalloc_get_block_write returned zero even if we failed to find a mapping
> blocks. Returning non zero ensures we fallback to the error handling path
> of block_write_full_page which would properly redirty the page after
> the below patch is applied.
> 
> http://article.gmane.org/gmane.linux.file-systems/33145
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
> 
> NOTE: I am not sure whether -EGAIN is the right error to be returned error.
> This patch should enable us to push the pending ext4 patches in the patch
> queue without depending on the full series from Jan. Will reply to this
> email with patch ordering.
> 
>  fs/ext4/inode.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 25638bc..6c814af 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2514,7 +2514,10 @@ static int noalloc_get_block_write(struct inode *inode, sector_t iblock,
>  	if (ret > 0) {
>  		bh_result->b_size = (ret << inode->i_blkbits);
>  		ret = 0;
> -	}
> +	} else if (create && ret == 0)
> +		/* write request on unmapped buffer head. */
> +		ret = -EAGAIN;
> +
>  	return ret;
>  }
> 

Now that i tried this with a test case, this patch really doesn't make
the situation better. So we can drop the above patch. But i guess wei
should push the pending patches in the patchqueue even without
Jan kara's changes. Below is what i found.

Without the below set of patches we have some really bad bugs with ext4
on a 1k blocksize filesystem

dont-look-at-buffer_heads-outside-i_size
fix-mmap-truncate-race-with-subpage-blocksize
fix-mmap-truncate-race-with-nondelalloc 
move-__ext4_journaled-writepage-function


a) As I mentioned in the call, without the changes, a simple mmap and 
truncate on a file will result in us looping in writepage. The attached test
program shows that. The fsync() calls won't return.

b) But with the above changes we will now start dropping some file
contents after a truncate -> mmap -> truncate sequence. In the test
program attached, the value of *(addr + 2048 ) is dropped. Jan's patches
will fix the problem for us. But for 2.6.30 we are still ok even if the
contents are dropped because the man page for mmap states
"The effect of changing the size of the underlying file of a mapping on
the pages that correspond to added or removed regions of the file is unspecified."

considering that the above set of patches is really fixing the problem
mentioned in (a) . We may want to push the patches to 2.6.30.

#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <stdlib.h>

main(int argc, char *argv[])
{
	int fd = open(argv[1], O_RDWR | O_CREAT, 0666);
	char *addr;
	ftruncate(fd, 1024);
	addr = (char *)mmap(NULL, 4096, PROT_WRITE, MAP_SHARED, fd, 0);
	if (addr == MAP_FAILED) {
		perror("Error in mmap\n");
		exit(1);
	}
	*addr = 'a';
	*(addr+1) = 'b';
	ftruncate(fd, 4096);
	*(addr + 2048) = 'k';
	fsync(fd);
	close(fd);
}


