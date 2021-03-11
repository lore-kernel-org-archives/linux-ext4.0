Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6D0DC433E0
	for <linux-ext4@archiver.kernel.org>; Thu, 11 Mar 2021 15:31:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8870064E98
	for <linux-ext4@archiver.kernel.org>; Thu, 11 Mar 2021 15:31:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234132AbhCKPan (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 11 Mar 2021 10:30:43 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:45146 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S234121AbhCKPaW (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Mar 2021 10:30:22 -0500
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 12BFU9qp025815
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Mar 2021 10:30:09 -0500
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 3FF5615C3AA0; Thu, 11 Mar 2021 10:30:09 -0500 (EST)
Date:   Thu, 11 Mar 2021 10:30:09 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Marco Elver <elver@google.com>
Cc:     Dmitry Vyukov <dvyukov@google.com>, Jan Kara <jack@suse.cz>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        syzbot <syzbot+30774a6acf6a2cf6d535@syzkaller.appspotmail.com>,
        Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: [syzbot] KCSAN: data-race in start_this_handle /
 start_this_handle
Message-ID: <YEo3gYOU/VnmHCeV@mit.edu>
References: <0000000000008de88005bd40ac36@google.com>
 <20210311142503.GA31816@quack2.suse.cz>
 <CACT4Y+ZtBwv1aXUumTXnWzAi7LEpJ6CZemGyVR2FC6_YO2E4EQ@mail.gmail.com>
 <YEoybjJpCQzNx15r@elver.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEoybjJpCQzNx15r@elver.google.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Mar 11, 2021 at 04:08:30PM +0100, Marco Elver wrote:
> If the outcome of the check does not affect correctness and the code is
> entirely fault tolerant to the precise value being read, then a
> data_race(!journal->j_running_transaction) marking here would be fine.

So a very common coding pattern is to check a value w/o the lock, and
if it looks like we might need to check *with* a lock, we'll grab the
lock and recheck.  Does KCSAN understand that this sort of thing is
safe automatically?

In thie particular case, it's a bit more complicated than that; we're
checking a value, and then allocating memory, grabbing the spin lock,
and then re-checking the value, so we don't have to drop the spinlock,
allocate the memory, grab the lock again, and then rechecking the
value.  So even if KCSAN catches the simpler case as described above,
we still might need to explicitly mark the data_race explicitly.

But the more we could have the compiler automatically figure out
things without needing an explicit tag, it would seem to me that this
would be better, since manual tagging is going to be more error-prone.

Cheers,

      	 	       	      	      	       - Ted
