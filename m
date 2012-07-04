From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH] e2fsprogs/csum: Use fs.csum_seed for xattr block csum
 calculation.
Date: Tue, 3 Jul 2012 20:03:21 -0700
Message-ID: <20120704030321.GD2342@tux1.beaverton.ibm.com>
References: <1340547756-2932-1-git-send-email-tm@tao.ma>
 <20120703165826.GB2342@tux1.beaverton.ibm.com>
 <4FF3A004.7050006@tao.ma>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:32775 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755464Ab2GDDD0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Jul 2012 23:03:26 -0400
Received: from /spool/local
	by e3.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Tue, 3 Jul 2012 23:03:25 -0400
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 8CE4A38C803A
	for <linux-ext4@vger.kernel.org>; Tue,  3 Jul 2012 23:03:22 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q6433M69370726
	for <linux-ext4@vger.kernel.org>; Tue, 3 Jul 2012 23:03:22 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q648YEbv000369
	for <linux-ext4@vger.kernel.org>; Wed, 4 Jul 2012 04:34:15 -0400
Content-Disposition: inline
In-Reply-To: <4FF3A004.7050006@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 04, 2012 at 09:44:36AM +0800, Tao Ma wrote:
> On 07/04/2012 12:58 AM, Darrick J. Wong wrote:
> > On Sun, Jun 24, 2012 at 10:22:36PM +0800, Tao Ma wrote:
> >> From: Tao Ma <boyu.mt@taobao.com>
> >>
> >> As I mentioned in the kernel part patch with the subject
> >> "ext4: Use s_csum_seed instead of i_csum_seed for xattr block csum",
> >> it is not easy for the kernel to use the proper inode csum seed.
> >> So always use the fs.csum_seed for the xattr block csum calculation.
> >>
> >> Cc: Darrick J. Wong <djwong@us.ibm.com>
> > 
> > Acked-by: Darrick J. Wong <djwong@us.ibm.com>
> > 
> > (I assume there's a similar patch for e2fsprogs?)
> uh, sorry, but this *is* the patch for e2fsprogs. Something wrong here?

Oops, I got confused.  Please ignore my baffled comment. :/

--D
> 
> Thanks
> Tao
> > 
> > --D
> >> Cc: "Theodore Ts'o" <tytso@mit.edu>
> >> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> >> ---
> >>  lib/ext2fs/csum.c |   18 +++---------------
> >>  1 files changed, 3 insertions(+), 15 deletions(-)
> >>
> >> diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
> >> index a7096d2..5ccbc1c 100644
> >> --- a/lib/ext2fs/csum.c
> >> +++ b/lib/ext2fs/csum.c
> >> @@ -119,21 +119,9 @@ static errcode_t ext2fs_ext_attr_block_csum(ext2_filsys fs, ext2_ino_t inum,
> >>  	struct ext2_inode inode;
> >>
> >>  	hdr->h_checksum = 0;
> >> -	if (ext2fs_le32_to_cpu(hdr->h_refcount) != 1) {
> >> -		block = ext2fs_cpu_to_le64(block);
> >> -		*crc = ext2fs_crc32c_le(fs->csum_seed, (unsigned char *)&block,
> >> -					sizeof(block));
> >> -	} else {
> >> -		retval = ext2fs_read_inode(fs, inum, &inode);
> >> -		if (retval)
> >> -			return retval;
> >> -		inum = ext2fs_cpu_to_le32(inum);
> >> -		gen = ext2fs_cpu_to_le32(inode.i_generation);
> >> -		*crc = ext2fs_crc32c_le(fs->csum_seed, (unsigned char *)&inum,
> >> -					sizeof(inum));
> >> -		*crc = ext2fs_crc32c_le(*crc, (unsigned char *)&gen,
> >> -					sizeof(gen));
> >> -	}
> >> +	block = ext2fs_cpu_to_le64(block);
> >> +	*crc = ext2fs_crc32c_le(fs->csum_seed, (unsigned char *)&block,
> >> +				sizeof(block));
> >>  	*crc = ext2fs_crc32c_le(*crc, (unsigned char *)buf, fs->blocksize);
> >>  	hdr->h_checksum = old_crc;
> >>
> >> -- 
> >> 1.7.1
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> 

