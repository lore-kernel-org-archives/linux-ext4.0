From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: Reserve FEATURE_RO_COMPAT and INO flag
Date: Fri, 26 Apr 2013 05:47:58 -0600
Message-ID: <2B5199BA-39D5-4118-B4FC-96C8B800507B@dilger.ca>
References: <1366900760-18899-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Lukas Czerner <lczerner@redhat.com>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:60192 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab3DZLsA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Apr 2013 07:48:00 -0400
Received: by mail-pa0-f50.google.com with SMTP id bg4so2452527pad.9
        for <linux-ext4@vger.kernel.org>; Fri, 26 Apr 2013 04:48:00 -0700 (PDT)
In-Reply-To: <1366900760-18899-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I was looking in the maint and master branches, but I don't see these flags anywhere?

Cheers, Andreas

On 2013-04-25, at 8:39, Lukas Czerner <lczerner@redhat.com> wrote:

> EXT4_FEATURE_RO_COMPAT_REPLICA and EXT4_REPLICA_INO are reserved in
> e2fsprogs for non-upstream feature. However it has never been reserved
> in kernel, fix this. Thanks to Radek Pazdera to pointing it out.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
> fs/ext4/ext4.h |    3 +++
> 1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 3b83cd6..6369c28 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -241,6 +241,7 @@ struct ext4_io_submit {
> #define EXT4_UNDEL_DIR_INO     6    /* Undelete directory inode */
> #define EXT4_RESIZE_INO         7    /* Reserved group descriptors inode */
> #define EXT4_JOURNAL_INO     8    /* Journal inode */
> +#define EXT4_REPLICA_INO     10    /* Used by non-upstream feature */
> 
> /* First non-reserved inode for old ext4 filesystems */
> #define EXT4_GOOD_OLD_FIRST_INO    11
> @@ -1481,6 +1482,8 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
>  * GDT_CSUM bits are mutually exclusive.
>  */
> #define EXT4_FEATURE_RO_COMPAT_METADATA_CSUM    0x0400
> +/* Reserved for non-upstream feature */
> +#define EXT4_FEATURE_RO_COMPAT_REPLICA        0x0800
> 
> #define EXT4_FEATURE_INCOMPAT_COMPRESSION    0x0001
> #define EXT4_FEATURE_INCOMPAT_FILETYPE        0x0002
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
