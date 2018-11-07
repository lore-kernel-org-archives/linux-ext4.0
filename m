Return-Path: <SRS0=XuXQ=NS=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49204 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727203AbeKHBEX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 7 Nov 2018 20:04:23 -0500
Date: Wed, 7 Nov 2018 10:33:30 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Vasily Averin <vvs@virtuozzo.com>
Cc: linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] ext4: possible sbi->s_group_desc leak in
 ext4_fill_super
Message-ID: <20181107153330.GC9919@thunk.org>
References: <cover.1541011937.git.vvs@virtuozzo.com>
 <4b554ca1-f46e-742e-4aaa-04b379baf5f9@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b554ca1-f46e-742e-4aaa-04b379baf5f9@virtuozzo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 31, 2018 at 10:12:27PM +0300, Vasily Averin wrote:
> Fixes bfe0a5f47ada ("ext4: add more mount time checks of the superblock") # 4.18
> 
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
> ---
>  fs/ext4/super.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index a221f1cdf704..ed4d36506ec2 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -4100,7 +4100,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  			 le32_to_cpu(es->s_inodes_count),
>  			 ((u64)sbi->s_groups_count * sbi->s_inodes_per_group));
>  		ret = -EINVAL;
> -		goto failed_mount;
> +		db_count = 0;
> +		goto failed_mount2;
>  	}
>  
>  	bgl_lock_init(sbi->s_blockgroup_lock);

Thanks for spotting this!

A better fix would be to move this check earlier, before the
allocation of sbi->s_group_desc.

						- Ted

commit 9fa8bc9b9d3c6864f8dddd83893a02fcc1b48b62
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Wed Nov 7 10:32:53 2018 -0500

    ext4: fix possible leak of sbi->s_group_desc_leak in error path
    
    Fixes: bfe0a5f47ada ("ext4: add more mount time checks of the superblock")
    Reported-by: Vasily Averin <vvs@virtuozzo.com>
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>
    Cc: stable@kernel.org # 4.18

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index a221f1cdf704..92092b55db1e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4075,6 +4075,14 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	sbi->s_groups_count = blocks_count;
 	sbi->s_blockfile_groups = min_t(ext4_group_t, sbi->s_groups_count,
 			(EXT4_MAX_BLOCK_FILE_PHYS / EXT4_BLOCKS_PER_GROUP(sb)));
+	if (((u64)sbi->s_groups_count * sbi->s_inodes_per_group) !=
+	    le32_to_cpu(es->s_inodes_count)) {
+		ext4_msg(sb, KERN_ERR, "inodes count not valid: %u vs %llu",
+			 le32_to_cpu(es->s_inodes_count),
+			 ((u64)sbi->s_groups_count * sbi->s_inodes_per_group));
+		ret = -EINVAL;
+		goto failed_mount;
+	}
 	db_count = (sbi->s_groups_count + EXT4_DESC_PER_BLOCK(sb) - 1) /
 		   EXT4_DESC_PER_BLOCK(sb);
 	if (ext4_has_feature_meta_bg(sb)) {
@@ -4094,14 +4102,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		ret = -ENOMEM;
 		goto failed_mount;
 	}
-	if (((u64)sbi->s_groups_count * sbi->s_inodes_per_group) !=
-	    le32_to_cpu(es->s_inodes_count)) {
-		ext4_msg(sb, KERN_ERR, "inodes count not valid: %u vs %llu",
-			 le32_to_cpu(es->s_inodes_count),
-			 ((u64)sbi->s_groups_count * sbi->s_inodes_per_group));
-		ret = -EINVAL;
-		goto failed_mount;
-	}
 
 	bgl_lock_init(sbi->s_blockgroup_lock);
 
