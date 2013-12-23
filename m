From: Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH 05/10] misc/create_inode.c: copy regular file
Date: Mon, 23 Dec 2013 11:32:19 -0800
Message-ID: <1387827139.5088.69.camel@dvhart-mobl4.amr.corp.intel.com>
References: <1387800600-13718-1-git-send-email-liezhi.yang@windriver.com>
	 <1387800600-13718-6-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Robert Yang <liezhi.yang@windriver.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:53961 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757468Ab3LWTcq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Dec 2013 14:32:46 -0500
In-Reply-To: <1387800600-13718-6-git-send-email-liezhi.yang@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2013-12-23 at 07:09 -0500, Robert Yang wrote:
> The do_write_internal() is used for copying file from native fs to
> target, most of the code are from debugfs/debugfs.c, the
> debugfs/debugfs.c will be modified to use this function.
> 
> Signed-off-by: Robert Yang <liezhi.yang@windriver.com>
> ---
>  misc/create_inode.c |  184 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 184 insertions(+)
> 


> +
>  /* Copy the native file to the fs */
>  errcode_t do_write_internal(ext2_ino_t cwd, const char *src, const char *dest)
>  {
> +	int		fd;
> +	struct stat	statbuf;
> +	ext2_ino_t	newfile;
> +	errcode_t	retval;
> +	struct ext2_inode inode;
> +	int		bufsize = IO_BUFSIZE;
> +	int		make_holes = 0;
> +	char		*func_name = "do_write_internal";

Does __FUNCTION__ not provide this same functionality in this context?
No need to store this explicitly is there?


-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel


