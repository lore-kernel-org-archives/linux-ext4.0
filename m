Return-Path: <SRS0=x6sY=UT=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7560CC43613
	for <linux-ext4@archiver.kernel.org>; Thu, 20 Jun 2019 04:02:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DC6F2147A
	for <linux-ext4@archiver.kernel.org>; Thu, 20 Jun 2019 04:02:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbfFTECB (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 20 Jun 2019 00:02:01 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:45909 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725857AbfFTECB (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Jun 2019 00:02:01 -0400
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x5K41u2f005812
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Jun 2019 00:01:57 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 5CE5A420484; Thu, 20 Jun 2019 00:01:56 -0400 (EDT)
Date:   Thu, 20 Jun 2019 00:01:56 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Gabriel Krisman Bertazi <krisman@collabora.com>
Cc:     linux-ext4@vger.kernel.org, kernel@collabora.com
Subject: Re: [PATCH] ext4: Optimize case-insensitive lookups
Message-ID: <20190620040156.GB15783@mit.edu>
References: <20190617190240.30996-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617190240.30996-1-krisman@collabora.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Jun 17, 2019 at 03:02:40PM -0400, Gabriel Krisman Bertazi wrote:
> Temporarily cache a casefolded version of the file name under lookup in
> ext4_filename, to avoid repeatedly casefolding it.  I got up to 30%
> speedup on lookups of large directories (>100k entries), depending on
> the length of the string under lookup.
> 
> v2:
>   - Dinamically allocate space for the casefolded version.
> 
> Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>

Thanks, applied.

						- Ted
