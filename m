Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7896CC433E0
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Jan 2021 15:56:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C72522C9F
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Jan 2021 15:56:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730427AbhAUPzh (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Jan 2021 10:55:37 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:58312 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729550AbhAUPzK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jan 2021 10:55:10 -0500
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 10LFsDcO002812
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 10:54:15 -0500
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id AC5A215C35F5; Thu, 21 Jan 2021 10:54:13 -0500 (EST)
Date:   Thu, 21 Jan 2021 10:54:13 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Cc:     linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v3 02/15] e2fsck: add kernel endian-ness conversion macros
Message-ID: <YAmjpUjrcOgkQ5Ik@mit.edu>
References: <20210120212641.526556-1-user@harshads-520.kir.corp.google.com>
 <20210120212641.526556-3-user@harshads-520.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210120212641.526556-3-user@harshads-520.kir.corp.google.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Jan 20, 2021 at 01:26:28PM -0800, Harshad Shirwadkar wrote:
> From: Harshad Shirwadkar <harshadshirwadkar@gmail.com>
> 
> In order to make recovery.c identical with kernel, we need endianness
> conversion macros (such as cpu_to_be32 and friends) defined in
> e2fsprogs. This patch defines these macros and also fixes recovery.c
> to use these. These macros are also needed for fast commit recovery
> patches later in this series.
> 
> Signed-off-by: Harshad Shirwadkar <harshadshirwadkar@gmail.com>
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>

Thanks, applied.

					- Ted
