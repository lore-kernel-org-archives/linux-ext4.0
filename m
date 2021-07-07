Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1119C07E96
	for <linux-ext4@archiver.kernel.org>; Wed,  7 Jul 2021 02:44:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B79461C81
	for <linux-ext4@archiver.kernel.org>; Wed,  7 Jul 2021 02:44:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbhGGCrY (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 6 Jul 2021 22:47:24 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:45879 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229894AbhGGCrY (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Jul 2021 22:47:24 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 1672iepG028992
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 6 Jul 2021 22:44:40 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 3167615C3CC6; Tue,  6 Jul 2021 22:44:40 -0400 (EDT)
Date:   Tue, 6 Jul 2021 22:44:40 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH 4/6] Fix -Wunused-parameter warnings
Message-ID: <YOUVGCFT6fRmS9eT@mit.edu>
References: <20210616045334.1655288-1-ebiggers@kernel.org>
 <20210616045334.1655288-5-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210616045334.1655288-5-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Jun 15, 2021 at 09:53:32PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Fix all warnings about unused function parameters that were introduced
> since e2fsprogs v1.45.4, by adding EXT2FS_ATTR((unused)) or removing
> parameters as appropriate.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Applied, thanks.

					- Ted
