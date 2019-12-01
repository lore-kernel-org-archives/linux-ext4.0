Return-Path: <SRS0=U6eS=ZX=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68E18C432C0
	for <linux-ext4@archiver.kernel.org>; Sun,  1 Dec 2019 01:16:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A0DB2084D
	for <linux-ext4@archiver.kernel.org>; Sun,  1 Dec 2019 01:16:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbfLABQ1 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 30 Nov 2019 20:16:27 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:39411 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726188AbfLABQ1 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 30 Nov 2019 20:16:27 -0500
Received: from callcc.thunk.org (pool-72-93-95-157.bstnma.fios.verizon.net [72.93.95.157])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id xB11GNCv008472
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 30 Nov 2019 20:16:23 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id DE1D2421A48; Sat, 30 Nov 2019 20:16:22 -0500 (EST)
Date:   Sat, 30 Nov 2019 20:16:22 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [GIT PULL] ext4 updates for 5.5
Message-ID: <20191201011622.GA19310@mit.edu>
References: <20191126125304.GA20746@mit.edu>
 <CAHk-=whqR7T_UuKX0JvOFK48RdiViOTPkNxxfjwh70FxjoxE0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whqR7T_UuKX0JvOFK48RdiViOTPkNxxfjwh70FxjoxE0Q@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sat, Nov 30, 2019 at 11:09:58AM -0800, Linus Torvalds wrote:
> Merges are commits too. And merges need commit messages too. They need
> an explanation of what they do - and why - the same way a normal
> commit does.

Ack, I'll make sure the merges have a high-level description of the
patch series and why branches from other git trees are needed for
prerequisites.

Cheers,

					- Ted
