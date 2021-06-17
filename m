Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F22BAC2B9F4
	for <linux-ext4@archiver.kernel.org>; Thu, 17 Jun 2021 15:01:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1321613CB
	for <linux-ext4@archiver.kernel.org>; Thu, 17 Jun 2021 15:01:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbhFQPDb (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 17 Jun 2021 11:03:31 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:50125 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S230507AbhFQPDa (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Jun 2021 11:03:30 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 15HF1AHH010114
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Jun 2021 11:01:11 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 7C5AD15C3CBA; Thu, 17 Jun 2021 11:01:10 -0400 (EDT)
Date:   Thu, 17 Jun 2021 11:01:10 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Tian Tao <tiantao6@hisilicon.com>
Cc:     adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v2] ext4: remove set but rewrite variables
Message-ID: <YMtjttGok4hZq821@mit.edu>
References: <1621493752-36890-1-git-send-email-tiantao6@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1621493752-36890-1-git-send-email-tiantao6@hisilicon.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, May 20, 2021 at 02:55:52PM +0800, Tian Tao wrote:
> In the ext4_dx_add_entry function, the at variable is assigned but will
> reset just after “again:” label. So delete the unnecessary assignment.
> this will not chang the logic.
> 
> Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
> Reviewed-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>

Applied, thanks.

					- Ted
