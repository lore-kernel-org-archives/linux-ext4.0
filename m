Return-Path: <SRS0=f4LO=SY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB9E3C10F11
	for <linux-ext4@archiver.kernel.org>; Mon, 22 Apr 2019 21:17:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 709DB20B1F
	for <linux-ext4@archiver.kernel.org>; Mon, 22 Apr 2019 21:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555967841;
	bh=cshqRET+WFOGxkX+6CAeoxYLpUvqiULVAOe6PSpLPPU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=S7TOSQ/C5O9BymV2YGVQDcvPAqOkefJosJAlK1myhqpFG7cAC6BlbTMkysnsHdFE/
	 0e7eIbgN0rY6+QD0Gqx0hEQ/2zbMw7j5vYTa1KqvmvUPp+5YjMAqxXLH6qdo1h8DFZ
	 cTPmlwPVBQGhDwsutsajbD0fo3aFGAa4Iga+GuQ0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729382AbfDVVRV (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 22 Apr 2019 17:17:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:41164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728868AbfDVVRU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 22 Apr 2019 17:17:20 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10EB920896;
        Mon, 22 Apr 2019 21:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555967840;
        bh=cshqRET+WFOGxkX+6CAeoxYLpUvqiULVAOe6PSpLPPU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oyJRIBba7F/E/ZNQr99ZLMhgwZnYzAqXMUjrr+0fI3UddrN2ViMmu4glLg0D+u7tQ
         RLclWL4WJ1cP76ROFGzDY2KxmT3dHpZBhrQ6xsJmuxlDSOTmrOHfudhR1G8UWygos8
         LGfdxwtF1xXkf5ngE1Oo3NvHPh3yzvmJIbPvjMrk=
Date:   Mon, 22 Apr 2019 14:17:18 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Gabriel Krisman Bertazi <krisman@collabora.com>
Cc:     tytso@mit.edu, kernel@collabora.com, linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: Re: [PATCH v4 4/9] lib/ext2fs: Implement NLS support
Message-ID: <20190422211717.GB22674@gmail.com>
References: <20181201003910.18982-1-krisman@collabora.com>
 <20181201003910.18982-5-krisman@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181201003910.18982-5-krisman@collabora.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Nov 30, 2018 at 07:39:05PM -0500, Gabriel Krisman Bertazi wrote:
> From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
> 
> Basic NLS support is required in e2fsprogs because of fsck, which
> needsto calculate dx hashes for encoding aware filesystems.  this patch
> implements this infrastructure as well as ascii support.
> 
> We don't need to do all the dance of versioning as we do in the kernel,
> because we know before-hand which encodings and versions we
> support (those we know how to store in the sb), so it is simpler just to
> create static tables.
> 
> Changes since v3:
>   - Prevent buffer overflow during normalization/casefold.
>   - Signal invalid sequences and let caller handle it.
> 
[...]
> diff --git a/lib/ext2fs/nls_ascii.c b/lib/ext2fs/nls_ascii.c
> new file mode 100644
> index 000000000000..5d513df404c1
> --- /dev/null
> +++ b/lib/ext2fs/nls_ascii.c
> @@ -0,0 +1,68 @@
> +#include "nls.h"
> +
> +#include <errno.h>
> +#include <string.h>
> +
> +
> +static unsigned char charset_tolower(const struct nls_table *table,
> +				     unsigned int c)
> +{
> +	if (c >= 'A' && c <= 'Z')
> +		return (c | 0x20);
> +	return c;
> +}

Is charset_tolower() supposed to be used for something?  It's never called.

- Eric
