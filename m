Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C9FDC71155
	for <linux-ext4@archiver.kernel.org>; Wed,  2 Dec 2020 18:48:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 424D72173E
	for <linux-ext4@archiver.kernel.org>; Wed,  2 Dec 2020 18:48:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389264AbgLBSs4 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 2 Dec 2020 13:48:56 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:54042 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387582AbgLBSs4 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Dec 2020 13:48:56 -0500
Received: from callcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 0B2Im7HG014760
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 2 Dec 2020 13:48:08 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id A9059420136; Wed,  2 Dec 2020 13:48:07 -0500 (EST)
Date:   Wed, 2 Dec 2020 13:48:07 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH 08/15] e2fsck: add fast commit setup code
Message-ID: <20201202184807.GL390058@mit.edu>
References: <20201120191606.2224881-1-harshadshirwadkar@gmail.com>
 <20201120191606.2224881-9-harshadshirwadkar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201120191606.2224881-9-harshadshirwadkar@gmail.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Nov 20, 2020 at 11:15:59AM -0800, Harshad Shirwadkar wrote:
> Add fast_commit.h that contains the necessary helpers needed for fast
> commit replay. Note that this file is also byte by byte identical with
> kernel's fast_commit.h. Also, we introduce the
> "e2fsck_fc_replay_state" structure which is needed for ext4 fast
> commit replay.
> 
> Signed-off-by: Harshad Shirwadkar <harshadshirwadkar@gmail.com>

Looks good,

Reviewed-by: Theodore Ts'o <tytso@mit.edu>
