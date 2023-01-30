Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33D50C54EED
	for <linux-ext4@archiver.kernel.org>; Mon, 30 Jan 2023 05:09:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232549AbjA3FJF (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 30 Jan 2023 00:09:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbjA3FJE (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Jan 2023 00:09:04 -0500
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C3FF2384D
        for <linux-ext4@vger.kernel.org>; Sun, 29 Jan 2023 21:09:03 -0800 (PST)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 30U58uwf018477
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Jan 2023 00:08:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1675055338; bh=zgWH92TCTnvZJbzNNX4wAnq6dm4Qus9Vxi42cNnYE6I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=L5DkURMjtHY/dkjkBWHila8ngHoISDlmtj+unbjxhvrjsRuzBb5xgrx/9kh/3L+ar
         pb4uvwm7EDsLhpftQz8aALMaAZdUqwTba+zqjglsZgczai1+T3Ky4FXRv/BkBgv8Gf
         Fv2KkHwcRnJlkCzfM3tqjGxIKTKJUn/uHt/4Qsirq+vvyn83IXx/KSl7JIW/Mf3jUZ
         lz2vF0PzVUTvfzFj9Z0sOdmKzfAibllCeTvA+PBu1i41zuuD/jlt57dlXSrkp3waef
         qPXCWrQIPpGgHzDZbqeInL+3kqYt5dEFiub4JekA48DxOr2mu0tAs78byn7kez/9gK
         5HO8/5ckALugQ==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 183A215C3589; Mon, 30 Jan 2023 00:08:56 -0500 (EST)
Date:   Mon, 30 Jan 2023 00:08:56 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH 3/4] lib/ext2fs: don't warn about lack of getmntent on
 Windows
Message-ID: <Y9dQ6NpthjzvGG8h@mit.edu>
References: <20230128224651.59593-1-ebiggers@kernel.org>
 <20230128224651.59593-4-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230128224651.59593-4-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sat, Jan 28, 2023 at 02:46:50PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> It is expected that Windows doesn't have getmntent(), so don't warn
> about it.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied to the maint branch.

					- Ted
