Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BE79C433ED
	for <linux-ext4@archiver.kernel.org>; Fri,  2 Apr 2021 15:41:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DAA961152
	for <linux-ext4@archiver.kernel.org>; Fri,  2 Apr 2021 15:41:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236237AbhDBPlA (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 2 Apr 2021 11:41:00 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:60228 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S236211AbhDBPk7 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Apr 2021 11:40:59 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 132Fengx012513
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 2 Apr 2021 11:40:50 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id D039615C3AC7; Fri,  2 Apr 2021 11:40:49 -0400 (EDT)
Date:   Fri, 2 Apr 2021 11:40:49 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Alexander Lochmann <alexander.lochmann@tu-dortmund.de>
Cc:     Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Updated locking documentation for transaction_t
Message-ID: <YGc7AcUkZ99iAOGO@mit.edu>
References: <20210211171410.17984-1-alexander.lochmann@tu-dortmund.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210211171410.17984-1-alexander.lochmann@tu-dortmund.de>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Feb 11, 2021 at 06:14:10PM +0100, Alexander Lochmann wrote:
> Some members of transaction_t are allowed to be read without
> any lock being held if accessed from the correct context.
> We used LockDoc's findings to determine those members.
> Each member of them is marked with a short comment:
> "no lock needed for jbd2 thread".
> 
> Signed-off-by: Alexander Lochmann <alexander.lochmann@tu-dortmund.de>
> Signed-off-by: Horst Schirmeier <horst.schirmeier@tu-dortmund.de>
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, applied.  I reflowed the comments before applying the patch.

		    	     	 	  - Ted
