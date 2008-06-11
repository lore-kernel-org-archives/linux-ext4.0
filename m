From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 6/6] ext4: tighten restrictions on inode flags
Date: Wed, 11 Jun 2008 17:01:04 +0530
Message-ID: <20080611113104.GC9008@skywalker>
References: <1213142649-32685-1-git-send-email-duaneg@dghda.com> <1213142649-32685-2-git-send-email-duaneg@dghda.com> <1213142649-32685-3-git-send-email-duaneg@dghda.com> <1213142649-32685-4-git-send-email-duaneg@dghda.com> <1213142649-32685-5-git-send-email-duaneg@dghda.com> <1213142649-32685-6-git-send-email-duaneg@dghda.com> <1213142649-32685-7-git-send-email-duaneg@dghda.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org, Andreas Dilger <adilger@sun.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Duane Griffin <duaneg@dghda.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:39135 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbYFKLbQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jun 2008 07:31:16 -0400
Content-Disposition: inline
In-Reply-To: <1213142649-32685-7-git-send-email-duaneg@dghda.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 11, 2008 at 01:04:09AM +0100, Duane Griffin wrote:
> At the moment there are few restrictions on which flags may be set on which
> inodes. Specifically DIRSYNC may only be set on directories and IMMUTABLE
> and APPEND may not be set on links. Tighten that to disallow TOPDIR being
> set on non-directories and SECRM, UNRM, COMPR, SYNC, DIRTY, COMPRBLK,
> NOCOMPR, ECOMPR, INDEX, JOURNAL_DATA, NOTAIL, HUGE_FILE, EXTENTS or
> EXT_MIGRATE being set on anything but regular files or directories.
> 
> Introduce a flags masking function which masks flags based on mode and use
> it during inode creation and when flags are set via the ioctl to facilitate
> future consistency.
> 
> Signed-off-by: Duane Griffin <duaneg@dghda.com>
> --
> 
> The specific flags masked out here are those suggested by Andreas, as well
> as IMMUTABLE, which I included to match the behaviour of the existing code,
> and EXT_MIGRATE.
> 
> It would be good to get some review of these.
> 
> ---
>  fs/ext4/ext4.h   |   24 ++++++++++++++++++++++++
>  fs/ext4/ialloc.c |   14 +++++---------
>  fs/ext4/ioctl.c  |    3 +--
>  3 files changed, 30 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 1a4faa5..2aafd1b 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -243,6 +243,30 @@ struct ext4_group_desc
>  			   EXT4_JOURNAL_DATA_FL | EXT4_NOTAIL_FL|\
>  			   EXT4_DIRSYNC_FL)
> 
> +/* Flags that are inappropriate for regular files. */
> +#define EXT4_REG_FLMASK (EXT4_DIRSYNC_FL | EXT4_TOPDIR_FL)
> +
> +/* Flags that are inappropriate for non-directories/regular files. */
> +#define EXT4_OTHER_FLMASK (EXT4_SECRM_FL | EXT4_UNRM_FL | EXT4_COMPR_FL |\
> +			   EXT4_SYNC_FL | EXT4_IMMUTABLE_FL | EXT4_APPEND_FL |\
> +			   EXT4_DIRTY_FL | EXT4_COMPRBLK_FL | EXT4_NOCOMPR_FL|\
> +			   EXT4_ECOMPR_FL | EXT4_INDEX_FL |\
> +			   EXT4_JOURNAL_DATA_FL | EXT4_NOTAIL_FL |\
> +			   EXT4_DIRSYNC_FL | EXT4_TOPDIR_FL |\
> +			   EXT4_HUGE_FILE_FL | EXT4_EXTENTS_FL |\
> +			   EXT4_EXT_MIGRATE)
> +
> +/* Mask out flags that are inappropriate for the given type of inode. */
> +static inline __le32 ext4_mask_flags(__le16 mode, __le32 flags)
> +{
> +	if (S_ISDIR(mode))
> +		return flags;
> +	else if (S_ISREG(mode))
> +		return flags & ~EXT4_REG_FLMASK;
> +	else
> +		return flags & ~EXT4_OTHER_FLMASK;
> +}
> +

why are the arguments __le32 ? They should be in host order.

static inline  __u32 ext4_mask_flags(umode_t mode, __u32 flags)

-aneesh
