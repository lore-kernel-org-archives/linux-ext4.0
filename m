From: djwong <djwong@us.ibm.com>
Subject: Re: [dm-devel] EXT4-fs error (device dm-42):
 ext4_mb_generate_buddy:741: group 1904, 32254 clusters in bitmap, 32258 in
 gd
Date: Thu, 7 Jun 2012 15:27:29 -0700
Message-ID: <20120607222729.GI6938@tux1.beaverton.ibm.com>
References: <471046920.20120604234941@eikelenboom.it>
 <20120605000356.GM29466@outflux.net>
 <1018371644.20120605224154@eikelenboom.it>
 <20120605210806.GB7182@thunk.org>
 <1883708187.20120606090126@eikelenboom.it>
 <CAGXu5jK-4dO59-x3eTU10OntcPwsVptjpUzQdbbHOvy9_VBQ2A@mail.gmail.com>
 <1482118647.20120606164012@eikelenboom.it>
 <20120607042756.GA30776@thunk.org>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "Ted Ts'o" <tytso@mit.edu>,
	Sander Eikelenboom <linux@eikelenboom.it>,
	Kees Cook <keescook@chromium.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120607042756.GA30776@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jun 07, 2012 at 12:27:56AM -0400, Ted Ts'o wrote:
> I think this patch should fix things.  Could you give it a try (after
> re-enabling uninit_bg and then running e2fsck on the file systems)?
> 
> Many thanks,
> 
> 						- Ted
> 
> commit b6b218940d47f20fc14e4d203930c575be0c65bf
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Thu Jun 7 00:26:56 2012 -0400
> 
>     ext4: fix the free blocks calculation for ext3 file systems w/ uninit_bg
>     
>     Ext3 filesystems that are converted to use as many ext4 file systems
>     as possible 

Just to clarify the description a bit:

Did you mean "..as many ext4 filesystem _features_ as possible" ?

> will enable uninit_bg to speed up e2fsck times.  File
>     systems with an native ext3 layout of inode tables and block

Perhaps "On file systems with a native ext3 layout..." ?

--D

>     allocation bitmaps (as opposed to ext4's flex_bg layout), ext4 would
>     sometimes incorrectly calculate the number of free blocks in an
>     uninitialized block group.  As a result, when first allocating a block
>     in block group marked uninitalized, ext4 would incorrectly report that
>     the file system was corrupt:
>     
>     EXT4-fs error (device dm-42): ext4_mb_generate_buddy:741: group 1699, 32254 clusters in bitmap, 32258 in gd
>     
>     Fix the calculation in ext4_num_overhead_clusters() to avoid this
>     problem.
>     
>     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index 99b6324..cee7812 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -90,8 +90,8 @@ unsigned ext4_num_overhead_clusters(struct super_block *sb,
>  	 * unusual file system layouts.
>  	 */
>  	if (ext4_block_in_group(sb, ext4_block_bitmap(sb, gdp), block_group)) {
> -		block_cluster = EXT4_B2C(sbi, (start -
> -					       ext4_block_bitmap(sb, gdp)));
> +		block_cluster = EXT4_B2C(sbi,
> +					 ext4_block_bitmap(sb, gdp) - start);
>  		if (block_cluster < num_clusters)
>  			block_cluster = -1;
>  		else if (block_cluster == num_clusters) {
> @@ -102,7 +102,7 @@ unsigned ext4_num_overhead_clusters(struct super_block *sb,
> 
>  	if (ext4_block_in_group(sb, ext4_inode_bitmap(sb, gdp), block_group)) {
>  		inode_cluster = EXT4_B2C(sbi,
> -					 start - ext4_inode_bitmap(sb, gdp));
> +					 ext4_inode_bitmap(sb, gdp) - start);
>  		if (inode_cluster < num_clusters)
>  			inode_cluster = -1;
>  		else if (inode_cluster == num_clusters) {
> @@ -114,7 +114,7 @@ unsigned ext4_num_overhead_clusters(struct super_block *sb,
>  	itbl_blk = ext4_inode_table(sb, gdp);
>  	for (i = 0; i < sbi->s_itb_per_group; i++) {
>  		if (ext4_block_in_group(sb, itbl_blk + i, block_group)) {
> -			c = EXT4_B2C(sbi, start - itbl_blk + i);
> +			c = EXT4_B2C(sbi, itbl_blk + i - start);
>  			if ((c < num_clusters) || (c == inode_cluster) ||
>  			    (c == block_cluster) || (c == itbl_cluster))
>  				continue;
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
