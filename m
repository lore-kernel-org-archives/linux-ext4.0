From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: Protect group inode free counting with group lock.
Date: Wed, 16 May 2012 08:43:28 -0500
Message-ID: <4FB3AF00.9060704@redhat.com>
References: <1337158192-4591-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14324 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932296Ab2EPNnd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 May 2012 09:43:33 -0400
In-Reply-To: <1337158192-4591-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/16/12 3:49 AM, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> Now when we set the group inode free count, we don't have a proper
> group lock so that multiple threads may decrease the inode free
> count at the same time. And e2fsck will complain something like:

This is only in the ! EXT4_FEATURE_RO_COMPAT_GDT_CSUM case I guess?
That would be worth mentioning in the summary & changelog.

I guess you were testing without that for some reason?

-eric

> Free inodes count wrong for group #1 (1, counted=0).
> Fix? no
> 
> Free inodes count wrong for group #2 (3, counted=0).
> Fix? no
> 
> Directories count wrong for group #2 (780, counted=779).
> Fix? no
> 
> Free inodes count wrong for group #3 (2272, counted=2273).
> Fix? no
> 
> So this patch try to protect it with the ext4_lock_group.
> 
> btw, it is found by xfstests test case 269 and I have run it 100
> times and the error in e2fsck doesn't show up again.
> 
> Cc: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> ---
>  fs/ext4/ialloc.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index 409c2ee..25595e2 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -772,7 +772,9 @@ got:
>  			ext4_itable_unused_set(sb, gdp,
>  					(EXT4_INODES_PER_GROUP(sb) - ino));
>  		up_read(&grp->alloc_sem);
> -	}
> +	} else
> +		ext4_lock_group(sb, group);
> +
>  	ext4_free_inodes_set(sb, gdp, ext4_free_inodes_count(sb, gdp) - 1);
>  	if (S_ISDIR(mode)) {
>  		ext4_used_dirs_set(sb, gdp, ext4_used_dirs_count(sb, gdp) + 1);
> @@ -782,10 +784,9 @@ got:
>  			atomic_inc(&sbi->s_flex_groups[f].used_dirs);
>  		}
>  	}
> -	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
> +	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
>  		gdp->bg_checksum = ext4_group_desc_csum(sbi, group, gdp);
> -		ext4_unlock_group(sb, group);
> -	}
> +	ext4_unlock_group(sb, group);
>  
>  	BUFFER_TRACE(inode_bitmap_bh, "call ext4_handle_dirty_metadata");
>  	err = ext4_handle_dirty_metadata(handle, NULL, inode_bitmap_bh);

