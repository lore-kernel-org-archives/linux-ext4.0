From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: do not enable delalloc by default for ext2
Date: Tue, 27 Mar 2012 10:34:42 -0500
Message-ID: <4F71DE12.2090700@redhat.com>
References: <4F71C4B3.9090402@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <esandeen@redhat.com>
To: Brian Foster <bfoster@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755230Ab2C0Pel (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Mar 2012 11:34:41 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q2RFYflp020926
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 27 Mar 2012 11:34:41 -0400
In-Reply-To: <4F71C4B3.9090402@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/27/12 8:46 AM, Brian Foster wrote:
> Use traditional ext2 mount options. Do not enable delalloc by default for ext2.

This makes sense to me, I think.

It was done for ext3 to semi-preserve the journal "5s sync" I think, and
one could argue that delalloc is ok for ext2, but it seems like people would
expect behavior which is as close to what ext2.ko provided as possible.  So,

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/ext4/super.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 9339009..b08a547 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3229,7 +3229,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  	 * enable delayed allocation by default
>  	 * Use -o nodelalloc to turn it off
>  	 */
> -	if (!IS_EXT3_SB(sb) &&
> +	if (!IS_EXT3_SB(sb) && !IS_EXT2_SB(sb) &&
>  	    ((def_mount_opts & EXT4_DEFM_NODELALLOC) == 0))
>  		set_opt(sb, DELALLOC);
>  

