From: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: slab error in verify_redzone_free (2.6.27-rc5)
Date: Thu, 4 Sep 2008 09:13:56 +0300
Message-ID: <84144f020809032313k7e29720bn4286ad0097397a7d@mail.gmail.com>
References: <20080903214642.GA9938@joi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: "Marcin Slusarz" <marcin.slusarz@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:60238 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbYIDGN6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Sep 2008 02:13:58 -0400
Received: by wa-out-1112.google.com with SMTP id j37so2197586waf.23
        for <linux-ext4@vger.kernel.org>; Wed, 03 Sep 2008 23:13:57 -0700 (PDT)
In-Reply-To: <20080903214642.GA9938@joi>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Marcin,

(I'm cc'ing the ext3 developers)

On Thu, Sep 4, 2008 at 12:46 AM, Marcin Slusarz
<marcin.slusarz@gmail.com> wrote:
> Sep  1 20:22:07 [kernel] [ 8541.403598] slab error in verify_redzone_free(): cache `ext3_inode_cache': memory outside object was overwritten
> Sep  1 20:22:07 [kernel] [ 8541.403613] Pid: 206, comm: kswapd0 Not tainted 2.6.27-rc5 #362
> Sep  1 20:22:07 [kernel] [ 8541.403620]
> Sep  1 20:22:07 [kernel] [ 8541.403621] Call Trace:
> Sep  1 20:22:07 [kernel] [ 8541.403635]  [<ffffffff8028c034>] __slab_error+0x26/0x28
> Sep  1 20:22:07 [kernel] [ 8541.403640]  [<ffffffff8028c84d>] cache_free_debugcheck+0x13a/0x1fc
> Sep  1 20:22:07 [kernel] [ 8541.403646]  [<ffffffff802e966d>] ? ext3_destroy_inode+0x80/0x87
> Sep  1 20:22:07 [kernel] [ 8541.403649]  [<ffffffff8028cb53>] kmem_cache_free+0x4e/0xad
> Sep  1 20:22:07 [kernel] [ 8541.403653]  [<ffffffff802e966d>] ext3_destroy_inode+0x80/0x87
> Sep  1 20:22:07 [kernel] [ 8541.403657]  [<ffffffff802a45e5>] destroy_inode+0x37/0x4c
> Sep  1 20:22:07 [kernel] [ 8541.403661]  [<ffffffff802a4fdc>] dispose_list+0xcf/0x103
> Sep  1 20:22:07 [kernel] [ 8541.403664]  [<ffffffff802a51e6>] shrink_icache_memory+0x1d6/0x208
> Sep  1 20:22:07 [kernel] [ 8541.403669]  [<ffffffff802747ba>] shrink_slab+0xeb/0x181
> Sep  1 20:22:07 [kernel] [ 8541.403673]  [<ffffffff80274f60>] kswapd+0x317/0x4b4
> Sep  1 20:22:07 [kernel] [ 8541.403677]  [<ffffffff80273610>] ? isolate_pages_global+0x0/0x39
> Sep  1 20:22:07 [kernel] [ 8541.403684]  [<ffffffff80241394>] ? autoremove_wake_function+0x0/0x3d
> Sep  1 20:22:07 [kernel] [ 8541.403688]  [<ffffffff80274c49>] ? kswapd+0x0/0x4b4
> Sep  1 20:22:07 [kernel] [ 8541.403692]  [<ffffffff8024127f>] kthread+0x4e/0x7b
> Sep  1 20:22:07 [kernel] [ 8541.403696]  [<ffffffff8020c039>] child_rip+0xa/0x11
> Sep  1 20:22:07 [kernel] [ 8541.403701]  [<ffffffff80228a10>] ? finish_task_switch+0x5f/0xa5
> Sep  1 20:22:07 [kernel] [ 8541.403705]  [<ffffffff802289b1>] ? finish_task_switch+0x0/0xa5
> Sep  1 20:22:07 [kernel] [ 8541.403708]  [<ffffffff8020bb83>] ? restore_args+0x0/0x30
> Sep  1 20:22:07 [kernel] [ 8541.403713]  [<ffffffff80241231>] ? kthread+0x0/0x7b
> Sep  1 20:22:07 [kernel] [ 8541.403716]  [<ffffffff8020c02f>] ? child_rip+0x0/0x11
> Sep  1 20:22:07 [kernel] [ 8541.403718]
> Sep  1 20:22:07 [kernel] [ 8541.403721] ffff88000000f9d8: redzone 1:0xd84156c5635688c0, redzone 2:0x43220000ff3e0001.
>
> Full log and .config is here: http://www.kadu.net/~joi/kernel/2008.09.03/
> I don't remember what I was doing while this happened - I noticed this error today...

OK, so redzone1 looks good ("RED_ACTIVE") whereas redzone2, which is
the red-zone at the end of an object, has a bogus value. So looks like
a simple buffer overflow in the ext3_inode_cachep cache. If you can
reproduce this, you could try CONFIG_SLUB which shows us the full
corruption that can give us a better clue why this is happening.

                                Pekka
