Return-Path: <SRS0=oERZ=R2=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 772E4C43381
	for <linux-ext4@archiver.kernel.org>; Sat, 23 Mar 2019 15:54:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E42120828
	for <linux-ext4@archiver.kernel.org>; Sat, 23 Mar 2019 15:54:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727504AbfCWPyH (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 23 Mar 2019 11:54:07 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:48587 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726889AbfCWPyH (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 23 Mar 2019 11:54:07 -0400
Received: from callcc.thunk.org ([70.42.157.31])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x2NFroZr023802
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 23 Mar 2019 11:53:54 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 0DAD4421A01; Sat, 23 Mar 2019 11:53:50 -0400 (EDT)
Date:   Sat, 23 Mar 2019 11:53:49 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     "zhangyi (F)" <yi.zhang@huawei.com>
Cc:     linux-ext4@vger.kernel.org, jack@suse.cz, adilger.kernel@dilger.ca,
        miaoxie@huawei.com
Subject: Re: [PATCH v2 1/2] ext4: brelse all indirect buffer in
 ext4_ind_remove_space()
Message-ID: <20190323155349.GC5675@mit.edu>
References: <1552633813-42832-1-git-send-email-yi.zhang@huawei.com>
 <1552633813-42832-2-git-send-email-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1552633813-42832-2-git-send-email-yi.zhang@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Mar 15, 2019 at 03:10:12PM +0800, zhangyi (F) wrote:
> All indirect buffers get by ext4_find_shared() should be released no
> mater the branch should be freed or not. But now, we forget to release
> the lower depth indirect buffers when removing space from the same
> higher depth indirect block. It will lead to buffer leak and futher
> more, it may lead to quota information corruption when using old quota,
> consider the following case.
> 
>  - Create and mount an empty ext4 filesystem without extent and quota
>    features,
>  - quotacheck and enable the user & group quota,
>  - Create some files and write some data to them, and then punch hole
>    to some files of them, it may trigger the buffer leak problem
>    mentioned above.
>  - Disable quota and run quotacheck again, it will create two new
>    aquota files and write the checked quota information to them, which
>    probably may reuse the freed indirect block(the buffer and page
>    cache was not freed) as data block.
>  - Enable quota again, it will invoke
>    vfs_load_quota_inode()->invalidate_bdev() to try to clean unused
>    buffers and pagecache. Unfortunately, because of the buffer of quota
>    data block is still referenced, quota code cannot read the up to date
>    quota info from the device and lead to quota information corruption.
> 
> This problem can be reproduced by xfstests generic/231 on ext3 file
> system or ext4 file system without extent and quota features.
> 
> This patch fix this problem by brelse the missing indirect buffers, in
> ext4_ind_remove_space().
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> Suggested-by: Jan Kara <jack@suse.cz>
> Cc: <stable@vger.kernel.org>

Thanks, applied.

						- Ted
