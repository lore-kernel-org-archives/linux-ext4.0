Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E75D4C07E99
	for <linux-ext4@archiver.kernel.org>; Tue,  6 Jul 2021 00:29:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1C81613AA
	for <linux-ext4@archiver.kernel.org>; Tue,  6 Jul 2021 00:29:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbhGFAbh (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 5 Jul 2021 20:31:37 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:47434 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229722AbhGFAbh (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Jul 2021 20:31:37 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 1660SsuN005735
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 5 Jul 2021 20:28:54 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 365A015C3C96; Mon,  5 Jul 2021 20:28:54 -0400 (EDT)
Date:   Mon, 5 Jul 2021 20:28:54 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Michael Forney <mforney@mforney.org>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH 1/2] libext2fs: use statement-expression for container_of
 only on GNU-compatible compilers
Message-ID: <YOOjxsfoOnZHDNA+@mit.edu>
References: <20210414074128.31268-1-mforney@mforney.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210414074128.31268-1-mforney@mforney.org>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Apr 14, 2021 at 12:41:27AM -0700, Michael Forney wrote:
> Functionally, the statement-expression is not necessary here; it
> just gives a bit of type-safety to make sure the pointer really
> does have a compatible type with the specified member of the struct.
> 
> When statement expressions are not available, we can just use a
> portable fallback macro that skips this member type check.
> 
> Signed-off-by: Michael Forney <mforney@mforney.org>

Applied, thanks.

						- Ted
