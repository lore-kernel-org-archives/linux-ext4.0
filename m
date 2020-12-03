Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DF6EC001B1
	for <linux-ext4@archiver.kernel.org>; Thu,  3 Dec 2020 14:05:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49B80206D8
	for <linux-ext4@archiver.kernel.org>; Thu,  3 Dec 2020 14:05:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730844AbgLCOFA (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 3 Dec 2020 09:05:00 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:55565 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727930AbgLCOE7 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Dec 2020 09:04:59 -0500
Received: from callcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 0B3E45tu021699
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 3 Dec 2020 09:04:05 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 37597420136; Thu,  3 Dec 2020 09:04:05 -0500 (EST)
Date:   Thu, 3 Dec 2020 09:04:05 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Alexander Lochmann <alexander.lochmann@tu-dortmund.de>
Cc:     Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Updated locking documentation for transaction_t
Message-ID: <20201203140405.GC441757@mit.edu>
References: <20190408083500.66759-1-alexander.lochmann@tu-dortmund.de>
 <10cfbef1-994c-c604-f8a6-b1042fcc622f@tu-dortmund.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10cfbef1-994c-c604-f8a6-b1042fcc622f@tu-dortmund.de>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Oct 15, 2020 at 03:26:28PM +0200, Alexander Lochmann wrote:
> Hi folks,
> 
> I've updated the lock documentation according to our finding for
> transaction_t.
> Does this patch look good to you?

I updated the annotations to match with the local usage, e.g:

	 * When commit was requested [journal_t.j_state_lock]

became:

	 * When commit was requested [j_state_lock]

Otherwise, looks good.  Thanks for the patch!

	   	 	       	       - Ted
