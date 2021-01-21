Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E97CC433E0
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Jan 2021 23:27:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE1882087E
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Jan 2021 23:27:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbhAUX1h (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Jan 2021 18:27:37 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:40583 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726576AbhAUX1a (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jan 2021 18:27:30 -0500
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 10LNQeve026042
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 18:26:41 -0500
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 9463515C35F5; Thu, 21 Jan 2021 18:26:40 -0500 (EST)
Date:   Thu, 21 Jan 2021 18:26:40 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH] mke2fs.8: Improve valid block size documentation
Message-ID: <YAoNsMfa++aH6sD5@mit.edu>
References: <20201216102206.23127-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201216102206.23127-1-jack@suse.cz>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Dec 16, 2020 at 11:22:06AM +0100, Jan Kara wrote:
> Explain which valid block sizes mke2fs supports in more detail.
> 
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied, thanks!

					- Ted
