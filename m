From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH 03/28] ext4: ext4_mkdir should dirty dir_block with the
 parent	inode
Date: Tue, 18 Oct 2011 12:11:47 +0800
Message-ID: <4E9CFC83.5010905@tao.ma>
References: <20111008075343.20506.23155.stgit@elm3c44.beaverton.ibm.com> <20111008075403.20506.36338.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>,
	linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:54442 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750728Ab1JRELy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 18 Oct 2011 00:11:54 -0400
In-Reply-To: <20111008075403.20506.36338.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Darrick,
On 10/08/2011 03:54 PM, Darrick J. Wong wrote:
> ext4_mkdir calls ext4_handle_dirty_metadata with dir_block and the inode "dir".
> Unfortunately, dir_block belongs to the newly created directory (which is
> "inode"), not the parent directory (which is "dir").  Fix the incorrect
> association.
could you please re-send this patch and other fixes that isn't related
to metadata checksum? I need this when implementing inlined dir, and I
guess this can be merged in this merge window.

Thanks
Tao
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
>  fs/ext4/namei.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 6d3fab4..50c7294 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -1863,7 +1863,7 @@ retry:
>  	ext4_set_de_type(dir->i_sb, de, S_IFDIR);
>  	inode->i_nlink = 2;
>  	BUFFER_TRACE(dir_block, "call ext4_handle_dirty_metadata");
> -	err = ext4_handle_dirty_metadata(handle, dir, dir_block);
> +	err = ext4_handle_dirty_metadata(handle, inode, dir_block);
>  	if (err)
>  		goto out_clear_inode;
>  	err = ext4_mark_inode_dirty(handle, inode);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

