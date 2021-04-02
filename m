Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18AC3C433B4
	for <linux-ext4@archiver.kernel.org>; Fri,  2 Apr 2021 20:03:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3A8D61163
	for <linux-ext4@archiver.kernel.org>; Fri,  2 Apr 2021 20:03:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbhDBUDP (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 2 Apr 2021 16:03:15 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:54369 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229647AbhDBUDL (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Apr 2021 16:03:11 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 132K36Ol028596
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 2 Apr 2021 16:03:06 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id DEFED15C3ACE; Fri,  2 Apr 2021 16:03:05 -0400 (EDT)
Date:   Fri, 2 Apr 2021 16:03:05 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Andreas Dilger <adilger@dilger.ca>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH] e2image: add OPTIONS section to man page
Message-ID: <YGd4eRiwpjBsXMK7@mit.edu>
References: <20210309083508.30900-1-adilger@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309083508.30900-1-adilger@dilger.ca>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Mar 09, 2021 at 01:35:08AM -0700, Andreas Dilger wrote:
> Reorganize the e2image.8 man page so that the command-line options
> are listed in a dedicated OPTIONS section, rather than being
> interspersed among the text in the DESCRIPTION section.  Otherwise,
> it is difficult to determine which options are available, and to
> find where each option is described.
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Applied, thanks.

					- Ted
