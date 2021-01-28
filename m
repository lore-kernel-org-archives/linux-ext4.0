Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6B5AC433E0
	for <linux-ext4@archiver.kernel.org>; Thu, 28 Jan 2021 03:11:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7910264DD0
	for <linux-ext4@archiver.kernel.org>; Thu, 28 Jan 2021 03:11:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbhA1DLZ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 27 Jan 2021 22:11:25 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:41645 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229892AbhA1DLL (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Jan 2021 22:11:11 -0500
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 10S3AJIt021778
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jan 2021 22:10:19 -0500
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 3219A15C344F; Wed, 27 Jan 2021 22:10:19 -0500 (EST)
Date:   Wed, 27 Jan 2021 22:10:19 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Arnaud Ferraris <arnaud.ferraris@collabora.com>
Cc:     linux-ext4@vger.kernel.org, drosen@google.com,
        krisman@collabora.com, ebiggers@kernel.org
Subject: Re: [PATCH v3 06/12] e2fsck: Fix entries with invalid encoded
 characters
Message-ID: <YBIrG5CMZmyH+/8s@mit.edu>
References: <20201217173544.52953-1-arnaud.ferraris@collabora.com>
 <20201217173544.52953-7-arnaud.ferraris@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201217173544.52953-7-arnaud.ferraris@collabora.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Dec 17, 2020 at 06:35:38PM +0100, Arnaud Ferraris wrote:
> From: Gabriel Krisman Bertazi <krisman@collabora.com>
> 
> On strict mode, invalid Unicode sequences are not permited.  This patch
> adds a verification step to pass2 to detect and modify the entries with
> the same replacement char used for non-encoding directories '.'.
> 
> After the encoding test, we still want to check the name for usual
> problems, '\0', '/' in the middle of the sequence.
> 
> Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
> Signed-off-by: Arnaud Ferraris <arnaud.ferraris@collabora.com>

Thanks, applied.

					- Ted
