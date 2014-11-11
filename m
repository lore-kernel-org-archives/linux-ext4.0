From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/4] e2fsprogs/tune2fs: fix memory write overflow
Date: Tue, 11 Nov 2014 00:37:14 -0800
Message-ID: <20141111083714.GF10043@birch.djwong.org>
References: <1415689169-19393-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
 <1415689169-19393-4-git-send-email-wangxg.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39158 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbaKKIhW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Nov 2014 03:37:22 -0500
Content-Disposition: inline
In-Reply-To: <1415689169-19393-4-git-send-email-wangxg.fnst@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 11, 2014 at 02:59:29PM +0800, Xiaoguang Wang wrote:
> If we apply this patch 'e2fsprogs/tune2fs: rewrite metadata checksums when resizing inode size',
> we will trigger a segfault, this is because of the inode cache issues.
> 
> Firstly we should notice that in expand_inode_table(), we have change the super block's s_inode_size
> to new inode size(for example, 256).
> 
> Then we re-compute metadata checksums, see below code flow:
> |-->rewrite_metadata_checksums
> |----->rewrite_inodes
> |-------->ext2fs_write_inode_full
> In ext2fs_write_inode_full(), if an inode cache is hit, the below code will be executed:
> 	/* Check to see if the inode cache needs to be updated */
> 	if (fs->icache) {
> 		for (i=0; i < fs->icache->cache_size; i++) {
> 			if (fs->icache->cache[i].ino == ino) {
> 				memcpy(fs->icache->cache[i].inode, inode,
> 				       (bufsize > length) ? length : bufsize);
> 				break;
> 			}
> 		}
> 	}
> 
> Before executing rewrite_inodes(), actually the inode in inode cache is allocated by
> old inode size(for example, 128), but here the memcpy will obviously write overflow,
> '(bufsize > length) ? length : bufsize' here will return 256(new inode size), so this is
> wrong, we need to fix this.
> I think we should call ext2fs_free_inode_cache() in expand_inode_table(), to drop the
> inode cache, because inode size has changed, if necessary, we will re-create this inode cache.
> 
> Steps to reproduce this bug(apply 'e2fsprogs/tune2fs: rewrite metadata checksums when resizing inode size' first).
> 	dd if=/dev/zero of=file.img bs=1M count=128
> 	device_name=$(/sbin/losetup -f)
> 	/sbin/losetup -f file.img
> 	mkfs.ext4 -I 128 -O ^flex_bg $device_name
> 	tune2fs -I 256 $device_name
> 
> Signed-off-by: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
> ---
>  misc/tune2fs.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/misc/tune2fs.c b/misc/tune2fs.c
> index 91dc7c1..78b3806 100644
> --- a/misc/tune2fs.c
> +++ b/misc/tune2fs.c
> @@ -2244,6 +2244,8 @@ static int expand_inode_table(ext2_filsys fs, unsigned long new_ino_size)
>  
>  	/* Update the meta data */
>  	fs->inode_blocks_per_group = new_ino_blks_per_grp;
> +
> +	ext2fs_free_inode_cache(fs);

Aha, yes, we do need to expose the ctor/dtor APIs for the inode cache!

Patches 2 & 4 look ok to me.

--D

>  	fs->super->s_inode_size = new_ino_size;
>  
>  err_out:
> -- 
> 1.8.2.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
