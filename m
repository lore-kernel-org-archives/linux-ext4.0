Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFF31C4320A
	for <linux-ext4@archiver.kernel.org>; Mon, 23 Aug 2021 14:52:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 981F5613E6
	for <linux-ext4@archiver.kernel.org>; Mon, 23 Aug 2021 14:52:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbhHWOxY (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 23 Aug 2021 10:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbhHWOxX (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Aug 2021 10:53:23 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE54C061575;
        Mon, 23 Aug 2021 07:52:40 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id 691211F42633
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Shreeya Patel <shreeya.patel@collabora.com>,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 02/11] f2fs: simplify f2fs_sb_read_encoding
Organization: Collabora
References: <20210818140651.17181-1-hch@lst.de>
        <20210818140651.17181-3-hch@lst.de>
Date:   Mon, 23 Aug 2021 10:52:36 -0400
In-Reply-To: <20210818140651.17181-3-hch@lst.de> (Christoph Hellwig's message
        of "Wed, 18 Aug 2021 16:06:42 +0200")
Message-ID: <877dgc2oy3.fsf@collabora.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Christoph Hellwig <hch@lst.de> writes:

> Return the encoding table as the return value instead of as an argument,
> and don't bother with the encoding flags as the caller can handle that
> trivially.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good:

Reviewed-by: Gabriel Krisman Bertazi <krisman@collabora.com>


-- 
Gabriel Krisman Bertazi
