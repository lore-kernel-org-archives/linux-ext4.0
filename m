From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH] ext4: don't split xattr inode refcounts across
 i_ctime and i_version fields
Date: Tue, 9 Jan 2018 10:52:49 -0800
Message-ID: <20180109185249.GA5594@magnolia>
References: <20180109144701.27387-1-jlayton@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, tytso@mit.edu,
        linux-ext4@vger.kernel.org, dhowells@redhat.com
To: Jeff Layton <jlayton@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:43780 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756287AbeAISxN (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Jan 2018 13:53:13 -0500
Content-Disposition: inline
In-Reply-To: <20180109144701.27387-1-jlayton@kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 09, 2018 at 09:47:01AM -0500, Jeff Layton wrote:
> From: Jeff Layton <jlayton@redhat.com>
> 
> This patch is based on top of the i_version rework that I'm flogging
> upstream. It's just a cleanup of some nastiness I noticed while in there.
> 
> This code uses the i_ctime and i_version fields to each store half of
> a refcount. I suspect it was done this way long ago when the i_version

Way long ago == 2017-06-22 :)

The new 64k xattr value feature in ext4 uses hidden inodes to store attr
values that don't fit in a single block.  Since the inode can be shared
by multiple xattr keys and isn't exported via NFS (I hope...), they use
a 64-bit refcount mashed into i_ctime and i_version.  That's what this
gobbledygook is for.

https://ext4.wiki.kernel.org/index.php/Ext4_Disk_Layout#Large_Extended_Attribute_Values

--D

> field was a 32 bits, and was never changed when the field was converted
> to a 64 bit value.
> 
> Change the code to just store the refcount in the i_version field rather
> than splitting it across both fields.
> 
> Cc: David Howells <dhowells@redhat.com>
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
>  fs/ext4/xattr.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 63656dbafdc4..6ea78dd367ca 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -294,14 +294,12 @@ ext4_xattr_inode_hash(struct ext4_sb_info *sbi, const void *buffer, size_t size)
>  
>  static u64 ext4_xattr_inode_get_ref(struct inode *ea_inode)
>  {
> -	return ((u64)ea_inode->i_ctime.tv_sec << 32) |
> -		(u32) inode_peek_iversion_raw(ea_inode);
> +	return inode_peek_iversion_raw(ea_inode);
>  }
>  
>  static void ext4_xattr_inode_set_ref(struct inode *ea_inode, u64 ref_count)
>  {
> -	ea_inode->i_ctime.tv_sec = (u32)(ref_count >> 32);
> -	inode_set_iversion_raw(ea_inode, ref_count & 0xffffffff);
> +	inode_set_iversion_raw(ea_inode, ref_count);
>  }
>  
>  static u32 ext4_xattr_inode_get_hash(struct inode *ea_inode)
> -- 
> 2.14.3
> 
