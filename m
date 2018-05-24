From: Jaco Kroon <jaco@uls.co.za>
Subject: Re: [PATCH] ext4: Forbid overflowing inode count when resizing
Date: Thu, 24 May 2018 15:52:50 +0200
Message-ID: <dd9ad588-a3eb-24f6-7f12-3fdcc1562180@uls.co.za>
References: <20180524113646.3859-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-ext4@vger.kernel.org, stable@vger.kernel.org
To: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180524113646.3859-1-jack@suse.cz>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Jan,

To confirm, this would prevent you from resizing the filesystem
completely and put a limit on the max size.

Would another approach possibly be to make the additional blocks
available, but without allocating additional inodes by way of flex groups?

In other words, accept the resize below, but then lower down in the same
function where flex groups gets added, only add until the overflow would
occur.  Or make it overflow once, set number of inodes to 2^32-1 and
then stop adding more?  In my (and I'm betting most use-cases) this
would en up wasting 1 potential inode.

That way the resize can still proceed.

The check that is then currently tripping up userspace tools remain in
place, but will also allow for the special value of 2^32-1 if (and only
if) the calculation for what the number of inodes should be ends up
being greater than equal to 2^32 (would require special code to avoid
the wrap-around condition).  For the prevent overflow case the logic may
actually end up being marginally more complicated.

Would that make sense?  I'd be willing to attempt a patch, but I'll have
to check if I've got some way to actually test this somewhere.

If that does not make sense and a hard limit on the ext4 size based on
the inode count to size ratio is a given:


On 24/05/2018 13:36, Jan Kara wrote:
> ext4_resize_fs() has an off-by-one bug when checking whether growing of
> a filesystem will not overflow inode count. As a result it allows a
> filesystem with 8192 inodes per group to grow to 64TB which overflows
> inode count to 0 and makes filesystem unusable. Fix it.
>
> CC: stable@vger.kernel.org
> Fixes: 3f8a6411fbada1fa482276591e037f3b1adcf55b
> Reported-by: Jaco Kroon <jaco@uls.co.za>
> Signed-off-by: Jan Kara <jack@suse.cz>
Acked-By: Jaco Kroon <jaco@uls.co.za>
> ---
>  fs/ext4/resize.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
> index b6bec270a8e4..d792b7689d92 100644
> --- a/fs/ext4/resize.c
> +++ b/fs/ext4/resize.c
> @@ -1933,7 +1933,7 @@ int ext4_resize_fs(struct super_block *sb, ext4_fsblk_t n_blocks_count)
>  		return 0;
>  
>  	n_group = ext4_get_group_number(sb, n_blocks_count - 1);
> -	if (n_group > (0xFFFFFFFFUL / EXT4_INODES_PER_GROUP(sb))) {
> +	if (n_group >= (0xFFFFFFFFUL / EXT4_INODES_PER_GROUP(sb))) {
>  		ext4_warning(sb, "resize would cause inodes_count overflow");
>  		return -EINVAL;
>  	}
