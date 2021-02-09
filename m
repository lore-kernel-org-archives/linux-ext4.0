Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1290C433E0
	for <linux-ext4@archiver.kernel.org>; Tue,  9 Feb 2021 04:49:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78C2B64E8A
	for <linux-ext4@archiver.kernel.org>; Tue,  9 Feb 2021 04:49:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbhBIEtv (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 8 Feb 2021 23:49:51 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:41110 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229671AbhBIEtu (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Feb 2021 23:49:50 -0500
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 1194n1EN027530
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 8 Feb 2021 23:49:02 -0500
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 8F54E15C39D8; Mon,  8 Feb 2021 23:49:01 -0500 (EST)
Date:   Mon, 8 Feb 2021 23:49:01 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH 3/3] e2fsck: endianness fixes for fast commit replay
Message-ID: <YCIUPR0E6qVVQNMo@mit.edu>
References: <20210204233601.2369470-1-harshads@google.com>
 <20210204233601.2369470-3-harshads@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210204233601.2369470-3-harshads@google.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Feb 04, 2021 at 03:36:01PM -0800, Harshad Shirwadkar wrote:
> From: Harshad Shirwadkar <harshadshirwadkar@gmail.com>
> 
> There are a few places where the endianness conversion wasn't done
> right. This patch fixes that. Verified that after this patch,
> j_recover_fast_commit passes on big endian qemu VM.
> 
> root@debian-powerpc:~/e2fsprogs/tests# make j_recover_fast_commit
> j_recover_fast_commit: : ok
> 
> Signed-off-by: Harshad Shirwadkar <harshadshirwadkar@gmail.com>

Thanks, applied.

					- Ted
