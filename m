Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EE5DC4338F
	for <linux-ext4@archiver.kernel.org>; Tue, 10 Aug 2021 15:03:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D57D60F02
	for <linux-ext4@archiver.kernel.org>; Tue, 10 Aug 2021 15:03:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242503AbhHJPDz (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 10 Aug 2021 11:03:55 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:57798 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S240677AbhHJPDz (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Aug 2021 11:03:55 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 17AF3TVP017872
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Aug 2021 11:03:30 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id A9FCB15C3DD0; Tue, 10 Aug 2021 11:03:29 -0400 (EDT)
Date:   Tue, 10 Aug 2021 11:03:29 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Lukas Czerner <lczerner@redhat.com>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH 6/7] libss: Add missing error handling for fdopen()
Message-ID: <YRKVQdRCr5oDV7AL@mit.edu>
References: <20210806095820.83731-1-lczerner@redhat.com>
 <20210806095820.83731-6-lczerner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210806095820.83731-6-lczerner@redhat.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Aug 06, 2021 at 11:58:19AM +0200, Lukas Czerner wrote:
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, applied.

					- Ted
