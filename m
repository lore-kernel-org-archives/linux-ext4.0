Return-Path: <SRS0=bqz9=Q2=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2461DC43381
	for <linux-ext4@archiver.kernel.org>; Tue, 19 Feb 2019 23:26:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E769F21738
	for <linux-ext4@archiver.kernel.org>; Tue, 19 Feb 2019 23:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550618813;
	bh=POpGdhA3InWYsydyS1/MuKX26HVGkEYqOR+ifJS8UAE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=ZE28sZBIejQPonnmm+EP+RNY5tEwdvRNgfqnTwgF407YzYtSkh4buIAmlWRNzt3sx
	 9jqVfIkT6ZdeeJnJfeGO4pco647YjNnZ717EyrQU+HFTHtAdfu4GlmeUqsMSwfgh+H
	 aeGYyceL7KRQo6OemfOzQBbtNxDtYRmNLKQoXqF8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728409AbfBSX0w (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 19 Feb 2019 18:26:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:34624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726405AbfBSX0w (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 19 Feb 2019 18:26:52 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55F782147A;
        Tue, 19 Feb 2019 23:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550618811;
        bh=POpGdhA3InWYsydyS1/MuKX26HVGkEYqOR+ifJS8UAE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AlQqGNdAUMeV8vXnrT8N4Hsn+0RG4C6lc6aze+vAo4z8zQntG+XJBF/AmDUrf/Mcl
         /01sTCuu2Unw1GPfPJqgtL3n5GjETrrg31TfvpKSuUvYGSGJIDNlHFfe+vSbnZkaf9
         KVCa6LlKwRQIiSzasx8di5hStWGztPcTRdIjVcJM=
Date:   Tue, 19 Feb 2019 15:26:49 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Chandan Rajendra <chandan@linux.ibm.com>
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, jaegeuk@kernel.org
Subject: Re: [f2fs-dev] [RFC PATCH 05/10] fsverity: Add call back to decide
 if verity check has to be performed
Message-ID: <20190219232649.GF12177@gmail.com>
References: <20190218100433.20048-1-chandan@linux.ibm.com>
 <20190218100433.20048-6-chandan@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190218100433.20048-6-chandan@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi Chandan,

On Mon, Feb 18, 2019 at 03:34:28PM +0530, Chandan Rajendra wrote:
> Ext4 and F2FS store verity metadata in data extents (beyond
> inode->i_size) associated with a file. But other filesystems might
> choose alternative means to store verity metadata. Hence this commit
> adds a callback function pointer to 'struct fsverity_operations' to help
> in deciding if verity operation needs to performed against a page-cache
> page holding file data.
> 
> Signed-off-by: Chandan Rajendra <chandan@linux.ibm.com>
> ---
>  fs/ext4/super.c          | 9 +++++++++
>  fs/post_read_process.c   | 5 +++--
>  include/linux/fsverity.h | 1 +
>  3 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 9314dddfbf34..2d7781ab6824 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1428,10 +1428,19 @@ static struct page *ext4_read_verity_metadata_page(struct inode *inode,
>  	return read_mapping_page(inode->i_mapping, index, NULL);
>  }
>  
> +static bool ext4_verity_required(struct inode *inode, pgoff_t index)
> +{
> +	if (index < ((i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT))
> +		return true;
> +	else
> +		return false;
> +}

This can be simplified to:

	return index < (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;

> +
>  static const struct fsverity_operations ext4_verityops = {
>  	.set_verity		= ext4_set_verity,
>  	.get_metadata_end	= ext4_get_verity_metadata_end,
>  	.read_metadata_page	= ext4_read_verity_metadata_page,
> +	.verity_required	= ext4_verity_required,
>  };
>  #endif /* CONFIG_FS_VERITY */

Doesn't f2fs need this too?  This patch only changes ext4.

>  
> diff --git a/fs/post_read_process.c b/fs/post_read_process.c
> index 9720eeff0160..1f8663d70247 100644
> --- a/fs/post_read_process.c
> +++ b/fs/post_read_process.c
> @@ -79,8 +79,9 @@ struct bio_post_read_ctx *get_bio_post_read_ctx(struct inode *inode,
>  	if (IS_ENCRYPTED(inode) && S_ISREG(inode->i_mode))
>  		post_read_steps |= 1 << STEP_DECRYPT;
>  #ifdef CONFIG_FS_VERITY
> -	if (inode->i_verity_info != NULL &&
> -		(index < ((i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT)))
> +	if (inode->i_verity_info != NULL
> +		&& inode->i_sb->s_vop->verity_required
> +		&& inode->i_sb->s_vop->verity_required(inode, index))
>  		post_read_steps |= 1 << STEP_VERITY;

If ->verity_required is NULL, shouldn't that be equivalent to
->verity_required() returning true?

>  #endif
>  	if (post_read_steps) {
> diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
> index 7c33b42abf1b..b83712d6c79a 100644
> --- a/include/linux/fsverity.h
> +++ b/include/linux/fsverity.h
> @@ -18,6 +18,7 @@ struct fsverity_operations {
>  	int (*set_verity)(struct inode *inode, loff_t data_i_size);
>  	int (*get_metadata_end)(struct inode *inode, loff_t *metadata_end_ret);
>  	struct page *(*read_metadata_page)(struct inode *inode, pgoff_t index);
> +	bool (*verity_required)(struct inode *inode, pgoff_t index);
>  };
>  
>  #ifdef CONFIG_FS_VERITY
> -- 
> 2.19.1
> 

- Eric
