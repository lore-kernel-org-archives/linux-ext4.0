Return-Path: <SRS0=G6ZV=DQ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFDFBC433DF
	for <linux-ext4@archiver.kernel.org>; Fri,  9 Oct 2020 02:00:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AEA222248
	for <linux-ext4@archiver.kernel.org>; Fri,  9 Oct 2020 02:00:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730878AbgJICAl (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 8 Oct 2020 22:00:41 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:41917 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729285AbgJICAk (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Oct 2020 22:00:40 -0400
Received: from callcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 09920GT4029986
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 8 Oct 2020 22:00:16 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id B9297420107; Thu,  8 Oct 2020 22:00:15 -0400 (EDT)
Date:   Thu, 8 Oct 2020 22:00:15 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     "zhangyi (F)" <yi.zhang@huawei.com>
Cc:     linux-ext4@vger.kernel.org, jack@suse.com, adilger.kernel@dilger.ca
Subject: Re: [PATCH v2 7/7] ext4: introduce ext4_sb_bread_unmovable() to
 replace sb_bread_unmovable()
Message-ID: <20201009020015.GG816148@mit.edu>
References: <20200924073337.861472-1-yi.zhang@huawei.com>
 <20200924073337.861472-8-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200924073337.861472-8-yi.zhang@huawei.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Sep 24, 2020 at 03:33:37PM +0800, zhangyi (F) wrote:
> Now we only use sb_bread_unmovable() to read superblock and descriptor
> block at mount time, so there is no opportunity that we need to clear
> buffer verified bit and also handle buffer write_io error bit. But for
> the sake of unification, let's introduce ext4_sb_bread_unmovable() to
> replace all sb_bread_unmovable(). After this patch, we stop using read
> helpers in fs/buffer.c.
> 
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>

Thanks, applied.

					- Ted
