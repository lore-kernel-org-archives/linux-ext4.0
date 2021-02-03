Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5369AC433DB
	for <linux-ext4@archiver.kernel.org>; Wed,  3 Feb 2021 03:54:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00B5464F61
	for <linux-ext4@archiver.kernel.org>; Wed,  3 Feb 2021 03:54:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbhBCDy0 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 2 Feb 2021 22:54:26 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:33686 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S230000AbhBCDyZ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Feb 2021 22:54:25 -0500
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 1133rVOX017571
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 2 Feb 2021 22:53:32 -0500
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 62B2915C39E2; Tue,  2 Feb 2021 22:53:31 -0500 (EST)
Date:   Tue, 2 Feb 2021 22:53:31 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Benno Schulenberg <bensberg@telfort.nl>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH 2/2] mke2fs.8: fix various formatting issues, and sort
 the synopsis
Message-ID: <YBoeOxRzNod5npU7@mit.edu>
References: <20201020094829.3234-1-bensberg@telfort.nl>
 <20201020094829.3234-2-bensberg@telfort.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201020094829.3234-2-bensberg@telfort.nl>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Oct 20, 2020 at 11:48:29AM +0200, Benno Schulenberg wrote:
> Also, delete the sentence that says that the inode size cannot
> be changed after creating the file system, as tune2fs acquired
> the -I option.
> 
> Signed-off-by: Benno Schulenberg <bensberg@telfort.nl>

Thanks, applied.

					- Ted
