Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE100C4338F
	for <linux-ext4@archiver.kernel.org>; Tue, 10 Aug 2021 14:59:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80B6360F38
	for <linux-ext4@archiver.kernel.org>; Tue, 10 Aug 2021 14:59:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242242AbhHJO7W (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 10 Aug 2021 10:59:22 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:56824 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S239178AbhHJO7W (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Aug 2021 10:59:22 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 17AEwu3q015734
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Aug 2021 10:58:56 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 36BC615C3DD0; Tue, 10 Aug 2021 10:58:56 -0400 (EDT)
Date:   Tue, 10 Aug 2021 10:58:56 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Lukas Czerner <lczerner@redhat.com>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH 1/7] e2fsck: value stored to err is never read
Message-ID: <YRKUMP51280FXK7F@mit.edu>
References: <20210806095820.83731-1-lczerner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210806095820.83731-1-lczerner@redhat.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Aug 06, 2021 at 11:58:14AM +0200, Lukas Czerner wrote:
> Remove it to silence clang warning.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Applied, thanks.

Note that we try to keep e2fsck/recovery.c and fs/jbd2/recovery.c in
sync, so it's appreciated patches sent to e2fsck/recovery.c or
fs/jbd2/recovery.c is sent to the other.  I can take care of it in
this case.

Cheers,

					- Ted
