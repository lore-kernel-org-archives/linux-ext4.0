Return-Path: <SRS0=o5fV=7M=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43B5FC433E0
	for <linux-ext4@archiver.kernel.org>; Sat, 30 May 2020 15:07:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10B192074D
	for <linux-ext4@archiver.kernel.org>; Sat, 30 May 2020 15:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590851273;
	bh=VFC2e2QDPFdOJxydI3qWtpXTrKif7HwS+5L0IvnfvA0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=UAFtF1o22seC7OO49V1G3BfAz6nXcXrFBffIwhYcBXiSDffUWKv+34LT8HWAINe6Y
	 sKDjHx3x/s8spp31ugGM5/+QRQLIfOgcMPI3Ggrz2DC98wnOt4h/PSTOucs+QcgPYC
	 RaA2SIyvVDgP0M2KADb8XQ+Vrdqd9yiXtbzyK41I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729026AbgE3PHw (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 30 May 2020 11:07:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728927AbgE3PHv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 30 May 2020 11:07:51 -0400
Received: from localhost (unknown [104.132.1.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0848E20715;
        Sat, 30 May 2020 15:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590851271;
        bh=VFC2e2QDPFdOJxydI3qWtpXTrKif7HwS+5L0IvnfvA0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QU8rTwEO5UY8g832e8Juk2CySLLj8tTS0HmL+BgnaqGyakKYO97n+mG84Saq0PngC
         /WZEjiLYtZ1/USS/PLqjOliTkCoDlk+W0hOmpe28n4Lqhlz5N7ZhIfkOqWp0Z67lBF
         XwZdlN/y1PeZAE7UNpeDCouJg7qdIcMa8qkvHYTA=
Date:   Sat, 30 May 2020 08:07:50 -0700
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Daniel Rosenberg <drosen@google.com>,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: Re: [PATCH] f2fs: avoid utf8_strncasecmp() with unstable name
Message-ID: <20200530150750.GA184700@google.com>
References: <20200530060418.221707-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200530060418.221707-1-ebiggers@kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On 05/29, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> If the dentry name passed to ->d_compare() fits in dentry::d_iname, then
> it may be concurrently modified by a rename.  This can cause undefined
> behavior (possibly out-of-bounds memory accesses or crashes) in
> utf8_strncasecmp(), since fs/unicode/ isn't written to handle strings
> that may be concurrently modified.
> 
> Fix this by first copying the filename to a stack buffer if needed.
> This way we get a stable snapshot of the filename.
> 
> Fixes: 2c2eb7a300cd ("f2fs: Support case-insensitive file name lookups")
> Cc: <stable@vger.kernel.org> # v5.4+
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Daniel Rosenberg <drosen@google.com>
> Cc: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Jaegeuk Kim <jaegeuk@kernel.org>

> ---
>  fs/f2fs/dir.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
> index 44bfc464df787..5c179b72eb8a8 100644
> --- a/fs/f2fs/dir.c
> +++ b/fs/f2fs/dir.c
> @@ -1083,6 +1083,7 @@ static int f2fs_d_compare(const struct dentry *dentry, unsigned int len,
>  	struct qstr qstr = {.name = str, .len = len };
>  	const struct dentry *parent = READ_ONCE(dentry->d_parent);
>  	const struct inode *inode = READ_ONCE(parent->d_inode);
> +	char strbuf[DNAME_INLINE_LEN];
>  
>  	if (!inode || !IS_CASEFOLDED(inode)) {
>  		if (len != name->len)
> @@ -1090,6 +1091,22 @@ static int f2fs_d_compare(const struct dentry *dentry, unsigned int len,
>  		return memcmp(str, name->name, len);
>  	}
>  
> +	/*
> +	 * If the dentry name is stored in-line, then it may be concurrently
> +	 * modified by a rename.  If this happens, the VFS will eventually retry
> +	 * the lookup, so it doesn't matter what ->d_compare() returns.
> +	 * However, it's unsafe to call utf8_strncasecmp() with an unstable
> +	 * string.  Therefore, we have to copy the name into a temporary buffer.
> +	 */
> +	if (len <= DNAME_INLINE_LEN - 1) {
> +		unsigned int i;
> +
> +		for (i = 0; i < len; i++)
> +			strbuf[i] = READ_ONCE(str[i]);
> +		strbuf[len] = 0;
> +		qstr.name = strbuf;
> +	}
> +
>  	return f2fs_ci_compare(inode, name, &qstr, false);
>  }
>  
> -- 
> 2.26.2
