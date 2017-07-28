From: =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>
Subject: Re: [PATCH] ext4: Fix SEEK_HOLE/SEEK_DATA for blocksize < pagesize
Date: Fri, 28 Jul 2017 13:40:25 +0200
Message-ID: <CAHpGcM+Ts=8Yu_4n-MbQaimxdJFCMAvMhLXucJDifivJcvr9YQ@mail.gmail.com>
References: <20170728111637.12473-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        stable@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:36794 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751071AbdG1Lk1 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Jul 2017 07:40:27 -0400
In-Reply-To: <20170728111637.12473-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2017-07-28 13:16 GMT+02:00 Jan Kara <jack@suse.cz>:
> ext4_find_unwritten_pgoff() does not properly handle a situation when
> starting index is in the middle of a page and blocksize < pagesize. The
> following command shows the bug on filesystem with 1k blocksize:
>
>   xfs_io -f -c "falloc 0 4k" \
>             -c "pwrite 1k 1k" \
>             -c "pwrite 3k 1k" \
>             -c "seek -a -r 0" foo
>
> In this example, neither lseek(fd, 1024, SEEK_HOLE) nor lseek(fd, 2048,
> SEEK_DATA) will return the correct result.
>
> Fix the problem by neglecting buffers in a page before starting offset.

This looks correct as a minimal fix for 4.13. We can later switch to
page_cache_seek_hole_data which does the same thing as
ext4_find_unwritten_pgoff, or directly to iomap_seek_{hole,data}.

> Reported-by: Andreas Gruenbacher <agruenba@redhat.com>
> CC: stable@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/file.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> This is an easy fix for the SEEK_HOLE/SEEK_DATA bug Andreas found. Longer
> term we want to move ext4 to use page_cache_seek_hole_data() however for
> stable backporting this is more suitable.
>
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index b221d0b546b0..8ba34cbe8fe7 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -530,6 +530,8 @@ static int ext4_find_unwritten_pgoff(struct inode *inode,
>                                 lastoff = page_offset(page);
>                                 bh = head = page_buffers(page);
>                                 do {
> +                                       if (lastoff + bh->b_size <= startoff)
> +                                               goto next;
>                                         if (buffer_uptodate(bh) ||
>                                             buffer_unwritten(bh)) {
>                                                 if (whence == SEEK_DATA)
> @@ -544,6 +546,7 @@ static int ext4_find_unwritten_pgoff(struct inode *inode,
>                                                 unlock_page(page);
>                                                 goto out;
>                                         }
> +next:
>                                         lastoff += bh->b_size;
>                                         bh = bh->b_this_page;
>                                 } while (bh != head);
> --
> 2.12.3

Thanks,
Andreas
