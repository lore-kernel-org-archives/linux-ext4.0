Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7272C433E0
	for <linux-ext4@archiver.kernel.org>; Tue, 23 Feb 2021 02:58:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B69A64DF3
	for <linux-ext4@archiver.kernel.org>; Tue, 23 Feb 2021 02:58:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbhBWC6E (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 22 Feb 2021 21:58:04 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:43808 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231196AbhBWC6E (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Feb 2021 21:58:04 -0500
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 11N2vEPB030740
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Feb 2021 21:57:15 -0500
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 5D7D415C342C; Mon, 22 Feb 2021 21:57:14 -0500 (EST)
Date:   Mon, 22 Feb 2021 21:57:14 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Andreas Dilger <adilger@dilger.ca>
Cc:     linux-ext4@vger.kernel.org, Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [PATCH] misc: replace remaining loff_t with ext2_loff_t
Message-ID: <YDRvCkPSayiAPHTi@mit.edu>
References: <20201212095823.35563-1-adilger@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201212095823.35563-1-adilger@dilger.ca>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sat, Dec 12, 2020 at 02:58:23AM -0700, Andreas Dilger wrote:
> From: Andreas Dilger <adilger@whamcloud.com>
> 
> Replace the remaining loff_t uses with ext2_loff_t, as
> was done in patch 1df6a4555, since loff_t is a GCC'ism
> and is not portable.
> 
> Signed-off-by: Andreas Dilger <adilger@whamcloud.com>

Thanks, applied.

					- Ted
