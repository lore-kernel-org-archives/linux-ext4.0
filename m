Return-Path: <SRS0=5bfQ=YL=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93A98CA9EB3
	for <linux-ext4@archiver.kernel.org>; Fri, 18 Oct 2019 01:57:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C3AD21D7D
	for <linux-ext4@archiver.kernel.org>; Fri, 18 Oct 2019 01:57:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409526AbfJRB5A (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 17 Oct 2019 21:57:00 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:44860 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2409223AbfJRB47 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Oct 2019 21:56:59 -0400
Received: from callcc.thunk.org (pool-72-93-95-157.bstnma.fios.verizon.net [72.93.95.157])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x9I1utmt016701
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Oct 2019 21:56:56 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 58DD0420458; Thu, 17 Oct 2019 21:56:55 -0400 (EDT)
Date:   Thu, 17 Oct 2019 21:56:55 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH v3 12/13] docs: Add fast commit documentation
Message-ID: <20191018015655.GB21137@mit.edu>
References: <20191001074101.256523-1-harshadshirwadkar@gmail.com>
 <20191001074101.256523-13-harshadshirwadkar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191001074101.256523-13-harshadshirwadkar@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Oct 01, 2019 at 12:41:01AM -0700, Harshad Shirwadkar wrote:
> +
> +Multiple fast commit blocks are a part of one sub-transaction. To
> +indicate the last block in a fast commit transaction, fc_flags field
> +in the last block in every subtransaction is marked with "LAST" (0x1)
> +flag. A subtransaction is valid only if all the following conditions
> +are met:
> +
> +1) SUBTID of all blocks is either equal to or greater than SUBTID of
> +   the previous fast commit block.
> +2) For every sub-transaction, last block is marked with LAST flag.
> +3) There are no invalid blocks in between.

I'm wondering why we need to support multiple inodes being modified in
a single transaction.  As we currently have defined what can be done,
all updates to an inode should be free standing and not dependent on a
change to another inode, right?  And today, one block only modifies
one inode.

The only reason why we might want to define a sub-transaction as being
composed of multiple inodes, which must all be updated in an
all-or-nothing fashion, is the swap boot inode ioctl, and if that's
the only one, I wonder if it's worth the extra complexity.

Am I missing anything?

					- Ted
