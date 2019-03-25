Return-Path: <SRS0=eNh3=R4=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FDCFC43381
	for <linux-ext4@archiver.kernel.org>; Mon, 25 Mar 2019 17:29:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7AF72087E
	for <linux-ext4@archiver.kernel.org>; Mon, 25 Mar 2019 17:29:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rRhCl6Ic"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729710AbfCYR3a (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 25 Mar 2019 13:29:30 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44573 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728912AbfCYR3a (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Mar 2019 13:29:30 -0400
Received: by mail-pg1-f195.google.com with SMTP id i2so6897410pgj.11
        for <linux-ext4@vger.kernel.org>; Mon, 25 Mar 2019 10:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u0WZcwjJqQggkCrQ+/+tUTFaxWK1rSC0xhtoYTl+KFA=;
        b=rRhCl6IckDK/nSQz27C2cKYoeRTYkLETTM5IDKRm820N5T54vHvZdvbnP9QPVJQbqJ
         9a+WHmWpryscHm49tHjXQOKNE/+sv17lLFoF5PRSn7Z2/hMhVqu8w0F4d0GZNZyc0RAc
         5t9F8BiLX2HfXaz6+NY6+1x4vyAk1qz0lR3BsPCaCVuBxAJTXRcFNSvoI9gfRrQZRjO8
         sCz4B6/YXGJCaPUnpOu9ER0ty30f9Rk4/0qc51kbI2i+hn7YOq3jwGvQsbbOangnEg9r
         2nMRPvA89GcWcr4d7nR7CctOPH5hDTl/ur8B+TQln763ifNQu7NGNVpfxVNS+mjiiwh+
         kC4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u0WZcwjJqQggkCrQ+/+tUTFaxWK1rSC0xhtoYTl+KFA=;
        b=j9bG3SThoP0/UZh0nexsMDotlxhIRVVKy/eOa3v8V8tGZh5wrlf/8k1dvtV43yiQHw
         Dd8e0bAuU7jqNGJPwCIso1H++3K+0+/5otKqHksRiGLaagKrsBPD4nosk8awLuSOMJM/
         HhEjcOnMB7guExKpiDFRGiwEuJ65Ncc2cM2he4bfEB50uuKXevtDeJVTo+E0YNynwARi
         xZ/3qQsshDO9rKGsogW5ycFLrYWcMHHe1OGYmAJiJhW5+VMrAZsSgr1ZstvU6bIqb9Dd
         7Hqgz4SbSLX/QDYNgB29gV1R/PSSTHUbsWj6DLLXcZVFel4Jc5BJGJ+oog9Vyw0KU1ij
         3Grg==
X-Gm-Message-State: APjAAAU1yBYvYRc3IyHa4fvOM8F0mzqka8odbSKANHJKjx0u7DJKTo1J
        xslriqqL31kRRnG4Kvu/DyQI9TweDCp2rQiZwFZBBQ==
X-Google-Smtp-Source: APXvYqwSauUoiCe/n9CIkx2/tiQEARlpM4vXmrqDlzevKT9HcmblozxMRQDf/VaH8JqpqsttycqJxaZDFmk9BrNG0Vc=
X-Received: by 2002:a62:209c:: with SMTP id m28mr12332914pfj.94.1553534968992;
 Mon, 25 Mar 2019 10:29:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190325130040.1437445-1-arnd@arndb.de>
In-Reply-To: <20190325130040.1437445-1-arnd@arndb.de>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 25 Mar 2019 10:29:17 -0700
Message-ID: <CAKwvOd=8Vgv-OUxj09zReaXUZEGKsGzHGNzHnr7J8k90Qf0H1A@mail.gmail.com>
Subject: Re: [PATCH] ext4: use BUG() instead of BUG_ON(1)
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>,
        Eric Whitney <enwlinux@gmail.com>,
        Sean Fu <fxinrong@gmail.com>, Jan Kara <jack@suse.cz>,
        Eric Biggers <ebiggers@google.com>, linux-ext4@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Mar 25, 2019 at 6:00 AM Arnd Bergmann <arnd@arndb.de> wrote:
>
> BUG_ON(1) leads to bogus warnings from clang when
> CONFIG_PROFILE_ANNOTATED_BRANCHES is set:
>
>  fs/ext4/inode.c:544:4: error: variable 'retval' is used uninitialized whenever 'if' condition is false
>       [-Werror,-Wsometimes-uninitialized]
>                         BUG_ON(1);
>                         ^~~~~~~~~
>  include/asm-generic/bug.h:61:36: note: expanded from macro 'BUG_ON'
>                                    ^~~~~~~~~~~~~~~~~~~
>  include/linux/compiler.h:48:23: note: expanded from macro 'unlikely'
>                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>  fs/ext4/inode.c:591:6: note: uninitialized use occurs here
>         if (retval > 0 && map->m_flags & EXT4_MAP_MAPPED) {
>             ^~~~~~
>  fs/ext4/inode.c:544:4: note: remove the 'if' if its condition is always true
>                         BUG_ON(1);
>                         ^
>  include/asm-generic/bug.h:61:32: note: expanded from macro 'BUG_ON'
>                                ^
>  fs/ext4/inode.c:502:12: note: initialize the variable 'retval' to silence this warning
>
> Change it to BUG() so clang can see that this code path can never
> continue.

Thanks for the patch; I suspect the definition of `unlikely` is tricky
to "see through."  This is more concise about what we want to do in
these cases anyways.
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  fs/ext4/extents_status.c | 4 ++--
>  fs/ext4/inode.c          | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
> index 2b439afafe13..023a3eb3afa3 100644
> --- a/fs/ext4/extents_status.c
> +++ b/fs/ext4/extents_status.c
> @@ -711,7 +711,7 @@ static void ext4_es_insert_extent_ind_check(struct inode *inode,
>                          * We don't need to check unwritten extent because
>                          * indirect-based file doesn't have it.
>                          */
> -                       BUG_ON(1);
> +                       BUG();
>                 }
>         } else if (retval == 0) {
>                 if (ext4_es_is_written(es)) {
> @@ -780,7 +780,7 @@ static int __es_insert_extent(struct inode *inode, struct extent_status *newes)
>                         }
>                         p = &(*p)->rb_right;
>                 } else {
> -                       BUG_ON(1);
> +                       BUG();
>                         return -EINVAL;
>                 }
>         }
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index b32a57bc5d5d..190f0478582a 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -541,7 +541,7 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
>                         map->m_len = retval;
>                         retval = 0;
>                 } else {
> -                       BUG_ON(1);
> +                       BUG();
>                 }
>  #ifdef ES_AGGRESSIVE_TEST
>                 ext4_map_blocks_es_recheck(handle, inode, map,
> @@ -1876,7 +1876,7 @@ static int ext4_da_map_blocks(struct inode *inode, sector_t iblock,
>                 else if (ext4_es_is_unwritten(&es))
>                         map->m_flags |= EXT4_MAP_UNWRITTEN;
>                 else
> -                       BUG_ON(1);
> +                       BUG();
>
>  #ifdef ES_AGGRESSIVE_TEST
>                 ext4_map_blocks_es_recheck(NULL, inode, map, &orig_map, 0);
> --
> 2.20.0
>


-- 
Thanks,
~Nick Desaulniers
