From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH, RFC] ext4: add EXT4_IOC_ALLOC_DA_BLKS ioctl
Date: Tue, 24 Feb 2009 15:08:32 +0530
Message-ID: <20090224093832.GB25657@skywalker>
References: <1235451952-2726-1-git-send-email-tytso@mit.edu> <1235451952-2726-2-git-send-email-tytso@mit.edu> <1235451952-2726-3-git-send-email-tytso@mit.edu> <1235451952-2726-4-git-send-email-tytso@mit.edu> <1235451952-2726-5-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:55960 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881AbZBXJin (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Feb 2009 04:38:43 -0500
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp08.au.ibm.com (8.13.1/8.13.1) with ESMTP id n1O9ceCW005038
	for <linux-ext4@vger.kernel.org>; Tue, 24 Feb 2009 20:38:40 +1100
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n1O9cwWF376870
	for <linux-ext4@vger.kernel.org>; Tue, 24 Feb 2009 20:38:58 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n1O9ceah013184
	for <linux-ext4@vger.kernel.org>; Tue, 24 Feb 2009 20:38:40 +1100
Content-Disposition: inline
In-Reply-To: <1235451952-2726-5-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 24, 2009 at 12:05:50AM -0500, Theodore Ts'o wrote:
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index 22dd29f..0d59f5f 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -262,6 +262,19 @@ setversion_out:
>  		return err;
>  	}
> 
> +	case EXT4_IOC_ALLOC_DA_BLKS:
> +	{
> +		int err;
> +		if (!is_owner_or_cap(inode))
> +			return -EACCES;
> +
> +		err = mnt_want_write(filp->f_path.mnt);
> +		if (err)
> +			return err;
> +		err = ext4_alloc_da_blocks(inode);
> +		return err;
> +	}
> +

I guess we need a  matching
	mnt_drop_write();

>  	default:
>  		return -ENOTTY;
>  	}
> -- 
> 1.5.6.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
