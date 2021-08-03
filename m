Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CE11C4338F
	for <linux-ext4@archiver.kernel.org>; Tue,  3 Aug 2021 16:16:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAD7660F9C
	for <linux-ext4@archiver.kernel.org>; Tue,  3 Aug 2021 16:16:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbhHCQQk (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 3 Aug 2021 12:16:40 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:60823 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S233020AbhHCQPy (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Aug 2021 12:15:54 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 173GFdgF021423
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 3 Aug 2021 12:15:39 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 14CCE15C37C0; Tue,  3 Aug 2021 12:15:39 -0400 (EDT)
Date:   Tue, 3 Aug 2021 12:15:39 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH 3/9] e2image: Dump quota files
Message-ID: <YQlrq40wmMMYO9YP@mit.edu>
References: <20210616105735.5424-1-jack@suse.cz>
 <20210616105735.5424-4-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210616105735.5424-4-jack@suse.cz>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Jun 16, 2021 at 12:57:29PM +0200, Jan Kara wrote:
> Dump quota files to resulting filesystem image. They are fs metadata.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied to the maint branch.

					- Ted
