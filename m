From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH] ext4: Use proper csum calculation in ext4_rename.
Date: Tue, 3 Jul 2012 10:01:53 -0700
Message-ID: <20120703170153.GC2342@tux1.beaverton.ibm.com>
References: <1340379514-2838-1-git-send-email-tm@tao.ma>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:60090 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755297Ab2GCRD5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Jul 2012 13:03:57 -0400
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Tue, 3 Jul 2012 13:03:55 -0400
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id C5BCD38C809E
	for <linux-ext4@vger.kernel.org>; Tue,  3 Jul 2012 13:01:55 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q63H1t3Z409210
	for <linux-ext4@vger.kernel.org>; Tue, 3 Jul 2012 13:01:55 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q63H1sKn008613
	for <linux-ext4@vger.kernel.org>; Tue, 3 Jul 2012 13:01:55 -0400
Content-Disposition: inline
In-Reply-To: <1340379514-2838-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 22, 2012 at 11:38:34PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> In ext4_rename, when the old name is a dir, we need to
> change ".." to its new parent and journal the change, so
> with metadata_csum enabled, we have to re-calc the csum.
> 
> As the first block of the dir can be either a htree root
> or a normal directory block and we have different csum
> calculation for these 2 types, we have to choose the right
> one in ext4_rename.
> 
> btw, it is found by xfstests 013.

Good catch!

Acked-by: Darrick J. Wong <djwong@us.ibm.com>

--D
> 
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> ---
>  fs/ext4/namei.c |   11 +++++++++--
>  1 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 5845cd9..0edaf18 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -2918,8 +2918,15 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
>  		PARENT_INO(dir_bh->b_data, new_dir->i_sb->s_blocksize) =
>  						cpu_to_le32(new_dir->i_ino);
>  		BUFFER_TRACE(dir_bh, "call ext4_handle_dirty_metadata");
> -		retval = ext4_handle_dirty_dirent_node(handle, old_inode,
> -						       dir_bh);
> +		if (is_dx(old_inode)) {
> +			retval = ext4_handle_dirty_dx_node(handle,
> +							   old_inode,
> +							   dir_bh);
> +		} else {
> +			retval = ext4_handle_dirty_dirent_node(handle,
> +							       old_inode,
> +							       dir_bh);
> +		}
>  		if (retval) {
>  			ext4_std_error(old_dir->i_sb, retval);
>  			goto end_rename;
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

