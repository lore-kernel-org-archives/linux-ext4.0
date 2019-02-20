Return-Path: <SRS0=xo2J=Q3=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56A55C43381
	for <linux-ext4@archiver.kernel.org>; Wed, 20 Feb 2019 00:21:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23C432147A
	for <linux-ext4@archiver.kernel.org>; Wed, 20 Feb 2019 00:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550622064;
	bh=8jAL+i/Xw4E/DoMBjFlCXfus2xR1vOVXl7Qqb5+987s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=SYxLxY7qafHonKux+jCkhgbc5OBLFGGfkIOE+vUWE909QZ5bcQ1jyX+IcLuZiUCZJ
	 zYai+uv06rsavSp3yDlsrXuUNVnB6Qls9rKDSOEJ2MhStdkSmlYqV7QFu+9r1F6VyA
	 MIKbfGz7B4jcsr3AwVHGQNlqsi1lXHhzSKRnBtiI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729092AbfBTAVD (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 19 Feb 2019 19:21:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:54110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727476AbfBTAVD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 19 Feb 2019 19:21:03 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5EEF20855;
        Wed, 20 Feb 2019 00:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550622061;
        bh=8jAL+i/Xw4E/DoMBjFlCXfus2xR1vOVXl7Qqb5+987s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s7xt0CyWARUJ7rEDvfMwZpDqgu0h8U6ZeqW+r5dJG1ap2yN/qSdDLAOX81ZfGkw9P
         WuPHuQW+HpLkmn+lUCSEufyvs8XmQmiH/X3egeZs4kaK053E0HbpHxqcM3GU7K6Ht4
         Oemxhh+q2u+QeU9PJEz8HSqpguhNXsogUJhXqcFA=
Date:   Tue, 19 Feb 2019 16:21:00 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Chandan Rajendra <chandan@linux.ibm.com>
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, jaegeuk@kernel.org
Subject: Re: [f2fs-dev] [RFC PATCH 06/10] Introduce REQ_POST_READ_PROC bio
 flag
Message-ID: <20190220002059.GG12177@gmail.com>
References: <20190218100433.20048-1-chandan@linux.ibm.com>
 <20190218100433.20048-7-chandan@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190218100433.20048-7-chandan@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi Chandan,

On Mon, Feb 18, 2019 at 03:34:29PM +0530, Chandan Rajendra wrote:
> Ext4 and F2FS currently use a non-NULL value stored at bio->bi_private
> to determine if the contents of the bio need to be "post processed"
> i.e. whether its contents need to be decrypted and/or verified. For
> block size < page size scenario, bio->bi_private would hold a pointer to
> buffer_head. Hence, this commit adds the new flag REQ_POST_READ_PROC to
> be able to decisively check for post process requirement for a bio.
> 
> Signed-off-by: Chandan Rajendra <chandan@linux.ibm.com>
> ---
>  fs/ext4/readpage.c        | 11 +++++++++--
>  fs/post_read_process.c    |  2 +-
>  include/linux/blk_types.h |  2 ++
>  3 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/readpage.c b/fs/ext4/readpage.c
> index 8943fc41fd33..c7dbab35deaa 100644
> --- a/fs/ext4/readpage.c
> +++ b/fs/ext4/readpage.c
> @@ -245,6 +245,7 @@ int ext4_mpage_readpages(struct address_space *mapping,
>  		}
>  		if (bio == NULL) {
>  			struct bio_post_read_ctx *ctx;
> +			unsigned int op_flags = 0;
>  
>  			bio = bio_alloc(GFP_KERNEL,
>  				min_t(int, nr_pages, BIO_MAX_PAGES));
> @@ -259,8 +260,14 @@ int ext4_mpage_readpages(struct address_space *mapping,
>  			bio->bi_iter.bi_sector = blocks[0] << (blkbits - 9);
>  			bio->bi_end_io = mpage_end_io;
>  			bio->bi_private = ctx;
> -			bio_set_op_attrs(bio, REQ_OP_READ,
> -						is_readahead ? REQ_RAHEAD : 0);
> +
> +			if (is_readahead)
> +				op_flags |= REQ_RAHEAD;
> +
> +			if (ctx)
> +				op_flags |= REQ_POST_READ_PROC;
> +
> +			bio_set_op_attrs(bio, REQ_OP_READ, op_flags);
>  		}
>  
>  		length = first_hole << blkbits;
> diff --git a/fs/post_read_process.c b/fs/post_read_process.c
> index 1f8663d70247..66c1c6e57e70 100644
> --- a/fs/post_read_process.c
> +++ b/fs/post_read_process.c
> @@ -104,7 +104,7 @@ void put_bio_post_read_ctx(struct bio_post_read_ctx *ctx)
>  
>  bool bio_post_read_required(struct bio *bio)
>  {
> -	return bio->bi_private && !bio->bi_status;
> +	return bio->bi_opf & REQ_POST_READ_PROC;
>  }
>  
>  static int __init bio_init_post_read_processing(void)
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 5c7e7f859a24..6904945c8c40 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -320,6 +320,7 @@ enum req_flag_bits {
>  	__REQ_RAHEAD,		/* read ahead, can fail anytime */
>  	__REQ_BACKGROUND,	/* background IO */
>  	__REQ_NOWAIT,           /* Don't wait if request will block */
> +	__REQ_POST_READ_PROC,
>  
>  	/* command specific flags for REQ_OP_WRITE_ZEROES: */
>  	__REQ_NOUNMAP,		/* do not free blocks when zeroing */
> @@ -346,6 +347,7 @@ enum req_flag_bits {
>  #define REQ_RAHEAD		(1ULL << __REQ_RAHEAD)
>  #define REQ_BACKGROUND		(1ULL << __REQ_BACKGROUND)
>  #define REQ_NOWAIT		(1ULL << __REQ_NOWAIT)
> +#define REQ_POST_READ_PROC	(1ULL << __REQ_POST_READ_PROC)
>  #define REQ_NOUNMAP		(1ULL << __REQ_NOUNMAP)
>  #define REQ_HIPRI		(1ULL << __REQ_HIPRI)
>  
> -- 
> 2.19.1
> 
> 
> 

I don't think this is an appropriate use of a request flag, as request flags are
meant for the block layer.

Also doesn't the bio still need a pointer to the bio_post_read_ctx anyway?  So I
don't see how this would solve the problem, if ->bi_private is already used.

- Eric
