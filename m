From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC PATCH] ext3, ext4, ocfs2: remove unused macro
 NAMEI_RA_INDEX
Date: Tue, 18 Dec 2012 18:48:11 +0100
Message-ID: <20121218174811.GC5987@quack.suse.cz>
References: <1355820999-27972-1-git-send-email-yan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org, Jan Kara <jack@suse.cz>,
	Theodore Ts'o <tytso@mit.edu>, Mark Fasheh <mfasheh@suse.com>,
	linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
To: Guo Chao <yan@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54250 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703Ab2LRRs1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Dec 2012 12:48:27 -0500
Content-Disposition: inline
In-Reply-To: <1355820999-27972-1-git-send-email-yan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 18-12-12 16:56:39, Guo Chao wrote:
> This macro, initially introduced by ext2 in v0.99.15, does not
> have any users from the beginning. It has been removed in later
> ext2 version but still remains in the code of ext3, ext4, ocfs2.
> Remove this macro there.
  Thanks. I've merged the patch into my tree. Since it's trivial, I guess
other fs maintainers won't mind.

								Honza
> 
> Cc: Jan Kara <jack@suse.cz>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: linux-ext4@vger.kernel.org
> Cc: ocfs2-devel@oss.oracle.com
> Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
> ---
>  fs/ext3/namei.c |    1 -
>  fs/ext4/namei.c |    1 -
>  fs/ocfs2/dir.c  |    1 -
>  3 files changed, 3 deletions(-)
> 
> diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
> index 890b894..88f64eb 100644
> --- a/fs/ext3/namei.c
> +++ b/fs/ext3/namei.c
> @@ -36,7 +36,6 @@
>  #define NAMEI_RA_CHUNKS  2
>  #define NAMEI_RA_BLOCKS  4
>  #define NAMEI_RA_SIZE        (NAMEI_RA_CHUNKS * NAMEI_RA_BLOCKS)
> -#define NAMEI_RA_INDEX(c,b)  (((c) * NAMEI_RA_BLOCKS) + (b))
>  
>  static struct buffer_head *ext3_append(handle_t *handle,
>  					struct inode *inode,
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index cac4482..3f8c3d4 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -47,7 +47,6 @@
>  #define NAMEI_RA_CHUNKS  2
>  #define NAMEI_RA_BLOCKS  4
>  #define NAMEI_RA_SIZE	     (NAMEI_RA_CHUNKS * NAMEI_RA_BLOCKS)
> -#define NAMEI_RA_INDEX(c,b)  (((c) * NAMEI_RA_BLOCKS) + (b))
>  
>  static struct buffer_head *ext4_append(handle_t *handle,
>  					struct inode *inode,
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index 8fe4e28..fc12135 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -67,7 +67,6 @@
>  #define NAMEI_RA_CHUNKS  2
>  #define NAMEI_RA_BLOCKS  4
>  #define NAMEI_RA_SIZE        (NAMEI_RA_CHUNKS * NAMEI_RA_BLOCKS)
> -#define NAMEI_RA_INDEX(c,b)  (((c) * NAMEI_RA_BLOCKS) + (b))
>  
>  static unsigned char ocfs2_filetype_table[] = {
>  	DT_UNKNOWN, DT_REG, DT_DIR, DT_CHR, DT_BLK, DT_FIFO, DT_SOCK, DT_LNK
> -- 
> 1.7.9.5
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
