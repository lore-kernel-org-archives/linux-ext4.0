From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] e2undo: fix endian issues
Date: Thu, 16 Jun 2016 16:05:10 -0700
Message-ID: <20160616230510.GC5724@birch.djwong.org>
References: <fe6468da-e719-2d83-579a-e8bab91c0a99@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26032 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbcFPXFP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Jun 2016 19:05:15 -0400
Content-Disposition: inline
In-Reply-To: <fe6468da-e719-2d83-579a-e8bab91c0a99@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 16, 2016 at 05:51:04PM -0500, Eric Sandeen wrote:
> Two new e2undo issues exist in the latest release on big endian
> machines.
> 
> From sparse check:
> 
> undo_io.c:157:26: warning: invalid assignment: |=
> undo_io.c:157:26:    left side has type restricted __le32
> undo_io.c:157:26:    right side has type int
> undo_io.c:161:26: warning: invalid assignment: &=
> undo_io.c:161:26:    left side has type restricted __le32
> undo_io.c:161:26:    right side has type int
> 
> e2undo.c:211:16: warning: cast to restricted __le64
> e2undo.c:211:16: warning: cast from restricted blk64_t
> e2undo.c:212:16: warning: cast to restricted __le64
> e2undo.c:212:16: warning: cast from restricted blk64_t
> 
> Addresses-RedHat-Bugzilla: 1344636
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/lib/ext2fs/undo_io.c b/lib/ext2fs/undo_io.c
> index f921218..776d5b8 100644
> --- a/lib/ext2fs/undo_io.c
> +++ b/lib/ext2fs/undo_io.c
> @@ -154,11 +154,11 @@ struct undo_private_data {
>  #define E2UNDO_FEATURE_COMPAT_FS_OFFSET 0x1	/* the filesystem offset */
>  
>  static inline void e2undo_set_feature_fs_offset(struct undo_header *header) {
> -	header->f_compat |= E2UNDO_FEATURE_COMPAT_FS_OFFSET;
> +	header->f_compat |= ext2fs_le32_to_cpu(E2UNDO_FEATURE_COMPAT_FS_OFFSET);
>  }
>  
>  static inline void e2undo_clear_feature_fs_offset(struct undo_header *header) {
> -	header->f_compat &= ~E2UNDO_FEATURE_COMPAT_FS_OFFSET;
> +	header->f_compat &= ~ext2fs_le32_to_cpu(E2UNDO_FEATURE_COMPAT_FS_OFFSET);
>  }

(I don't remember the fs_offset patch going to the list?)

>  static io_manager undo_io_backing_manager;
> diff --git a/misc/e2undo.c b/misc/e2undo.c
> index a8cb000..6fb6e44 100644
> --- a/misc/e2undo.c
> +++ b/misc/e2undo.c
> @@ -208,8 +208,7 @@ static int key_compare(const void *a, const void *b)
>  
>  	ka = a;
>  	kb = b;
> -	return ext2fs_le64_to_cpu(ka->fsblk) -
> -	       ext2fs_le64_to_cpu(kb->fsblk);
> +	return ka->fsblk - kb->fsblk;

Otherwise, both changes look ok, so
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  }
>  
>  static int e2undo_setup_tdb(const char *name, io_manager *io_ptr)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
