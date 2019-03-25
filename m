Return-Path: <SRS0=eNh3=R4=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71DA5C43381
	for <linux-ext4@archiver.kernel.org>; Mon, 25 Mar 2019 18:14:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 465C6206DF
	for <linux-ext4@archiver.kernel.org>; Mon, 25 Mar 2019 18:14:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DvrjHK7z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729914AbfCYSOo (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 25 Mar 2019 14:14:44 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:43648 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729238AbfCYSOo (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Mar 2019 14:14:44 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2PIE5MO074994;
        Mon, 25 Mar 2019 18:14:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=jo3Bob4cdRs1bV5NhlO4YDp1KXeRPUJkiPauAObNPMo=;
 b=DvrjHK7z9J5drV3Qp/wqaxKhVuE1hBjVK3cI7XpW57tRNG4VsOwHTFJ+NaNp6NjNDPvA
 0KV9JD5oqzCHlO4GLpC8vON4OYS/TRzncbQcSLNNE68PhNZcD4lDbGeHx02Poumt5xGS
 RHjanLynevuDxjRtxbqGUxVs5jwtMr0V9Locj8ohnceXZXHOoMBy45XwCT6/QDclmdRc
 fvSMrHgWJISmVHb+k68DL83cHxmMMtcmYffF7Jz25aQDBYdXvK05ubi1ep9n9kUoa/7m
 sGEK2OChytMGT73NkMbWH2ZDc+CD5qjDtXflt+/eKjCAQvL7N9ONFCHuQkyJ9SIeFhYi Dw== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2re6g0nrhm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Mar 2019 18:14:30 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x2PIERmM016767
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Mar 2019 18:14:30 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x2PIEOYP030352;
        Mon, 25 Mar 2019 18:14:24 GMT
Received: from localhost (/10.159.240.244)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 25 Mar 2019 11:14:24 -0700
Date:   Mon, 25 Mar 2019 11:14:22 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Eric Whitney <enwlinux@gmail.com>,
        Sean Fu <fxinrong@gmail.com>, Jan Kara <jack@suse.cz>,
        Eric Biggers <ebiggers@google.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: use BUG() instead of BUG_ON(1)
Message-ID: <20190325181422.GH1173@magnolia>
References: <20190325130040.1437445-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190325130040.1437445-1-arnd@arndb.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9206 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903250131
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Mar 25, 2019 at 02:00:25PM +0100, Arnd Bergmann wrote:
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

I grok that most of these look like "should never get here" assertions,
but shouldn't we be converting these BUG*() calls to "shut down fs,
bounce error back to userspace" instead of killing the whole kernel?

(He says knowing that ripping all of those out is its own project... :P)

--D

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
