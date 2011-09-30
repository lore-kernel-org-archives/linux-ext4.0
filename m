From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH] ext4: ext4_mkdir should dirty dir_block with the
	parent inode
Date: Fri, 30 Sep 2011 12:45:41 -0700
Message-ID: <20110930194541.GW12086@tux1.beaverton.ibm.com>
References: <20110817033954.GP20655@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110817033954.GP20655@tux1.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Aug 16, 2011 at 08:39:54PM -0700, Darrick J. Wong wrote:
> ext4_mkdir calls ext4_handle_dirty_metadata with dir_block and the inode "dir".
> Unfortunately, dir_block belongs to the newly created directory (which is
> "inode"), not the parent directory (which is "dir").  Fix the incorrect
> association.

Any thoughts about this one, Ted?

--D
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
>  fs/ext4/namei.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 2b5c34b..a2c2855 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -1866,7 +1866,7 @@ retry:
>  	ext4_set_de_type(dir->i_sb, de, S_IFDIR);
>  	inode->i_nlink = 2;
>  	BUFFER_TRACE(dir_block, "call ext4_handle_dirty_metadata");
> -	err = ext4_handle_dirty_metadata(handle, dir, dir_block);
> +	err = ext4_handle_dirty_metadata(handle, inode, dir_block);
>  	if (err)
>  		goto out_clear_inode;
>  	err = ext4_mark_inode_dirty(handle, inode);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
