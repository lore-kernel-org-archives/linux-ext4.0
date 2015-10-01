From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] ext4: don't print warnings on successful MMP read
 completion
Date: Wed, 30 Sep 2015 23:26:50 -0700
Message-ID: <20151001062650.GA24393@birch.djwong.org>
References: <20150930174256.GL10390@birch.djwong.org>
 <B015F41A-6489-4EFC-A4EC-305589AC3C97@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31397 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbbJAG0y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Oct 2015 02:26:54 -0400
Content-Disposition: inline
In-Reply-To: <B015F41A-6489-4EFC-A4EC-305589AC3C97@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 01, 2015 at 12:20:43AM -0600, Andreas Dilger wrote:
> On Sep 30, 2015, at 11:42 AM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > 
> > If the MMP block reads without error, don't spam dmesg with warnings.
> 
> It is hard to tell from the patch context here, but in the version
> of read_mmp_block() I have (v4.3-rc3-55-gdd36d73) the only way to
> get to warn_exit: is if there is an error already.

Aha!  I'd forgotten that this patch came after an (unreleased) patch to change
all the checksum and corruption errors to report the same codes as XFS.
Without /that/ patch, this one is unnecessary.

Sorry for the noise, everyone can disregard this (for now).

--D

> 
> > diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
> > index 6eb1a61..7bc0873 100644
> > --- a/fs/ext4/mmp.c
> > +++ b/fs/ext4/mmp.c
> > @@ -104,8 +104,9 @@ static int read_mmp_block(struct super_block *sb, struct buffer_head **bh,
> 
> The preceding few lines are as follows, and all of the jumps to
> warn_exit before this set ret != 0:
> 
>         mmp = (struct mmp_struct *)((*bh)->b_data);
>         if (le32_to_cpu(mmp->mmp_magic) == EXT4_MMP_MAGIC &&
>             ext4_mmp_csum_verify(sb, mmp))
>                 return 0;
> > 	ret = -EINVAL;
> > 
> > warn_exit:
> > -	ext4_warning(sb, "Error %d while reading MMP block %llu",
> > -		     ret, mmp_block);
> > +	if (ret)
> > +		ext4_warning(sb, "Error %d while reading MMP block %llu",
> > +			     ret, mmp_block);
> > 	return ret;
> > }
> 
> How does this code get to warn_exit: without setting ret?
> 
> Cheers, Andreas
> 
> 
> 
> 
> 
