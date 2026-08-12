Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39082395243;
	Wed, 12 Aug 2026 18:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786560105; cv=none; b=TRRDJGeoaUTDK2ZuyjUzBTIv1NqTm5r57WlTmPOQ/5LCcxL5f9/OfQrE9roHPitjKqETf4kROxumG1AeYK/M2t35aaEY+KK/ri6MD87dZj9olGFnLvNMHceJF1wmwoE09K2v349WYkuC31tleWiefI9aXCffP8/V5WIFVHk36+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786560105; c=relaxed/simple;
	bh=Jk/x95qG6nywLCMhUbiYVyaNBZ3M3sPPWVMn4DIbWqw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rkrlzKKHwo5IhUiooM52WNcl2Aqba8K7amCtd+18Q2Kxbjvgb/5nb9waEPt0VrOSuj1IaRLsm2AN3+N3m6J+y3l8YBs3eP38mppM2sCx9eEPAwLVCBk+C10AUcBFgLw20ngcj5zal1MDNuB6DmY0dR3gpDPaw1OlWsg672PaOmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lrjmv2ym; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lrjmv2ym"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CCB641F00A3A;
	Wed, 12 Aug 2026 18:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786560103;
	bh=xx7MGN+qPswecuAUIESO3n3xmlzUhspZGHNZ3/a3824=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Lrjmv2ymIRGGzTwHPSAnxKG/HP5x3y4djYc0TXLKcYtTiYvb83VH8imt9VjFQ5W5P
	 qEZDLY7DF2wntte31ow94+V5hOd5Yho2fPuEXlXyilzOLaXII9Pv2o8RFhQ0EDzPyG
	 g2MREexrypvsuHRrEevXn8ArZowL+s4+jMMaVQtVMxD62iWm8vjvEK1mB8Zl2ARYaQ
	 ltmA+UjSIsnN7ZU9ef18lfMQ7FiYNMHJc25ph0a53K+OSU/3PpeBYIK6gumBZ5lKJm
	 fICIOZ7T6b3Xbh0IOiqi5n87e+ceDTlvsy2b0nDJeyCuK7YjvEWS+OTxmn8UeDObpK
	 3SJzUEdoYeNTQ==
Date: Wed, 12 Aug 2026 11:41:43 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: guzebing <guzebing1612@gmail.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com,
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
	yi.zhang@huawei.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: only update tune mount options when requested
Message-ID: <20260812184143.GW7398@frogsfrogsfrogs>
References: <20260810151200.1405562-1-guzebing1612@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810151200.1405562-1-guzebing1612@gmail.com>

On Mon, Aug 10, 2026 at 11:12:00PM +0800, guzebing wrote:
> EXT4_IOC_SET_TUNE_SB_PARAM uses set_flags to indicate which superblock
> fields the caller wants to update. ext4_sb_setparams() checks set_flags
> before updating the other supported fields, but always copied mount_opts
> into the on-disk s_mount_opts field.
> 
> As a result, callers that do not set EXT4_TUNE_FL_MOUNT_OPTS can still
> clear or alter the on-disk default mount options through their unused
> mount_opts buffer. This can affect subsequent mounts by changing the
> filesystem's stored default mount options.
> 
> Only copy mount_opts into s_mount_opts when EXT4_TUNE_FL_MOUNT_OPTS is set,
> matching the set_flags semantics used by the other tuneable superblock
> fields.
> 
> Fixes: 04a91570ac67 ("ext4: implemet new ioctls to set and get superblock parameters")
> Signed-off-by: guzebing <guzebing1612@gmail.com>

Cc: <stable@vger.kernel.org> # v6.18

> ---
>  fs/ext4/ioctl.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index c8387e6a2c6e9..1f6d7afb62ec7 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -1362,7 +1362,8 @@ static void ext4_sb_setparams(struct ext4_sb_info *sbi,
>  		es->s_encoding = cpu_to_le16(params->encoding);
>  	if (params->set_flags & EXT4_TUNE_FL_ENCODING_FLAGS)
>  		es->s_encoding_flags = cpu_to_le16(params->encoding_flags);
> -	strscpy_pad(es->s_mount_opts, params->mount_opts);
> +	if (params->set_flags & EXT4_TUNE_FL_MOUNT_OPTS)

Ordinarily I'd say that this is a UABI break, however, Ted never merged
the userspace code into e2fsprogs so there's no userspace to break.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +		strscpy_pad(es->s_mount_opts, params->mount_opts);
>  	if (params->set_flags & EXT4_TUNE_FL_EDIT_FEATURES) {
>  		es->s_feature_compat |=
>  			cpu_to_le32(params->set_feature_compat_mask);
> -- 
> 2.20.1
> 
