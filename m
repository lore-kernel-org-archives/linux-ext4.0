Return-Path: <SRS0=+gwa=TM=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E526CC04A6B
	for <linux-ext4@archiver.kernel.org>; Sun, 12 May 2019 21:18:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCBB320989
	for <linux-ext4@archiver.kernel.org>; Sun, 12 May 2019 21:18:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfELVSZ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 12 May 2019 17:18:25 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:40536 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbfELVSZ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 12 May 2019 17:18:25 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id 24394280EE4
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     "Theodore Ts'o" <tytso@mit.edu>
Cc:     Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] unicode: add missing check for an error return from utf8lookup()
Organization: Collabora
References: <20190512085752.1791-1-tytso@mit.edu>
Date:   Sun, 12 May 2019 17:18:20 -0400
In-Reply-To: <20190512085752.1791-1-tytso@mit.edu> (Theodore Ts'o's message of
        "Sun, 12 May 2019 04:57:52 -0400")
Message-ID: <85lfzbbcdf.fsf@collabora.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

"Theodore Ts'o" <tytso@mit.edu> writes:

> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Cc: Gabriel Krisman Bertazi <krisman@collabora.com>

Acked-by: Gabriel Krisman Bertazi <krisman@collabora.com>

> ---
>  fs/unicode/utf8-norm.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/unicode/utf8-norm.c b/fs/unicode/utf8-norm.c
> index 20d440c3f2db..801ed6d2ea37 100644
> --- a/fs/unicode/utf8-norm.c
> +++ b/fs/unicode/utf8-norm.c
> @@ -714,6 +714,8 @@ int utf8byte(struct utf8cursor *u8c)
>  			}
>  
>  			leaf = utf8lookup(u8c->data, u8c->hangul, u8c->s);
> +			if (!leaf)
> +				return -1;
>  			ccc = LEAF_CCC(leaf);
>  		}

-- 
Gabriel Krisman Bertazi
