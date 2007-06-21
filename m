From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] added sanity check for xattr validation
Date: Thu, 21 Jun 2007 15:50:37 -0500
Message-ID: <467AE49D.6030207@redhat.com>
References: <20070226223322.GA30215@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Jim Garlick <garlick@llnl.gov>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755758AbXFUUu4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Jun 2007 16:50:56 -0400
In-Reply-To: <20070226223322.GA30215@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger wrote:
> Ted,
> the attached patch adds an extra validity test in check_ext_attr().  If
> an attribute's e_value_size is zero the current code does not allocate
> a region for it and as a result the e_value_offs value is not verified.
> However, if e_value_offs is very large then the later call to
> ext2fs_ext_attr_hash_entry() can dereference bad memory and crash e2fsck.

Did this patch get lost?  Don't see it in Hg...

Thanks,
-Eric

> Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
> Signed-off-by: Jim Garlick <garlick@llnl.gov>
> 
> =========================== e_value_offs.patch ============================
> 
> Index: e2fsprogs-1.39/e2fsck/pass1.c
> ===================================================================
> --- e2fsprogs-1.39.orig/e2fsck/pass1.c	2007-02-10 15:43:36.000000000 +0530
> +++ e2fsprogs-1.39/e2fsck/pass1.c	2007-02-10 15:45:36.000000000 +0530
> @@ -1346,6 +1347,11 @@
>  			if (fix_problem(ctx, PR_1_EA_BAD_VALUE, pctx))
>  				goto clear_extattr;
>  		}
> +		if (entry->e_value_offs + entry->e_value_size > fs->blocksize) {
> +			if (fix_problem(ctx, PR_1_EA_BAD_VALUE, pctx))
> +				goto clear_extattr;
> +			break;
> +		}
>  		if (entry->e_value_size &&
>  		    region_allocate(region, entry->e_value_offs,
>  				    EXT2_EXT_ATTR_SIZE(entry->e_value_size))) {
> =========================== e_value_offs.patch ============================
> 
> Cheers, Andreas
> --
> Andreas Dilger
> Principal Software Engineer
> Cluster File Systems, Inc.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
