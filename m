Return-Path: <SRS0=Vv4O=SE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD2D3C43381
	for <linux-ext4@archiver.kernel.org>; Tue,  2 Apr 2019 04:11:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A89EB2084C
	for <linux-ext4@archiver.kernel.org>; Tue,  2 Apr 2019 04:11:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M9+C/gUE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbfDBELk (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 2 Apr 2019 00:11:40 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:44600 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725778AbfDBELk (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Apr 2019 00:11:40 -0400
Received: by mail-ot1-f65.google.com with SMTP id d24so10724486otl.11
        for <linux-ext4@vger.kernel.org>; Mon, 01 Apr 2019 21:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=tqhdaoFrqSUIauHdscu4p5O1JmQPM4fuxjVc4qLIJRY=;
        b=M9+C/gUE6okqqiimvwqP4cK4HJv8XqfLwJ0rKX3tD1CoECUoCEPcl6sYnFI8CFDi7N
         45qtKkhFI6cOp4yKX3B5OICjeaBYadwQJl7zZEUKfvxUDljS9/5CwI3ODhrKlT1wPZtg
         DMu0rVINCJgZLb8YTYiuxayY6FewRxITwNWDt6Y7c+LWDAzY8EiRPUA0cHyedJZ9oT5q
         ir4fgscyTtlGYzDYv97u7/Z9MYda172iLS5mckD3XleXq/v+uFjzdjkm+H9l9CffXo7j
         ks8iw7uCoyJMa+xXnncld585KbvACK9nXbmDYUnMCX0po95wJ/IcUPqicc7usVfcN7NS
         SpEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=tqhdaoFrqSUIauHdscu4p5O1JmQPM4fuxjVc4qLIJRY=;
        b=dXIZFEXuUF4ksdw59Vdy22O5seue7N3EUZ+5XK1j/NT1iwn/geo4BxH9VUfxCtm3Sc
         ai7/eNf/AvAdwNAfDpfsya43haG26t8H8RN1AOmQi0QRdIuApBnsJce/lL548l4IM2Gm
         3l6lrBTCLD7Y3dbPjwk2u7ed9sY+LTUuvRxgkLV9DMmHfO92+iPArHVLTCkowf/vLMeS
         QengLMuxSqghFn/wMXNQB6/WREXeekVQ4A5U1mkMz/KBwj2sJxTSlsGwgdOp+ULP4Alz
         52sfJsEWQ9lWC5puOlxotNbCP/gjEKpkI3sruPC7yfTh8kmAsXmulA3Si2btuxugRJmC
         Ch/Q==
X-Gm-Message-State: APjAAAWbChwf+Y5Oz2iwol+SykuKmV15AlJ4KiIA66//S65YtAbuHZ/R
        Lz8tNh2Ya/p9sLuF4McE8AU=
X-Google-Smtp-Source: APXvYqy7Wwn/KEW83DZddHovyPkivaWWyQORNpksdsB27L/k+vs5PUffiXLyuLgn46n8oQJV3WxIag==
X-Received: by 2002:a9d:7d06:: with SMTP id v6mr14783772otn.187.1554178299356;
        Mon, 01 Apr 2019 21:11:39 -0700 (PDT)
Received: from ali-186590e05fa3.local ([205.204.117.4])
        by smtp.gmail.com with ESMTPSA id o1sm5778849otj.11.2019.04.01.21.11.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Apr 2019 21:11:38 -0700 (PDT)
Subject: Re: [PATCH v2] jbd2: check superblock mapped prior to committing
To:     Jiufei Xue <jiufei.xue@linux.alibaba.com>,
        linux-ext4@vger.kernel.org
Cc:     tytso@mit.edu, jack@suse.cz, renzhen@linux.alibaba.com
References: <20190328100750.71045-1-jiufei.xue@linux.alibaba.com>
From:   Jiufei Xue <xuejiufei@gmail.com>
Message-ID: <a406d83f-78a1-7f32-6ddb-9ec9df7a05ab@gmail.com>
Date:   Tue, 2 Apr 2019 12:11:33 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190328100750.71045-1-jiufei.xue@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi Ted,

can I get your Acked-by?

Thanks,
Jiufei

On 2019/3/28 下午6:07, Jiufei Xue wrote:
> We hit a BUG at fs/buffer.c:3057 if we detached the nbd device
> before unmounting ext4 filesystem.
>
> The typical chain of events leading to the BUG:
> jbd2_write_superblock
>   submit_bh
>     submit_bh_wbc
>       BUG_ON(!buffer_mapped(bh));
>
> The block device is removed and all the pages are invalidated. JBD2
> was trying to write journal superblock to the block device which is
> no longer present.
>
> Fix this by checking the journal superblock's buffer head prior to
> submitting.
>
> Cc: stable@kernel.org
> Reported-by: Eric Ren <renzhen@linux.alibaba.com>
> Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> ---
>  fs/jbd2/journal.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 382c030cc78b..37e16d969925 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -1350,6 +1350,10 @@ static int jbd2_write_superblock(journal_t *journal, int write_flags)
>  	journal_superblock_t *sb = journal->j_superblock;
>  	int ret;
>  
> +	/* Buffer got discarded which means block device got invalidated */
> +	if (!buffer_mapped(bh))
> +		return -EIO;
> +
>  	trace_jbd2_write_superblock(journal, write_flags);
>  	if (!(journal->j_flags & JBD2_BARRIER))
>  		write_flags &= ~(REQ_FUA | REQ_PREFLUSH);
