Return-Path: <SRS0=Quj2=DK=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6EA3C4363D
	for <linux-ext4@archiver.kernel.org>; Sat,  3 Oct 2020 04:55:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A5C42311D
	for <linux-ext4@archiver.kernel.org>; Sat,  3 Oct 2020 04:55:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725681AbgJCEzC (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 3 Oct 2020 00:55:02 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:52330 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725446AbgJCEzC (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 3 Oct 2020 00:55:02 -0400
Received: from callcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 0934sebH014742
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 3 Oct 2020 00:54:41 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 5190042003C; Sat,  3 Oct 2020 00:54:40 -0400 (EDT)
Date:   Sat, 3 Oct 2020 00:54:40 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Qilong Zhang <zhangqilong3@huawei.com>
Cc:     adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Subject: Re: [PATCH -next] ext4: add trace exit in exception path.
Message-ID: <20201003045440.GG23474@mit.edu>
References: <20200921124738.23352-1-zhangqilong3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921124738.23352-1-zhangqilong3@huawei.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Sep 21, 2020 at 08:47:38PM +0800, Qilong Zhang wrote:
> From: Zhang Qilong <zhangqilong3@huawei.com>
> 
> Missing trace exit in exception path of ext4_sync_file and
> ext4_ind_map_blocks.
> 
> Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>

Thanks, applied.

					- Ted
