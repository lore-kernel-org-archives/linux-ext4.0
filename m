Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 403D1C32772
	for <linux-ext4@archiver.kernel.org>; Tue, 23 Aug 2022 12:56:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243268AbiHWM4X (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 23 Aug 2022 08:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243336AbiHWMzy (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Aug 2022 08:55:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F09F37B7BE
        for <linux-ext4@vger.kernel.org>; Tue, 23 Aug 2022 03:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661248826;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fSKjEkPwBNECJWm8x7JSs95bpa+IJORUywN0gdEUTNA=;
        b=Gfpmc78Wpq5RGlOJM1wF5SfWppeL2I2dqzbvJnrattYfDtR/mJozJFJHjHfnj/AmXDlhjG
        iXWA/GXrxrriVbQkSY9PQz8hfQ29gvFmM2G4uAxTwOa9wyq0bcNhztifen6oc2J3YS1rFC
        0BGtRAxVH2y0gb7mcyyy0kC7ohRTeeM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-217-OJwysFzpPuicEiN_cP8fhA-1; Tue, 23 Aug 2022 06:00:22 -0400
X-MC-Unique: OJwysFzpPuicEiN_cP8fhA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 798023C0D854;
        Tue, 23 Aug 2022 10:00:22 +0000 (UTC)
Received: from fedora (unknown [10.40.193.45])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8920F40D2830;
        Tue, 23 Aug 2022 10:00:21 +0000 (UTC)
Date:   Tue, 23 Aug 2022 12:00:19 +0200
From:   Lukas Czerner <lczerner@redhat.com>
To:     Jan Kara <jack@suse.cz>
Cc:     Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Salvatore Bonaccorso <carnil@debian.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] ext4: Fix check for block being out of directory size
Message-ID: <20220823100019.wukhx7a6bul4isjl@fedora>
References: <20220822114832.1482-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220822114832.1482-1-jack@suse.cz>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Aug 22, 2022 at 01:48:32PM +0200, Jan Kara wrote:
> The check in __ext4_read_dirblock() for block being outside of directory
> size was wrong because it compared block number against directory size
> in bytes. Fix it.

Good catch, thanks!

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

> 
> Fixes: 65f8ea4cd57d ("ext4: check if directory block is within i_size")
> CVE: CVE-2022-1184
> CC: stable@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/namei.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 3a31b662f661..bc2e0612ec32 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -126,7 +126,7 @@ static struct buffer_head *__ext4_read_dirblock(struct inode *inode,
>  	struct ext4_dir_entry *dirent;
>  	int is_dx_block = 0;
>  
> -	if (block >= inode->i_size) {
> +	if (block >= inode->i_size >> inode->i_blkbits) {
>  		ext4_error_inode(inode, func, line, block,
>  		       "Attempting to read directory block (%u) that is past i_size (%llu)",
>  		       block, inode->i_size);
> -- 
> 2.35.3
> 

