Return-Path: <SRS0=FVYV=BR=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A327FC433E0
	for <linux-ext4@archiver.kernel.org>; Fri,  7 Aug 2020 17:59:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83B132086A
	for <linux-ext4@archiver.kernel.org>; Fri,  7 Aug 2020 17:59:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgHGR7m (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 7 Aug 2020 13:59:42 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:39286 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725934AbgHGR7m (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Aug 2020 13:59:42 -0400
Received: from callcc.thunk.org (pool-96-230-252-158.bstnma.fios.verizon.net [96.230.252.158])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 077HxOfg005715
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 7 Aug 2020 13:59:25 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 86684420263; Fri,  7 Aug 2020 13:59:24 -0400 (EDT)
Date:   Fri, 7 Aug 2020 13:59:24 -0400
From:   tytso@mit.edu
To:     "zhangyi (F)" <yi.zhang@huawei.com>
Cc:     <linux-ext4@vger.kernel.org>, <jack@suse.cz>,
        <adilger.kernel@dilger.ca>, <zhangxiaoxu5@huawei.com>,
        <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v3 4/5] jbd2: abort journal if free a async write error
 metadata buffer
Message-ID: <20200807175924.GX7657@mit.edu>
References: <20200620025427.1756360-1-yi.zhang@huawei.com>
 <20200620025427.1756360-5-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200620025427.1756360-5-yi.zhang@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sat, Jun 20, 2020 at 10:54:26AM +0800, zhangyi (F) wrote:
> If we free a metadata buffer which has been failed to async write out
> in the background, the jbd2 checkpoint procedure will not detect this
> failure in jbd2_log_do_checkpoint(), so it may lead to filesystem
> inconsistency after cleanup journal tail. This patch abort the journal
> if free a buffer has write_io_error flag to prevent potential further
> inconsistency.
> 
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>

Thanks, applied.

					- Ted
