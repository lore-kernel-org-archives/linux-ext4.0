Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE9E3C433E0
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Jan 2021 16:54:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E45323A57
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Jan 2021 16:54:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388185AbhAUQxr (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Jan 2021 11:53:47 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:58264 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729088AbhAUPyt (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jan 2021 10:54:49 -0500
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 10LFs0Ja002686
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 10:54:00 -0500
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 468F215C35F5; Thu, 21 Jan 2021 10:54:00 -0500 (EST)
Date:   Thu, 21 Jan 2021 10:54:00 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH v3 01/15] ext2fs: move calculate_summary_stats to ext2fs
 lib
Message-ID: <YAmjmA1mf1aaFMwg@mit.edu>
References: <20210120212641.526556-1-user@harshads-520.kir.corp.google.com>
 <20210120212641.526556-2-user@harshads-520.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210120212641.526556-2-user@harshads-520.kir.corp.google.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Jan 20, 2021 at 01:26:27PM -0800, Harshad Shirwadkar wrote:
> From: Harshad Shirwadkar <harshadshirwadkar@gmail.com>
> 
> The function calculate_summary_stats sets the global metadata of the
> file system. Tune2fs had this function defined statically in
> tune2fs.c. Fast commit replay needs this function to set global
> metadata at the end of the replay phase. So, move this function to
> libext2fs.
> 
> Signed-off-by: Harshad Shirwadkar <harshadshirwadkar@gmail.com>
> Reviewed-by: Theodore Ts'o <tytso@mit.edu>

Thanks, applied.

						- Ted
