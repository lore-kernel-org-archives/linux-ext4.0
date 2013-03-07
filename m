From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Reserve xattr index for Rich ACL support
Date: Thu, 7 Mar 2013 15:59:51 +0100
Message-ID: <20130307145951.GA19976@quack.suse.cz>
References: <1360155211-7146-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jeffm@suse.de, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39912 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933122Ab3CGO7x (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Mar 2013 09:59:53 -0500
Content-Disposition: inline
In-Reply-To: <1360155211-7146-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 06-02-13 13:53:31, Jan Kara wrote:
> SUSE is carrying out of tree patches for Rich ACL support for ext4 as
> they didn't get upstream due to opposition of some VFS maintainers.
> Reserve xattr index for Rich ACLs so that it cannot be taken by anything
> else which would force users to backup and reset their Rich ACLs on
> files.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
  Ping? Any opinion on this?

								Honza
> ---
>  fs/ext4/xattr.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
> index 69eda78..7955773 100644
> --- a/fs/ext4/xattr.h
> +++ b/fs/ext4/xattr.h
> @@ -22,6 +22,7 @@
>  #define	EXT4_XATTR_INDEX_LUSTRE			5
>  #define EXT4_XATTR_INDEX_SECURITY	        6
>  #define EXT4_XATTR_INDEX_SYSTEM			7
> +#define EXT4_XATTR_INDEX_RICHACL		8
>  
>  struct ext4_xattr_header {
>  	__le32	h_magic;	/* magic number for identification */
> -- 
> 1.7.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
