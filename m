From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] libext2fs: do not print any error message from libext2fs
Date: Tue, 14 May 2013 00:53:56 +0800
Message-ID: <20130513165356.GB14526@gmail.com>
References: <1367059481-6090-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:48279 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab3EMQgL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 May 2013 12:36:11 -0400
Received: by mail-pd0-f170.google.com with SMTP id 10so4559315pdi.1
        for <linux-ext4@vger.kernel.org>; Mon, 13 May 2013 09:36:10 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1367059481-6090-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 27, 2013 at 06:44:41PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> In libext2fs we don't print any error message form it except that OMIT_COM_ERR
> is defined.  In lib/ext2fs/inline_data.c it doesn't obey this rule.  So fix it.
> Meanwhile when we find an dir entry in inline data, we will print the message in
> debugfs rather than in libext2fs.
> 
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>

Hi Ted,

As we discuss a while ago, until now, I only submit this patch for
improving the inline data patch series for e2fsprogs.  IIRC, you have
mentioned that we need to check ext2_ext_attr_ibody_header in libext2fs
and improve some codes in e2fsck (Please let me know if I forgot
something).  As you said, you also have some fixes for this, but it is
still too un-stable to send them out.  So I think maybe we could find a
proper public place to share our works in order to avoid some duplicated
works.  I am happy to improve these stuff.  Please let me know if I need
to do something.

Thanks,
                                                - Zheng

> ---
> [This patch is against pu branch of e2fsprogs tree]
> 
>  debugfs/htree.c          | 5 ++++-
>  lib/ext2fs/inline_data.c | 6 +++---
>  2 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/debugfs/htree.c b/debugfs/htree.c
> index ca39b4b..e042fd7 100644
> --- a/debugfs/htree.c
> +++ b/debugfs/htree.c
> @@ -388,8 +388,11 @@ void do_dirsearch(int argc, char *argv[])
>  	pb.len = strlen(pb.search_name);
>  
>  	if (ext2fs_inode_has_inline_data(current_fs, inode)) {
> -		ext2fs_inline_data_dirsearch(current_fs, inode,
> +		errcode_t retval;
> +		retval = ext2fs_inline_data_dirsearch(current_fs, inode,
>  					     argv[2], strlen(argv[2]));
> +		if (retval)
> +			printf("Entry found at inline data\n");
>  		goto out;
>  	}
>  
> diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
> index ea3736c..6d5cf52 100644
> --- a/lib/ext2fs/inline_data.c
> +++ b/lib/ext2fs/inline_data.c
> @@ -134,16 +134,16 @@ static int do_search_dir(ext2_filsys fs, void *start, unsigned int size,
>  		de = (struct ext2_dir_entry *)(start + offset);
>  		errcode = ext2fs_get_rec_len(fs, de, &rec_len);
>  		if (errcode) {
> +#ifndef OMIT_COM_ERR
>  			com_err("search_dir_inline_data", errcode,
>  				"while getting rec_len for inline data");
> +#endif
>  			return errcode;
>  		}
>  		if (de->inode &&
>  		    len == (de->name_len & 0xFF) &&
> -		    strncmp(name, de->name, len) == 0) {
> -			printf("Entry found at inline data\n");
> +		    strncmp(name, de->name, len) == 0)
>  			return 1;
> -		}
>  		offset += rec_len;
>  	}
>  	return 0;
> -- 
> 1.7.12.rc2.18.g61b472e
> 
