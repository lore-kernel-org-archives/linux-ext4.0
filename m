From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: minor dumpe2fs issue
Date: Wed, 15 Mar 2017 14:48:04 -0700
Message-ID: <20170315214804.GN5281@birch.djwong.org>
References: <CAMXxnT4ihap2-wW97akNHDpjfUqE1rHOAeFtBsb33bKyGEWCuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: TR Reardon <reardonia@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51049 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753626AbdCOVsR (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Mar 2017 17:48:17 -0400
Content-Disposition: inline
In-Reply-To: <CAMXxnT4ihap2-wW97akNHDpjfUqE1rHOAeFtBsb33bKyGEWCuQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[cc mailing list]

On Wed, Mar 15, 2017 at 05:29:52PM -0400, TR Reardon wrote:
> hey, I found a small issue with bigalloc & dumpe2fs, wonder if you'd
> fold a fix into your stream of updates?
> 
> basically, the printing of "Free blocks:" is wrong for bigalloc filesystems.
> 
> modest change below
> 
> +Reardon

This could use a more fully fleshed out description, such as "Ensure
that we print the start and end block number of free clusters even if
there's only a single free cluster."

Furthermore, does this change the output of the 'make check' tests?

> diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
> index 395ea9ee..3b829cd5 100644
> --- a/misc/dumpe2fs.c
> +++ b/misc/dumpe2fs.c
> @@ -97,9 +97,9 @@ static void print_free(unsigned long group, char * bitmap,
>                         print_number((i + offset) * ratio);
>                         for (j = i; j < num && !in_use (bitmap, j); j++)
>                                 ;
> -                       if (--j != i) {
> +                       if (--j != i || ratio > 1 ) {
>                                 fputc('-', stdout);
> -                               print_number((j + offset) * ratio);
> +                               print_number((j + offset + 1) * ratio - 1);

The code looks ok, but we cannot accept patches that lack a
Signed-off-by header.

Please see section 11 in submitting patches:
https://www.kernel.org/doc/Documentation/process/submitting-patches.rst

Also please cc the mailing list.

--D

>                                 i = j;
>                         }
>                         p = 1;
