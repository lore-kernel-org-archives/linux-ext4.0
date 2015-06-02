From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: only call ext4_truncate when size <= isize
Date: Tue, 2 Jun 2015 10:08:18 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1506021008030.4950@localhost.localdomain>
References: <1432049337-3520-1-git-send-email-jbacik@fb.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Josef Bacik <jbacik@fb.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54152 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754700AbbFBIIY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Jun 2015 04:08:24 -0400
In-Reply-To: <1432049337-3520-1-git-send-email-jbacik@fb.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 19 May 2015, Josef Bacik wrote:

> Date: Tue, 19 May 2015 11:28:57 -0400
> From: Josef Bacik <jbacik@fb.com>
> To: tytso@mit.edu, linux-ext4@vger.kernel.org
> Subject: [PATCH] ext4: only call ext4_truncate when size <= isize
> 
> At LSF we decided that if we truncate up from isize we shouldn't trim fallocated
> blocks that were fallocated with KEEP_SIZE and are past the new i_size.  This
> patch fixes ext4 to do this.  Thanks,

Looks good, thanks!

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/ext4/inode.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 0554b0b..92174dd 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4640,6 +4640,7 @@ static void ext4_wait_for_tail_page_commit(struct inode *inode)
>  int ext4_setattr(struct dentry *dentry, struct iattr *attr)
>  {
>  	struct inode *inode = d_inode(dentry);
> +	loff_t oldsize = inode->i_size;
>  	int error, rc = 0;
>  	int orphan = 0;
>  	const unsigned int ia_valid = attr->ia_valid;
> @@ -4727,8 +4728,6 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
>  				goto err_out;
>  			}
>  		} else {
> -			loff_t oldsize = inode->i_size;
> -
>  			i_size_write(inode, attr->ia_size);
>  			pagecache_isize_extended(inode, oldsize, inode->i_size);
>  		}
> @@ -4756,7 +4755,7 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
>  	 * We want to call ext4_truncate() even if attr->ia_size ==
>  	 * inode->i_size for cases like truncation of fallocated space
>  	 */
> -	if (attr->ia_valid & ATTR_SIZE)
> +	if (attr->ia_valid & ATTR_SIZE && attr->ia_size <= oldsize)
>  		ext4_truncate(inode);
>  
>  	if (!rc) {
> 
