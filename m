From: Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH 06/10] misc/create_inode.c: create directory
Date: Mon, 23 Dec 2013 11:35:30 -0800
Message-ID: <1387827330.5088.70.camel@dvhart-mobl4.amr.corp.intel.com>
References: <1387800600-13718-1-git-send-email-liezhi.yang@windriver.com>
	 <1387800600-13718-7-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Robert Yang <liezhi.yang@windriver.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56162 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757269Ab3LWTfc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Dec 2013 14:35:32 -0500
In-Reply-To: <1387800600-13718-7-git-send-email-liezhi.yang@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2013-12-23 at 07:09 -0500, Robert Yang wrote:
> The do_mkdir_internal() is used for making dir on the target fs, most of
> the code are from debugfs/debugfs.c, the debugfs/debugfs.c will be
> modified to use this function.
> 
> Signed-off-by: Robert Yang <liezhi.yang@windriver.com>
> ---
>  misc/create_inode.c |   34 ++++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
> 

Similar comments here...

> diff --git a/misc/create_inode.c b/misc/create_inode.c
> index 718d499..95acffe 100644
> --- a/misc/create_inode.c
> +++ b/misc/create_inode.c
> @@ -130,6 +130,40 @@ try_again:
>  /* Make a directory in the fs */
>  errcode_t do_mkdir_internal(ext2_ino_t cwd, const char *name, struct stat *st)
>  {
> +	char			*cp;
> +	ext2_ino_t		parent_ino, ino;
> +	errcode_t		retval;
> +	struct ext2_inode	inode;
> +	char			*func_name = "do_mkdir_internal";


__FUNCTION__ ?

> +
> +
> +	cp = strrchr(name, '/');
> +	if (cp) {
> +		*cp = 0;
> +		if ((retval =  ext2fs_namei(current_fs, root, cwd, name, &parent_ino))){
> +			com_err(name, retval, 0);
> +			return retval;
> +		}
> +		name = cp+1;
> +	} else {
> +		parent_ino = cwd;
> +		name = name;

Copy from debugfs artifact?


-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel


