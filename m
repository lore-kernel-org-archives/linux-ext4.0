Return-Path: <SRS0=5zRl=EN=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4F50C4742C
	for <linux-ext4@archiver.kernel.org>; Sat,  7 Nov 2020 03:25:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88474206F4
	for <linux-ext4@archiver.kernel.org>; Sat,  7 Nov 2020 03:25:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbgKGDZm (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 6 Nov 2020 22:25:42 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:38360 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727298AbgKGDZm (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Nov 2020 22:25:42 -0500
Received: from callcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 0A73PP8L003828
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 6 Nov 2020 22:25:26 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 5C2CD420107; Fri,  6 Nov 2020 22:25:25 -0500 (EST)
Date:   Fri, 6 Nov 2020 22:25:25 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Chao Yu <yuchao0@huawei.com>
Cc:     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: add missing file in ext4 entry
Message-ID: <20201107032525.GA2499342@mit.edu>
References: <20201030022435.1136-1-yuchao0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201030022435.1136-1-yuchao0@huawei.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Oct 30, 2020 at 10:24:35AM +0800, Chao Yu wrote:
> include/trace/events/ext4.h belongs to ext4 module, add the file path into
> ext4 entry in MAINTAINERS.
> 
> Signed-off-by: Chao Yu <yuchao0@huawei.com>

Thanks, applied.

					- Ted
