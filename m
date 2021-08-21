Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,TVD_SPACE_RATIO autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC49EC4338F
	for <linux-ext4@archiver.kernel.org>; Sat, 21 Aug 2021 04:03:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88134611C4
	for <linux-ext4@archiver.kernel.org>; Sat, 21 Aug 2021 04:03:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbhHUEER (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 21 Aug 2021 00:04:17 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:57207 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229498AbhHUEEP (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 21 Aug 2021 00:04:15 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 17L43Cg6022336
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 21 Aug 2021 00:03:14 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 735C915C3DBB; Sat, 21 Aug 2021 00:03:12 -0400 (EDT)
Date:   Sat, 21 Aug 2021 00:03:12 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     syzbot <syzbot+1bd003b0dbaa786227e6@syzkaller.appspotmail.com>
Cc:     adilger.kernel@dilger.ca, bvanassche@acm.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@kernel.org, peterz@infradead.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] KASAN: use-after-free Write in ext4_write_inline_data
Message-ID: <YSB7AENonC6a0rCH@mit.edu>
References: <000000000000dc107905c99b8e53@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000dc107905c99b8e53@google.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git 9e445093e523f3277081314c864f708fd4bd34aa
