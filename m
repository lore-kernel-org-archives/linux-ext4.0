Return-Path: <SRS0=wnCJ=UF=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FSL_HELO_FAKE,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_HIGH,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEA50C04AB5
	for <linux-ext4@archiver.kernel.org>; Thu,  6 Jun 2019 22:45:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C4582089E
	for <linux-ext4@archiver.kernel.org>; Thu,  6 Jun 2019 22:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1559861128;
	bh=IpeP4llY6H8KG7+vBFY5WZTqeGaAD5HxVZl5eZNKYbc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=HyyYpzZqi7Zw1b9Jj1VZLi1WR2sE1lCbNETuGHTBSvHS4yDcURWvbgJ5T0RoZFXNy
	 3H5CrhVJwlchKSqF+BPYZeLKNT1wRBUJ0DC9X+hv5RwErUHxSgPFOJwDHcs4BsMWKw
	 A5M/KYktJxum1uafNA6KbNBG2D2mKJilxI1bc+QQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbfFFWp2 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 6 Jun 2019 18:45:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:39372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726567AbfFFWp2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 6 Jun 2019 18:45:28 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66C1D20868;
        Thu,  6 Jun 2019 22:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559861127;
        bh=IpeP4llY6H8KG7+vBFY5WZTqeGaAD5HxVZl5eZNKYbc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EjEhdUByVca2KOEz9p6NHR2DzDlvCiSfwrexPZ54Ql+CrCOEMFlgSCRsBsssPLMPl
         bff+yIbFliFhncDBeyopUAVMVuUiq8mYp9QVZZX2Vp899XXpO+bK6s/dnzReJXP77D
         ILdIA0wDj5XPOIjoU8HT4qu9g7iBgEi7CLt0SLLA=
Date:   Thu, 6 Jun 2019 15:45:25 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Wang Shilong <wangshilong1991@gmail.com>
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Andreas Dilger <adilger@dilger.ca>,
        Wang Shilong <wshilong@ddn.com>
Subject: Re: [f2fs-dev] [PATCH 1/2] ext4: only set project inherit bit for
 directory
Message-ID: <20190606224525.GB84833@gmail.com>
References: <1559795545-17290-1-git-send-email-wshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559795545-17290-1-git-send-email-wshilong1991@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Jun 06, 2019 at 01:32:24PM +0900, Wang Shilong wrote:
> From: Wang Shilong <wshilong@ddn.com>
> 
> It doesn't make any sense to have project inherit bits
> for regular files, even though this won't cause any
> problem, but it is better fix this.
> 
> Cc: Andreas Dilger <adilger@dilger.ca>
> Signed-off-by: Wang Shilong <wshilong@ddn.com>
> ---
>  fs/ext4/ext4.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 1cb67859e051..ceb74093e138 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -421,7 +421,8 @@ struct flex_groups {
>  			   EXT4_PROJINHERIT_FL | EXT4_CASEFOLD_FL)
>  
>  /* Flags that are appropriate for regular files (all but dir-specific ones). */
> -#define EXT4_REG_FLMASK (~(EXT4_DIRSYNC_FL | EXT4_TOPDIR_FL | EXT4_CASEFOLD_FL))
> +#define EXT4_REG_FLMASK (~(EXT4_DIRSYNC_FL | EXT4_TOPDIR_FL | EXT4_CASEFOLD_FL |\
> +			   EXT4_PROJINHERIT_FL))
>  
>  /* Flags that are appropriate for non-directories/regular files. */
>  #define EXT4_OTHER_FLMASK (EXT4_NODUMP_FL | EXT4_NOATIME_FL)
> -- 
> 2.21.0

Won't this break 'chattr' on files that already have this flag set?
FS_IOC_GETFLAGS will return this flag, so 'chattr' will pass it back to
FS_IOC_SETFLAGS which will return EOPNOTSUPP due to this:

	if (ext4_mask_flags(inode->i_mode, flags) != flags)
		return -EOPNOTSUPP;

- Eric
