Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B47EC433B4
	for <linux-ext4@archiver.kernel.org>; Fri,  7 May 2021 22:50:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FF9061003
	for <linux-ext4@archiver.kernel.org>; Fri,  7 May 2021 22:50:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbhEGWvC (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 7 May 2021 18:51:02 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:40293 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229470AbhEGWvB (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 7 May 2021 18:51:01 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 147Mntd2018763
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 7 May 2021 18:49:55 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id F414015C39BD; Fri,  7 May 2021 18:49:54 -0400 (EDT)
Date:   Fri, 7 May 2021 18:49:54 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Artem Blagodarenko <artem.blagodarenko@gmail.com>
Cc:     linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca,
        Alexey Lyashkov <c17817@cray.com>,
        Artem Blagodarenko <c17828@cray.com>
Subject: Re: [PATCH] e2image: fix overflow in l2 table processing
Message-ID: <YJXEEhxkGdMEdRGQ@mit.edu>
References: <20210422052448.29802-1-artem.blagodarenko@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210422052448.29802-1-artem.blagodarenko@gmail.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Apr 22, 2021 at 01:24:48AM -0400, Artem Blagodarenko wrote:
> For a large partition during e2image capture process
> it is possible to overflow offset at multiply operation.
> This leads to the situation when data is written to the
> position at the start of the image instead of the image end.
> 
> Let's use the right cast to avoid integer overflow.
> 
> Signed-off-by: Alexey Lyashkov <c17817@cray.com>
> Signed-off-by: Artem Blagodarenko <c17828@cray.com>
> HPE-bug-id: LUS-9368

Thanks, applied.

					- Ted
