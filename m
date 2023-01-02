Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE64FC3DA7A
	for <linux-ext4@archiver.kernel.org>; Mon,  2 Jan 2023 11:13:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231949AbjABLNH (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 2 Jan 2023 06:13:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231730AbjABLNC (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jan 2023 06:13:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C85AC
        for <linux-ext4@vger.kernel.org>; Mon,  2 Jan 2023 03:12:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672657935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Vffoyq4kjjtDmu0OYi2MsiQ6OLxFuvmce5ViXFa1Msk=;
        b=bhyCz+tz2ucKBULN6/I0rL0uLVadGQsmxA6c4H8r35KN+pI0tokfqEN2Z4KXlUCRfxZBVw
        VJ/6OVYg0NoWKt2K482ejCwni5TJlYuzmSrhXq+UeT9LFhpYET76aRgic2YIlMREHvMB8f
        Cs18Kni/fpJblVvErKzTVBbPHyl6U/A=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-UvpAo1GvPvu2R0hdbvm3Kg-1; Mon, 02 Jan 2023 06:12:09 -0500
X-MC-Unique: UvpAo1GvPvu2R0hdbvm3Kg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B3030380670D;
        Mon,  2 Jan 2023 11:12:08 +0000 (UTC)
Received: from ovpn-193-44.brq.redhat.com (ovpn-193-44.brq.redhat.com [10.40.193.44])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CCB22492D8B;
        Mon,  2 Jan 2023 11:12:07 +0000 (UTC)
Date:   Mon, 2 Jan 2023 12:12:05 +0100
From:   Lukas Czerner <lczerner@redhat.com>
To:     Wang Jianjian <wangjianjian3@huawei.com>
Cc:     linux-ext4@vger.kernel.org, zhangzhikang1@huawei.com,
        wangqiang62@huawei.com, zhengbowen7@huawei.com
Subject: Re: [PATCH 1/1] ext4: Don't show commit interval if it is zero
Message-ID: <20230102111205.5arohyoxw5alkych@ovpn-193-44.brq.redhat.com>
References: <20221219015140.877136-1-wangjianjian3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221219015140.877136-1-wangjianjian3@huawei.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi,

good catch, this is indeed a bug. You could also fix the xfstest ext4/053
which missed this problem.

You can add

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

On Mon, Dec 19, 2022 at 09:51:40AM +0800, Wang Jianjian wrote:
> If commit interval is 0, it means using default value.
> 
> Fixes: 6e47a3cc68fc ("ext4: get rid of super block and sbi from handle_mount_ops()")
> Signed-off-by: Wang Jianjian <wangjianjian3@huawei.com>
> ---
>  fs/ext4/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 16a343e8047d..b93911d80cd9 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -2146,7 +2146,7 @@ static int ext4_parse_param(struct fs_context *fc, struct fs_parameter *param)
>  		return 0;
>  	case Opt_commit:
>  		if (result.uint_32 == 0)
> -			ctx->s_commit_interval = JBD2_DEFAULT_MAX_COMMIT_AGE;
> +			result.uint_32 = JBD2_DEFAULT_MAX_COMMIT_AGE;
>  		else if (result.uint_32 > INT_MAX / HZ) {
>  			ext4_msg(NULL, KERN_ERR,
>  				 "Invalid commit interval %d, "
> -- 
> 2.32.0
> 

