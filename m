Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 371E9C433E0
	for <linux-ext4@archiver.kernel.org>; Thu, 28 Jan 2021 02:50:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDC5E64DD3
	for <linux-ext4@archiver.kernel.org>; Thu, 28 Jan 2021 02:50:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbhA1CuW (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 27 Jan 2021 21:50:22 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:38557 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229494AbhA1CuW (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Jan 2021 21:50:22 -0500
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 10S2nSX6015041
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jan 2021 21:49:28 -0500
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id EC92715C344F; Wed, 27 Jan 2021 21:49:27 -0500 (EST)
Date:   Wed, 27 Jan 2021 21:49:27 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Arnaud Ferraris <arnaud.ferraris@collabora.com>
Cc:     linux-ext4@vger.kernel.org, drosen@google.com,
        krisman@collabora.com, ebiggers@kernel.org
Subject: Re: [PATCH RESEND v2 04/12] ext2fs: Implement faster CI comparison
 of strings
Message-ID: <YBImN/d4SmLa8red@mit.edu>
References: <20201210150353.91843-1-arnaud.ferraris@collabora.com>
 <20201210150353.91843-5-arnaud.ferraris@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201210150353.91843-5-arnaud.ferraris@collabora.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Dec 10, 2020 at 04:03:45PM +0100, Arnaud Ferraris wrote:
> From: Gabriel Krisman Bertazi <krisman@collabora.com>
> 
> Instead of calling casefold two times and memcmp the result, which
> require allocating a temporary buffer for the casefolded version, add a
> strcasecmp-like method to perform the comparison of each code-point
> during the casefold itself.
> 
> This method is exposed because it needs to be used directly by fsck.
> 
> Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
> Signed-off-by: Arnaud Ferraris <arnaud.ferraris@collabora.com>

Thanks, applied.

					- Ted
