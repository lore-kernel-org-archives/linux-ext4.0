Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF68FC4332F
	for <linux-ext4@archiver.kernel.org>; Mon, 21 Nov 2022 19:52:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbiKUTw1 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 21 Nov 2022 14:52:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiKUTwY (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Nov 2022 14:52:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66504D39DC;
        Mon, 21 Nov 2022 11:52:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A5F261457;
        Mon, 21 Nov 2022 19:52:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3593CC433C1;
        Mon, 21 Nov 2022 19:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669060343;
        bh=e3ckNQ3AIoADAgf/ebPYYoIm7JZ0SGqlrtn9J2k3xWQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WVT4pmRQyclkI9wj3E0sS0TMkksmSbkkQqj66ikyHbwPoFKShZspYh3gjOUXrIVkZ
         2T5hY3fRA2FrEdkg5Ba9oeUbylKKPFeBQ1mEnh/tk+MakYyUC0d0Sjq3QFOxKqWkQh
         doaNEiGEUMTR6OB0HxAMCDlO5kUfhujQQm4S1iPL2uCP+7bQYd+u0LrEvpwjEczRce
         dIKCxAmWSSxBdveRpnjHXK3wETuCajOfXlb4dOnLstiCoubTitlxPk9l8ua8cSGc7W
         Jt+Tef4yqhp/ZdE19AYHBXoUsqKX7RhRiZTmrHrDSahzG7jiS3ElENnng4xtP3Lop7
         Bzd4v4Db3luag==
Date:   Mon, 21 Nov 2022 19:52:21 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Alexander Potapenko <glider@google.com>
Cc:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        tytso@mit.edu, adilger.kernel@dilger.ca, jaegeuk@kernel.org,
        chao@kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        syzbot+9767be679ef5016b6082@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/5] fs: ext4: initialize fsdata in pagecache_write()
Message-ID: <Y3vW9Q8HVQth2Sz4@gmail.com>
References: <20221121112134.407362-1-glider@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221121112134.407362-1-glider@google.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Nov 21, 2022 at 12:21:30PM +0100, Alexander Potapenko wrote:
> When aops->write_begin() does not initialize fsdata, KMSAN reports
> an error passing the latter to aops->write_end().
> 
> Fix this by unconditionally initializing fsdata.
> 
> Cc: Eric Biggers <ebiggers@kernel.org>
> Fixes: c93d8f885809 ("ext4: add basic fs-verity support")
> Reported-by: syzbot+9767be679ef5016b6082@syzkaller.appspotmail.com
> Signed-off-by: Alexander Potapenko <glider@google.com>
> ---
>  fs/ext4/verity.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/verity.c b/fs/ext4/verity.c
> index 3c640bd7ecaeb..30e3b65798b50 100644
> --- a/fs/ext4/verity.c
> +++ b/fs/ext4/verity.c
> @@ -79,7 +79,7 @@ static int pagecache_write(struct inode *inode, const void *buf, size_t count,
>  		size_t n = min_t(size_t, count,
>  				 PAGE_SIZE - offset_in_page(pos));
>  		struct page *page;
> -		void *fsdata;
> +		void *fsdata = NULL;
>  		int res;
>  
>  		res = aops->write_begin(NULL, mapping, pos, n, &page, &fsdata);

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
