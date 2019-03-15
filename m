Return-Path: <SRS0=fczw=RS=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E76E0C43381
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Mar 2019 04:31:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1D1B21871
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Mar 2019 04:31:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfCOEbZ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 15 Mar 2019 00:31:25 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:39623 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726458AbfCOEbZ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Mar 2019 00:31:25 -0400
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x2F4VKLg003557
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Mar 2019 00:31:21 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 74388420AA8; Fri, 15 Mar 2019 00:31:20 -0400 (EDT)
Date:   Fri, 15 Mar 2019 00:31:20 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Artem Blagodarenko <artem.blagodarenko@gmail.com>
Cc:     linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca,
        alexey.lyashkov@gmail.com
Subject: Re: [PATCH] ext4: check if group has free space
Message-ID: <20190315043120.GI11334@mit.edu>
References: <20190307114914.86453-1-c17828@cray.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190307114914.86453-1-c17828@cray.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Mar 07, 2019 at 02:49:14PM +0300, Artem Blagodarenko wrote:
> Regular allocator make four groups processing loops to
> find good group to allocate blocks. On 4th loop it accept any
> group, even if there is no free space at all.
> 
> This patch adds group free space check to skip full groups.
> 
> Sigend-off-by: Artem Blagodarenko <c17828@cray.com>

This patch doesn't change anything.  Note the check that we have at
the very beginning of ext4_mb_good_group():

	free = grp->bb_free;
	if (free == 0)
		return 0;

This is before we even go into the case statement, so your change:

>  	case 3:
> -		return 1;
> +		/* Skip group without any free space */
> +		return free ? 1 : 0;

is a no-op; we will always be returning 1, since if free == 0, we would
have bailed out at the top of the function.

Cheers,

					- Ted
