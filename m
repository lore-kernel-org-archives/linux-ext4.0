Return-Path: <SRS0=xo2J=Q3=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 122F6C43381
	for <linux-ext4@archiver.kernel.org>; Wed, 20 Feb 2019 00:35:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9D3E21773
	for <linux-ext4@archiver.kernel.org>; Wed, 20 Feb 2019 00:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550622910;
	bh=DoDSSXimdGnYd1I3HUBRoWytUw/pdr0NyGTPDovoQFg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=LJ5mQbGnwQgKaNSHCFFcc11sAV4mMPbXz5FTsbmWwIfnSvrCTtenMiIbFn4ZtRlGx
	 iXs7HNpNfLbR2oMU/KmIkxt9WikHbr/PRpIY/QeF7TiqPGeBu71+nZ1F7TEkGw37rW
	 UTW6tulw6ZYs+NwtNtNfjS49o/nbMwtC1GzLKaWg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730019AbfBTAfK (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 19 Feb 2019 19:35:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:59990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728290AbfBTAfK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 19 Feb 2019 19:35:10 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 606A821738;
        Wed, 20 Feb 2019 00:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550622909;
        bh=DoDSSXimdGnYd1I3HUBRoWytUw/pdr0NyGTPDovoQFg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RmusjfPGMSCZOQNUdu2DYiW4mYjPGZPDh79GB+GkJNEmb+sgbebjztvjslfLeiyYe
         moyOlheSHPkJyLly+dbp1VtVMKPrSWsY8WEPFCkld7tL92VQE0HLaJUy3NayL6rIL4
         aXoRnA795dRniNeQEiNRESqV38PWiIXimv/CHEt4=
Date:   Tue, 19 Feb 2019 16:35:07 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Chandan Rajendra <chandan@linux.ibm.com>
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, jaegeuk@kernel.org, yuchao0@huawei.com
Subject: Re: [RFC PATCH 08/10] fsverity: Add call back to verify file holes
Message-ID: <20190220003507.GH12177@gmail.com>
References: <20190218100433.20048-1-chandan@linux.ibm.com>
 <20190218100433.20048-9-chandan@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190218100433.20048-9-chandan@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Feb 18, 2019 at 03:34:31PM +0530, Chandan Rajendra wrote:
> readpage() implmentations zero out part of the page-cache page mapping a
> file hole. This commit adds a call back to "struct fsverity_operations"
> which readpage() can invoke to verify the file hole.

I don't see why this is needed.  Since now CONFIG_FS_VERITY will be a bool,
can't you just call fsverity_verify_hole() directly?

> 
> Signed-off-by: Chandan Rajendra <chandan@linux.ibm.com>
> ---
>  fs/ext4/super.c          | 1 +
>  include/linux/fsverity.h | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 4493ddc357c6..94e0d4b56653 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1459,6 +1459,7 @@ static const struct fsverity_operations ext4_verityops = {
>  	.read_metadata_page	= ext4_read_verity_metadata_page,
>  	.verity_required	= ext4_verity_required,
>  	.readpage_limit		= ext4_readpage_limit,
> +	.check_hole		= fsverity_check_hole,
>  };
>  #endif /* CONFIG_FS_VERITY */
>  
> diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
> index fc8113acbbfe..8bc28b07d550 100644
> --- a/include/linux/fsverity.h
> +++ b/include/linux/fsverity.h
> @@ -20,6 +20,7 @@ struct fsverity_operations {
>  	struct page *(*read_metadata_page)(struct inode *inode, pgoff_t index);
>  	bool (*verity_required)(struct inode *inode, pgoff_t index);
>  	loff_t (*readpage_limit)(struct inode *inode);
> +	bool (*check_hole)(struct inode *inode, struct page *page);
>  };
>  
>  #ifdef CONFIG_FS_VERITY
> -- 
> 2.19.1
> 
