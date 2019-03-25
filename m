Return-Path: <SRS0=eNh3=R4=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E042DC4360F
	for <linux-ext4@archiver.kernel.org>; Mon, 25 Mar 2019 17:31:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B72CD205C9
	for <linux-ext4@archiver.kernel.org>; Mon, 25 Mar 2019 17:31:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729825AbfCYRa7 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 25 Mar 2019 13:30:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:55132 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726217AbfCYRa7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 25 Mar 2019 13:30:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CD4B7B023;
        Mon, 25 Mar 2019 17:30:56 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 110591E429A; Mon, 25 Mar 2019 18:30:56 +0100 (CET)
Date:   Mon, 25 Mar 2019 18:30:56 +0100
From:   Jan Kara <jack@suse.cz>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Eric Whitney <enwlinux@gmail.com>,
        Sean Fu <fxinrong@gmail.com>, Jan Kara <jack@suse.cz>,
        Eric Biggers <ebiggers@google.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: use BUG() instead of BUG_ON(1)
Message-ID: <20190325173056.GK8308@quack2.suse.cz>
References: <20190325130040.1437445-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190325130040.1437445-1-arnd@arndb.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon 25-03-19 14:00:25, Arnd Bergmann wrote:
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
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Sure. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

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
>  			 * We don't need to check unwritten extent because
>  			 * indirect-based file doesn't have it.
>  			 */
> -			BUG_ON(1);
> +			BUG();
>  		}
>  	} else if (retval == 0) {
>  		if (ext4_es_is_written(es)) {
> @@ -780,7 +780,7 @@ static int __es_insert_extent(struct inode *inode, struct extent_status *newes)
>  			}
>  			p = &(*p)->rb_right;
>  		} else {
> -			BUG_ON(1);
> +			BUG();
>  			return -EINVAL;
>  		}
>  	}
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index b32a57bc5d5d..190f0478582a 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -541,7 +541,7 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
>  			map->m_len = retval;
>  			retval = 0;
>  		} else {
> -			BUG_ON(1);
> +			BUG();
>  		}
>  #ifdef ES_AGGRESSIVE_TEST
>  		ext4_map_blocks_es_recheck(handle, inode, map,
> @@ -1876,7 +1876,7 @@ static int ext4_da_map_blocks(struct inode *inode, sector_t iblock,
>  		else if (ext4_es_is_unwritten(&es))
>  			map->m_flags |= EXT4_MAP_UNWRITTEN;
>  		else
> -			BUG_ON(1);
> +			BUG();
>  
>  #ifdef ES_AGGRESSIVE_TEST
>  		ext4_map_blocks_es_recheck(NULL, inode, map, &orig_map, 0);
> -- 
> 2.20.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
