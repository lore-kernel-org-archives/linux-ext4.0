Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A5E5C433E1
	for <linux-ext4@archiver.kernel.org>; Tue, 23 Mar 2021 19:15:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E93CA619CB
	for <linux-ext4@archiver.kernel.org>; Tue, 23 Mar 2021 19:15:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233298AbhCWTPX (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 23 Mar 2021 15:15:23 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:53692 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233286AbhCWTPN (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Mar 2021 15:15:13 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id 7B8F31F44AB6
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     Shreeya Patel <shreeya.patel@collabora.com>
Cc:     tytso@mit.edu, adilger.kernel@dilger.ca, jaegeuk@kernel.org,
        chao@kernel.org, ebiggers@google.com, drosen@google.com,
        ebiggers@kernel.org, yuchao0@huawei.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, kernel@collabora.com,
        andre.almeida@collabora.com
Subject: Re: [PATCH v3 4/5] fs: unicode: Rename utf8-core file to unicode-core
Organization: Collabora
References: <20210323183201.812944-1-shreeya.patel@collabora.com>
        <20210323183201.812944-5-shreeya.patel@collabora.com>
Date:   Tue, 23 Mar 2021 15:15:09 -0400
In-Reply-To: <20210323183201.812944-5-shreeya.patel@collabora.com> (Shreeya
        Patel's message of "Wed, 24 Mar 2021 00:02:00 +0530")
Message-ID: <87k0pxd6ma.fsf@collabora.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Shreeya Patel <shreeya.patel@collabora.com> writes:

> Rename the file name from utf8-core to unicode-core for transformation of
> utf8-core file into the unicode subsystem layer file and also for better
> understanding.
>
> Signed-off-by: Shreeya Patel <shreeya.patel@collabora.com>

Acked-by: Gabriel Krisman Bertazi <krisman@collabora.com>

Thanks,

> ---
>  fs/unicode/Makefile                        | 2 +-
>  fs/unicode/{utf8-core.c => unicode-core.c} | 0
>  2 files changed, 1 insertion(+), 1 deletion(-)
>  rename fs/unicode/{utf8-core.c => unicode-core.c} (100%)
>
> diff --git a/fs/unicode/Makefile b/fs/unicode/Makefile
> index b88aecc86..fbf9a629e 100644
> --- a/fs/unicode/Makefile
> +++ b/fs/unicode/Makefile
> @@ -3,7 +3,7 @@
>  obj-$(CONFIG_UNICODE) += unicode.o
>  obj-$(CONFIG_UNICODE_NORMALIZATION_SELFTEST) += utf8-selftest.o
>  
> -unicode-y := utf8-norm.o utf8-core.o
> +unicode-y := utf8-norm.o unicode-core.o
>  
>  $(obj)/utf8-norm.o: $(obj)/utf8data.h
>  
> diff --git a/fs/unicode/utf8-core.c b/fs/unicode/unicode-core.c
> similarity index 100%
> rename from fs/unicode/utf8-core.c
> rename to fs/unicode/unicode-core.c

-- 
Gabriel Krisman Bertazi
