Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D5BCC432BE
	for <linux-ext4@archiver.kernel.org>; Tue, 10 Aug 2021 14:59:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCA1660F25
	for <linux-ext4@archiver.kernel.org>; Tue, 10 Aug 2021 14:59:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242251AbhHJO7h (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 10 Aug 2021 10:59:37 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:56880 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S242163AbhHJO7g (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Aug 2021 10:59:36 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 17AExBeG015868
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Aug 2021 10:59:11 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 4E6FE15C3DD0; Tue, 10 Aug 2021 10:59:11 -0400 (EDT)
Date:   Tue, 10 Aug 2021 10:59:11 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Lukas Czerner <lczerner@redhat.com>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH 2/7] ext2fs: initialize retval before using it
Message-ID: <YRKUPx+ygoG0DU0+@mit.edu>
References: <20210806095820.83731-1-lczerner@redhat.com>
 <20210806095820.83731-2-lczerner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210806095820.83731-2-lczerner@redhat.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Aug 06, 2021 at 11:58:15AM +0200, Lukas Czerner wrote:
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Applied, thanks.

					- Ted
