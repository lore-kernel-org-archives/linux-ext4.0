From: Peter Staubach <staubach@redhat.com>
Subject: Re: [PATCH] e2fsprogs : Add stricter checks for blocksize in ext2fs_open
Date: Fri, 11 Jul 2008 08:43:31 -0400
Message-ID: <48775573.3050203@redhat.com>
References: <ea11fea30807110149g31065f31k5231bbebc5133587@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbYGKMnh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Jul 2008 08:43:37 -0400
In-Reply-To: <ea11fea30807110149g31065f31k5231bbebc5133587@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Manish Katiyar wrote:
> Below patch adds stricter checks in ext2fs_open() so that we catch bad
> block sizes earlier than later.
>
> ============================================================================
>
> Signed-off-by: "Manish Katiyar" <mkatiyar@gmail.com>
>
> ---
>  lib/ext2fs/openfs.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
> index fc54afe..670cc7c 100644
> --- a/lib/ext2fs/openfs.c
> +++ b/lib/ext2fs/openfs.c
> @@ -233,7 +233,9 @@ errcode_t ext2fs_open2(const char *name, const
> char *io_options,
>  	}
>  	
>  	fs->blocksize = EXT2_BLOCK_SIZE(fs->super);
> -	if (fs->blocksize == 0) {
> +	if ((fs->blocksize < EXT2_MIN_BLOCK_SIZE) ||
> +	    (fs->blocksize > EXT2_MAX_BLOCK_SIZE) ||
> +	    (fs->blocksize % EXT2_MIN_BLOCK_SIZE != 0)) {
>   

It seems to me that this would read more clearly as:

               ((fs->blocksize % EXT2_MIN_BLOCK_SIZE) != 0)) {

    Thanx!

       ps

>  		retval = EXT2_ET_CORRUPT_SUPERBLOCK;
>  		goto cleanup;
>  	}
>   

