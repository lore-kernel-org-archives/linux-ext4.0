Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56BEEC4338F
	for <linux-ext4@archiver.kernel.org>; Sat, 14 Aug 2021 14:14:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30CA060F51
	for <linux-ext4@archiver.kernel.org>; Sat, 14 Aug 2021 14:14:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233510AbhHNOPK (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 14 Aug 2021 10:15:10 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:53040 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S232315AbhHNOPI (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 14 Aug 2021 10:15:08 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 17EEEZbg018324
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 14 Aug 2021 10:14:36 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id B103D15C37C1; Sat, 14 Aug 2021 10:14:35 -0400 (EDT)
Date:   Sat, 14 Aug 2021 10:14:35 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: fix fast commit alignment issues
Message-ID: <YRfPyx+xOanN4uWu@mit.edu>
References: <20210811212414.14468-1-harshads@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811212414.14468-1-harshads@google.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Aug 11, 2021 at 02:24:14PM -0700, Harshad Shirwadkar wrote:
> From: Harshad Shirwadkar <harshadshirwadkar@gmail.com>
> 
> This patch ports following fast commit alignment issues merged in
> e2fsprogs to ext4 in kernel:
> 
> https://patchwork.ozlabs.org/project/linux-ext4/list/?series=242554&state=*
> 
> Signed-off-by: Harshad Shirwadkar <harshadshirwadkar@gmail.com>

It appears this patch had landed already in 5.13 as a7ba36bc94f20
("ext4: fix fast commit alignment issues").

Cheers,

						- Ted
