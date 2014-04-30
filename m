From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 7/7] mke2fs: only print the low-level file system stats
 in verbose mode
Date: Wed, 30 Apr 2014 13:22:52 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1404301316180.2100@localhost.localdomain>
References: <1398556834-31913-1-git-send-email-tytso@mit.edu> <1398556834-31913-7-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754283AbaD3LW5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Apr 2014 07:22:57 -0400
In-Reply-To: <1398556834-31913-7-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 26 Apr 2014, Theodore Ts'o wrote:

> Date: Sat, 26 Apr 2014 20:00:34 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Ext4 Developers List <linux-ext4@vger.kernel.org>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Subject: [PATCH 7/7] mke2fs: only print the low-level file system stats in
>     verbose mode

While I kind of like this, because mke2fs is really quite verbose as
it is. However I am afraid that this will break scripts for people.

Also there are actually some useful information in that output like
block size, size of the file system and file system label if
specified. Also maybe having UUID in there will be also useful.

Thanks!
-Lukas

> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  misc/mke2fs.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index 3694ce5..b274165 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -618,6 +618,9 @@ static void show_stats(ext2_filsys fs)
>  	dgrp_t			i;
>  	int			need, col_left;
>  
> +	if (!verbose)
> +		goto skip_details;
> +
>  	if (ext2fs_blocks_count(&fs_param) != ext2fs_blocks_count(s))
>  		fprintf(stderr, _("warning: %llu blocks unused.\n\n"),
>  		       ext2fs_blocks_count(&fs_param) - ext2fs_blocks_count(s));
> @@ -666,6 +669,7 @@ static void show_stats(ext2_filsys fs)
>  		       s->s_blocks_per_group, s->s_clusters_per_group);
>  	printf(_("%u inodes per group\n"), s->s_inodes_per_group);
>  
> +skip_details:
>  	if (fs->group_desc_count == 1) {
>  		printf("\n");
>  		return;
> 
