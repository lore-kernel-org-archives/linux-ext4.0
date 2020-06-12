Return-Path: <SRS0=SNdn=7Z=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42997C433E1
	for <linux-ext4@archiver.kernel.org>; Fri, 12 Jun 2020 14:11:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 171782074B
	for <linux-ext4@archiver.kernel.org>; Fri, 12 Jun 2020 14:11:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="b+qIjrVX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgFLOLh (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 12 Jun 2020 10:11:37 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:59147 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726451AbgFLOLg (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 12 Jun 2020 10:11:36 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 6BFE05C0198;
        Fri, 12 Jun 2020 10:11:35 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 12 Jun 2020 10:11:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=N2UTN5
        zf4fI0fEU1GAssqOF62PIajnZlEs++lgSKQbc=; b=b+qIjrVXrY+JWnlhm+V7kj
        KCEFRHny1iUTmOd1iSHkK8slA/Rmg52yRFS3Dbl8ysb2m6LGfLlPvUavZgEch1D1
        50wDCaGsNwqoUM3DGsmmTAsmMvNoSEnohbNjiF12V68ehGOPkuy6czWEX++b1Fbc
        7jL3nE0XeYby72N1WzjwVErOatuQXkxyATCn3AePyBR5OHycWsKc1wQAT8/qHTYF
        4I+C/j2VG6x6pa1v8GwWFAQQKXW+7oQIMTe/zyR/GJOlbinmwO/ogyhwdShcP8xn
        ysqgFPTy59ijXmy56iEHo2bJztvn1Llo5ztP4FsWmZq0p3LL3fkN2iOOFS+To1tQ
        ==
X-ME-Sender: <xms:FI3jXr7zLtYmKIwGNCcWN3YyA4cxOdiGQQ36vu6_6pES5fUAnWXSzQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeiuddgjeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpefgvefgveeuudeuffeiffehieffgfejleevtdetueetueffkeevgffgtddugfek
    veenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeejledrudejledrledtrd
    efvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehi
    ughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:FI3jXg6YGCCa8T3yZL8FddXBYToroM75whLfyMMtWLvsetLmKNjs5w>
    <xmx:FI3jXieqXQv6Etc3KefcYG9j9RPrz0cbVXvvNBNQsCk93tTqGMCG0g>
    <xmx:FI3jXsLol_COGgpBtXEfJZup2-MVr8Qvsd8QG6LGDw0Jx3NDDBS0Jw>
    <xmx:F43jXsGwt9-2XShtxzNUuXCg5z4DLWfgwG0kRhaR9e5NgeZljYXQMg>
Received: from localhost (bzq-79-179-90-32.red.bezeqint.net [79.179.90.32])
        by mail.messagingengine.com (Postfix) with ESMTPA id E060432800D0;
        Fri, 12 Jun 2020 09:51:35 -0400 (EDT)
Date:   Fri, 12 Jun 2020 16:51:33 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Ritesh Harjani <riteshh@linux.ibm.com>
Cc:     syzbot <syzbot+82f324bb69744c5f6969@syzkaller.appspotmail.com>,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        sfr@canb.auug.org.au, syzkaller-bugs@googlegroups.com,
        tytso@mit.edu
Subject: Re: linux-next test error: BUG: using smp_processor_id() in
 preemptible [ADDR] code: syz-fuzzer/6792
Message-ID: <20200612135133.GA28968@splinter>
References: <0000000000008ff8ea05a71818b5@google.com>
 <20200602124130.256274203F@d06av24.portsmouth.uk.ibm.com>
 <20200612124340.GA23832@splinter>
 <20200612133905.CDF9A5204E@d06av21.portsmouth.uk.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200612133905.CDF9A5204E@d06av21.portsmouth.uk.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Jun 12, 2020 at 07:09:04PM +0530, Ritesh Harjani wrote:
> I see Ted has already taken v2 of this patch in his dev repo.
> Should be able to see in linux tree soon.
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git/commit/?h=dev&id=811985365378df01386c3cfb7ff716e74ca376d5

Great, thanks a lot. I've replaced previous patch with this one in my
testing tree.
