From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: [PATCH 01/11 RESEND] libe2p: Add new function get_fragment_score()
Date: Thu, 23 Jun 2011 17:00:17 +0900
Message-ID: <4E02F291.6040805@sx.jp.nec.com>
References: <4DF8522F.2020304@sx.jp.nec.com> <20110617031814.GA31884@thunk.org> <4E007FE1.8000704@sx.jp.nec.com> <20110621135608.GG32133@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:33514 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817Ab1FWIAy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Jun 2011 04:00:54 -0400
In-Reply-To: <20110621135608.GG32133@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2011/06/21 22:56, Ted Ts'o wrote:
> I'm really nervous about having filefrag print a "fragmentation
> score".  The problem is that the problem is invariably far more
> complex than can be boiled into a single number, and so users look at
> it and start worrying when they shouldn't.

It's possible that could happen. I suppose filefrag should output
"fragmented" or "not fragmented" to understand when they shouldn't do e4defag.
But it would be difficult to implement this idea because the threshold for
the determination of which file is fragmented is different of each filesystem.
As it stands now, I think filefrag shouldn't output fragmentation score.

However, I think I add get_fragment_score() to libe2p because e4defrag will
still use it.

> And the statement, "so that e4defrag can compare two files'
> fragmentation to prevent the worse fragmentation" begs the question of
> what is "worse".  The real issue here is that it's a multidimensional
> problem.

We need to define "what is worse" for e4defrag. If fragments per megabyte of
the file is bigger than the threshold, e4defrag will call EXT4_IOC_MOVE_EXT
ioctl. The threshold may be customizable by an option.

> "fragments per megabyte" is definitely better, especially if you
> disregard the tail.  It's worth consider how it works for files
> smaller than a megabyte.  Do you round the file size up to the nearest
> megabyte?  Is it an integer score, or does it need to be floating
> point?  An integer score where the size is rounded up to the nearest
> megabyte sounds like a best plan, but I'm sure we could still find
> some interesting non-linearities that lead to surprising results.

An integer score sounds good to me.

Regards,
Kazuya Mio
