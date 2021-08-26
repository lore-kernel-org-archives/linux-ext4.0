Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11DB3C432BE
	for <linux-ext4@archiver.kernel.org>; Thu, 26 Aug 2021 14:55:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D71F060F45
	for <linux-ext4@archiver.kernel.org>; Thu, 26 Aug 2021 14:55:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbhHZO4E (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 26 Aug 2021 10:56:04 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:46628 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231458AbhHZO4E (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 26 Aug 2021 10:56:04 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 17QEtB6R012930
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Aug 2021 10:55:12 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 9DA9B15C33EE; Thu, 26 Aug 2021 10:55:11 -0400 (EDT)
Date:   Thu, 26 Aug 2021 10:55:11 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH 0/5 v7] ext4: Speedup orphan file handling
Message-ID: <YSerT9AfQ3sGBTF9@mit.edu>
References: <20210816093626.18767-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816093626.18767-1-jack@suse.cz>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Aug 16, 2021 at 11:57:03AM +0200, Jan Kara wrote:
> 
> Here is the seventh version of my series to speed up orphan inode handling in
> ext4. I've forgot to add a check that orphan file is not exposed in directory
> hierarchy. The only change in this version is addition of that fix.

Thanks, applied.

					- Ted
