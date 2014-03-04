From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH v3 24/30] e2fsck: check inline_data in pass1
Date: Tue, 4 Mar 2014 12:51:12 +0800
Message-ID: <20140304045111.GA12937@gmail.com>
References: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
 <1386323897-2354-25-git-send-email-wenqing.lz@taobao.com>
 <20140303221840.GB4452@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:64020 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755944AbaCDEpo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Mar 2014 23:45:44 -0500
Received: by mail-pd0-f172.google.com with SMTP id p10so4647727pdj.3
        for <linux-ext4@vger.kernel.org>; Mon, 03 Mar 2014 20:45:43 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20140303221840.GB4452@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 03, 2014 at 05:18:40PM -0500, Theodore Ts'o wrote:
> On Fri, Dec 06, 2013 at 05:58:11PM +0800, Zheng Liu wrote:
> > From: Zheng Liu <wenqing.lz@taobao.com>
> > 
> > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> 
> With my change to patch 11/30, the following change is needed to this
> patch.
> 
> 						- Ted

Thanks for fixing this.  The patch looks good to me.
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
                                                - Zheng

> 
> diff --git a/lib/ext2fs/dblist_dir.c b/lib/ext2fs/dblist_dir.c
> index 1e36584..2fbb772 100644
> --- a/lib/ext2fs/dblist_dir.c
> +++ b/lib/ext2fs/dblist_dir.c
> @@ -78,9 +78,7 @@ static int db_dir_proc(ext2_filsys fs, struct ext2_db_entry2 *db_info,
>  		return DBLIST_ABORT;
>  	if (inode.i_flags & EXT4_INLINE_DATA_FL) {
>  		ctx->flags = DIRENT_FLAG_INCLUDE_INLINE_DATA;
> -		ext2fs_inline_data_dir_iterate(fs, ctx->dir,
> -					       ext2fs_process_dir_block,
> -					       ctx);
> +		ret = ext2fs_inline_data_dir_iterate(fs, ctx->dir, ctx);
>  	} else {
>  		ret = ext2fs_process_dir_block(fs, &db_info->blk,
>  					       db_info->blockcnt, 0, 0,
