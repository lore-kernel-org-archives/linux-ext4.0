Return-Path: <SRS0=fczw=RS=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7709C43381
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Mar 2019 03:38:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 976552186A
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Mar 2019 03:38:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbfCODib (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 14 Mar 2019 23:38:31 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:59889 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726708AbfCODib (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Mar 2019 23:38:31 -0400
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x2F3cL8e024076
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Mar 2019 23:38:22 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 70B7B420AA8; Thu, 14 Mar 2019 23:38:21 -0400 (EDT)
Date:   Thu, 14 Mar 2019 23:38:21 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Lukas Czerner <lczerner@redhat.com>
Cc:     linux-ext4@vger.kernel.org, Frank Sorenson <fsorenso@redhat.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] ext4: Fix data corruption caused by unaligned direct AIO
Message-ID: <20190315033821.GC11334@mit.edu>
References: <20190306110642.11804-1-lczerner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190306110642.11804-1-lczerner@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Mar 06, 2019 at 12:06:42PM +0100, Lukas Czerner wrote:
> Ext4 needs to serialize unaligned direct AIO because the zeroing of
> partial blocks of two competing unaligned AIOs can result in data
> corruption.
> 
> However it decides not to serialize if the potentially unaligned aio is
> past i_size with the rationale that no pending writes are possible past
> i_size. Unfortunately if the i_size is not block aligned and the second
> unaligned write lands past i_size, but still into the same block, it has
> the potential of corrupting the previous unaligned write to the same
> block.
> 
> This is (very simplified) reproducer from Frank
> 
>     // 41472 = (10 * 4096) + 512
>     // 37376 = 41472 - 4096
> 
>     ftruncate(fd, 41472);
>     io_prep_pwrite(iocbs[0], fd, buf[0], 4096, 37376);
>     io_prep_pwrite(iocbs[1], fd, buf[1], 4096, 41472);
> 
>     io_submit(io_ctx, 1, &iocbs[1]);
>     io_submit(io_ctx, 1, &iocbs[2]);
> 
>     io_getevents(io_ctx, 2, 2, events, NULL);
> 
> Without this patch the 512B range from 40960 up to the start of the
> second unaligned write (41472) is going to be zeroed overwriting the data
> written by the first write. This is a data corruption.
> 
> 00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
> *
> 00009200  30 30 30 30 30 30 30 30  30 30 30 30 30 30 30 30
> *
> 0000a000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
> *
> 0000a200  31 31 31 31 31 31 31 31  31 31 31 31 31 31 31 31
> 
> With this patch the data corruption is avoided because we will recognize
> the unaligned_aio and wait for the unwritten extent conversion.
> 
> 00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
> *
> 00009200  30 30 30 30 30 30 30 30  30 30 30 30 30 30 30 30
> *
> 0000a200  31 31 31 31 31 31 31 31  31 31 31 31 31 31 31 31
> *
> 0000b200
> 
> Reported-by: Frank Sorenson <fsorenso@redhat.com>
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Fixes: e9e3bcecf44c ("ext4: serialize unaligned asynchronous DIO")
> Cc: <stable@vger.kernel.org>

Thanks, applied.

					- Ted
