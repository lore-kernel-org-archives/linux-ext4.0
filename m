Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD104C4338F
	for <linux-ext4@archiver.kernel.org>; Tue,  3 Aug 2021 02:34:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9638F60C3E
	for <linux-ext4@archiver.kernel.org>; Tue,  3 Aug 2021 02:34:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233356AbhHCCeL (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 2 Aug 2021 22:34:11 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:46944 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S233304AbhHCCeK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Aug 2021 22:34:10 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 1732Xqva018394
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 2 Aug 2021 22:33:54 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 6D22A15C3DD2; Mon,  2 Aug 2021 22:33:52 -0400 (EDT)
Date:   Mon, 2 Aug 2021 22:33:52 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     wuguanghao <wuguanghao3@huawei.com>
Cc:     linux-ext4@vger.kernel.org, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com
Subject: Re: [PATCH v3 10/12] hashmap: change return value type of
 ext2fs_hashmap_add()
Message-ID: <YQirECZyPrR791AS@mit.edu>
References: <20210728015648.284588-1-wuguanghao3@huawei.com>
 <20210728015648.284588-4-wuguanghao3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210728015648.284588-4-wuguanghao3@huawei.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Jul 28, 2021 at 09:56:47AM +0800, wuguanghao wrote:
> From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> 
> In ext2fs_hashmap_add(), new entry is allocated by calling
> malloc(). If malloc() return NULL, it will cause a
> segmentation fault problem.
> 
> Here, we change return value type of ext2fs_hashmap_add()
> from void to int. If allocating new entry fails, we will
> return 1, and the callers should also verify the return
> value of ext2fs_hashmap_add().
> 
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>

Thanks, applied.

Note: I changed ext2fs_hashmap_add() to return an int instead of an
errocode_t.  The commit description said it was going to be an int,
and the code returns -1 (so I fixed the commit description to reflect
-1).  Note that errcode_t is not appropriate for non-errno / com_err
error codes.  So making the function prototype of hashmap_add() to
return an int is the correct thing to do.

Cheers,

					- Ted
