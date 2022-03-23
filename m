Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C69EAC433EF
	for <linux-ext4@archiver.kernel.org>; Wed, 23 Mar 2022 22:05:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345097AbiCWWGn (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 23 Mar 2022 18:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238850AbiCWWGm (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Mar 2022 18:06:42 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF6A5C657;
        Wed, 23 Mar 2022 15:05:11 -0700 (PDT)
Received: from cwcc.thunk.org (pool-108-7-220-252.bstnma.fios.verizon.net [108.7.220.252])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 22NM570a032048
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 18:05:07 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 20D0915C0038; Wed, 23 Mar 2022 18:05:07 -0400 (EDT)
Date:   Wed, 23 Mar 2022 18:05:07 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [GIT PULL] ext4 updates for 5.18-rc1
Message-ID: <YjuZk3wa36+ckqrV@mit.edu>
References: <YjuYwa2jhanwyryf@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjuYwa2jhanwyryf@mit.edu>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Never mind, I see this was already pulled.  I didn't see a message
from the the pr-tracking-bot, but that was my fault, because I had
forgotten to Cc linux-kernel.  So I guess the resend's useful for the
purposes of indicating the putting the PULL on the record.

Apologies for the noise.

							- Ted
