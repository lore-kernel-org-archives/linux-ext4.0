From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] mballoc: fix hot spins after err_freebuddy and
	err_freemeta
Date: Fri, 18 Apr 2008 10:44:14 +0530
Message-ID: <20080418051414.GA10568@skywalker>
References: <4807762A.9090202@tiscali.nl> <20080417175843.GA7517@skywalker> <480796FE.2010707@tiscali.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: alex@clusterfs.com, sct@redhat.com, akpm@linux-foundation.org,
	adilger@clusterfs.com, linux-ext4@vger.kernel.org,
	lkml <linux-kernel@vger.kernel.org>
To: Roel Kluin <12o3l@tiscali.nl>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754917AbYDRFOm@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <480796FE.2010707@tiscali.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Apr 17, 2008 at 08:29:18PM +0200, Roel Kluin wrote:
> Aneesh Kumar K.V wrote:
> 
> > The function needs more changes. For ex:
> > 
> > 2279     if (meta_group_info[j] == NULL) {
> > 2280               printk(KERN_ERR "EXT4-fs: can't allocate buddy mem\n");
> > 2281               i--;
> > 2282               goto err_freebuddy;
> > 2283     }
> > 
> > That decrement  i--; could result in bad value if i == 0;.
> 
> Thanks Aneesh,
> ---
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ext4_mb_init_backend() has a variable i of type ext4_group_t. which is typedefined
> in include/linux/ext4_fs_i.h:34 to unsigned long. Since unsigned, i >= 0 is always
> true, so fix hot spins after err_freebuddy and err_freemeta.
> Also when meta_group_info cannot be allocated prevent a decrement of i when zero.
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index ef97f19..2c13dca 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -2572,8 +2572,13 @@ static int ext4_mb_init_backend(struct super_block *sb)
>  		meta_group_info[j] = kzalloc(len, GFP_KERNEL);
>  		if (meta_group_info[j] == NULL) {
>  			printk(KERN_ERR "EXT4-fs: can't allocate buddy mem\n");
> -			i--;
> -			goto err_freebuddy;
> +			if (i != 0) {
> +				i--;
> +				goto err_freebuddy;
> +			} else {
> +				i = num_meta_group_infos - 1;
> +				goto err_freemeta;
> +			}
>  		}
>  		desc = ext4_get_group_desc(sb, i, NULL);
>  		if (desc == NULL) {
> @@ -2618,14 +2623,14 @@ static int ext4_mb_init_backend(struct super_block *sb)
>  	return 0;
> 
>  err_freebuddy:
> -	while (i >= 0) {
> +	do {
>  		kfree(ext4_get_group_info(sb, i));
> -		i--;
> -	}
> -	i = num_meta_group_infos;
> +	} while (i-- != 0);
> +	i = num_meta_group_infos - 1;
>  err_freemeta:
> -	while (--i >= 0)
> +	do {
>  		kfree(sbi->s_group_info[i]);
> +	} while (i-- != 0);
>  	iput(sbi->s_buddy_cache);
>  err_freesgi:
>  	kfree(sbi->s_group_info);
> 

Won't this also have a memory corruption ?  Let's say we fail in the first
loop itslef. That's with i = 0, and since we are using kmalloc.
we may find sbi->s_group_info[0] having some random values. So the
kfree can crash. Why not a simple change like below ?

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 28b5ada..c14f566 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2223,7 +2223,7 @@ static noinline void ext4_mb_store_history(struct ext4_allocation_context *ac)
 
 static int ext4_mb_init_backend(struct super_block *sb)
 {
-	ext4_group_t i;
+	long i; /* should be able to store group number */
 	int j, len, metalen;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	int num_meta_group_infos =
@@ -2257,6 +2257,7 @@ static int ext4_mb_init_backend(struct super_block *sb)
 		if (meta_group_info == NULL) {
 			printk(KERN_ERR "EXT4-fs: can't allocate mem for a "
 			       "buddy group\n");
+			i--;
 			goto err_freemeta;
 		}
 		sbi->s_group_info[i] = meta_group_info;
@@ -2328,7 +2329,7 @@ err_freebuddy:
 		kfree(ext4_get_group_info(sb, i));
 		i--;
 	}
-	i = num_meta_group_infos;
+	i = num_meta_group_infos - 1;
 err_freemeta:
 	while (--i >= 0)
 		kfree(sbi->s_group_info[i]);
