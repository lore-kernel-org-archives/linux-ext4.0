Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 906E9C4338F
	for <linux-ext4@archiver.kernel.org>; Mon, 23 Aug 2021 14:53:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76AB761184
	for <linux-ext4@archiver.kernel.org>; Mon, 23 Aug 2021 14:53:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbhHWOyV (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 23 Aug 2021 10:54:21 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:47258 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbhHWOyU (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Aug 2021 10:54:20 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id 255591F42633
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Shreeya Patel <shreeya.patel@collabora.com>,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 03/11] unicode: remove the charset field from struct
 unicode_map
Organization: Collabora
References: <20210818140651.17181-1-hch@lst.de>
        <20210818140651.17181-4-hch@lst.de>
Date:   Mon, 23 Aug 2021 10:53:33 -0400
In-Reply-To: <20210818140651.17181-4-hch@lst.de> (Christoph Hellwig's message
        of "Wed, 18 Aug 2021 16:06:43 +0200")
Message-ID: <8735r02owi.fsf@collabora.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Christoph Hellwig <hch@lst.de> writes:

> It is hardcoded and only used for a f2fs sysfs file where it can be
> hardcoded just as easily.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Gabriel Krisman Bertazi <krisman@collabora.com>


-- 
Gabriel Krisman Bertazi
