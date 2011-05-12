From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] debugfs: remove unused htree_dump "-l" argument
Date: Thu, 12 May 2011 09:43:05 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1105120941170.3752@dhcp-27-109.brq.redhat.com>
References: <4DCABD5B.8040403@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753722Ab1ELHnI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 May 2011 03:43:08 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p4C7h8MC026894
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 12 May 2011 03:43:08 -0400
In-Reply-To: <4DCABD5B.8040403@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 11 May 2011, Eric Sandeen wrote:

> The long_opt / -l argument was apparently never implemented,
> so remove it and associated argument parsing.
> 
> This slightly changes the (undocumented) behavior because it
> no longer defaults to cwd if no filespec is specified...

The patch looks good.

Thanks!
-Lukas

> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/debugfs/htree.c b/debugfs/htree.c
> index 08f9749..b829e25 100644
> --- a/debugfs/htree.c
> +++ b/debugfs/htree.c
> @@ -197,8 +197,6 @@ void do_htree_dump(int argc, char *argv[])
>  {
>  	ext2_ino_t	ino;
>  	struct ext2_inode inode;
> -	int		c;
> -	int		long_opt = 0;
>  	blk64_t		blk;
>  	char		*buf = NULL;
>  	struct 		ext2_dx_root_info  *rootnode;
> @@ -211,28 +209,7 @@ void do_htree_dump(int argc, char *argv[])
>  
>  	pager = open_pager();
>  
> -	reset_getopt();
> -	while ((c = getopt (argc, argv, "l")) != EOF) {
> -		switch (c) {
> -		case 'l':
> -			long_opt++;
> -			break;
> -		default:
> -			goto print_usage;
> -		}
> -	}
> -
> -	if (argc > optind+1) {
> -	print_usage:
> -		com_err(0, 0, "Usage: htree_dump [-l] file");
> -		goto errout;
> -	}
> -
> -	if (argc == optind)
> -		ino = cwd;
> -	else
> -		ino = string_to_inode(argv[optind]);
> -	if (!ino)
> +	if (common_inode_args_process(argc, argv, &ino, 0))
>  		goto errout;
>  
>  	if (debugfs_read_inode(ino, &inode, argv[1]))
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
