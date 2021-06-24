Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CF62C49EA6
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Jun 2021 14:17:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFEAC613C2
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Jun 2021 14:17:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbhFXOTh (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 24 Jun 2021 10:19:37 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:50354 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229878AbhFXOTh (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jun 2021 10:19:37 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 15OEH5xn030201
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Jun 2021 10:17:06 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 7D90515C3CD7; Thu, 24 Jun 2021 10:17:05 -0400 (EDT)
Date:   Thu, 24 Jun 2021 10:17:05 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Leah Rumancik <leah.rumancik@gmail.com>
Cc:     linux-ext4@vger.kernel.org, dan.carpenter@oracle.com,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] ext4: fix input checking in fs/jbd2/journal.c
Message-ID: <YNST4d8fCcGjQmzS@mit.edu>
References: <20210607175558.3343945-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210607175558.3343945-1-leah.rumancik@gmail.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Jun 07, 2021 at 05:55:58PM +0000, Leah Rumancik wrote:
> Update
> 
> 	if (JBD2_JOURNAL_FLUSH_DISCARD & !blk_queue_discard(q))
> 
> to use && instead of &. JBD2_JOURNAL_FLUSH_DISCARD is set to 1 so &
> technically works but && could be a bit faster and will maintain
> correctness in the event the value of JBD2_JOURNAL_FLUSH_DISCARD is
> updated.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>

Thanks, I've folded this fix into the base commit.

	     	    	     	      - Ted
