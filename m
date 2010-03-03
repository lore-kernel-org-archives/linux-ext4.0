From: Leonard Michlmayr <leonard.michlmayr@gmail.com>
Subject: Re: [PATCH 11/28] ext4: correctly calculate number of blocks for
 fiemap
Date: Wed, 03 Mar 2010 09:34:31 +0100
Message-ID: <1267605271.7648.14.camel@michlmayr>
References: <1267553925-6308-1-git-send-email-tytso@mit.edu>
	 <1267553925-6308-12-git-send-email-tytso@mit.edu>
	 <4B8E1410.1010107@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Akira Fujita <a-fujita@rs.jp.nec.com>,
	Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:7174 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab0CCIee (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Mar 2010 03:34:34 -0500
Received: by fg-out-1718.google.com with SMTP id l26so191400fgb.1
        for <linux-ext4@vger.kernel.org>; Wed, 03 Mar 2010 00:34:33 -0800 (PST)
In-Reply-To: <4B8E1410.1010107@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi

I think that the patch is valid as it is.

<snip>
>  >   		start_blk = start>>  inode->i_sb->s_blocksize_bits;
>  > -		len_blks = len>>  inode->i_sb->s_blocksize_bits;
>  > +		last_blk = (start + len - 1)>>  inode->i_sb->s_blocksize_bits;
>  > +		len_blks = last_blk - start_blk + 1;
> 
> In 1KB block size, the overflow occurs at above line.
> Since last_blk is set 0xffffffff when len is equal to s_maxbytes.
> Therefore ext4_fiemap() can not get correct extent information
> with 0 length.  How about adding this change?
> 

I have considered this possibility, but len == 0 is an invalid request
and would be sorted out by fs/ioctl.c:fiemap_check_ranges. If you want
to make sure that everything is correct even if len == 0 slips through
consider Andreas Dilger's solution which does not introduce a new branch
to the code:

(Here end_blk is one more than the last block)

end_blk = (start + len + inode->i_sb->s_blocksize - 1) >> inode->i_sb->s_blocksize_bits;
len_blks = end_blk - start_blk;

I think we don't need to copy the functionality of fiemap_check_ranges.
At least if there a no danger that len == 0 will be allowed in the
specification in future?

> Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
> ---
>   extents.c |    3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> --- linux-2.6.33-rc8-a/fs/ext4/extents.c        2010-03-03 14:53:49.000000000 +0900
> +++ linux-2.6.33-rc8-b/fs/ext4/extents.c        2010-03-03 15:31:57.000000000 +0900
> @@ -3912,7 +3912,8 @@ int ext4_fiemap(struct inode *inode, str
> 
>                  start_blk = start >> inode->i_sb->s_blocksize_bits;
>                  last_blk = (start + len - 1) >> inode->i_sb->s_blocksize_bits;
> -               len_blks = last_blk - start_blk + 1;
> +               len_blks = (loff_t)last_blk - start_blk + 1 < EXT_MAX_BLOCK ?
> +                               last_blk - start_blk + 1 : EXT_MAX_BLOCK;
> 
>                  /*
>                   * Walk the extent tree gathering extent information.
> 
> 
> (2010/03/03 3:18), Theodore Ts'o wrote:
> > From: Leonard Michlmayr<leonard.michlmayr@gmail.com>
> >
> > ext4_fiemap() rounds the length of the requested range down to
> > blocksize, which is is not the true number of blocks that cover the
> > requested region.  This problem is especially impressive if the user
> > requests only the first byte of a file: not a single extent will be
> > reported.
> >
> > We fix this by calculating the last block of the region and then
> > subtract to find the number of blocks in the extents.
> >
> > Signed-off-by: Leonard Michlmayr<leonard.michlmayr@gmail.com>
> > Signed-off-by: "Theodore Ts'o"<tytso@mit.edu>
> > ---
> >   fs/ext4/extents.c |    6 ++++--
> >   1 files changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index bd80891..bc9860f 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -3768,7 +3768,6 @@ int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
> >   		__u64 start, __u64 len)
> >   {
> >   	ext4_lblk_t start_blk;
> > -	ext4_lblk_t len_blks;
> >   	int error = 0;
> >
> >   	/* fallback to generic here if not in extents fmt */
> > @@ -3782,8 +3781,11 @@ int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
> >   	if (fieinfo->fi_flags&  FIEMAP_FLAG_XATTR) {
> >   		error = ext4_xattr_fiemap(inode, fieinfo);
> >   	} else {
> > +		ext4_lblk_t last_blk, len_blks;
> > +
> >   		start_blk = start>>  inode->i_sb->s_blocksize_bits;
> > -		len_blks = len>>  inode->i_sb->s_blocksize_bits;
> > +		last_blk = (start + len - 1)>>  inode->i_sb->s_blocksize_bits;
> > +		len_blks = last_blk - start_blk + 1;
> >
> >   		/*
> >   		 * Walk the extent tree gathering extent information.
> 




