Return-Path: <SRS0=Jip5=BQ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDB5DC433E5
	for <linux-ext4@archiver.kernel.org>; Thu,  6 Aug 2020 11:00:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C856722DA7
	for <linux-ext4@archiver.kernel.org>; Thu,  6 Aug 2020 11:00:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbgHFExv (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 6 Aug 2020 00:53:51 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:44711 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727118AbgHFExu (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Aug 2020 00:53:50 -0400
Received: from callcc.thunk.org (pool-96-230-252-158.bstnma.fios.verizon.net [96.230.252.158])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 0764rYov021458
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 6 Aug 2020 00:53:35 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id AF651420263; Thu,  6 Aug 2020 00:53:34 -0400 (EDT)
Date:   Thu, 6 Aug 2020 00:53:34 -0400
From:   tytso@mit.edu
To:     zhengliang <zhengliang6@huawei.com>
Cc:     <adilger.kernel@dilger.ca>, <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH v2] ext4: lost matching-pair of trace in ext4_truncate
Message-ID: <20200806045334.GD7657@mit.edu>
References: <20200701083027.45996-1-zhengliang6@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701083027.45996-1-zhengliang6@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Jul 01, 2020 at 04:30:27PM +0800, zhengliang wrote:
> It should call trace exit in all return path for ext4_truncate.
> 
> v2:
> It shoule call trace exit in all return path, and add "out_trace" label to avoid the
> multiple copies of the cleanup code in each error case.
>  
> Signed-off-by: zhengliang <zhengliang6@huawei.com>

Thanks, applied.

						- Ted
