Return-Path: <SRS0=afbN=SJ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB67AC10F0E
	for <linux-ext4@archiver.kernel.org>; Sun,  7 Apr 2019 16:29:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D89920B1F
	for <linux-ext4@archiver.kernel.org>; Sun,  7 Apr 2019 16:29:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbfDGQ35 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 7 Apr 2019 12:29:57 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:58474 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726329AbfDGQ34 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Apr 2019 12:29:56 -0400
Received: from callcc.thunk.org (43.sub-174-222-9.myvzw.com [174.222.9.43])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x37GTeZc016417
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 7 Apr 2019 12:29:43 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 72A27421A0D; Sun,  7 Apr 2019 12:29:39 -0400 (EDT)
Date:   Sun, 7 Apr 2019 12:29:39 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Andreas Dilger <adilger.kernel@dilger.ca>,
        clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Eric Whitney <enwlinux@gmail.com>,
        Sean Fu <fxinrong@gmail.com>, Jan Kara <jack@suse.cz>,
        Eric Biggers <ebiggers@google.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: use BUG() instead of BUG_ON(1)
Message-ID: <20190407162939.GA4039@mit.edu>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
        Arnd Bergmann <arnd@arndb.de>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Eric Whitney <enwlinux@gmail.com>, Sean Fu <fxinrong@gmail.com>,
        Jan Kara <jack@suse.cz>, Eric Biggers <ebiggers@google.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190325130040.1437445-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190325130040.1437445-1-arnd@arndb.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Mar 25, 2019 at 02:00:25PM +0100, Arnd Bergmann wrote:
> BUG_ON(1) leads to bogus warnings from clang when
> CONFIG_PROFILE_ANNOTATED_BRANCHES is set:
> 
>	....
> 
> Change it to BUG() so clang can see that this code path can never
> continue.

Thanks, applied.

					- Ted
