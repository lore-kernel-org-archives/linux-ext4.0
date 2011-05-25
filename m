From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: [PATCH] ext4: invalidate gap cache when writing extents last
 block
Date: Wed, 25 May 2011 17:59:23 +0900
Message-ID: <4DDCC4EB.5000007@sx.jp.nec.com>
References: <alpine.LFD.2.00.1105130829160.3768@dhcp-27-109.brq.redhat.com> <1305268616-5167-1-git-send-email-lczerner@redhat.com> <4DCCF208.3040704@sx.jp.nec.com> <4DDB6D66.3010703@sx.jp.nec.com> <alpine.LFD.2.00.1105241037190.4028@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:42283 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab1EYI7y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 May 2011 04:59:54 -0400
In-Reply-To: <alpine.LFD.2.00.1105241037190.4028@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2011/05/24 17:57, Lukas Czerner wrote:
> Hi Kazuya,
>
> I am really sorry for late answer. I think you're partly right. my
> solution is not good, but I still think that your is not good as well. I
> need to look at this again and more closely, sorry.
>
> What do you think about this: ext4_ext_next_allocated_block() should
> return next allocated block, however instead it in some cases returns
> EXT_MAX_BLOCK, which points at the last logical block in a file, which
> however in some cases might be equal to the last not allocated block,
> not first allocated block in subsequent extent. And boom, we have (next
> == lblock).

I think so, too.

> So if we want to really return next allocated block (or more
> specifically, next block which we can not allocate), we should in those
> cases return EXT_MAX_BLOCK+1. And we should do this in
> ext4_ext_put_gap_in_cache() as well when there is no extent yet. Also
> note that as I said EXT_MAX_BLOCK means maximum logical block, however
> we use it as lenght in ext4_ext_put_gap_in_cache() which does not sound
> right either. It seems all a little bit messy :-/. I need to look at it
> and try it to see if it would work, but I think it does make sense.
>
> What do you think?

AFAIK, it's the best way to fix this problem. But I have no idea that doesn't
increase the size of struct ext4_ext_cache. I'm looking forward to seeing
the patch.

Regards,
Kazuya Mio
