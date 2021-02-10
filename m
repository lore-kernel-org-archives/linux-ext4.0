Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 916C3C433E6
	for <linux-ext4@archiver.kernel.org>; Wed, 10 Feb 2021 18:05:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5137564DB1
	for <linux-ext4@archiver.kernel.org>; Wed, 10 Feb 2021 18:05:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233625AbhBJSEq (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 10 Feb 2021 13:04:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:54356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233736AbhBJSCS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 10 Feb 2021 13:02:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C52B064DB1;
        Wed, 10 Feb 2021 18:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612980097;
        bh=Iudm1YPyBEuC3zsZbxFFEccmpFqohJdXbI1ik4Yv3hA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pPiT+PDAgEjsKzfsSkjSdc3SyTSYJczkvJZfDsvbkTjdsAappNeeowXVDm7c1ZfmW
         3NgRp/xNq9/vvx0MDSPwae/Pfwez3sdYXSGjB0mCQkXM9WpavXDncCN6o2jipPHrkh
         pPEd180S5qsSzBPfz3fKC18D0hy77ZQxdyct1n52BN5I8khJ6pUwIDDeMNWPNTSyHP
         vOcM8LkFe/dcdgCmlMesbTdwTfCCAbI+C7qAlMPOm0Ji98dsDjtzuQc6XBV4RIX068
         d57a0sEgyuKYO3ED/HADo5fFMtpOHocdukCHHQdd6AMMhsflHe5N6qXPTVqUly+fme
         RzYAo2VodoOwA==
Date:   Wed, 10 Feb 2021 10:01:35 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Cc:     linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, axboe@kernel.dk, tytso@mit.edu,
        adilger.kernel@dilger.ca, jaegeuk@kernel.org, chao@kernel.org,
        johannes.thumshirn@wdc.com, damien.lemoal@wdc.com,
        bvanassche@acm.org, dongli.zhang@oracle.com, clm@fb.com,
        ira.weiny@intel.com, dsterba@suse.com, hch@infradead.org,
        dave.hansen@intel.com
Subject: Re: [RFC PATCH 8/8] f2fs: use memcpy_to_page() in pagecache_write()
Message-ID: <YCQff/XYAqDUXhhQ@sol.localdomain>
References: <20210207190425.38107-1-chaitanya.kulkarni@wdc.com>
 <20210207190425.38107-9-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210207190425.38107-9-chaitanya.kulkarni@wdc.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sun, Feb 07, 2021 at 11:04:25AM -0800, Chaitanya Kulkarni wrote:
> Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>

No explanation in commit message?  There isn't much explanation needed for this,
but there should be at least one sentence.

Likewise for the other patches.

>  fs/f2fs/verity.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/fs/f2fs/verity.c b/fs/f2fs/verity.c
> index 44e057bdc416..ca019685a944 100644
> --- a/fs/f2fs/verity.c
> +++ b/fs/f2fs/verity.c
> @@ -79,7 +79,6 @@ static int pagecache_write(struct inode *inode, const void *buf, size_t count,
>  				 PAGE_SIZE - offset_in_page(pos));
>  		struct page *page;
>  		void *fsdata;
> -		void *addr;
>  		int res;
>  
>  		res = pagecache_write_begin(NULL, inode->i_mapping, pos, n, 0,
> @@ -87,9 +86,7 @@ static int pagecache_write(struct inode *inode, const void *buf, size_t count,
>  		if (res)
>  			return res;
>  
> -		addr = kmap_atomic(page);
> -		memcpy(addr + offset_in_page(pos), buf, n);
> -		kunmap_atomic(addr);
> +		memcpy_to_page(page, offset_in_page(pos) buf, n);

This is missing a comma between 'offset_in_page(pos)' and 'buf'.

Otherwise the patches to fs/{ext4,f2fs}/verity.c look fine; thanks for doing
this!

- Eric
