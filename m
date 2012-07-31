From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [PATCH 2/7] libext2fs: use abort() instead of perror()/exit()
Date: Tue, 31 Jul 2012 11:34:38 -0700
Message-ID: <C4F449DF-59AB-4E63-9545-9D2F8F912563@whamcloud.com>
References: <20120628024356.GB17989@thor.bakeyournoodle.com> <1343684862-13181-1-git-send-email-tytso@mit.edu> <1343684862-13181-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"tony@bakeyournoodle.com" <tony@bakeyournoodle.com>,
	Theodore Ts'o <tytso@mit.edu>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50027 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368Ab2GaSjN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Jul 2012 14:39:13 -0400
Received: by yhmm54 with SMTP id m54so6413790yhm.19
        for <linux-ext4@vger.kernel.org>; Tue, 31 Jul 2012 11:39:12 -0700 (PDT)
In-Reply-To: <1343684862-13181-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-07-30, at 14:47, Theodore Ts'o <tytso@mit.edu> wrote:

> This simplifies the number of C library symbols needed by boot loader
> systems such as yaboot.

This doesn't improve the debugability of the code at all. Instead of getting an error message (as cryptic as it was), now there is no error and the process will just die.

I'm guessing from the original coding that there is no error handling for this case? 

Cheers, Andreas

> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
> lib/ext2fs/blkmap64_rb.c | 6 ++----
> 1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/ext2fs/blkmap64_rb.c b/lib/ext2fs/blkmap64_rb.c
> index e6b7e04..74140ec 100644
> --- a/lib/ext2fs/blkmap64_rb.c
> +++ b/lib/ext2fs/blkmap64_rb.c
> @@ -134,10 +134,8 @@ static void rb_get_new_extent(struct bmap_rb_extent **ext, __u64 start,
> 
>    retval = ext2fs_get_mem(sizeof (struct bmap_rb_extent),
>                &new_ext);
> -    if (retval) {
> -        perror("ext2fs_get_mem");
> -        exit(1);
> -    }
> +    if (retval)
> +        abort();
> 
>    new_ext->start = start;
>    new_ext->count = count;
> -- 
> 1.7.12.rc0.22.gcdd159b
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
